//
// Created by Niklas Rammerstorfer on 25.11.17.
// Copyright (c) 2017 Niklas Rammerstorfer. All rights reserved.
//

import Foundation

struct StudentLocation {

    // MARK: Properties.
//    private(set) var createdAt: Date
    private(set) var firstName: String
    private(set) var lastName : String
    private(set) var latitude: Double
    private(set) var longitude: Double
    private(set) var mapString: String
    private(set) var mediaURL: String
    private(set) var objectID: String
    private(set) var uniqueKey: String
//    private(set) var updatedAt: Date

    private var dateFormatter: DateFormatter

    init(dictionary: [String: AnyObject]) throws{
        dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US")

//        guard let createdAtString = dictionary[ParseClient.JSONResponseKeys.CreatedAt] as? String,
//                let createdAt = dateFormatter.date(from: createdAtString) else{
//            throw ParseClient.ParseAPIError.parseError(description: "Can not find key '\(ParseClient.JSONResponseKeys.CreatedAt)' in \(dictionary)")
//        }

        guard let firstName = dictionary[ParseAPIClient.JSONResponseKeys.FirstName] as? String else{
            throw ParseAPIClient.ParseAPIError.parseError(description: "Can not find key '\(ParseAPIClient.JSONResponseKeys.FirstName)' in \(dictionary)")
        }

        guard let lastName = dictionary[ParseAPIClient.JSONResponseKeys.LastName] as? String else{
            throw ParseAPIClient.ParseAPIError.parseError(description: "Can not find key '\(ParseAPIClient.JSONResponseKeys.LastName)' in \(dictionary)")
        }

        guard let latitude = dictionary[ParseAPIClient.JSONResponseKeys.Latitude] as? Double else{
            throw ParseAPIClient.ParseAPIError.parseError(description: "Can not find key '\(ParseAPIClient.JSONResponseKeys.Latitude)' in \(dictionary)")
        }

        guard let longitude = dictionary[ParseAPIClient.JSONResponseKeys.Longitude] as? Double else{
            throw ParseAPIClient.ParseAPIError.parseError(description: "Can not find key '\(ParseAPIClient.JSONResponseKeys.Longitude)' in \(dictionary)")
        }

        guard let mapString = dictionary[ParseAPIClient.JSONResponseKeys.MapString] as? String else{
            throw ParseAPIClient.ParseAPIError.parseError(description: "Can not find key '\(ParseAPIClient.JSONResponseKeys.MapString)' in \(dictionary)")
        }

        guard let mediaURL = dictionary[ParseAPIClient.JSONResponseKeys.MediaURL] as? String else{
            throw ParseAPIClient.ParseAPIError.parseError(description: "Can not find key '\(ParseAPIClient.JSONResponseKeys.MediaURL)' in \(dictionary)")
        }

        guard let objectID = dictionary[ParseAPIClient.JSONResponseKeys.ObjectID] as? String else{
            throw ParseAPIClient.ParseAPIError.parseError(description: "Can not find key '\(ParseAPIClient.JSONResponseKeys.ObjectID)' in \(dictionary)")
        }

        guard let uniqueKey = dictionary[ParseAPIClient.JSONResponseKeys.UniqueKey] as? String else{
            throw ParseAPIClient.ParseAPIError.parseError(description: "Can not find key '\(ParseAPIClient.JSONResponseKeys.UniqueKey)' in \(dictionary)")
        }

//        guard let updatedAtString = dictionary[ParseClient.JSONResponseKeys.UpdatedAt] as? String,
//                let updatedAt = dateFormatter.date(from: updatedAtString) else{
//            throw ParseClient.ParseAPIError.parseError(description: "Can not find key '\(ParseClient.JSONResponseKeys.UpdatedAt)' in \(dictionary)")
//        }

//        self.createdAt = createdAt
        self.firstName = firstName
        self.lastName = lastName
        self.latitude = latitude
        self.longitude = longitude
        self.mapString = mapString
        self.mediaURL = mediaURL
        self.objectID = objectID
        self.uniqueKey = uniqueKey
//        self.updatedAt = updatedAt
    }

    static func studentLocations(from dictionaryArray: [[String: AnyObject]]) -> [StudentLocation]{
        var studentLocations = [StudentLocation]()
        var errorLog = [Int: ParseAPIClient.ParseAPIError]()

        var i = 0
        for dict in dictionaryArray{

            do{
                let studentLocation = try StudentLocation(dictionary: dict)
                studentLocations.append(studentLocation)
            }
            catch{
                let apiError = error as! ParseAPIClient.ParseAPIError
                errorLog[i] = apiError
            }

            i += 1
        }

        if errorLog.count > 0 {
            print("Parse error log \(errorLog.count) entries. (index: errorDescription):")
            print("\t \(errorLog)")
        }

        return studentLocations
    }
}
