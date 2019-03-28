//
//  WiFi.swift
//  ou.fyp
//
//  Created by Chan Hong Wing on 27/3/2019.
//  Copyright © 2019 Chan Hong Wing. All rights reserved.
//

import UIKit

class WiFi: Codable {
    let apName: String
    let band: String
    let block: String
    let floor: String
    let location: String
    let ssid: String
    
    enum CodingKeys: String, CodingKey {
        case apName = "AP name"
        case band = "Band"
        case block = "Block"
        case floor = "Floor"
        case location = "Location"
        case ssid = "SSID"
    }
    
    init(apName: String, band: String, block: String, floor: String, location: String, ssid: String) {
        self.apName = apName
        self.band = band
        self.block = block
        self.floor = floor
        self.location = location
        self.ssid = ssid
    }
}
