//
// Created by Niklas Rammerstorfer on 25.11.17.
// Copyright (c) 2017 Niklas Rammerstorfer. All rights reserved.
//

import Foundation

class ParseAPIClient: APIClient {

    // MARK: Properties

    static let shared = ParseAPIClient()

    // MARK: APIClient members

    override func createURL(methodParameters: [String: String]?, withPathExtension: String?) -> URL? {
        var urlComponents = URLComponents()
        urlComponents.scheme = Constants.APIScheme
        urlComponents.host = Constants.APIHost
        urlComponents.path = Constants.APIPath + (withPathExtension ?? "")

        // Construct the query.
        if let methodParameters = methodParameters{
            var queryItems = [URLQueryItem]()

            for (key, value) in methodParameters{
                queryItems.append(URLQueryItem(name: key, value: value))
            }

            urlComponents.queryItems = queryItems
        }

        return urlComponents.url
    }

    override func createGETRequest(URL: URL) -> URLRequest {
        var request = URLRequest(url: URL)
        request.addValue(HeaderValues.ApplicationId, forHTTPHeaderField: HeaderKeys.ApplicationId)
        request.addValue(HeaderValues.RestAPIKey, forHTTPHeaderField: HeaderKeys.RestAPIKey)

        return request
    }

    override func createPOSTRequest(URL: URL, jsonBody: Data?) -> URLRequest {
        var request = createGETRequest(URL: URL)
        request.httpMethod = "POST"
        request.addValue(HeaderValues.ContentType, forHTTPHeaderField: HeaderKeys.ContentType)

        request.httpBody = jsonBody!

        return request
    }

    override func createPUTRequest(URL: URL, jsonBody: Data?) -> URLRequest {
        var request = createGETRequest(URL: URL)
        request.httpMethod = "PUT"
        request.addValue(HeaderValues.ContentType, forHTTPHeaderField: HeaderKeys.ContentType)

        request.httpBody = jsonBody!

        return request
    }

    // MARK: Convenience methods

    func getStudentLocations(limit: Int, order: String?, completionHandler: @escaping ([StudentLocation]?, APIError?) -> Void){

        // Method parameters.
        var methodParameters: [String: String] = [
            QueryKeys.Limit: String(limit)
        ]

        if let order = order{
            methodParameters[QueryKeys.Order] = order
        }

        // Request.
        taskForGETMethod(method: Methods.GetStudents, methodParameters: methodParameters){
            (result, error) in

            guard error == nil else{
                completionHandler(nil, error)
                return
            }

            guard let resultArray = result![JSONKeys.Results] as? [[String: AnyObject]] else{
                completionHandler(nil, APIError.parseError(description: "Cannot find key '\(JSONKeys.Results)' in \(result!)"))
                return
            }

            let studentLocations = StudentLocation.studentLocations(from: resultArray)
            completionHandler(studentLocations, nil)
        }
    }

    func getStudentLocation(uniqueKey: String, completionHandler: @escaping (StudentLocation?, APIError?) -> Void){
        let methodParameters = [
            QueryKeys.Where: "{\"\(QueryKeys.UniqueKey)\": \"\(uniqueKey)\"}"
        ]

        taskForGETMethod(method: Methods.GetStudents, methodParameters: methodParameters){
            (result, error) in

            guard error == nil else{
                completionHandler(nil, error)
                return
            }

            guard let resultArray = result![JSONKeys.Results] as? [[String: AnyObject]] else{
                completionHandler(nil, APIError.parseError(description: "Cannot find key '\(JSONKeys.Results)' in \(result!)"))
                return
            }

            do {
                let studentLocation = try StudentLocation(dictionary: resultArray[0])
                completionHandler(studentLocation, nil)
            }
            catch{
                let apiError = error as! APIError
                completionHandler(nil, apiError)
            }
        }
    }

    func postStudentLocation(studentLocation: StudentLocation, completionHandler: @escaping (Bool?, APIError?) -> Void){
        taskForPOSTMethod(method: Methods.GetStudents, methodParameters: nil, jsonBody: studentLocation.toJSONData()){
            (result, error) in

            guard error == nil else{
                completionHandler(false, error)
                return
            }

            completionHandler(true, nil)
        }
    }

    func putStudentLocation(studentLocation: StudentLocation, completionHandler: @escaping (Bool?, APIError?) -> Void){

        taskForPUTMethod(method: Methods.GetStudents + "/\(studentLocation.objectID!)", methodParameters: nil, jsonBody: studentLocation.toJSONData()){
            (result, error) in

            guard error == nil else{
                completionHandler(false, error)
                return
            }

            completionHandler(true, nil)
        }
    }
}
