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

    private struct AlertDialogStrings{
        static let OverwriteTitle = ""
        static let OverwriteMessage = "You have already posted a student location. Would you like to overwrite it?"
        static let OverwritePositiveAction = "Overwrite"
        static let OverwriteNegativeAction = "Cancel"
    }

    private struct NavigationBarStrings{
        static let Title = "On the Map"
        static let Logout = "Logout"
    }

    struct NotificationNames {
        static let DidFinishAddingStudentLocation = "didFinishAddingStudentLocation"
    }

    // MARK: Properties

    private(set) var studentLocationRepository: StudentLocationRepository!

    // MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        initNavigationBar()
        initStudentLocationRepository()

        NotificationCenter.default.addObserver(self, selector: #selector(didFinishAddingStudentLocation(_:)),
                name: NSNotification.Name(rawValue: NotificationNames.DidFinishAddingStudentLocation), object: nil)
    }

    private func initNavigationBar() {
        self.navigationItem.title = NavigationBarStrings.Title

        self.navigationItem.rightBarButtonItems = [
            UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(prepareForNavigatingToInformationPostingView)),
            UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(loadStudentLocations))
        ]

        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: NavigationBarStrings.Logout,
                                                                style: .plain, target: self, action: #selector(logout))
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

    @objc func logout(){
        UdacityAPIClient.shared.logout(){
            (success, error) in

            if error != nil{
                print(error!)
            }

            self.navigationController!.dismiss(animated: true)
        }
    }

    @objc func didFinishAddingStudentLocation(_ notification: NSNotification) {
        loadStudentLocations()
    }

    // MARK: Presenting errors

    func presentAlert(title: String?, message: String) {
        let alertCtrl = UIAlertController(title: title ?? "", message: message, preferredStyle: .alert)
        self.present(alertCtrl, animated: true)
    }

    func presentOverwriteAlert(){
        let alertCtrl = UIAlertController(title: AlertDialogStrings.OverwriteTitle, message: AlertDialogStrings.OverwriteMessage, preferredStyle: .alert)
        alertCtrl.addAction(UIAlertAction(title: AlertDialogStrings.OverwriteNegativeAction, style: .cancel))
        alertCtrl.addAction(UIAlertAction(title: AlertDialogStrings.OverwritePositiveAction, style: .destructive){
            alertAction in self.performSegue(withIdentifier: self.segueIdentifierForInformationPostingView(), sender: nil)
        })

        self.present(alertCtrl, animated: true)
    }

    // MARK: Navigation

    @objc func prepareForNavigatingToInformationPostingView(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate

        // Is there already a StudentLocation of current user?
        ParseAPIClient.shared.getStudentLocation(uniqueKey: appDelegate.account!.ID){
            (studentLocation, error) in

            guard error == nil else{
                print(error!)
                return
            }

            guard studentLocation == nil else{
                appDelegate.studentLocationToOverwrite = studentLocation
                self.presentOverwriteAlert()
                return
            }

            self.performSegue(withIdentifier: self.segueIdentifierForInformationPostingView(), sender: nil)
        }
    }

    // MARK: Methods to be overridden by subclasses

    func didFinishLoadingStudentLocations(success: Bool, error: ParseAPIClient.APIClientError?){
        preconditionFailure("This method has to be implemented")
    }

    func segueIdentifierForInformationPostingView() -> String{
        preconditionFailure("This method has to be implemented")
    }
}
