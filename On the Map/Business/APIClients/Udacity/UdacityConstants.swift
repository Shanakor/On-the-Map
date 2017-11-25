//
// Created by Niklas Rammerstorfer on 24.11.17.
// Copyright (c) 2017 Niklas Rammerstorfer. All rights reserved.
//

import Foundation

extension UdacityClient{
    struct Constants{
        static let APIScheme = "https"
        static let APIHost = "www.udacity.com"
        static let APIPath = "/api"

        static let SignUpURL = "https://www.udacity.com/account/auth#!/signup"
    }

    struct Methods{
        static let NewSession = "/session"
    }

    struct Header{

        struct Keys {
            static let Accept = "Accept"
            static let ContentType = "Content-Type"
        }

        struct Values{
            static let Accept = "application/json"
            static let ContentType = "application/json"
        }
    }

    struct JSONBodyKeys {
        static let Udacity = "udacity"
        static let Username = "username"
        static let password = "password"
    }

    struct JSONResponseKeys {
        static let Status = "status"
        static let Error = "error"
        static let Account = "account"
        static let AccountKey = "key"
    }

    enum UdacityAPIError: CustomStringConvertible{
        case connectionError(description: String)
        case parseError(description: String)
        case serverError(description: String)

        var description: String {
            switch self {
                case .connectionError(let description):
                    return "Connection failure: \(description)"
                case .parseError(let description):
                    return "Parse failure: \(description)"
                case .serverError(let description):
                    return "Server returned error: \(description)"
            }
        }
    }
}