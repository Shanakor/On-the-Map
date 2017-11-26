//
//  MapTabbedViewController.swift
//  On the Map
//
//  Created by Niklas Rammerstorfer on 25.11.17.
//  Copyright © 2017 Niklas Rammerstorfer. All rights reserved.
//

import UIKit
import MapKit

class MapTabbedViewController: BaseTabbedViewController {

    // MARK: IBOutlets

    @IBOutlet weak var mapView: MKMapView!

    // MARK: Constants

    private struct Identifiers{
        static let annotationViewReusableIdentifier = "annotationViewReusableIdentifier"
    }

    // MARK: Initialization

    override func viewDidLoad() {
        super.viewDidLoad()

        mapView.delegate = self
    }

    override func studentLocationsDidLoad(success: Bool, error: ParseAPIClient.ParseAPIError?) {
        if success {
            self.refreshAnnotations()
        } else {
            presentAlert(title: nil, message: error!.description)
        }
    }
}

// MARK: Extension for MapViewDelegate
extension MapTabbedViewController: MKMapViewDelegate{

    // MARK: Delegate functions.

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: Identifiers.annotationViewReusableIdentifier) as? MKPinAnnotationView

        if pinView == nil{
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: Identifiers.annotationViewReusableIdentifier)
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
           let subtitle = annotation.subtitle,
           let url = URL(string: subtitle!){

            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }

    // MARK: MapView helper functions.

    func refreshAnnotations(){
        mapView.removeAnnotations(mapView.annotations)
        mapView.addAnnotations(MKPointAnnotation.fromStudentLocations(studentLocationRepository.studentLocations))
    }
}
