//
// Created by Niklas Rammerstorfer on 25.11.17.
// Copyright (c) 2017 Niklas Rammerstorfer. All rights reserved.
//

import Foundation

struct StudentInformation {

    // MARK: Properties.

//    private(set) var createdAt: Date
    private(set) var firstName: String
    private(set) var lastName : String
    private(set) var latitude: Double
    private(set) var longitude: Double
    private(set) var mapString: String
    private(set) var mediaURL: String
    var objectID: String?
    private(set) var uniqueKey: String
//    private(set) var updatedAt: Date

    // MARK: Initialization.
    init(firstName: String, lastName: String, latitude: Double, longitude: Double,
         mapString: String, mediaURL: String, uniqueKey: String){
        self.firstName = firstName
        self.lastName = lastName
        self.latitude = latitude
        self.longitude = longitude
        self.mapString = mapString
        self.mediaURL = mediaURL
        self.uniqueKey = uniqueKey
    }

    init(dictionary: [String: AnyObject]) throws{
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US")

//        guard let createdAtString = dictionary[ParseClient.JSONResponseKeys.CreatedAt] as? String,
//                let createdAt = dateFormatter.date(from: createdAtString) else{
//            throw ParseClient.APIError.parseError(description: "Can not find key '\(ParseClient.JSONResponseKeys.CreatedAt)' in \(dictionary)")
//        }

        guard let firstName = dictionary[ParseAPIClient.JSONKeys.FirstName] as? String else{
            throw ParseAPIClient.APIClientError.parseError(description: "Can not find key '\(ParseAPIClient.JSONKeys.FirstName)' in \(dictionary)")
        }

        guard let lastName = dictionary[ParseAPIClient.JSONKeys.LastName] as? String else{
            throw ParseAPIClient.APIClientError.parseError(description: "Can not find key '\(ParseAPIClient.JSONKeys.LastName)' in \(dictionary)")
        }

        guard let latitude = dictionary[ParseAPIClient.JSONKeys.Latitude] as? Double else{
            throw ParseAPIClient.APIClientError.parseError(description: "Can not find key '\(ParseAPIClient.JSONKeys.Latitude)' in \(dictionary)")
        }

        guard let longitude = dictionary[ParseAPIClient.JSONKeys.Longitude] as? Double else{
            throw ParseAPIClient.APIClientError.parseError(description: "Can not find key '\(ParseAPIClient.JSONKeys.Longitude)' in \(dictionary)")
        }

        guard let mapString = dictionary[ParseAPIClient.JSONKeys.MapString] as? String else{
            throw ParseAPIClient.APIClientError.parseError(description: "Can not find key '\(ParseAPIClient.JSONKeys.MapString)' in \(dictionary)")
        }

        guard let mediaURL = dictionary[ParseAPIClient.JSONKeys.MediaURL] as? String else{
            throw ParseAPIClient.APIClientError.parseError(description: "Can not find key '\(ParseAPIClient.JSONKeys.MediaURL)' in \(dictionary)")
        }

        guard let objectID = dictionary[ParseAPIClient.JSONKeys.ObjectID] as? String else{
            throw ParseAPIClient.APIClientError.parseError(description: "Can not find key '\(ParseAPIClient.JSONKeys.ObjectID)' in \(dictionary)")
        }

        guard let uniqueKey = dictionary[ParseAPIClient.JSONKeys.UniqueKey] as? String else{
            throw ParseAPIClient.APIClientError.parseError(description: "Can not find key '\(ParseAPIClient.JSONKeys.UniqueKey)' in \(dictionary)")
        }

//        guard let updatedAtString = dictionary[ParseClient.JSONResponseKeys.UpdatedAt] as? String,
//                let updatedAt = dateFormatter.date(from: updatedAtString) else{
//            throw ParseClient.APIError.parseError(description: "Can not find key '\(ParseClient.JSONResponseKeys.UpdatedAt)' in \(dictionary)")
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

    static func studentInformations(from dictionaryArray: [[String: AnyObject]]) -> [StudentInformation]{
        var studentInformations = [StudentInformation]()
        var errorLog = [Int: ParseAPIClient.APIClientError]()

        var i = 0
        for dict in dictionaryArray{

            do{
                let studentInformation = try StudentInformation(dictionary: dict)
                studentInformations.append(studentInformation)
            }
            catch{
                let apiError = error as! ParseAPIClient.APIClientError
                errorLog[i] = apiError
            }

            i += 1
        }

        if errorLog.count > 0 {
            print("Parse error log \(errorLog.count) entries. (index: errorDescription):")
            print("\t \(errorLog)")
        }

        return studentInformations
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
