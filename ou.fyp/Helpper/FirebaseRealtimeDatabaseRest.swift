//
//  FirebaseRealtimeDatabaseRest.swift
//  ou.fyp
//
//  Created by Chan Hong Wing on 20/2/2019.
//  Copyright © 2019 Chan Hong Wing. All rights reserved.
//

import UIKit
import SwiftyJSON

fileprivate let URL = "https://ouhkface-89b5c.firebaseio.com"

class FirebaseRealtimeDatabaseRest: NSObject {
    static let shared = FirebaseRealtimeDatabaseRest()
    
    func getUser(userId:String, result:@escaping (JSON?, Error?)->()) {
        print(URL+"/Users\(userId).json")
        let request = NSMutableURLRequest(url: NSURL(string: URL+"/Users/\(userId).json")! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "GET"
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                result(nil, error)
            } else {
                do{
                    let json = try JSON(data: data!)
                    
                    result(json, nil)
                    
                }catch let error{
                    result(nil, error)
                }
            }
        })
        
        dataTask.resume()
    }
    
    func putUser(authId:String, userData:Data, result:@escaping (JSON?, Error?)->()) {
        
        let headers = [
            "Content-Type": "application/json"
        ]
        
        let request = NSMutableURLRequest(url: NSURL(string: URL+"/Users/\(authId).json")! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "PUT"
        request.allHTTPHeaderFields = headers
        request.httpBody = userData
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                result(nil, error)
            } else {
                do{
                    let json = try JSON(data: data!)
                    result(json, nil)
                }catch let error{
                    result(nil, error)
                }
            }
        })
        dataTask.resume()
    }
    
    func getClass(result:@escaping (JSON?, Error?)->()) {
        
        let request = NSMutableURLRequest(url: NSURL(string: URL+"/Classes.json")! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "GET"
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                result(nil, error)
            } else {
                do{
                    let json = try JSON(data: data!)
                    result(json, nil)
                }catch let error{
                    result(nil, error)
                }
            }
        })
        dataTask.resume()
    }
    
    func getStudentByClassID(classID:String, result:@escaping (JSON?, Error?)->()) {
        
        let request = NSMutableURLRequest(url: NSURL(string: "https://us-central1-ouhkface-89b5c.cloudfunctions.net/getStudentByClassID?classID=\(classID)")! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "GET"
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                result(nil, error)
            } else {
                do{
                    let json = try JSON(data: data!)
                    result(json, nil)
                }catch let error{
                    result(nil, error)
                }
            }
        })
        
        dataTask.resume()
    }
    
    func getWiFiInfoByBSSID(bssId:String, result:@escaping (Data?, Error?)->()) {
        
        
        let request = NSMutableURLRequest(url: NSURL(string: "https://ouhkface-89b5c.firebaseio.com/AP_BSSID/\(bssId).json")! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "GET"
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                result(nil, error)
            } else {
                result(data!, nil)
            }
        })
        
        dataTask.resume()
    }
    
    
    
}
