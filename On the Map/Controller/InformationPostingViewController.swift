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
    
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var linkTextField: UITextField!
    @IBOutlet weak var findLocationBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        enableLoginButton(false)
        locationTextField.delegate = self
        linkTextField.delegate = self
    }

    // MARK: UI Configuration

    private func enableLoginButton(_ enabled: Bool){
        findLocationBtn.isEnabled = enabled
        findLocationBtn.alpha = enabled ? 1.0 : 0.5
    }

    // MARK: IBActions

    @IBAction func dismissViewController(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func findLocation(_ sender: Any) {
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

        self.enableLoginButton(shouldEnableLoginBtn)

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
