//
//  ViewController.swift
//  On the Map
//
//  Created by Niklas Rammerstorfer on 24.11.17.
//  Copyright © 2017 Niklas Rammerstorfer. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view, typically from a nib.

        UdacityClient.shared.authenticate(username: "test_email", password: "testPassword"){
            (success, error) in
            if !success{
                print(error!)
            }
            else{
                print("Successfully logged in. YEAY!!")
                print("accountKey: \(UdacityClient.shared.accountKey)")
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

