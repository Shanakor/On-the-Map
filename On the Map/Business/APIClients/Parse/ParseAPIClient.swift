//
// Created by Niklas Rammerstorfer on 25.11.17.
// Copyright (c) 2017 Niklas Rammerstorfer. All rights reserved.
//

import Foundation

class ParseAPIClient: APIClient {

    // MARK: Properties

    static let shared = ParseAPIClient()

    // MARK: APIClient members

    override func createURL(method: String?, withPathExtension pathExtension: String?, methodParameters: [String: String]?) -> URL? {
        var urlComponents = URLComponents()
        urlComponents.scheme = Constants.APIScheme
        urlComponents.host = Constants.APIHost
        urlComponents.path = Constants.APIPath + (method ?? "") + (pathExtension ?? "")

        // Construct the query.
        if let methodParameters = methodParameters,
           methodParameters.count != 0{
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

    func getStudentInformations(limit: Int, order: String?, completionHandler: @escaping ([StudentInformation]?, APIClientError?) -> Void){

        // Construct method parameters.
        var methodParameters: [String: String] = [
            QueryKeys.Limit: String(limit)
        ]

        if let order = order{
            methodParameters[QueryKeys.Order] = order
        }

        // Make the request.
        taskForGETMethod(method: Methods.StudentInformation, withPathExtension: nil, methodParameters: methodParameters){
            (result, error) in

            guard error == nil else{
                completionHandler(nil, error)
                return
            }

            self.parseStudentInformationsData(result!, completionHandler: completionHandler)
        }
    }

    private func parseStudentInformationsData(_ parsedResult: [String: AnyObject], completionHandler: @escaping ([StudentInformation]?, APIClientError?) -> Void){
        guard let resultArray = parsedResult[JSONKeys.Results] as? [[String: AnyObject]] else{
            completionHandler(nil, APIClientError.parseError(description: "Cannot find key '\(JSONKeys.Results)' in \(parsedResult)"))
            return
        }

        let studentInformations = StudentInformation.studentInformations(from: resultArray)
        completionHandler(studentInformations, nil)
    }

    func getStudentInformation(uniqueKey: String, completionHandler: @escaping (StudentInformation?, APIClientError?) -> Void){
        // Construct method parameters.
        let methodParameters = [
            QueryKeys.Where: "{\"\(QueryKeys.UniqueKey)\": \"\(uniqueKey)\"}"
        ]

        // Make the request.
        taskForGETMethod(method: Methods.StudentInformation, withPathExtension: nil, methodParameters: methodParameters){
            (result, error) in

            guard error == nil else{
                completionHandler(nil, error)
                return
            }

            self.parseStudentInformation(result!, completionHandler: completionHandler)
        }
    }

    private func parseStudentInformation(_ parsedResult: [String: AnyObject], completionHandler: @escaping (StudentInformation?, APIClientError?) -> Void){
        self.parseStudentInformationsData(parsedResult){
            (studentInformations, error) in

            guard error == nil else{
                completionHandler(nil, error)
                return
            }

            if studentInformations!.count == 0{
                completionHandler(nil, nil)
                return
            }

            completionHandler(studentInformations![0], nil)
        }
    }

    func postStudentInformation(studentInformation: StudentInformation, completionHandler: @escaping (Bool, APIClientError?) -> Void){
        taskForPOSTMethod(method: Methods.StudentInformation, withPathExtension: nil, methodParameters: nil,
                jsonBody: studentInformation.toJSONData()){
            (result, error) in

            guard error == nil else{
                completionHandler(false, error)
                return
            }

            completionHandler(true, nil)
        }
    }

    func putStudentInformation(studentInformation: StudentInformation, completionHandler: @escaping (Bool, APIClientError?) -> Void){
        taskForPUTMethod(method: Methods.StudentInformation, withPathExtension: "/\(studentInformation.objectID!)",
                methodParameters: nil, jsonBody: studentInformation.toJSONData()){
            (result, error) in

            guard error == nil else{
                completionHandler(false, error)
                return
            }

            completionHandler(true, nil)
        }
    }
}
