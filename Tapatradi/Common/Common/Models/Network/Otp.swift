//
//  Otp.swift
//  Common
//
//  Created by Aman Maharjan on 05/10/2021.
//

import Foundation

public struct Otp: NetworkResponse {

    public let success: Int
    public let message: String?
    public let userId: Int?
    public let otpCode: Int?
    
    enum CodingKeys: String, CodingKey {
        case success
        case message
        case userId = "uid"
        case otpCode = "otp"
    }
    
}

extension Otp: Decodable {
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        success = try container.decode(Int.self, forKey: .success)
        message = try? container.decode(String.self, forKey: .message)
        userId = try? container.decode(Int.self, forKey: .userId)
        otpCode = try? container.decode(Int.self, forKey: .otpCode)
    }
    
}
