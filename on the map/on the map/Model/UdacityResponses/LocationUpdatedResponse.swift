//
//  LocationUpdatedResponse.swift
//  on the map
//
//  Created by Abdulla Hasanov on 11/22/19.
//  Copyright © 2019 Abdulla Hasanov. All rights reserved.
//

import Foundation

struct LocationUpdatedResponse: Codable {
    let updatedAt: String
    
    enum CodingKeys: String, CodingKey {
        case updatedAt = "updatedAt"
    }
}
