//
//  StudentInformation.swift
//  on the map
//
//  Created by Abdulla Hasanov on 11/21/19.
//  Copyright © 2019 Abdulla Hasanov. All rights reserved.
//

import Foundation

struct StudentInformation: Codable {
    let objectId: String?
    let uniqueKey: String?
    let firstName: String?
    let lastName: String?
    let mapString: String?
    let mediaURL: String?
    let latitude: Double?
    let longitude: Double?
    let createdAt: String?
    let updatedAt: String?
    
    enum CondingKeys: String, CodingKey {
        case objectId = "objectId"
        case uniqueKey = "uniqueKey"
        case firstName = "firstName"
        case lastName = "lastName"
        case mapString = "mapString"
        case mediaURL = "mediaURL"
        case latitude = "latitude"
        case longitude = "longitude"
        case createdAt = "createdAt"
        case updatedAt = "updatedAt"
    }
}
