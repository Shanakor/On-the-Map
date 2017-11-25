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

    // MARK: Initialization.

    init(dictionary: [String: AnyObject]) throws{
        dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US")

//        guard let createdAtString = dictionary[ParseClient.JSONResponseKeys.CreatedAt] as? String,
//                let createdAt = dateFormatter.date(from: createdAtString) else{
//            throw ParseClient.ParseAPIError.parseError(description: "Can not find key '\(ParseClient.JSONResponseKeys.CreatedAt)' in \(dictionary)")
//        }

        guard let firstName = dictionary[ParseAPIClient.JSONKeys.FirstName] as? String else{
            throw ParseAPIClient.ParseAPIError.parseError(description: "Can not find key '\(ParseAPIClient.JSONKeys.FirstName)' in \(dictionary)")
        }

        guard let lastName = dictionary[ParseAPIClient.JSONKeys.LastName] as? String else{
            throw ParseAPIClient.ParseAPIError.parseError(description: "Can not find key '\(ParseAPIClient.JSONKeys.LastName)' in \(dictionary)")
        }

        guard let latitude = dictionary[ParseAPIClient.JSONKeys.Latitude] as? Double else{
            throw ParseAPIClient.ParseAPIError.parseError(description: "Can not find key '\(ParseAPIClient.JSONKeys.Latitude)' in \(dictionary)")
        }

        guard let longitude = dictionary[ParseAPIClient.JSONKeys.Longitude] as? Double else{
            throw ParseAPIClient.ParseAPIError.parseError(description: "Can not find key '\(ParseAPIClient.JSONKeys.Longitude)' in \(dictionary)")
        }

        guard let mapString = dictionary[ParseAPIClient.JSONKeys.MapString] as? String else{
            throw ParseAPIClient.ParseAPIError.parseError(description: "Can not find key '\(ParseAPIClient.JSONKeys.MapString)' in \(dictionary)")
        }

        guard let mediaURL = dictionary[ParseAPIClient.JSONKeys.MediaURL] as? String else{
            throw ParseAPIClient.ParseAPIError.parseError(description: "Can not find key '\(ParseAPIClient.JSONKeys.MediaURL)' in \(dictionary)")
        }

        guard let objectID = dictionary[ParseAPIClient.JSONKeys.ObjectID] as? String else{
            throw ParseAPIClient.ParseAPIError.parseError(description: "Can not find key '\(ParseAPIClient.JSONKeys.ObjectID)' in \(dictionary)")
        }

        guard let uniqueKey = dictionary[ParseAPIClient.JSONKeys.UniqueKey] as? String else{
            throw ParseAPIClient.ParseAPIError.parseError(description: "Can not find key '\(ParseAPIClient.JSONKeys.UniqueKey)' in \(dictionary)")
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

    // MARK: JSON Conversion
    func toJSONData() -> Data{

        let rawJSON = [
            ParseAPIClient.JSONKeys.UniqueKey: uniqueKey as AnyObject,
            ParseAPIClient.JSONKeys.FirstName: firstName as AnyObject,
            ParseAPIClient.JSONKeys.LastName: lastName as AnyObject,
            ParseAPIClient.JSONKeys.MediaURL: mediaURL as AnyObject,
            ParseAPIClient.JSONKeys.MapString: mapString as AnyObject,
            ParseAPIClient.JSONKeys.Latitude: latitude as AnyObject,
            ParseAPIClient.JSONKeys.Longitude: longitude as AnyObject
        ]

        return try! JSONSerialization.data(withJSONObject: rawJSON)
    }
}
