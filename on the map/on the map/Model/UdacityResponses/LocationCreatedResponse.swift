//
//  LocationCreatedResponse.swift
//  on the map
//
//  Created by Abdulla Hasanov on 11/22/19.
//  Copyright © 2019 Abdulla Hasanov. All rights reserved.
//

import Foundation

struct LocationCreatedResponse: Codable {
    let createdAt: String
    let objectId: String
    
    enum CodingKeys: String, CodingKey {
        case createdAt = "createdAt"
        case objectId = "objectId"
    }
}
