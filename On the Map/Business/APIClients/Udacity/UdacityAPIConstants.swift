//
// Created by Niklas Rammerstorfer on 24.11.17.
// Copyright (c) 2017 Niklas Rammerstorfer. All rights reserved.
//

import Foundation

extension UdacityAPIClient {
    struct Constants{
        static let APIScheme = "https"
        static let APIHost = "www.udacity.com"
        static let APIPath = "/api"

        static let SignUpURL = "https://www.udacity.com/account/auth#!/signup"
    }

    struct Methods{
        static let NewSession = "/session"
        static let Users = "/users"
    }

    struct HeaderKeys{
        static let Accept = "Accept"
        static let ContentType = "Content-Type"

        struct Values{
            static let Accept = "application/json"
            static let ContentType = "application/json"
        }
    }

    struct HeaderValues{
        static let Accept = "application/json"
        static let ContentType = "application/json"
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

        static let User = "user"
        static let FirstName = "first_name"
        static let LastName = "last_name"
    }
}