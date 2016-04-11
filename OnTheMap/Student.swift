//
//  Student.swift
//  OnTheMap
//
//  Created by Nicholas Allio on 11/04/16.
//  Copyright © 2016 Nicholas Allio. All rights reserved.
//

import Foundation

class Student: NSObject {
    
    var pinPosition: AnyObject!
    var name: String!
    var link: String?
    
    init(name: String) {
        self.name = name
    }
}
