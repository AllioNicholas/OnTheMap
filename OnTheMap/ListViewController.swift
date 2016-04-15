//
//  ListViewController.swift
//  OnTheMap
//
//  Created by Nicholas Allio on 11/04/16.
//  Copyright © 2016 Nicholas Allio. All rights reserved.
//

import Foundation
import UIKit

class ListViewController: UITableViewController {
    
    var studentList: [Student] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.studentList = (UIApplication.sharedApplication().delegate as! AppDelegate).studentList
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return studentList.count
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("DevCell")!
        cell.imageView?.image = UIImage(named: "Pin")
        cell.textLabel?.text = "\(studentList[indexPath.row].firstName) \(studentList[indexPath.row].lastName)"
        return cell
    }
    
}