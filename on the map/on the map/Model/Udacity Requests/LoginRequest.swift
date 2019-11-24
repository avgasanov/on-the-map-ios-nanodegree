//
//  LoginRequest.swift
//  on the map
//
//  Created by Abdulla Hasanov on 11/21/19.
//  Copyright © 2019 Abdulla Hasanov. All rights reserved.
//

import Foundation

struct LoginRequest: Codable {
    let udacity: Udacity
    
    enum CodingKeys: String, CodingKey {
        case udacity = "udacity"
    }
    
    init(udacity: Udacity) {
        self.udacity = udacity
    }
    
    init(username: String, password: String) {
        self.udacity = Udacity(username: username, password: password)
    }
}

struct Udacity: Codable {
    let username: String
    let password: String
    
    enum CodingKeys: String, CodingKey {
        case username = "username"
        case password = "password"
    }
    
    init(username: String, password: String) {
        self.username = username
        self.password = password
    }
}
