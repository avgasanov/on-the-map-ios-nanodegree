//
//  LogoutResponse.swift
//  on the map
//
//  Created by Abdulla Hasanov on 11/22/19.
//  Copyright © 2019 Abdulla Hasanov. All rights reserved.
//

import Foundation

struct LogoutResponse: Codable {
    let session: Session
    
    enum CodingKeys: String, CodingKey {
        case session = "session"
    }
}

