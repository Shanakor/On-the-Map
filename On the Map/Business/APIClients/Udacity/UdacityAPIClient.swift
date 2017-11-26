//
// Created by Niklas Rammerstorfer on 24.11.17.
// Copyright (c) 2017 Niklas Rammerstorfer. All rights reserved.
//

import Foundation

class UdacityAPIClient: APIClient {

    // MARK: Properties

    static let shared = UdacityAPIClient()

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
        return URLRequest(url: URL)
    }

    override func createPOSTRequest(URL: URL, jsonBody: Data?) -> URLRequest {
        var request = URLRequest(url: URL)
        request.httpMethod = "POST"
        request.addValue(HeaderValues.Accept, forHTTPHeaderField: HeaderKeys.Accept)
        request.addValue(HeaderValues.ContentType, forHTTPHeaderField: HeaderKeys.ContentType)

        request.httpBody = jsonBody

        return request
    }

    override func createPUTRequest(URL: URL, jsonBody: Data?) -> URLRequest {
        return URLRequest(url: URL)
    }

    override func convertDataWithCompletionHandler(_ data: Data, completionHandler: @escaping ([String: AnyObject]?, APIError?) -> Void) {
        let range = Range(5..<data.count)
        let subsetData = data.subdata(in: range)

        super.convertDataWithCompletionHandler(subsetData, completionHandler: completionHandler)
    }

    // MARK: Convenience methods

    public func authenticate(username: String, password: String, completionHandler: @escaping (Bool, APIError?) -> Void = {_, _ in }){
        let jsonBody = "{\"\(JSONBodyKeys.Udacity)\": {\"\(JSONBodyKeys.Username)\": \"\(username)\", \"\(JSONBodyKeys.password)\": \"\(password)\"}}"
                        .data(using: .utf8)

        taskForPOSTMethod(method: Methods.NewSession, methodParameters: nil, jsonBody: jsonBody!){
            (result, error) in

            guard error == nil else{
                completionHandler(false, error)
                return
            }

            self.convertAuthDataWithCompletionHandler(result!, completionHandler: completionHandler)
        }
    }

    private func convertAuthDataWithCompletionHandler(_ parsedResult: [String: AnyObject], completionHandler: @escaping (Bool, APIError?) -> Void) {

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

        // TODO: Handle retrieved account key.

        completionHandler(true, nil)
    }
}
