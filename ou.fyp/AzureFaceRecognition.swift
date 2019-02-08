//
//  AzureFaceRecognition.swift
//  ou.fyp
//
//  Created by Chan Hong Wing on 5/2/2019.
//  Copyright © 2019 Chan Hong Wing. All rights reserved.
// Code 大部份由postman生成
//https://orange-water-9705.postman.co/collections/5080532-5ddc9a55-f653-4c73-9d6b-1886f39a7a03?workspace=693527de-4045-4178-8825-ec467db2294f

import UIKit
import SwiftyJSON

let APIKey = "71c7995fd77a4387a2de38d12d33e86f" // Ocp-Apim-Subscription-Key
let Region = "japaneast"
//let Face_api_url = "https://\(Region).api.cognitive.microsoft.com/face/v1.0/"

let PersonGroupId = "mypersongroup" //呢個本身set好 不變的

class AzureFaceRecognition: NSObject {
    
    static let shared = AzureFaceRecognition()
    
    //Face - Detect
    func faceDetect(faceImageData:Data, result:@escaping (JSON?, Error?)->()){
        
        let headers = [
            "Content-Type": "application/octet-stream",
            "Ocp-Apim-Subscription-Key": "71c7995fd77a4387a2de38d12d33e86f"
        ]
        
        let request = NSMutableURLRequest(url: NSURL(string: "https://japaneast.api.cognitive.microsoft.com/face/v1.0/detect?returnFaceId=true&returnFaceLandmarks=false")! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        request.httpBody = faceImageData
        
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
    
    //PersonGroup Person - Create
    func personCreate(name:String, userData:String, result:@escaping (JSON?, Error?)->()) {
        
        let headers = [
            "Content-Type": "application/json",
            "Ocp-Apim-Subscription-Key": APIKey
        ]
        let parameters = [
            "name": name,
            "userData": userData
            ] as [String : Any]
        
        do {
            let postData = try JSONSerialization.data(withJSONObject: parameters, options: [])
            let request = NSMutableURLRequest(url: NSURL(string: "https://japaneast.api.cognitive.microsoft.com/face/v1.0/persongroups/mypersongroup/persons")! as URL,
                                              cachePolicy: .useProtocolCachePolicy,
                                              timeoutInterval: 10.0)
            request.httpMethod = "POST"
            request.allHTTPHeaderFields = headers
            request.httpBody = postData as Data
            
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
        } catch let error {
            result(nil, error)
        }
        
    }
    
    func personsList(result:@escaping (JSON?, Error?)->()) {
        
        let headers = [
            "Content-Type": "application/json",
            "Ocp-Apim-Subscription-Key": APIKey
        ]
        
        let request = NSMutableURLRequest(url: NSURL(string: "https://japaneast.api.cognitive.microsoft.com/face/v1.0/persongroups/mypersongroup/persons?top=1000")! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
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
    
    //PersonGroup Person - Delete
    func personsDelete(personId:String, result:@escaping (Error?)->()) {
        let headers = [
            "Ocp-Apim-Subscription-Key": APIKey
        ]
        
        let request = NSMutableURLRequest(url: NSURL(string: "https://japaneast.api.cognitive.microsoft.com/face/v1.0/persongroups/mypersongroup/persons/\(personId)")! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "DELETE"
        request.allHTTPHeaderFields = headers
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                result(error)
            } else {
                let httpResponse = response as? HTTPURLResponse
                if httpResponse?.statusCode == 200{
                    result(nil)
                }else{
                    print("personsDelete fail")
                }
            }
        })
        dataTask.resume()
    }
    
    //PersonGroup Person - Add Face
    func  personAddFace(personId:String, faceImageData:Data, result:@escaping (JSON?, Error?)->()){
        
        let headers = [
            "Content-Type": "application/octet-stream",
            "Ocp-Apim-Subscription-Key": APIKey
        ]
        
        let request = NSMutableURLRequest(url: NSURL(string: "https://japaneast.api.cognitive.microsoft.com/face/v1.0/persongroups/mypersongroup/persons/\(personId)/persistedFaces")! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        request.httpBody = faceImageData
        
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
    
    //PersonGroup - Train
    func personGroupTrain(result:@escaping (Error?)->()) {
        
        let headers = [
            "Ocp-Apim-Subscription-Key": APIKey
        ]
        
        let request = NSMutableURLRequest(url: NSURL(string: "https://japaneast.api.cognitive.microsoft.com/face/v1.0/persongroups/mypersongroup/train")! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                result(error)
            } else {
                let httpResponse = response as? HTTPURLResponse
                if httpResponse?.statusCode == 202{
                    result(nil)
                }else{
                    print("PersonGroup Train have error")
                }
            }
        })
        dataTask.resume()
    }
    
    //PersonGroup - Get Training Status
    func personGroupTrainingStatus(result:@escaping (JSON?, Error?)->()) {
        
        let headers = [
            "Ocp-Apim-Subscription-Key": APIKey
        ]
        
        let request = NSMutableURLRequest(url: NSURL(string: "https://japaneast.api.cognitive.microsoft.com/face/v1.0/persongroups/mypersongroup/training")! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
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
    
    //Face - Identify
    func faceIdentify(faceIds:[String],maxNumOfCandidatesReturned:Int ,result:@escaping (JSON?, Error?)->()) {
        
        let headers = [
            "Content-Type": "application/json",
            "Ocp-Apim-Subscription-Key": APIKey
        ]
        let parameters = [
            "personGroupId": "mypersongroup",
            "faceIds": faceIds,
            "maxNumOfCandidatesReturned": maxNumOfCandidatesReturned,
            "confidenceThreshold": 0.5
            ] as [String : Any]
        do {
            let postData = try JSONSerialization.data(withJSONObject: parameters, options: [])
            let request = NSMutableURLRequest(url: NSURL(string: "https://japaneast.api.cognitive.microsoft.com/face/v1.0/identify")! as URL,
                                              cachePolicy: .useProtocolCachePolicy,
                                              timeoutInterval: 10.0)
            request.httpMethod = "POST"
            request.allHTTPHeaderFields = headers
            request.httpBody = postData as Data
            
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
        } catch let error {
            result(nil, error)
        }
        

    }
    
}
