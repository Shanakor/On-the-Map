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
        static let AddLocationSegue = "PresentAddLocationSceneFromMapScene"
    }

    // MARK: Properties

    private var mapViewDelegate: MapViewDelegate!

    // MARK: Initialization

    override func viewDidLoad() {
        super.viewDidLoad()

        mapViewDelegate = MapViewDelegate(mapView: mapView)
        mapView.delegate = mapViewDelegate
    }

    override func didFinishLoadingStudentLocations(success: Bool, error: ParseAPIClient.APIError?) {
        if success {
            let annotations = MKPointAnnotation.fromStudentLocations(studentLocationRepository.studentLocations)
            mapViewDelegate.refreshAnnotations(annotations)
        } else {
            presentAlert(title: nil, message: error!.description)
        }
    }

    override func didFinishAddingStudentLocation(_ notification: NSNotification) {
        super.didFinishAddingStudentLocation(notification)

        let studentLocation = notification.object as! StudentLocation
        let annotation = MKPointAnnotation.fromStudentLocation(studentLocation)

        mapView.addAnnotation(annotation)
        mapView.showAnnotations([annotation], animated: true)
        mapView.selectAnnotation(annotation, animated: true)
    }

    // MARK: Navigation

    override func segueIdentifierAddLocation() -> String {
        return Identifiers.AddLocationSegue
    }
}
