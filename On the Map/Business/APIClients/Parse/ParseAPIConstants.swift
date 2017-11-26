//
// Created by Niklas Rammerstorfer on 25.11.17.
// Copyright (c) 2017 Niklas Rammerstorfer. All rights reserved.
//

import Foundation

extension ParseAPIClient {
    struct Constants{
        static let APIScheme = "https"
        static let APIHost = "parse.udacity.com"
        static let APIPath = "/parse/classes"

        static let Limit = 100
    }

    struct Methods{
        static let StudentLocation = "/StudentLocation"
    }

    struct HeaderKeys{
        static let ApplicationId = "X-Parse-Application-Id"
        static let RestAPIKey = "X-Parse-REST-API-Key"

        static let Accept = "Accept"
        static let ContentType = "Content-Type"
    }

    struct HeaderValues{
        static let ApplicationId = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
        static let RestAPIKey = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"

        static let Accept = "application/json"
        static let ContentType = "application/json"
    }

    struct QueryKeys{
        static let Limit = "limit"
        static let Order = "order"
        static let Where = "where"
        static let UniqueKey = "uniqueKey"
    }

    struct JSONKeys {
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
}