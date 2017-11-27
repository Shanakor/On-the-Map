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

    // MARK: Properties

    private var mapViewDelegate: MapViewDelegate!
    private var annotationToCenterOn: MKPointAnnotation?

    // MARK: Initialization

    override func viewDidLoad() {
        super.viewDidLoad()

        mapViewDelegate = MapViewDelegate(mapView: mapView)
        mapView.delegate = mapViewDelegate
    }

    // MARK: BaseTabbedViewController members

    override func didFinishLoadingStudentInformations(success: Bool, error: ParseAPIClient.APIClientError?) {
        if success {
            let annotations = MKPointAnnotation.fromStudentInformations(studentInformationRepository.studentInformations)
            mapViewDelegate.refreshAnnotations(annotations)

            if let annotationToCenterOn = annotationToCenterOn{
                mapView.showAnnotations([annotationToCenterOn], animated: true)
                mapView.selectAnnotation(annotationToCenterOn, animated: true)
                self.annotationToCenterOn = nil
            }
        } else {
            presentAlert(title: nil, message: error!.description)
        }
    }

    override func didFinishAddingStudentInformation(_ notification: NSNotification) {
        super.didFinishAddingStudentInformation(notification)

        let studentInformation = notification.object as! StudentInformation
        annotationToCenterOn = MKPointAnnotation.fromStudentInformation(studentInformation)
    }

    // MARK: Navigation

    override func segueIdentifierForInformationPostingView() -> String {
        return AppDelegate.Identifiers.Segues.InformationPostingFromMapView
    }
}
