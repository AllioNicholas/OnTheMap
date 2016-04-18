//
//  MapViewController.swift
//  OnTheMap
//
//  Created by Nicholas Allio on 11/04/16.
//  Copyright © 2016 Nicholas Allio. All rights reserved.
//

import UIKit
import MapKit
import SafariServices

class MapViewController: UIViewController {

    @IBOutlet weak var map: MKMapView!
    
    override func viewDidLoad() {        
        self.map.delegate = self
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0)) {
            ParseAPI.sharedInstance().callGETMethod({ (result, error) in
                if let result = result {
                    if let errorMessage = result[Constants.ParseResponseKey.ErrorMessage] as? String {
                        // Error from the server
                        let alert = UIAlertController(title: "Error", message: errorMessage, preferredStyle: .Alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: .Cancel, handler: { (alertAction) in
                            alert.dismissViewControllerAnimated(true, completion: nil)
                        }))
                        self.presentViewController(alert, animated: true, completion: nil)
                    } else {
                        // There is data and we can use it
                        if let studentList = result[Constants.ParseResponseKey.Results] as? [[String:AnyObject]] {
                            for stud in studentList {
                                (UIApplication.sharedApplication().delegate as! AppDelegate).studentList.append(Student(dictionary: stud))
                            }
                            dispatch_async(dispatch_get_main_queue(), {
                                //TODO: change storage of students
                                // Load pins on the map
                                self.map.addAnnotations((UIApplication.sharedApplication().delegate as! AppDelegate).studentList)
                            })
                        } else {
                            print("Error parsing students")
                        }
                    }
                } else {
                    self.presentViewController(UIAlertController(title: "Error while logging in", message: error?.description, preferredStyle: .Alert), animated: true, completion: nil)
                }
            })
                    
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        refreshData()
    }
    
    @IBAction func refreshMap(sender: AnyObject) {
        refreshData()
    }
    
    func refreshData() {
        dispatch_async(dispatch_get_main_queue(), {
            // Load pins on the map
            self.map.removeAnnotations((UIApplication.sharedApplication().delegate as! AppDelegate).studentList)
            self.map.addAnnotations((UIApplication.sharedApplication().delegate as! AppDelegate).studentList)
        })
    }
}

extension MapViewController: MKMapViewDelegate {
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        if let annotation = annotation as? Student {
            let identifier = "pin"
            var view: MKPinAnnotationView
            if let dequeuedView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier) as? MKPinAnnotationView {
                dequeuedView.annotation = annotation
                view = dequeuedView
            } else {
                view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                view.canShowCallout = true
                view.calloutOffset = CGPoint(x: -5, y: 5)
                view.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure)
            }
            return view
        }
        return nil
    }
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        //open safari
        if let url = NSURL(string: view.annotation!.subtitle!!) {
            if UIApplication.sharedApplication().canOpenURL(url) {
                let webpage = SFSafariViewController(URL: url)
                self.presentViewController(webpage, animated: true, completion: nil)
            }
        }
        
    }

}

