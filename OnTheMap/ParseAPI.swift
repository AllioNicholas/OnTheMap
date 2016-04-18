//
//  ParseAPI.swift
//  OnTheMap
//
//  Created by Nicholas Allio on 18/04/16.
//  Copyright © 2016 Nicholas Allio. All rights reserved.
//

import Foundation

class ParseAPI: NSObject {
    let AppID = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
    let RESTAPIKey = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
    
    override init() {
        super.init()
    }
    
    class func sharedInstance() -> ParseAPI {
        struct Singleton {
            static var sharedInstance = ParseAPI()
        }
        return Singleton.sharedInstance
    }
    
    func callGETMethod(completionHandler: (result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionDataTask {
        let request = NSMutableURLRequest(URL: NSURL(string: "https://api.parse.com/1/classes/StudentLocation?order=-updatedAt&limit=50")!)
        request.addValue(self.AppID, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(self.RESTAPIKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            func sendError(error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandler(result: nil, error: NSError(domain: "callGETMethod", code: 1, userInfo: userInfo))
            }
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                sendError("There was an error with your request: \(error)")
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                sendError("Your request returned a status code other than 2xx!")
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                sendError("No data was returned by the request!")
                return
            }
            
            /* 5/6. Parse the data and use the data (happens in completion handler) */
            self.convertDataWithCompletionHandler(data, completionHandlerForConvertData: completionHandler)
            
        }
        
        task.resume()
        return task
    }
    
    func callPOSTMethod(body: String, completionHandler: (result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionDataTask {
        let request = NSMutableURLRequest(URL: NSURL(string: "https://api.parse.com/1/classes/StudentLocation")!)
        request.HTTPMethod = "POST"
        request.HTTPBody = body.dataUsingEncoding(NSUTF8StringEncoding)
        request.addValue(self.AppID, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(self.RESTAPIKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { (data, response, error) in
            
            func sendError(error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandler(result: nil, error: NSError(domain: "callPOSTMethod", code: 1, userInfo: userInfo))
            }
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                sendError("There was an error with your request: \(error)")
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                sendError("Your request returned a status code other than 2xx!")
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                sendError("No data was returned by the request!")
                return
            }
            
            /* 5/6. Parse the data and use the data (happens in completion handler) */
            self.convertDataWithCompletionHandler(data, completionHandlerForConvertData: completionHandler)
        }
        
        task.resume()
        return task
    }
    
    // given raw JSON, return a usable Foundation object
    private func convertDataWithCompletionHandler(data: NSData, completionHandlerForConvertData: (result: AnyObject!, error: NSError?) -> Void) {
        
        var parsedResult: AnyObject!
        do {
            parsedResult = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
        } catch {
            let userInfo = [NSLocalizedDescriptionKey : "Could not parse the data as JSON: '\(data)'"]
            completionHandlerForConvertData(result: nil, error: NSError(domain: "convertDataWithCompletionHandler", code: 1, userInfo: userInfo))
        }
        
        completionHandlerForConvertData(result: parsedResult, error: nil)
    }
    
}