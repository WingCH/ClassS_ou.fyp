//
//  Test.swift
//  FaceID
//
//  Created by Jonas Mock on 31.10.17.
//  Copyright © 2017 Jonas Mock. All rights reserved.
//

import Foundation

import UIKit


struct PersonGroupArray: Codable {
    let personGroupId: String
}

struct PersonArray: Codable {
    let personId: String
    let name: String
}

struct DetectArray: Decodable {
    var faceId: String
    
    init(faceId: String) {
        self.faceId = faceId
    }
    
    func getId() -> String{
        return faceId
        
    }
}

struct Persons: Decodable {
    
    var personId: String
    
    init(personId: String) {
        self.personId = personId
        
    }
    
    func getId() -> String{
        
        
        return personId
        
    }
    
}

struct Verify: Decodable {
    
    var isIdentical: Int
    var confidence: Double
    
    
    func getIsIdentical() -> Int{
        
        
        return isIdentical
        
    }
    func getConfidence() -> Double{
        
        
        return confidence
        
    }
    
}


