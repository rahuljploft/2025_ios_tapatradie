//
//  String+Extensions.swift
//  CommonTests
//
//  Created by Aman Maharjan on 17/09/2021.
//

import XCTest
import Common

class String_Extensions: XCTestCase {

    func test_validate_forInvalidInput() {
        let validationFunctions = [
            (validateRequired, ValidationMessage.required),
            (validateMobileNumber, ValidationMessage.invalidMobileNumber)
        ]
        var text = ""
        var result = text.validate(validationFunctions)
        XCTAssertFalse(result.isValid)
        XCTAssertTrue(result.validationResult == ValidationMessage.required)
        
        text = "1"
        result = text.validate(validationFunctions)
        XCTAssertFalse(result.isValid)
        XCTAssertTrue(result.validationResult == ValidationMessage.invalidMobileNumber)
    }
    
    func test_validate_forValidInput() {
        let validationFunctions = [
            (validateRequired, ValidationMessage.required),
            (validateMobileNumber, ValidationMessage.invalidMobileNumber)
        ]
        let text = "12345678"
        let result = text.validate(validationFunctions)
        XCTAssertTrue(result.isValid)
        XCTAssertTrue(result.validationResult == "")
    }

}
