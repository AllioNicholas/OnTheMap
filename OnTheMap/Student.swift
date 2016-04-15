//
//  Student.swift
//  OnTheMap
//
//  Created by Nicholas Allio on 11/04/16.
//  Copyright © 2016 Nicholas Allio. All rights reserved.
//

import Foundation

class Student: NSObject {
    
    
    var firstName: String!
    var lastName: String!
    var pinPosition: (Double?,Double?)
    var mapName: String?
    var link: String?
    var objectID: String!
    var uniqueKey: String!
    var creationDate: String?
    var updateDate: String?
    
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
    }
}
