//
//  Constants.swift
//  OnTheMap
//
//  Created by Nicholas Allio on 11/04/16.
//  Copyright © 2016 Nicholas Allio. All rights reserved.
//

import UIKit

struct Constants {
    
    struct Udacity {
        static let FacebookAppID = ""
    }
    
    struct UdacityResponseKey {
        static let StatusCode = "status"
        static let ErrorMessage = "error"
        static let Account = "account"
        static let Session = "session"
        
        static let AccountRegistered = "registered"
        static let AccountKey = "key"
        
        static let SessionID = "id"
        static let SessionExpiration = "expiration"
        
        static let User = "user"
        static let FirstName = "first_name"
        static let LastName = "last_name"
    }
    
    struct ParseResponseKey {
        static let ErrorMessage = "error"
        static let Results = "results"
    }
    
    struct ParseStudentLocationKey {
        static let StudentLocationID = "objectId"   // StudentLocationID
        static let StudentLocationUdacityID = "uniqueKey"   // StudentLocationUdacityID
        
        static let CreationDate = "createdAt"
        static let UpdatedDate = "updatedAt"
        
        static let FirstName = "firstName"
        static let LastName = "lastName"
        
        static let PinLatitude = "latitude"
        static let PinLongitude = "longitude"
        static let LocationName = "mapString"
        static let MediaURL = "mediaURL"
    }

}
