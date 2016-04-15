//
//  MapViewController.swift
//  OnTheMap
//
//  Created by Nicholas Allio on 11/04/16.
//  Copyright © 2016 Nicholas Allio. All rights reserved.
//

import UIKit

class MapViewController: UIViewController {

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let request = NSMutableURLRequest(URL: NSURL(string: "https://api.parse.com/1/classes/StudentLocation?order=-updatedAt&limit=50")!)
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil { // Handle error...
                self.presentViewController(UIAlertController(title: "Error while logging in", message: error?.description, preferredStyle: .Alert), animated: true, completion: nil)
            }
            
            var parsedData: AnyObject
            do {
                parsedData = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments)
                
                if let errorMessage = parsedData[Constants.ParseResponseKey.ErrorMessage] as? String {
                    // Error from the server
                    let alert = UIAlertController(title: "Error", message: errorMessage, preferredStyle: .Alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .Cancel, handler: { (alertAction) in
                        alert.dismissViewControllerAnimated(true, completion: nil)
                    }))
                    self.presentViewController(alert, animated: true, completion: nil)
                } else {
                    // There is data and we can use it
                    if let studentList = parsedData[Constants.ParseResponseKey.Results] as? [[String:AnyObject]] {
                        for stud in studentList {
                            (UIApplication.sharedApplication().delegate as! AppDelegate).studentList.append(Student(dictionary: stud))
                        }
                    } else {
                        print("Error parsing students")
                    }
                }
            } catch {
                print("Error parsing JSON")
            }
        }
        task.resume()
    }
}

