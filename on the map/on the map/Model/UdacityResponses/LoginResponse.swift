//
//  LoginResponse.swift
//  on the map
//
//  Created by Abdulla Hasanov on 11/21/19.
//  Copyright © 2019 Abdulla Hasanov. All rights reserved.
//

import Foundation

struct LoginResponse: Codable {
    let account: Account
    let session: Session
    
    enum CodingKeys: String, CodingKey {
        case account = "account"
        case session = "session"
    }
}

struct Account: Codable {
    let registered: Bool
    let key: String
    
    enum CodingKeys: String, CodingKey {
        case registered = "registered"
        case key = "key"
    }
}


