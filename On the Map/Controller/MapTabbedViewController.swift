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

    override func studentLocationsDidLoad(success: Bool, error: ParseAPIClient.APIError?) {
        if success {
            let annotations = MKPointAnnotation.fromStudentLocations(studentLocationRepository.studentLocations)
            mapViewDelegate.refreshAnnotations(annotations)
        } else {
            presentAlert(title: nil, message: error!.description)
        }
    }

    // MARK: Navigation

    override func segueIdentifierAddLocation() -> String {
        return Identifiers.AddLocationSegue
    }
}
