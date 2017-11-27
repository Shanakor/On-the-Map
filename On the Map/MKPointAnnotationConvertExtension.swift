//
// Created by Niklas Rammerstorfer on 25.11.17.
// Copyright (c) 2017 Niklas Rammerstorfer. All rights reserved.
//

import Foundation
import MapKit

extension MKPointAnnotation {

    static func fromStudentInformation(_ studentInformation: StudentInformation) -> MKPointAnnotation{
        let annotation = MKPointAnnotation()

        let lat = CLLocationDegrees(studentInformation.latitude)
        let long = CLLocationDegrees(studentInformation.longitude)
        annotation.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)

        annotation.title = "\(studentInformation.firstName) \(studentInformation.lastName)"
        annotation.subtitle = studentInformation.mediaURL

        return annotation
    }

    static func fromStudentInformations(_ studentInformations: [StudentInformation]) -> [MKPointAnnotation]{
        var annotations = [MKPointAnnotation]()

        for studentLoc in studentInformations{
            annotations.append(MKPointAnnotation.fromStudentInformation(studentLoc))
        }

        return annotations
    }
}
