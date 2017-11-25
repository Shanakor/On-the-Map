//
//  LoginViewController.swift
//  On the Map
//
//  Created by Niklas Rammerstorfer on 24.11.17.
//  Copyright © 2017 Niklas Rammerstorfer. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    // MARK: Constants
    struct AlertDialogText{
        static let connectionErrorTitle = "Connection failed"
        static let connectionErrorMessage = "Please try again or verify that you are connected to the internet."

        static let parseErrorTitle = "Parse failure"
        static let parseErrorMessage = "We could not process the data that was returned by the server. We are probably looking" +
                "into it this very moment."

        static let credentialErrorTitle = "Unauthorized"
        static let credentialErrorMessage = "Invalid username or password!"
    }

    // MARK: IBOutlets
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginBtn: UIButton!

    // MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        emailTextField.delegate = self
        passwordTextField.delegate = self

        enableLoginButton(false)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.addKeyboardObservers()
        self.emailTextField.becomeFirstResponder()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        self.removeKeyboardObservers()
    }

    // MARK: IBActions
    
    @IBAction func login(_ sender: Any) {
        let username = emailTextField.text!
        let password = passwordTextField.text!

        UdacityClient.shared.authenticate(username: username, password: password){
            (success, error) in

            if !success{
                print(error!)

                DispatchQueue.main.async {
                    self.presentAlertDialog(error!)
                }
            }
            else{
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: AppDelegate.Identifiers.Segues.MainScene, sender: nil)
                }
            }
        }
    }

    private func presentAlertDialog(_ error: UdacityClient.UdacityAPIError) {
        switch(error){
            case .connectionError:
                self.presentAlertDialog(title: AlertDialogText.connectionErrorTitle, message: AlertDialogText.connectionErrorMessage)
            case .parseError:
                self.presentAlertDialog(title: AlertDialogText.parseErrorTitle, message: AlertDialogText.parseErrorMessage)
            case .serverError:
                self.presentAlertDialog(title: AlertDialogText.credentialErrorTitle, message: AlertDialogText.credentialErrorMessage)
        }
    }

    private func presentAlertDialog(title: String, message: String){
        let alertCtrl = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alertCtrl.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))

        self.present(alertCtrl, animated: true, completion: nil)
    }

    @IBAction func openSignUpPageInBrowser(_ sender: Any) {
        UIApplication.shared.open(URL(string: UdacityClient.Constants.SignUpURL)!, options: [:], completionHandler: nil)
    }
}

// MARK: Extension for configuring UI.
extension LoginViewController{

    // MARK: Basic UI Configuration

    private func enableLoginButton(_ enabled: Bool){
        self.loginBtn.isEnabled = enabled
        self.loginBtn.alpha = enabled ? 1.0 : 0.5
    }

    // MARK: Keyboard behaviour

    private func addKeyboardObservers(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShow), name: .UIKeyboardDidShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidHide), name: .UIKeyboardDidHide, object: nil)
    }

    private func removeKeyboardObservers(){
        NotificationCenter.default.removeObserver(self)
    }

    @objc private func keyboardDidShow(_ notification: NSNotification){

    }

    @objc private func keyboardDidHide(_ notification: NSNotification){

    }
}

// MARK: Extension for UITextFieldDelegate.
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

