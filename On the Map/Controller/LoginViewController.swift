//
//  LoginViewController.swift
//  On the Map
//
//  Created by Niklas Rammerstorfer on 24.11.17.
//  Copyright © 2017 Niklas Rammerstorfer. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    // MARK: IBOutlets
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        emailTextField.delegate = self
        passwordTextField.delegate = self

        enableLoginButton(false)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.emailTextField.becomeFirstResponder()
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
    
    @IBAction func openSignUpPageInBrowser(_ sender: Any) {
        UIApplication.shared.open(URL(string: UdacityClient.Constants.SignUpURL)!, options: [:], completionHandler: nil)
    }
}

// MARK: Extension for configuring UI.
extension LoginViewController{
    private func enableLoginButton(_ enabled: Bool){
        self.loginBtn.isEnabled = enabled
        self.loginBtn.alpha = enabled ? 1.0 : 0.5
    }
}

// MARK: Extension for UITextFieldDelegate
extension LoginViewController : UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let txtFieldText = (textField.text ?? "") as NSString
        let textAfterUpdate = txtFieldText.replacingCharacters(in: range, with: string)

        // Determine whether both textFields have text.
        let shouldEnableLoginBtn = textAfterUpdate.lengthOfBytes(using: .utf8) != 0 &&
                                    nonFirstResponderTextField().text!.lengthOfBytes(using: .utf8) != 0

        self.enableLoginButton(shouldEnableLoginBtn)

        return true
    }

    private func nonFirstResponderTextField() -> UITextField{
        return self.emailTextField.isFirstResponder ? self.passwordTextField : self.emailTextField
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.emailTextField {
            self.passwordTextField.becomeFirstResponder()
            return false
        }
        else if textField == self.passwordTextField{
            self.login(self)
            return false
        }

        return true
    }
}

