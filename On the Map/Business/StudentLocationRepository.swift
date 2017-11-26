//
// Created by Niklas Rammerstorfer on 25.11.17.
// Copyright (c) 2017 Niklas Rammerstorfer. All rights reserved.
//

import Foundation

class StudentLocationRepository {

    // MARK: Properties

    static let shared = StudentLocationRepository()

    var studentLocations = [StudentLocation]()

    // MARK: Utility functions.

    public func loadStudentLocations(completionHandler: @escaping (Bool, ParseAPIClient.APIClientError?) -> Void){

        ParseAPIClient.shared.getStudentLocations(limit: ParseAPIClient.Constants.Limit, order: "-\(ParseAPIClient.JSONKeys.UpdatedAt)"){
            (studentLocations, error) in

            guard error == nil else{
                completionHandler(false, error)
                return
            }

            self.studentLocations = studentLocations!
            completionHandler(true, nil)
        }
    }
}
