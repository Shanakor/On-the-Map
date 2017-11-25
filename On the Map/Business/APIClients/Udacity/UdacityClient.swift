//
// Created by Niklas Rammerstorfer on 24.11.17.
// Copyright (c) 2017 Niklas Rammerstorfer. All rights reserved.
//

import Foundation

class UdacityClient {

    // MARK: Properties

    // Singleton.
    static let shared = UdacityClient()

    private(set) var sessionID: String?
    private(set) var accountKey: String?

    // MARK: Authentication

    public func authenticate(username: String, password: String, completionHandler: @escaping (Bool, UdacityAPIError?) -> Void = {_, _ in }){
        let request = authenticationRequest(username: username, password: password)

        let task = URLSession.shared.dataTask(with: request) {
            data, response, error in

            // GUARD: Did the request fail?
            guard error == nil else {
                completionHandler(false, .connectionError(description: "Request failed. Request: \(request)"))
                return
            }

            // GUARD: Did the request return status code OK?
            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode >= 200 || httpResponse.statusCode <= 299 else {
                completionHandler(false, .connectionError(description: "Status code was other than 2XX!"))
                return
            }

            // GUARD: Did the request return actual data?
            guard let data = data else {
                completionHandler(false, .connectionError(description: "No data was returned!"))
                return
            }

            self.convertAuthDataWithCompletionHandler(data, completionHandler: completionHandler)
        }

        task.resume()
    }

    private func convertAuthDataWithCompletionHandler(_ data: Data, completionHandler: @escaping (Bool, UdacityAPIError?) -> Void) {

        let parsedResult: [String: AnyObject]!
        let range = Range(5..<data.count)
        let subsetData = data.subdata(in: range)

        do{
            parsedResult = try JSONSerialization.jsonObject(with: subsetData, options: .allowFragments) as! [String: AnyObject]
        }
        catch{
            completionHandler(false, .parseError(description: "Could not convert to JSON from \(subsetData)"))
            return
        }

        if let _ = parsedResult[JSONResponseKeys.Status] as? Int{
            guard let errorString = parsedResult[JSONResponseKeys.Error] as? String else{
                completionHandler(false, .parseError(description: "Unknown error!"))
                return
            }

            completionHandler(false, .serverError(description: errorString))
            return
        }

        guard let accountDictionary = parsedResult[JSONResponseKeys.Account] as? [String: AnyObject] else{
            completionHandler(false, .parseError(description: "Can not find key '\(JSONResponseKeys.Account)' in \(parsedResult)"))
            return
        }

        guard let accountKey = accountDictionary[JSONResponseKeys.AccountKey] as? String else{
            completionHandler(false, .parseError(description: "Can not find key '\(JSONResponseKeys.AccountKey)' in \(accountDictionary)"))
            return
        }

        self.accountKey = accountKey
        completionHandler(true, nil)
    }

    private func authenticationRequest(username: String, password: String) -> URLRequest {
        var request = URLRequest(url: sessionURL())
        request.httpMethod = "POST"
        request.addValue(HeaderValues.Accept, forHTTPHeaderField: HeaderKeys.Accept)
        request.addValue(HeaderValues.ContentType, forHTTPHeaderField: HeaderKeys.ContentType)
        request.httpBody = "{\"\(JSONBodyKeys.Udacity)\": {\"\(JSONBodyKeys.Username)\": \"\(username)\", \"\(JSONBodyKeys.password)\": \"\(password)\"}}"
                            .data(using: .utf8)
        return request
    }

    private func sessionURL() -> URL{
        var urlComponents = URLComponents()
        urlComponents.scheme = Constants.APIScheme
        urlComponents.host = Constants.APIHost
        urlComponents.path = Constants.APIPath + Methods.NewSession

        return urlComponents.url!
    }
}
