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
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(presentAddLocationScene))
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

    func loadStudentLocations(){
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
        preconditionFailure("This method has to be implemented")
    }

    // MARK: Error handling

    func presentAlert(title: String?, message: String) {
        let alertCtrl = UIAlertController(title: title ?? "", message: message, preferredStyle: .alert)
        self.present(alertCtrl, animated: true)
    }

    // MARK: Navigation

    func segueIdentifierAddLocation() -> String{
        preconditionFailure("This method has to be implemented")
    }

    @objc func presentAddLocationScene(){
        performSegue(withIdentifier: segueIdentifierAddLocation(), sender: nil)
    }
}
