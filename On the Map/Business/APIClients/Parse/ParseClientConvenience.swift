//
// Created by Niklas Rammerstorfer on 25.11.17.
// Copyright (c) 2017 Niklas Rammerstorfer. All rights reserved.
//

import Foundation

extension ParseClient{
    func getStudentLocations(limit: Int, order: String?, completionHandler: @escaping ([StudentLocation]?, ParseAPIError?) -> Void = { _, _ in}){

        // Method parameters.
        var methodParameters: [String: String] = [
            QueryKeys.Limit: String(limit)
        ]

        if let order = order{
            methodParameters[QueryKeys.Order] = order
        }

        // Request.
        taskForGETMethod(method: Methods.GetStudents, methodParameters: methodParameters){
            (result, error) in

            guard error == nil else{
                completionHandler(nil, error)
                return
            }

            guard let resultArray = result![JSONResponseKeys.Results] as? [[String: AnyObject]] else{
                completionHandler(nil, ParseAPIError.parseError(description: "Cannot find key '\(JSONResponseKeys.Results)' in \(result!)"))
                return
            }

            let studentLocations = StudentLocation.studentLocations(from: resultArray)
            completionHandler(studentLocations, nil)
        }
    }
}