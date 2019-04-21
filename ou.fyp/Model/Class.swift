//
//  Class.swift
//  ou.fyp
//
//  Created by Chan Hong Wing on 22/2/2019.
//  Copyright © 2019 Chan Hong Wing. All rights reserved.
//

import UIKit

class Class: Codable {
    let students: [String]
    let bgUrl: String
    let duration: Duration
    let id, introduction, name, teacherId: String
    
    enum CodingKeys: String, CodingKey {
        case students = "Students"
        case bgUrl, duration, id, introduction, name, teacherId
    }
    
    init(students: [String], bgUrl: String, duration: Duration, id: String, introduction: String, name: String, teacherId: String) {
        self.students = students
        self.bgUrl = bgUrl
        self.duration = duration
        self.id = id
        self.introduction = introduction
        self.name = name
        self.teacherId = teacherId
    }
    
}

class Duration: Codable {
    let start: String
    let end: String
    
    init(start: String, end: String) {
        self.start = start
        self.end = end
    }
}

class ClassesCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var locationImage: UIImageView!
    @IBOutlet weak var locationName: UILabel!
    @IBOutlet weak var locationDescription: UILabel!
    
    @IBOutlet weak var introduction: UILabel!
    
}



