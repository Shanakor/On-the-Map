//
//  BaseTabbedViewController.swift
//  On the Map
//
//  Created by Niklas Rammerstorfer on 26.11.17.
//  Copyright © 2017 Niklas Rammerstorfer. All rights reserved.
//

import UIKit

class BaseTabbedViewController: UIViewController {

    private struct NavigationBarStrings{
        static let Title = "On the Map"
        static let Logout = "Logout"
    }

    struct NotificationNames {
        static let DidFinishAddingStudentInformation = "didFinishAddingStudentInformation"
    }

    // MARK: Properties

    private(set) var studentInformationRepository: StudentInformationRepository!

    // MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        initNavigationBar()
        initStudentInformationRepository()

        NotificationCenter.default.addObserver(self, selector: #selector(didFinishAddingStudentInformation(_:)),
                name: NSNotification.Name(rawValue: NotificationNames.DidFinishAddingStudentInformation), object: nil)
    }

    private func initNavigationBar() {
        self.navigationItem.title = NavigationBarStrings.Title

        self.navigationItem.rightBarButtonItems = [
            UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(prepareForNavigatingToInformationPostingView)),
            UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(loadStudentInformations))
        ]

        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: NavigationBarStrings.Logout,
                                                                style: .plain, target: self, action: #selector(logout))
    }

    private func initStudentInformationRepository() {
        studentInformationRepository = StudentInformationRepository.shared

        if studentInformationRepository.studentInformations.isEmpty{
            loadStudentInformations()
        }
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: Networking methods

    @objc func loadStudentInformations(){
        studentInformationRepository.loadStudentInformations{
            (success, error) in

            DispatchQueue.main.async{
                self.didFinishLoadingStudentInformations(success: success, error: error)
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

    @objc func didFinishAddingStudentInformation(_ notification: NSNotification) {
        loadStudentInformations()
    }

    // MARK: Presenting errors

    func presentAlert(title: String?, message: String) {
        let alertCtrl = UIAlertController(title: title ?? "", message: message, preferredStyle: .alert)
        alertCtrl.addAction(UIAlertAction(title: "Ok", style: .default))

        self.present(alertCtrl, animated: true)
    }

    func presentOverwriteAlert(){
        let alertCtrl = UIAlertController(title: ErrorMessageConstants.AlertDialogStrings.OverwriteAlert.Title, message: ErrorMessageConstants.AlertDialogStrings.OverwriteAlert.Message, preferredStyle: .alert)
        alertCtrl.addAction(UIAlertAction(title: ErrorMessageConstants.AlertDialogStrings.OverwriteAlert.NegativeAction, style: .cancel))
        alertCtrl.addAction(UIAlertAction(title: ErrorMessageConstants.AlertDialogStrings.OverwriteAlert.PositiveAction, style: .destructive){
            alertAction in self.performSegue(withIdentifier: self.segueIdentifierForInformationPostingView(), sender: nil)
        })

        self.present(alertCtrl, animated: true)
    }

    // MARK: Navigation

    @objc func prepareForNavigatingToInformationPostingView(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate

        // Is there already a StudentInformation of current user?
        ParseAPIClient.shared.getStudentInformation(uniqueKey: appDelegate.account!.ID){
            (studentInformation, error) in

            guard error == nil else{
                print(error!)
                return
            }

            guard studentInformation == nil else{
                appDelegate.studentInformationToOverwrite = studentInformation
                self.presentOverwriteAlert()
                return
            }

            self.performSegue(withIdentifier: self.segueIdentifierForInformationPostingView(), sender: nil)
        }
    }

    // MARK: Methods to be overridden by subclasses

    func didFinishLoadingStudentInformations(success: Bool, error: ParseAPIClient.APIClientError?){
        preconditionFailure("This method has to be implemented")
    }

    func segueIdentifierForInformationPostingView() -> String{
        preconditionFailure("This method has to be implemented")
    }
}
