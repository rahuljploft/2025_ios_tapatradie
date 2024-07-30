//
//  Email.swift
//  Common
//
//  Created by Aman Maharjan on 15/09/2021.
//

import Foundation

public func validateEmail(_ text: String, _ validationResult: String) -> (isValid: Bool, validationResult: String) {
    let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
    let isValid = emailTest.evaluate(with: text)
    return (isValid, isValid ? "" : validationResult)
}
