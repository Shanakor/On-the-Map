//
// Created by Niklas Rammerstorfer on 25.11.17.
// Copyright (c) 2017 Niklas Rammerstorfer. All rights reserved.
//

import Foundation
import MapKit

extension MKPointAnnotation {

    static func fromStudentLocation(_ studentLocation: StudentLocation) -> MKPointAnnotation{
        let annotation = MKPointAnnotation()

        let lat = CLLocationDegrees(studentLocation.latitude)
        let long = CLLocationDegrees(studentLocation.longitude)
        annotation.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)

        annotation.title = "\(studentLocation.firstName) \(studentLocation.lastName)"
        annotation.subtitle = studentLocation.mediaURL

        return annotation
    }

    static func fromStudentLocations(_ studentLocations: [StudentLocation]) -> [MKPointAnnotation]{
        var annotations = [MKPointAnnotation]()

        for studentLoc in studentLocations{
            annotations.append(MKPointAnnotation.fromStudentLocation(studentLoc))
        }

        return annotations
    }
}
