//
//  NewLocationStep2.swift
//  OnTheMap
//
//  Created by Nicholas Allio on 15/04/16.
//  Copyright © 2016 Nicholas Allio. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class NewLocationStep2: UIViewController {
    
    var location: String! = nil
    var coordinates = CLLocationCoordinate2D()
    
    @IBOutlet weak var locationPreview: MKMapView!
    @IBOutlet weak var linkToShare: UITextField!
    
    override func viewDidLoad() {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(location) { (placemarks, error) in
            if error != nil {
                let alert = UIAlertController(title: "Error", message: "Error finding location, retry", preferredStyle: .Alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .Cancel, handler: { (alert) in
                    self.navigationController?.popViewControllerAnimated(true)
                }))
                self.presentViewController(alert, animated: true, completion: nil)
            }
            if let locFound = placemarks?.first {
                self.coordinates = locFound.location!.coordinate
                dispatch_async(dispatch_get_main_queue(), {
                    self.locationPreview.addAnnotation(MKPlacemark(placemark: locFound))
                    self.locationPreview.setRegion(MKCoordinateRegionMakeWithDistance(locFound.location!.coordinate, 10000, 10000) , animated: true)
                })
            }
        }
    }

    @IBAction func submitPin(sender: AnyObject) {
        let request = NSMutableURLRequest(URL: NSURL(string: "https://api.parse.com/1/classes/StudentLocation")!)
        request.HTTPMethod = "POST"
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = "{\"uniqueKey\": \"\((UIApplication.sharedApplication().delegate as! AppDelegate).accountKey)\", \"firstName\": \"\((UIApplication.sharedApplication().delegate as! AppDelegate).appOwner?.firstName)\", \"lastName\": \"\((UIApplication.sharedApplication().delegate as! AppDelegate).appOwner?.lastName)\",\"mapString\": \"\(location)\", \"mediaURL\": \"\(linkToShare.text)\",\"latitude\": \(self.coordinates.latitude), \"longitude\": \(self.coordinates.longitude)}".dataUsingEncoding(NSUTF8StringEncoding)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil { // Handle error…
                let alert = UIAlertController(title: "Error", message: "Error posting location, retry", preferredStyle: .Alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .Cancel, handler: { (alert) in
                    self.dismissViewControllerAnimated(true, completion: nil)
                }))
            }
            let owner = (UIApplication.sharedApplication().delegate as! AppDelegate).appOwner!
            owner.coordinate = self.coordinates
            owner.pinPosition = (self.coordinates.latitude, self.coordinates.longitude)
            owner.link = self.linkToShare.text
            owner.mapName = self.location
            owner.title = "\(owner.firstName) \(owner.lastName)"
            
            (UIApplication.sharedApplication().delegate as! AppDelegate).studentList.append(owner)
            self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
        }
        task.resume()
    }
    
    @IBAction func cancelCreation(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}