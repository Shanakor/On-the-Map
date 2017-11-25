//
// Created by Niklas Rammerstorfer on 25.11.17.
// Copyright (c) 2017 Niklas Rammerstorfer. All rights reserved.
//

import Foundation

extension ParseAPIClient {
    func getStudentLocations(limit: Int, order: String?, completionHandler: @escaping ([StudentLocation]?, ParseAPIError?) -> Void){

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

            guard let resultArray = result![JSONKeys.Results] as? [[String: AnyObject]] else{
                completionHandler(nil, ParseAPIError.parseError(description: "Cannot find key '\(JSONKeys.Results)' in \(result!)"))
                return
            }

            let studentLocations = StudentLocation.studentLocations(from: resultArray)
            completionHandler(studentLocations, nil)
        }
    }

    func getStudentLocation(uniqueKey: String, completionHandler: @escaping (StudentLocation?, ParseAPIError?) -> Void){
        let methodParameters = [
            QueryKeys.Where: "{\"\(QueryKeys.UniqueKey)\": \"\(uniqueKey)\"}"
        ]

        taskForGETMethod(method: Methods.GetStudents, methodParameters: methodParameters){
            (result, error) in

            guard error == nil else{
                completionHandler(nil, error)
                return
            }

            guard let resultArray = result![JSONKeys.Results] as? [[String: AnyObject]] else{
                completionHandler(nil, ParseAPIError.parseError(description: "Cannot find key '\(JSONKeys.Results)' in \(result!)"))
                return
            }

            do {
                let studentLocation = try StudentLocation(dictionary: resultArray[0])
                completionHandler(studentLocation, nil)
            }
            catch{
                let apiError = error as! ParseAPIError
                completionHandler(nil, apiError)
            }
        }
    }

    func postStudentLocation(studentLocation: StudentLocation, completionHandler: @escaping (Bool?, ParseAPIError?) -> Void){
        taskForPOSTMethod(method: Methods.GetStudents, methodParameters: nil, studentLocation: studentLocation){
            (result, error) in

            guard error == nil else{
                completionHandler(false, error)
                return
            }

            completionHandler(true, nil)
        }
    }

    func putStudentLocation(studentLocation: StudentLocation, completionHandler: @escaping (Bool?, ParseAPIError?) -> Void){

        taskForPUTMethod(method: Methods.GetStudents, methodParameters: nil, studentLocation: studentLocation){
            (result, error) in

            guard error == nil else{
                completionHandler(false, error)
                return
            }

            completionHandler(true, nil)
        }
    }
}