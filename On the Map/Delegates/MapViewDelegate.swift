//
// Created by Niklas Rammerstorfer on 26.11.17.
// Copyright (c) 2017 Niklas Rammerstorfer. All rights reserved.
//

import Foundation
import MapKit

class MapViewDelegate: NSObject, MKMapViewDelegate{

    // MARK: Properties

    private var mapView: MKMapView

    // MARK: Initialization

    init(mapView: MKMapView){
        self.mapView = mapView
    }

    // MARK: Delegate functions.

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseIdentifier = "annotationViewReusableIdentifier"

        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier) as? MKPinAnnotationView

        if pinView == nil{
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseIdentifier)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = UIColor.red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        } else{
            pinView!.annotation = annotation
        }

        return pinView
    }

    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {

        if let annotation = view.annotation,
           let subtitle = annotation.subtitle{

            AppDelegate.openURL(urlString: subtitle!)
        }
    }

    // MARK: MapView helper functions.

    func refreshAnnotations(_ annotations: [MKPointAnnotation]){
        mapView.removeAnnotations(mapView.annotations)
        mapView.addAnnotations(annotations)
    }
}
