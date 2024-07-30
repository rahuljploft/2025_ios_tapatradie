//
//  AccessToken.swift
//  Common
//
//  Created by Aman Maharjan on 05/10/2021.
//

import Foundation

struct AccessToken_Internal: NetworkResponse {
    
    let success: Int
    let message: String?
    let token: String?
    
    enum CodingKeys: String, CodingKey {
        case success
        case message
        case token
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        success = try container.decode(Int.self, forKey: .success)
        message = try? container.decode(String.self, forKey: .message)
        token = try? container.decode(String.self, forKey: .token)
    }
    
}
