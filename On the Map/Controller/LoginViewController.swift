//
//  LoginViewController.swift
//  On the Map
//
//  Created by Niklas Rammerstorfer on 24.11.17.
//  Copyright © 2017 Niklas Rammerstorfer. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    // MARK: IBOutlets
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: IBActions
    
    @IBAction func login(_ sender: Any) {
        let username = emailTextField.text!
        let password = passwordTextField.text!

        UdacityClient.shared.authenticate(username: username, password: password){
            (success, error) in
            if !success{
                print(error!)
            }
            else{
                print("Successfully logged in. YEAY!!")
                print("accountKey: \(UdacityClient.shared.accountKey!)")

                DispatchQueue.main.async {
                    self.view.backgroundColor = UIColor.green
                }
            }
        }
    }
}

