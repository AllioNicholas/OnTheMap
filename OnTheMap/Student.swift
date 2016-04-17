//
//  Student.swift
//  OnTheMap
//
//  Created by Nicholas Allio on 11/04/16.
//  Copyright © 2016 Nicholas Allio. All rights reserved.
//

import Foundation
import MapKit

class Student: NSObject, MKAnnotation {
    
    var firstName: String!
    var lastName: String!
    var pinPosition: (Double?,Double?)
    var mapName: String?
    var link: String?
    var objectID: String!
    var uniqueKey: String!
    var creationDate: String?
    var updateDate: String?
    
    var title: String?
    var subtitle: String?
    var coordinate: CLLocationCoordinate2D
    
    init(first_name: String, last_name: String, uniqueKey: String) {
        self.firstName = first_name
        self.lastName = last_name
        self.uniqueKey = uniqueKey
        self.coordinate = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    }
    
    init(dictionary: [String:AnyObject]) {
        self.firstName = dictionary[Constants.ParseStudentLocationKey.FirstName] as! String
        self.lastName = dictionary[Constants.ParseStudentLocationKey.LastName] as! String
        self.pinPosition = (dictionary[Constants.ParseStudentLocationKey.PinLatitude] as? Double, dictionary[Constants.ParseStudentLocationKey.PinLongitude] as? Double)
        self.mapName = dictionary[Constants.ParseStudentLocationKey.LocationName] as? String
        self.link = dictionary[Constants.ParseStudentLocationKey.MediaURL] as? String
        self.objectID = dictionary[Constants.ParseStudentLocationKey.StudentLocationID] as! String
        self.uniqueKey = dictionary[Constants.ParseStudentLocationKey.StudentLocationUdacityID] as! String
        self.creationDate = dictionary[Constants.ParseStudentLocationKey.CreationDate] as? String
        self.updateDate = dictionary[Constants.ParseStudentLocationKey.UpdatedDate] as? String
        
        self.title = "\(self.firstName) \(self.lastName)"
        self.subtitle = self.link
        self.coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(self.pinPosition.0!), longitude: CLLocationDegrees(self.pinPosition.1!))
    }
}
