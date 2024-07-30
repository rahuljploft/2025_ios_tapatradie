//
//  Required.swift
//  Common
//
//  Created by Aman Maharjan on 17/09/2021.
//

import Foundation

public func validateRequired(_ text: String, _ validationResult: String) -> (isValid: Bool, validationResult: String) {
    let isValid = !text.isEmpty
    return (isValid, isValid ? "" : validationResult)
}
