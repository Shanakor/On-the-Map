//
// Created by Niklas Rammerstorfer on 24.11.17.
// Copyright (c) 2017 Niklas Rammerstorfer. All rights reserved.
//

import Foundation

extension UdacityClient{
    struct Constants{
        static let Scheme = "https"
        static let BaseUrl = "www.udacity.com/api/"
    }

    struct Methods{
        static let NewSession = "session"
    }

    struct Header{

        struct Keys {
            static let Accept = "Accept"
            static let ContentType = "ContentType"
        }

        struct Values{
            static let Accept = "application/json"
            static let ContentType = "application/json"
        }
    }

    struct JsonBodyKeys{
        static let Udacity = "udacity"
        static let Username = "username"
        static let password = "password"
    }
}