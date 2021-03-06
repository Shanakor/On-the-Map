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
    
    @IBOutlet weak var contentScrollView: UIScrollView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
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
        configureUILoading(loading: true)

        let username = emailTextField.text!
        let password = passwordTextField.text!

        UdacityAPIClient.shared.authenticate(username: username, password: password, completionHandler: onAuthenticationDidFinish)
    }

    private func onAuthenticationDidFinish(_ userID: String?, _ error: UdacityAPIClient.APIClientError?){
        DispatchQueue.main.async {
            self.configureUILoading(loading: false)
        }

        guard error == nil else{
            print(error!)

            DispatchQueue.main.async {
                self.presentAlertDialog(error: error!)
            }

            return
        }

        UdacityAPIClient.shared.getUserInfo(userID: userID!, completionHandler: onGetUserInfoDidFinish)
    }

    private func onGetUserInfoDidFinish(_ account: Account?, _ error: UdacityAPIClient.APIClientError?){
        guard error == nil else{
            print(error!)
            presentAlertDialog(error: error!)
            return
        }

        (UIApplication.shared.delegate as! AppDelegate).account = account

        DispatchQueue.main.async {
            self.performSegue(withIdentifier: AppDelegate.Identifiers.Segues.MainView, sender: nil)
        }
    }

    @IBAction func openSignUpPageInBrowser(_ sender: Any) {
        AppDelegate.openURL(urlString: UdacityAPIClient.Constants.SignUpURL)
    }

    // MARK: Presenting errors

    private func presentAlertDialog(error: UdacityAPIClient.APIClientError) {
        switch(error){
        case .connectionError:
            self.presentAlertDialog(title: ErrorMessageConstants.AlertDialogStrings.ConnectionError.Title, message: ErrorMessageConstants.AlertDialogStrings.ConnectionError.Message)
        case .parseError:
            self.presentAlertDialog(title: ErrorMessageConstants.AlertDialogStrings.ParseError.Title, message: ErrorMessageConstants.AlertDialogStrings.ParseError.Message)
        case .serverError:
            self.presentAlertDialog(title: ErrorMessageConstants.AlertDialogStrings.CredentialError.Title, message: ErrorMessageConstants.AlertDialogStrings.CredentialError.Message)
        default:
            break
        }
    }

    private func presentAlertDialog(title: String, message: String){
        let alertCtrl = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alertCtrl.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))

        self.present(alertCtrl, animated: true, completion: nil)
    }
}

// MARK: Extension for configuring UI

extension LoginViewController{

    // MARK: Basic UI Configuration

    private func enableLoginButton(_ enabled: Bool){
        self.loginBtn.isEnabled = enabled
        self.loginBtn.alpha = enabled ? 1.0 : 0.5
    }

    private func configureUILoading(loading: Bool){
        if loading{
            loadingIndicator.startAnimating()
            view.endEditing(true)
        }
        else{
            loadingIndicator.stopAnimating()
        }

        enableLoginButton(!loading)
    }

    // MARK: Keyboard behaviour

    private func addKeyboardObservers(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: .UIKeyboardWillHide, object: nil)
    }

    private func removeKeyboardObservers(){
        NotificationCenter.default.removeObserver(self)
    }

    @objc private func keyboardWillShow(_ notification: NSNotification){

        // Reveal view if it is obscured by the keyboard.
        let keyboardFrame = notification.userInfo![UIKeyboardFrameEndUserInfoKey] as! CGRect
        let keyboardHeight = keyboardFrame.size.height

        let scrollViewInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardHeight + 10, right: 0)
        contentScrollView.contentInset = scrollViewInsets
        contentScrollView.scrollIndicatorInsets = scrollViewInsets
    }

    @objc private func keyboardWillHide(_ notification: NSNotification){
        contentScrollView.contentInset = UIEdgeInsets.zero
        contentScrollView.scrollIndicatorInsets = UIEdgeInsets.zero
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
            if loginBtn.isEnabled {
                self.login(self)
            }

            return false
        }

        return true
    }
}

