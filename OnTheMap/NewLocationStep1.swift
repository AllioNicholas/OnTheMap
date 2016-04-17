//
//  NewLocationStep1.swift
//  OnTheMap
//
//  Created by Nicholas Allio on 15/04/16.
//  Copyright © 2016 Nicholas Allio. All rights reserved.
//

import Foundation
import UIKit

class NewLocationStep1: UIViewController {
    
    @IBOutlet weak var locationSelection: UITextField!
    @IBAction func cancelCreation(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "SearchLocation" && !(locationSelection.text?.isEmpty)! {
            let nextVC = segue.destinationViewController as! NewLocationStep2
            nextVC.location = locationSelection.text
        }
    }
}