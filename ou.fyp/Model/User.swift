//
//  User.swift
//  ou.fyp
//
//  Created by Chan Hong Wing on 20/2/2019.
//  Copyright © 2019 Chan Hong Wing. All rights reserved.
//

import UIKit
import Firebase

class User:Codable {
    
    let email: String
    var studentId: String?
    let name: String
    var persistedFaceIds: [String:String]?
    var personId: String?
    
    init() {
        self.email = (Auth.auth().currentUser?.email)!
        self.name = (Auth.auth().currentUser?.displayName)!
        self.persistedFaceIds = [:]
        self.studentId = ""
        self.personId = ""
    }
    
    func getJson() -> String {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        let data = try! encoder.encode(self)
        let encodedString = String(data: data, encoding: .utf8)!
        return encodedString
    }
    
    func getData() -> Data {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        let data = try! encoder.encode(self)
        return data
    }
    
}

class StudentCell: UICollectionViewCell {
    
    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var name: UILabel!
    
}
