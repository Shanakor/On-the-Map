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
    private var studentInformation: StudentInformation?

    // MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        mapViewDelegate = MapViewDelegate(mapView: mapView)
        mapView.delegate = mapViewDelegate
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        configureMapView()
    }

    private func configureMapView() {
        let account = (UIApplication.shared.delegate as! AppDelegate).account!

        studentInformation = StudentInformation(firstName: account.firstName, lastName: account.lastName,
                latitude: coordinate.latitude, longitude: coordinate.longitude,
                mapString: mapString, mediaURL: mediaURL, uniqueKey: account.ID)

        let annotation = MKPointAnnotation.fromStudentInformation(studentInformation!)
        mapView.addAnnotation(annotation)
        mapView.showAnnotations([annotation], animated: true)
        mapView.selectAnnotation(annotation, animated: true)
    }

    // MARK: IBActions

    @IBAction func uploadStudentInformationAndDismiss(_ sender: Any) {
        if let studentInformationToOverwrite = (UIApplication.shared.delegate as! AppDelegate).studentInformationToOverwrite{
            studentInformation!.objectID = studentInformationToOverwrite.objectID
            ParseAPIClient.shared.putStudentInformation(studentInformation: studentInformation!, completionHandler: didFinishUploadingStudentInformation)
        }
        else {
            ParseAPIClient.shared.postStudentInformation(studentInformation: studentInformation!, completionHandler: didFinishUploadingStudentInformation)
        }
    }

    private func didFinishUploadingStudentInformation(_ success: Bool, _ error: APIClient.APIClientError?){
        DispatchQueue.main.async {
            if !success {
                print(error!)
                self.presentUploadErrorAlertDialog()
                return
            } else {
                self.dismiss()
            }
        }
    }

    private func dismiss() {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: BaseTabbedViewController.NotificationNames.DidFinishAddingStudentInformation), object: studentInformation!)
        self.navigationController!.topViewController!.dismiss(animated: true)
    }

    // MARK: Error handling

    private func presentUploadErrorAlertDialog(){
        let alertCtrl = UIAlertController(title: ErrorMessageConstants.AlertDialogStrings.UploadError.Title, message: ErrorMessageConstants.AlertDialogStrings.UploadError.Message, preferredStyle: .alert)
        alertCtrl.addAction(UIAlertAction(title: ErrorMessageConstants.AlertDialogStrings.UploadError.NegativeAction, style: .destructive, handler: onCancelTapped))
        alertCtrl.addAction(UIAlertAction(title: ErrorMessageConstants.AlertDialogStrings.UploadError.PositiveAction, style: .default, handler: onRetryTapped))

        present(alertCtrl, animated: true)
    }

    private func onCancelTapped(_ action: UIAlertAction){
        self.dismiss()
    }

    private func onRetryTapped(_ action: UIAlertAction){
        self.uploadStudentInformationAndDismiss(self)
    }
}
