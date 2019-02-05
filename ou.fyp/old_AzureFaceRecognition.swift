//
//  AzureFaceRecognition.swift
//  ou.fyp
//
//  Created by Chan Hong Wing on 4/2/2019.
//  Copyright © 2019 Chan Hong Wing. All rights reserved.
//

import UIKit
import Alamofire
import Networking
import SwiftyJSON

let APIKey = "71c7995fd77a4387a2de38d12d33e86f" // Ocp-Apim-Subscription-Key
let Region = "japaneast"
let Face_api_url = "https://\(Region).api.cognitive.microsoft.com/face/v1.0/"
let PersonGroupId = "mypersongroup"

//let FindSimilarsUrl = "https://\(Region).api.cognitive.microsoft.com/face/v1.0/findsimilars"
//let DetectUrl = "https://\(Region).api.cognitive.microsoft.com/face/v1.0/detect?returnFaceId=true"

class old_AzureFaceRecognition: NSObject {
    static let shared = AzureFaceRecognition()
    
    
    
    
    func faceDetect(faceImageData:Data, result:@escaping (Bool)->()) {
//        let networking = Networking(baseURL: "\(Face_api_url)detect")
//
//        networking.headerFields = ["Ocp-Apim-Subscription-Key":APIKey]
//        networking.post("", parameterType: .custom("application/octet-stream"), parameters: faceImageData) { result in
//            // Successfull upload using `application/octet-stream` as `Content-Type`
//            switch result {
//            case .success(let response):
//                do{
//                    let json = try JSON(data: response.data)
//                    print(json.count)
//                    if let faceId = json[0]["faceId"].string {
//                        print(faceId)
//                    }else{
//                        print("no face")
//                    }
//                }catch let error{
//                    print(error)
//                }
//
//            // Do something with JSON, you can also get arrayBody
//            case .failure(let response):
//                print(response)
//
//                // Handle error
//            }
//        }
        
    }
    
    //https://japaneast.dev.cognitive.microsoft.com/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f3039523c
    func createPersonGroupPerson(name:String, userData:String,personId: @escaping (String)->()){
        
        let url = URL(string: "\(Face_api_url)persongroups/\(PersonGroupId)/persons")!
        
        let parameters = ["name": name, "userData": userData] as [String : Any]
        
        //create the session object
        let session = URLSession.shared
        
        //now create the URLRequest object using the url object
        var request = URLRequest(url: url)
        request.httpMethod = "POST" //set http method as POST
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted) // pass dictionary to nsdata object and set it as request body
        } catch let error {
            print(error.localizedDescription)
        }
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue(APIKey, forHTTPHeaderField: "Ocp-Apim-Subscription-Key")
        
        
        let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            
            guard error == nil else {
                return
            }
            
            guard let data = data else {
                return
            }
            do {
                //create json decoder and decode data
                let decoder = JSONDecoder()
                let json = try decoder.decode(Persons.self, from: data)
                
                personId("\(json.getId())")
                
            } catch let error {
                print(error)
            }
        })
        task.resume()
    }
    
    func addPersonFace(personId:String, faceImageData:Data, persistedFaceId:@escaping (Any)->()){
        print("addPersonFace")
        //create the url with URL
        let url = URL(string: "\(Face_api_url)persongroups/\(PersonGroupId)/persons/\(personId)/persistedFaces")! //change the url
        
        //create the session object
        let session = URLSession.shared
        
        //now create the URLRequest object using the url object
        var request = URLRequest(url: url)
        request.httpMethod = "POST" //set http method as POST
        
        request.httpBody = faceImageData
       
        request.addValue("application/octet-stream", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue(APIKey, forHTTPHeaderField: "Ocp-Apim-Subscription-Key")
        
        //create dataTask using the session object to send data to the server
        let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            
            guard error == nil else {
                return
            }
            
            guard let data = data else {
                return
            }
            print("A")
            do {
                //create json object from data
                if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] {
                    if (json["error"] != nil){
                        persistedFaceId("error")
                    }else{
                        persistedFaceId(json)
                    }
                    
                }
            } catch let error {
                print(error.localizedDescription)
            }
        })
        task.resume()
        
    }
    func listPersonGroup() {
        let headers = [
            "Content-Type": "application/json",
            "Ocp-Apim-Subscription-Key": "71c7995fd77a4387a2de38d12d33e86f",
            "cache-control": "no-cache",
            "Postman-Token": "1aebb09d-575c-4352-bfea-7ac3daa67a7e"
        ]
        
        let request = NSMutableURLRequest(url: NSURL(string: "https://japaneast.api.cognitive.microsoft.com/face/v1.0/persongroups?top=1000")! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                print(error!)
            } else {
                do{
                    let json = try JSON(data: data!)
                    print(json)
                }catch{
                    
                }
            }
        })
        
        dataTask.resume()
    }
    func listPersonGroup_2(result:@escaping ([PersonGroupArray])->Void) {
        print("listPersonGroup")
        
        //create the url with URL
        let url = URL(string: "\(Face_api_url)persongroups?top=1000")! //change the url
        print(url)
        //create the session object
        let session = URLSession.shared
        
        //now create the URLRequest object using the url object
        var request = URLRequest(url: url)
        request.httpMethod = "GET" //set http method as POST
        
        //request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        //request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue(APIKey, forHTTPHeaderField: "Ocp-Apim-Subscription-Key")
        
        //create dataTask using the session object to send data to the server
        let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            
            guard error == nil else {
                print(error!)
                return
            }
            
            guard let data = data else {
                print("data nil")
                return
            }
            
            
            do {
                //create json decoder and decode data
                let decoder = JSONDecoder()
                let json = try decoder.decode( [PersonGroupArray].self, from: data)
                result(json)
            } catch let error {
                print(error)
                
            }
        })
        task.resume()
        
    }
    
}


