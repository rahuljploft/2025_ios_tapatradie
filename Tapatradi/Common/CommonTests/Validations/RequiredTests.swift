//
//  RequiredTests.swift
//  CommonTests
//
//  Created by Aman Maharjan on 17/09/2021.
//

import XCTest
import Common

class RequiredTests: XCTestCase {

    func test_required_forInvalidInput() {
        let text = ""
        let result = validateRequired(text, ValidationMessage.required)
        XCTAssertFalse(result.isValid)
        XCTAssertTrue(result.validationResult == ValidationMessage.required)
    }
    
    func test_required_forValidInput() {
        let text = "test"
        let result = validateRequired(text, ValidationMessage.required)
        XCTAssertTrue(result.isValid)
        XCTAssertTrue(result.validationResult == "")
    }

}
