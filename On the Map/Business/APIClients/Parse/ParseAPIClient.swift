//
// Created by Niklas Rammerstorfer on 25.11.17.
// Copyright (c) 2017 Niklas Rammerstorfer. All rights reserved.
//

import Foundation

class ParseAPIClient {
    // MARK: Properties

    // Singleton.
    static let shared = ParseAPIClient()

    // MARK: Request methods.

    public func taskForGETMethod(method: String?, methodParameters: [String: String]?, completionHandlerForGET: @escaping ([String: AnyObject]?, ParseAPIError?) -> Void = { _, _ in }){
        guard let URL = createStudentLocationURL(methodParameters: methodParameters, withPathExtension: method) else{
            completionHandlerForGET(nil, .initializationError(description: "Cannot form a valid URL with the given parameters!"))
            return
        }

        let request = createParseAPIGETRequest(URL: URL)

        let task = URLSession.shared.dataTask(with: request) {
            data, response, error in

            // GUARD: Did the request fail?
            guard error == nil else {
                completionHandlerForGET(nil, .connectionError(description: "Request failed. Request: \(request)"))
                return
            }

            // GUARD: Did the request return status code OK?
            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode >= 200 || httpResponse.statusCode <= 299 else {
                completionHandlerForGET(nil, .connectionError(description: "Status code was other than 2XX!"))
                return
            }

            // GUARD: Did the request return actual data?
            guard let data = data else {
                completionHandlerForGET(nil, .connectionError(description: "No data was returned!"))
                return
            }

            self.convertDataWithCompletionHandler(data, completionHandler: completionHandlerForGET)
        }

        task.resume()
    }

    public func taskForPOSTMethod(method: String?, methodParameters: [String: String]?, studentLocation: StudentLocation, completionHandlerForPOST: @escaping ([String: AnyObject]?, ParseAPIError?) -> Void = { _, _ in }){

        guard let URL = createStudentLocationURL(methodParameters: methodParameters, withPathExtension: method) else{
            completionHandlerForPOST(nil, .initializationError(description: "Cannot form a valid URL with the given parameters!"))
            return
        }

        let request = createParseAPIPOSTRequest(URL: URL, studentLocation: studentLocation)

        let task = URLSession.shared.dataTask(with: request) {
            data, response, error in

            // GUARD: Did the request fail?
            guard error == nil else {
                completionHandlerForPOST(nil, .connectionError(description: "Request failed. Request: \(request)"))
                return
            }

            // GUARD: Did the request return status code OK?
            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode >= 200 || httpResponse.statusCode <= 299 else {
                completionHandlerForPOST(nil, .connectionError(description: "Status code was other than 2XX!"))
                return
            }

            // GUARD: Did the request return actual data?
            guard let data = data else {
                completionHandlerForPOST(nil, .connectionError(description: "No data was returned!"))
                return
            }

            self.convertDataWithCompletionHandler(data, completionHandler: completionHandlerForPOST)
        }

        task.resume()
    }

    private func createParseAPIGETRequest(URL: URL) -> URLRequest {
        var request = URLRequest(url: URL)
        request.addValue(HeaderValues.ApplicationId, forHTTPHeaderField: HeaderKeys.ApplicationId)
        request.addValue(HeaderValues.RestAPIKey, forHTTPHeaderField: HeaderKeys.RestAPIKey)

        return request
    }

    private func createParseAPIPOSTRequest(URL: URL, studentLocation: StudentLocation) -> URLRequest {
        var request = URLRequest(url: URL)
        request.httpMethod = "POST"
        request.addValue(HeaderValues.ApplicationId, forHTTPHeaderField: HeaderKeys.ApplicationId)
        request.addValue(HeaderValues.RestAPIKey, forHTTPHeaderField: HeaderKeys.RestAPIKey)
        request.addValue(HeaderValues.ContentType, forHTTPHeaderField: HeaderKeys.ContentType)

        request.httpBody = studentLocation.toJSONData()

        return request
    }

    private func convertDataWithCompletionHandler(_ data: Data, completionHandler: @escaping ([String: AnyObject]?, ParseAPIError?) -> Void) {

        let parsedResult: [String: AnyObject]!

        do{
            parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String: AnyObject]
        }
        catch{
            completionHandler(nil, .parseError(description: "Could not convert to JSON from \(data)"))
            return
        }

        completionHandler(parsedResult, nil)
    }

    private func createStudentLocationURL(methodParameters: [String: String]?, withPathExtension: String?) -> URL?{
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
}
