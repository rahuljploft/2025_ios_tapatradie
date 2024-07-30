//
//  EmailTests.swift
//  CommonTests
//
//  Created by Aman Maharjan on 17/09/2021.
//

import XCTest
import Common

class EmailTests: XCTestCase {

    func test_validateEmail_forInvalidInputs() {
        let emails = ["", "test", "test@", "test.test"]
        for email in emails {
            let result = validateEmail(email, ValidationMessage.invalidEmail)
            XCTAssertFalse(result.isValid)
            XCTAssertTrue(result.validationResult == ValidationMessage.invalidEmail)
        }
    }

    func test_validateEmail_validInputs() {
        let emails = ["test@example.com", "test1@example.com", "test.test@example.org"]
        for email in emails {
            let result = validateEmail(email, ValidationMessage.invalidEmail)
            XCTAssertTrue(result.isValid)
            XCTAssert(result.validationResult == "")
        }
    }
    
}
