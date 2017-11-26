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

    // MARK: Constants

    private struct AlertDialogStrings{
        static let UploadErrorTitle = "Uploading failed"
        static let UploadErrorMessage = "We were unable to upload the location."
        static let UploadErrorPositiveAction = "Retry"
        static let UploadErrorNegativeAction = "Discard"
    }

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

        configureMapView()
    }

    private func configureMapView() {
        let account = (UIApplication.shared.delegate as! AppDelegate).account!

        studentLocation = StudentLocation(firstName: account.firstName, lastName: account.lastName,
                latitude: coordinate.latitude, longitude: coordinate.longitude,
                mapString: mapString, mediaURL: mediaURL, uniqueKey: account.ID)

        let annotation = MKPointAnnotation.fromStudentLocation(studentLocation!)
        mapView.addAnnotation(annotation)
        mapView.showAnnotations([annotation], animated: true)
        mapView.selectAnnotation(annotation, animated: true)
    }

    // MARK: IBActions

    @IBAction func uploadStudentLocationAndDismiss(_ sender: Any) {
        if let studentLocationToOverwrite = (UIApplication.shared.delegate as! AppDelegate).studentLocationToOverwrite{
            studentLocation!.objectID = studentLocationToOverwrite.objectID
            ParseAPIClient.shared.putStudentLocation(studentLocation: studentLocation!, completionHandler: didFinishUploadingStudentLocation)
        }
        else {
            ParseAPIClient.shared.postStudentLocation(studentLocation: studentLocation!, completionHandler: didFinishUploadingStudentLocation)
        }
    }

    private func didFinishUploadingStudentLocation(_ success: Bool, _ error: APIClient.APIError?){
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
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: BaseTabbedViewController.Identifiers.DidFinishAddingStudentLocationSelector), object: studentLocation!)
        self.navigationController!.topViewController!.dismiss(animated: true)
    }

    // MARK: Error handling

    private func presentUploadErrorAlertDialog(){
        let alertCtrl = UIAlertController(title: AlertDialogStrings.UploadErrorTitle, message: AlertDialogStrings.UploadErrorMessage, preferredStyle: .alert)
        alertCtrl.addAction(UIAlertAction(title: AlertDialogStrings.UploadErrorNegativeAction, style: .destructive, handler: onCancelTapped))
        alertCtrl.addAction(UIAlertAction(title: AlertDialogStrings.UploadErrorPositiveAction, style: .default, handler: onRetryTapped))

        present(alertCtrl, animated: true)
    }

    private func onCancelTapped(_ action: UIAlertAction){
        self.dismiss()
    }

    private func onRetryTapped(_ action: UIAlertAction){
        self.uploadStudentLocationAndDismiss(self)
    }
}
