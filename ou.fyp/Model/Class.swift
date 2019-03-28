//
//  Class.swift
//  ou.fyp
//
//  Created by Chan Hong Wing on 22/2/2019.
//  Copyright © 2019 Chan Hong Wing. All rights reserved.
//

import UIKit

class Class: Codable {
    let bgUrl: String
    let duration: Duration
    let id: String
    let name: String
    
    init(bgUrl: String, duration: Duration, id: String, name: String) {
        self.bgUrl = bgUrl
        self.duration = duration
        self.id = id
        self.name = name
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
    
    @IBOutlet weak var fraction: UILabel!
}



