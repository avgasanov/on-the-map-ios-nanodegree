//
//  PublicUserInfo.swift
//  on the map
//
//  Created by Abdulla Hasanov on 11/24/19.
//  Copyright © 2019 Abdulla Hasanov. All rights reserved.
//

import Foundation

struct PublicUserInfo: Codable {
    let lastName: String
    let firstName: String
    
    enum CodingKeys: String, CodingKey {
        case lastName = "last_name"
        case firstName = "first_name"
    }
}

