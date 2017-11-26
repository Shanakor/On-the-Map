//
//  InformationPostingViewController.swift
//  On the Map
//
//  Created by Niklas Rammerstorfer on 26.11.17.
//  Copyright © 2017 Niklas Rammerstorfer. All rights reserved.
//

import UIKit

class InformationPostingViewController: UIViewController {

    // MARK: IBOutlets
    
    @IBOutlet weak var contentScrollView: UIScrollView!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var linkTextField: UITextField!
    @IBOutlet weak var findLocationBtn: UIButton!

    // MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        enableFindLocationButton(false)
        locationTextField.delegate = self
        linkTextField.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        addKeyboardObservers()
        locationTextField.becomeFirstResponder()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        removeKeyboardObservers()
    }

    // MARK: IBActions

    @IBAction func dismissViewController(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func findLocation(_ sender: Any) {
    }
}

// MARK: Extension for configuring UI.
extension InformationPostingViewController{

    // MARK: Basic UI Configuration

    private func enableFindLocationButton(_ enabled: Bool){
        findLocationBtn.isEnabled = enabled
        findLocationBtn.alpha = enabled ? 1.0 : 0.5
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

// MARK: Extension for UITextFieldDelegate.
extension InformationPostingViewController : UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let txtFieldText = (textField.text ?? "") as NSString
        let textAfterUpdate = txtFieldText.replacingCharacters(in: range, with: string)

        // Determine whether both textFields have text.
        let shouldEnableLoginBtn = textAfterUpdate.lengthOfBytes(using: .utf8) != 0 &&
                nonFirstResponderTextField().text!.lengthOfBytes(using: .utf8) != 0

        self.enableFindLocationButton(shouldEnableLoginBtn)

        return true
    }

    private func nonFirstResponderTextField() -> UITextField{
        return locationTextField.isFirstResponder ? linkTextField : locationTextField
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == locationTextField {
            linkTextField.becomeFirstResponder()
            return false
        }
        else if textField == linkTextField{
            if findLocationBtn.isEnabled {
                findLocation(self)
            }

            return false
        }

        return true
    }
}
