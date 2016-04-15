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
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        usernameTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    @IBAction func loginButtonPressed(sender: AnyObject) {
        if let username = usernameTextField.text where !username.isEmpty,
            let password = passwordTextField.text where !password.isEmpty {
            usernameTextField.enabled = false
            passwordTextField.enabled = false
            loginButton.enabled = false
            
            loginAndDisplayMap(username, password: password)
        } else {
            print("Could not proceed")
        }
    }
    
    func loginAndDisplayMap(username: String!, password: String!) {
        let request = NSMutableURLRequest(URL: NSURL(string: "https://www.udacity.com/api/session")!)
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = "{\"udacity\": {\"username\": \"\(username)\", \"password\": \"\(password)\"}}".dataUsingEncoding(NSUTF8StringEncoding)
        
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil { // Handle error…
                self.presentViewController(UIAlertController(title: "Error while logging in", message: error?.description, preferredStyle: .Alert), animated: true, completion: {
                    self.usernameTextField.enabled = true
                    self.passwordTextField.enabled = true
                    self.loginButton.enabled = true
                })
            }
            
            let newData = data!.subdataWithRange(NSMakeRange(5, data!.length - 5)) /* subset response data! */

            var parsedData: AnyObject
            do {
                parsedData = try NSJSONSerialization.JSONObjectWithData(newData, options: .AllowFragments)
                
                if let statusCode = parsedData[Constants.UdacityResponseKey.StatusCode] as? Int,
                    let errorMessage = parsedData[Constants.UdacityResponseKey.ErrorMessage] as? String {
                    // Error from the server
                    let alert = UIAlertController(title: "Error \(statusCode)", message: errorMessage, preferredStyle: .Alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .Cancel, handler: { (alertAction) in
                        alert.dismissViewControllerAnimated(true, completion: nil)
                    }))
                    self.presentViewController(alert, animated: true, completion: {
                        self.usernameTextField.enabled = true
                        self.passwordTextField.enabled = true
                        self.loginButton.enabled = true
                    })
                } else {
                    // There is data and we can use it
                    if let session = parsedData[Constants.UdacityResponseKey.Session] as? [String:AnyObject],
                        let account = parsedData[Constants.UdacityResponseKey.Account] as? [String:AnyObject] {
                        if let sessionID = session[Constants.UdacityResponseKey.SessionID] as? String,
                            let accountKey = account[Constants.UdacityResponseKey.AccountKey] as? String {
                            (UIApplication.sharedApplication().delegate as! AppDelegate).sessionID = sessionID
                            (UIApplication.sharedApplication().delegate as! AppDelegate).accountKey = accountKey
                            self.presentViewController((self.storyboard?.instantiateViewControllerWithIdentifier("TabBarViewController"))!, animated: true, completion: nil)
                        } else {
                            print("Error while extracting from sessio and account")
                        }
                    } else {
                        print("Error while extracting from parsedData")
                    }
                }
            } catch {
                print("Error parsing JSON")
            }
        }
        task.resume()
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
