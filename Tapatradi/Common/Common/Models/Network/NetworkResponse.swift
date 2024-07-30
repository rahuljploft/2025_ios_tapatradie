//
//  NetworkResponse.swift
//  Common
//
//  Created by Aman Maharjan on 05/10/2021.
//

import Foundation

public protocol NetworkResponse: Decodable {
    var success: Int { get }
    var message: String? { get }
}
