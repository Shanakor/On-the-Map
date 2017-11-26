//
//  BaseTabbedViewController.swift
//  On the Map
//
//  Created by Niklas Rammerstorfer on 26.11.17.
//  Copyright © 2017 Niklas Rammerstorfer. All rights reserved.
//

import UIKit

class BaseTabbedViewController: UIViewController {

    // MARK: Properties.

    private(set) var studentLocationRepository: StudentLocationRepository!

    // MARK: Initialization.

    override func viewDidLoad() {
        super.viewDidLoad()

        initNavigationBar()
        initStudentLocationRepository()
    }

    private func initNavigationBar() {
        self.navigationItem.title = "On the Map"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(presentAddLocationScene))
    }

    private func initStudentLocationRepository() {
        studentLocationRepository = StudentLocationRepository.shared

        if studentLocationRepository.isEmpty(){
            loadStudentLocations()
        }
    }

    func loadStudentLocations(){
        studentLocationRepository.loadStudentLocations{
            (success, error) in

            DispatchQueue.main.async{
                self.studentLocationsDidLoad(success: success, error: error)
            }
        }
    }

    func studentLocationsDidLoad(success: Bool, error: ParseAPIClient.ParseAPIError?){
        fatalError("studentLocationsDidLoad() can not be called on the BaseTabbedViewController class")
    }

    // MARK: Error handling

    func presentAlert(title: String?, message: String) {
        let alertCtrl = UIAlertController(title: title ?? "", message: message, preferredStyle: .alert)
        self.present(alertCtrl, animated: true)
    }

    // MARK: Navigation

    func segueIdentifierAddLocation() -> String{
        fatalError("segueIdentifierAddLocation() can not be called on the BaseTabbedViewController class")
    }

    @objc func presentAddLocationScene(){
        performSegue(withIdentifier: segueIdentifierAddLocation(), sender: nil)
    }
}
