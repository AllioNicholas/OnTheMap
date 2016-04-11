//
//  LoginViewController.swift
//  OnTheMap
//
//  Created by Nicholas Allio on 11/04/16.
//  Copyright © 2016 Nicholas Allio. All rights reserved.
//

import Foundation
import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        usernameTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    @IBAction func loginButtonPressed(sender: AnyObject) {
        if let username = usernameTextField.text where !username.isEmpty,
            let password = passwordTextField.text where !password.isEmpty {
            presentViewController((self.storyboard?.instantiateViewControllerWithIdentifier("TabBarViewController"))!, animated: true, completion: nil)
        } else {
            print("Could not proceed")
        }
    }
}

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == usernameTextField {
            return passwordTextField.becomeFirstResponder()
        } else {
            loginButtonPressed(textField)
            return true
        }
    }
}
