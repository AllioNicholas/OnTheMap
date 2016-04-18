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
    
    var messageFrame = UIView()
    var activityIndicator = UIActivityIndicatorView()
    var strLabel = UILabel()
    
    @IBOutlet weak var locationPreview: MKMapView!
    @IBOutlet weak var linkToShare: UITextField!
    
    override func viewDidLoad() {
        let geocoder = CLGeocoder()
        self.strLabel = UILabel(frame: CGRect(x: 50, y: 0, width: 200, height: 50))
        self.strLabel.text = "Loading..."
        self.strLabel.textColor = UIColor.whiteColor()
        self.messageFrame = UIView(frame: CGRect(x: self.view.frame.midX - 90, y: self.view.frame.midY - 25 , width: 180, height: 50))
        self.messageFrame.layer.cornerRadius = 15
        self.messageFrame.backgroundColor = UIColor(white: 0, alpha: 0.7)
        self.activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.White)
        self.activityIndicator.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        self.activityIndicator.startAnimating()
        self.messageFrame.addSubview(self.activityIndicator)
        self.messageFrame.addSubview(self.strLabel)
        self.view.addSubview(self.messageFrame)
        
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
                    self.messageFrame.removeFromSuperview()
                })
            }
        }
    }

    @IBAction func submitPin(sender: AnyObject) {
        let body = "{\"uniqueKey\": \"\((UIApplication.sharedApplication().delegate as! AppDelegate).accountKey!)\", \"firstName\": \"\((UIApplication.sharedApplication().delegate as! AppDelegate).appOwner!.firstName!)\", \"lastName\": \"\((UIApplication.sharedApplication().delegate as! AppDelegate).appOwner!.lastName!)\",\"mapString\": \"\(location)\", \"mediaURL\": \"\(linkToShare.text!)\",\"latitude\": \(self.coordinates.latitude), \"longitude\": \(self.coordinates.longitude)}"
                
        ParseAPI.sharedInstance().callPOSTMethod(body) { (result, error) in
            if let result = result {
                print(result)
                let owner = (UIApplication.sharedApplication().delegate as! AppDelegate).appOwner!
                owner.coordinate = self.coordinates
                owner.pinPosition = (self.coordinates.latitude, self.coordinates.longitude)
                owner.link = self.linkToShare.text
                owner.mapName = self.location
                owner.title = "\(owner.firstName) \(owner.lastName)"
                
                (UIApplication.sharedApplication().delegate as! AppDelegate).studentList.append(owner)
                self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
            } else {
                let alert = UIAlertController(title: "Error", message: "Error posting location, retry", preferredStyle: .Alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .Cancel, handler: { (alert) in
                    self.dismissViewControllerAnimated(true, completion: nil)
                }))
            }
        }
    }
    
    @IBAction func cancelCreation(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}