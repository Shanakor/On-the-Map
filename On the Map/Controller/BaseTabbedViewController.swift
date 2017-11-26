//
//  BaseTabbedViewController.swift
//  On the Map
//
//  Created by Niklas Rammerstorfer on 26.11.17.
//  Copyright © 2017 Niklas Rammerstorfer. All rights reserved.
//

import UIKit

class BaseTabbedViewController: UIViewController {

    // MARK: Constants

    struct AlertDialogStrings{
        static let OverwriteTitle = ""
        static let OverwriteMessage = "You have already posted a student location. Would you like to overwrite it?"
        static let OverwritePositiveAction = "Overwrite"
        static let OverwriteNegativeAction = "Cancel"
    }
    struct Identifiers{
        static let DidFinishAddingStudentLocationSelector = "didFinishAddingStudentLocation"
    }

    // MARK: Properties

    private(set) var studentLocationRepository: StudentLocationRepository!

    // MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        initNavigationBar()
        initStudentLocationRepository()

        NotificationCenter.default.addObserver(self, selector: #selector(didFinishAddingStudentLocation(_:)),
                name: NSNotification.Name(rawValue: Identifiers.DidFinishAddingStudentLocationSelector), object: nil)
    }


    private func initNavigationBar() {
        self.navigationItem.title = "On the Map"

        self.navigationItem.rightBarButtonItems = [
            UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(startAddLocationProcess)),
            UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(loadStudentLocations))
        ]
    }

    private func initStudentLocationRepository() {
        studentLocationRepository = StudentLocationRepository.shared

        if studentLocationRepository.studentLocations.isEmpty{
            loadStudentLocations()
        }
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: Networking methods

    @objc func loadStudentLocations(){
        studentLocationRepository.loadStudentLocations{
            (success, error) in

            DispatchQueue.main.async{
                self.didFinishLoadingStudentLocations(success: success, error: error)
            }
        }
    }

    func didFinishLoadingStudentLocations(success: Bool, error: ParseAPIClient.APIError?){
        preconditionFailure("This method has to be implemented")
    }

    // MARK: AddLocationDelegate members

    @objc func didFinishAddingStudentLocation(_ notification: NSNotification) {
        loadStudentLocations()
    }

    // MARK: Error handling

    func presentAlert(title: String?, message: String) {
        let alertCtrl = UIAlertController(title: title ?? "", message: message, preferredStyle: .alert)
        self.present(alertCtrl, animated: true)
    }

    func presentOverwriteAlert(){
        let alertCtrl = UIAlertController(title: AlertDialogStrings.OverwriteTitle, message: AlertDialogStrings.OverwriteMessage, preferredStyle: .alert)
        alertCtrl.addAction(UIAlertAction(title: AlertDialogStrings.OverwriteNegativeAction, style: .cancel))
        alertCtrl.addAction(UIAlertAction(title: AlertDialogStrings.OverwritePositiveAction, style: .destructive){
            alertAction in self.performSegue(withIdentifier: self.segueIdentifierAddLocation(), sender: nil)
        })

        self.present(alertCtrl, animated: true)
    }

    // MARK: Navigation

    func segueIdentifierAddLocation() -> String{
        preconditionFailure("This method has to be implemented")
    }

    @objc func startAddLocationProcess(){
        // Is there already a StudentLocation of this user?
        let account = (UIApplication.shared.delegate as! AppDelegate).account!

        ParseAPIClient.shared.getStudentLocation(uniqueKey: account.ID){
            (studentLocation, error) in

            guard error == nil else{
                print(error!)
                return
            }

            guard studentLocation == nil else{
                (UIApplication.shared.delegate as! AppDelegate).studentLocationToOverwrite = studentLocation
                self.presentOverwriteAlert()
                return
            }

            self.performSegue(withIdentifier: self.segueIdentifierAddLocation(), sender: nil)
        }
    }
}
