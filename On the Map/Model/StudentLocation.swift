//
// Created by Niklas Rammerstorfer on 25.11.17.
// Copyright (c) 2017 Niklas Rammerstorfer. All rights reserved.
//

import Foundation

struct StudentLocation {

    // MARK: Properties.
    private(set) var createdAt: Date
    private(set) var firstName: String
    private(set) var lastName : String
    private(set) var latitude: Double
    private(set) var longitude: Double
    private(set) var mapString: String
    private(set) var mediaURL: String
    private(set) var objectID: String
    private(set) var uniqueKey: Int
    private(set) var updatedAt: Date

    init(dictionary: [String: AnyObject]) throws{

        guard let createdAt = dictionary[ParseClient.JSONResponseKeys.CreatedAt] as? Date else{
            throw ParseClient.ParseAPIError.parseError(description: "Can not find key '\(ParseClient.JSONResponseKeys.CreatedAt)' in \(dictionary)")
        }

        guard let firstName = dictionary[ParseClient.JSONResponseKeys.FirstName] as? String else{
            throw ParseClient.ParseAPIError.parseError(description: "Can not find key '\(ParseClient.JSONResponseKeys.FirstName)' in \(dictionary)")
        }

        guard let lastName = dictionary[ParseClient.JSONResponseKeys.LastName] as? String else{
            throw ParseClient.ParseAPIError.parseError(description: "Can not find key '\(ParseClient.JSONResponseKeys.LastName)' in \(dictionary)")
        }

        guard let latitude = dictionary[ParseClient.JSONResponseKeys.Latitude] as? Double else{
            throw ParseClient.ParseAPIError.parseError(description: "Can not find key '\(ParseClient.JSONResponseKeys.Latitude)' in \(dictionary)")
        }

        guard let longitude = dictionary[ParseClient.JSONResponseKeys.Longitude] as? Double else{
            throw ParseClient.ParseAPIError.parseError(description: "Can not find key '\(ParseClient.JSONResponseKeys.Longitude)' in \(dictionary)")
        }

        guard let mapString = dictionary[ParseClient.JSONResponseKeys.MapString] as? String else{
            throw ParseClient.ParseAPIError.parseError(description: "Can not find key '\(ParseClient.JSONResponseKeys.MapString)' in \(dictionary)")
        }

        guard let mediaURL = dictionary[ParseClient.JSONResponseKeys.MediaURL] as? String else{
            throw ParseClient.ParseAPIError.parseError(description: "Can not find key '\(ParseClient.JSONResponseKeys.MediaURL)' in \(dictionary)")
        }

        guard let objectID = dictionary[ParseClient.JSONResponseKeys.ObjectID] as? String else{
            throw ParseClient.ParseAPIError.parseError(description: "Can not find key '\(ParseClient.JSONResponseKeys.CreatedAt)' in \(dictionary)")
        }

        guard let uniqueKey = dictionary[ParseClient.JSONResponseKeys.UniqueKey] as? Int else{
            throw ParseClient.ParseAPIError.parseError(description: "Can not find key '\(ParseClient.JSONResponseKeys.UniqueKey)' in \(dictionary)")
        }

        guard let updatedAt = dictionary[ParseClient.JSONResponseKeys.UpdatedAt] as? Date else{
            throw ParseClient.ParseAPIError.parseError(description: "Can not find key '\(ParseClient.JSONResponseKeys.UpdatedAt)' in \(dictionary)")
        }

        self.createdAt = createdAt
        self.firstName = firstName
        self.lastName = lastName
        self.latitude = latitude
        self.longitude = longitude
        self.mapString = mapString
        self.mediaURL = mediaURL
        self.objectID = objectID
        self.uniqueKey = uniqueKey
        self.updatedAt = updatedAt
    }

    static func studentLocations(from dictionaryArray: [[String: AnyObject]]) throws -> [StudentLocation]{
        var studentLocations = [StudentLocation]()

        var i = 0
        for dict in dictionaryArray{

            do{
                let studentLocation = try StudentLocation(dictionary: dict)
                studentLocations.append(studentLocation)
            }
            catch{
                let apiError = error as! ParseClient.ParseAPIError
                throw ParseClient.ParseAPIError.parseError(description: "Following error happened at position \(i) of \(dictionaryArray)\n\(apiError.description)")
            }

            i += 1
        }

        return studentLocations
    }
}
