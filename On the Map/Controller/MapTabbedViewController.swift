//
//  MapTabbedViewController.swift
//  On the Map
//
//  Created by Niklas Rammerstorfer on 25.11.17.
//  Copyright © 2017 Niklas Rammerstorfer. All rights reserved.
//

import UIKit
import MapKit

class MapTabbedViewController: UIViewController {

    // MARK: IBOutlets
    @IBOutlet weak var mapView: MKMapView!

    // MARK: Constants
    private struct Identifiers{
        static let annotationViewReusableIdentifier = "annotationViewReusableIdentifier"
    }

    // MARK: Properties.

    private var studentLocationRepository: StudentLocationRepository!

    // MARK: Initialization.

    override func viewDidLoad() {
        super.viewDidLoad()

        initStudentLocationRepository()
        mapView.delegate = self
    }

    private func initStudentLocationRepository() {
        studentLocationRepository = StudentLocationRepository.shared

        if studentLocationRepository.isEmpty(){
            studentLocationRepository.loadStudentLocations(completionHandler: studentLocationsDidLoad)
        }
    }

    private func studentLocationsDidLoad(success: Bool, error: ParseAPIClient.ParseAPIError?){
        DispatchQueue.main.async {
            if success {
                self.refreshAnnotations()
            } else {
                let alertCtrl = UIAlertController(title: "", message: error!.description, preferredStyle: .alert)
                self.present(alertCtrl, animated: true)
            }
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

    // MARK: MapView helper functions.

    func refreshAnnotations(){
        mapView.removeAnnotations(mapView.annotations)
        mapView.addAnnotations(MKPointAnnotation.fromStudentLocations(studentLocationRepository.studentLocations))
    }
}
