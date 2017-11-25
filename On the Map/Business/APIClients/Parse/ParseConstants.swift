//
// Created by Niklas Rammerstorfer on 25.11.17.
// Copyright (c) 2017 Niklas Rammerstorfer. All rights reserved.
//

import Foundation

extension ParseClient{
    struct Constants{
        static let APIScheme = "https"
        static let APIHost = "udacity.com"
        static let APISubDomain = "parse"
        static let APIPath = "/parse/classes"
    }

    struct Methods{
        static let GetStudents = "/StudentLocation"
    }

    struct HeaderKeys{
        static let ApplicationId = "X-Parse-Application-Id"
        static let RestAPIKey = "X-Parse-REST-API-Key"

        static let Accept = "Accept"
        static let ContentType = "Content-Type"
    }

    struct HeaderValues{
        static let Accept = "application/json"
        static let ContentType = "application/json"
    }

    struct QueryKeys{
        static let Limit = "limit"
        static let Order = "order"
    }

    struct QueryValues{
        static let Limit = 100
    }

    struct JSONBodyKeys {}

    struct JSONResponseKeys {
        static let Results = "results"
        static let CreatedAt = "createdAt"
        static let FirstName = "firstName"
        static let LastName = "lastName"
        static let Latitude = "latitude"
        static let Longitude = "longitude"
        static let MapString = "mapString"
        static let MediaURL = "mediaURL"
        static let ObjectID = "objectId"
        static let UniqueKey = "uniqueKey"
        static let UpdatedAt = "updatedAt"
    }

    enum ParseAPIError: CustomStringConvertible{
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