//
//  InformationPostingDetailViewController.swift
//  On the Map
//
//  Created by Niklas Rammerstorfer on 26.11.17.
//  Copyright © 2017 Niklas Rammerstorfer. All rights reserved.
//

import UIKit
import MapKit

class InformationPostingDetailViewController: UIViewController {
    
    // MARK: IBOutlets
    
    @IBOutlet weak var mapView: MKMapView!
    
    // MARK: Properties

    var mapString: String!
    var coordinate: CLLocationCoordinate2D!
    var mediaURL: String!

    private var mapViewDelegate: MapViewDelegate!
    private var studentLocation: StudentLocation?

    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        mapViewDelegate = MapViewDelegate(mapView: mapView)
        mapView.delegate = mapViewDelegate
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        let account = (UIApplication.shared.delegate as! AppDelegate).account!

        studentLocation = StudentLocation(firstName: account.firstName, lastName: account.lastName,
                latitude: coordinate.latitude, longitude: coordinate.longitude,
                mapString: mapString, mediaURL: mediaURL, uniqueKey: account.ID)

        let annotation = MKPointAnnotation.fromStudentLocation(studentLocation!)
        mapView.addAnnotation(annotation)
        mapView.showAnnotations([annotation], animated: true)
        mapView.selectAnnotation(annotation, animated: true)
    }
}
