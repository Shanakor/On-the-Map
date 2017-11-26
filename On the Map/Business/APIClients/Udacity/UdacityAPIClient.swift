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

    override func createDELETERequest(URL: URL, jsonBody: Data?) -> URLRequest {
        var request = URLRequest(url: URL)
        request.httpMethod = "DELETE"

        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }

        return request
    }

    override func convertDataWithCompletionHandler(_ data: Data, completionHandler: @escaping ([String: AnyObject]?, APIError?) -> Void) {
        let range = Range(5..<data.count)
        let subsetData = data.subdata(in: range)

        super.convertDataWithCompletionHandler(subsetData, completionHandler: completionHandler)
    }

    // MARK: Convenience methods

    public func authenticate(username: String, password: String, completionHandler: @escaping (String?, APIError?) -> Void = {_, _ in }){
        let jsonBody = "{\"\(JSONBodyKeys.Udacity)\": {\"\(JSONBodyKeys.Username)\": \"\(username)\", \"\(JSONBodyKeys.password)\": \"\(password)\"}}"
                        .data(using: .utf8)

        taskForPOSTMethod(method: Methods.Session, methodParameters: nil, jsonBody: jsonBody!){
            (result, error) in

            guard error == nil else{
                completionHandler(nil, error)
                return
            }

            self.convertAuthDataWithCompletionHandler(result!, completionHandler: completionHandler)
        }
    }

    private func convertAuthDataWithCompletionHandler(_ parsedResult: [String: AnyObject], completionHandler: @escaping (String?, APIError?) -> Void) {

        if let _ = parsedResult[JSONResponseKeys.Status] as? Int{
            guard let errorString = parsedResult[JSONResponseKeys.Error] as? String else{
                completionHandler(nil, .parseError(description: "Unknown error!"))
                return
            }

            completionHandler(nil, .serverError(description: errorString))
            return
        }

        guard let accountDictionary = parsedResult[JSONResponseKeys.Account] as? [String: AnyObject] else{
            completionHandler(nil, .parseError(description: "Can not find key '\(JSONResponseKeys.Account)' in \(parsedResult)"))
            return
        }

        guard let accountKey = accountDictionary[JSONResponseKeys.AccountKey] as? String else{
            completionHandler(nil, .parseError(description: "Can not find key '\(JSONResponseKeys.AccountKey)' in \(accountDictionary)"))
            return
        }

        completionHandler(accountKey, nil)
    }

    public func getUserInfo(userID: String, completionHandler: @escaping (Account?, APIError?) -> Void){
        taskForGETMethod(method: Methods.Users + "/\(userID)", methodParameters: nil){
            (result, error) in

            guard error == nil else{
                completionHandler(nil, error)
                return
            }

            self.convertUserDataWithCompletionHandler(result!, completionHandler: completionHandler)
        }
    }

    private func convertUserDataWithCompletionHandler(_ parsedResult: [String: AnyObject], completionHandler: @escaping (Account?, APIError?) -> Void){
        guard let user = parsedResult[JSONResponseKeys.User] as? [String: AnyObject] else{
            completionHandler(nil, .parseError(description: "Cannot find key '\(JSONResponseKeys.User)' in \(parsedResult)"))
            return
        }

        guard let userID = user[JSONResponseKeys.AccountKey] as? String else{
            completionHandler(nil, .parseError(description: "Cannot find key '\(JSONResponseKeys.AccountKey)' in \(parsedResult)"))
            return
        }

        guard let firstName = user[JSONResponseKeys.FirstName] as? String else{
            completionHandler(nil, .parseError(description: "Cannot find key '\(JSONResponseKeys.FirstName)' in \(parsedResult)"))
            return
        }

        guard let lastName = user[JSONResponseKeys.LastName] as? String else{
            completionHandler(nil, .parseError(description: "Cannot find key '\(JSONResponseKeys.LastName)' in \(parsedResult)"))
            return
        }

        completionHandler(Account(id: userID, firstName: firstName, lastName: lastName), nil)
    }

    public func logout(completionHandler: @escaping (Bool, APIError?) -> Void){
        taskForDELETEMethod(method: Methods.Session, methodParameters: nil, jsonBody: nil){
            (result, error) in

            guard error == nil else{
                completionHandler(false, error)
                return
            }

            completionHandler(true, nil)
        }
    }
}
