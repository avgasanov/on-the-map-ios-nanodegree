//
//  StudentsResponse.swift
//  on the map
//
//  Created by Abdulla Hasanov on 11/21/19.
//  Copyright © 2019 Abdulla Hasanov. All rights reserved.
//

import Foundation

struct StudentsResponse: Codable {
    let results: [StudentInformation]
    
    enum CodingKeys: String, CodingKey {
        case results = "results"
    }
}
