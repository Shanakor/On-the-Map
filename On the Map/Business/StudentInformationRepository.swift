//
// Created by Niklas Rammerstorfer on 25.11.17.
// Copyright (c) 2017 Niklas Rammerstorfer. All rights reserved.
//

import Foundation

class StudentInformationRepository {

    // MARK: Properties

    static let shared = StudentInformationRepository()

    var studentInformations = [StudentInformation]()

    // MARK: Utility functions.

    public func loadStudentInformations(completionHandler: @escaping (Bool, ParseAPIClient.APIClientError?) -> Void){

        ParseAPIClient.shared.getStudentInformations(limit: ParseAPIClient.Constants.Limit, order: "-\(ParseAPIClient.JSONKeys.UpdatedAt)"){
            (studentInformations, error) in

            guard error == nil else{
                completionHandler(false, error)
                return
            }

            self.studentInformations = studentInformations!
            completionHandler(true, nil)
        }
    }
}
