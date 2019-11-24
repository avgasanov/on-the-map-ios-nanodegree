//
//  Error.swift
//  on the map
//
//  Created by Abdulla Hasanov on 11/21/19.
//  Copyright © 2019 Abdulla Hasanov. All rights reserved.
//

import Foundation

struct ErrorResponse: Codable {
    let status: Int
    let error: String
    
    enum CodingKeys: String, CodingKey {
        case status = "status"
        case error = "error"
    }
}

extension ErrorResponse: LocalizedError {
    var errorDescription: String? {
        return error
    }
}
