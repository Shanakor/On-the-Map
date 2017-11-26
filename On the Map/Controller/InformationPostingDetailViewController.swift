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

    var coordinate: CLLocationCoordinate2D!
    var url: String!

    override func viewDidLoad() {
        super.viewDidLoad()

        print(coordinate)
        print(url)
    }
    
    // MARK: IBActions
    
}
