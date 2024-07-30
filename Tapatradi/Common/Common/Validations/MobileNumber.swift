//
//  PhoneNumber.swift
//  Common
//
//  Created by Aman Maharjan on 17/09/2021.
//

import Foundation

// TODO: Need modification
public func validateMobileNumber(_ text: String, _ validationResult: String) -> (isValid: Bool, validationResult: String) {
    let isValid = text.count >= 8
    return (isValid, isValid ? "" : validationResult)
}
