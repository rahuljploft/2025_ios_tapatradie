//
//  PhoneNumberTests.swift
//  CommonTests
//
//  Created by Aman Maharjan on 17/09/2021.
//

import XCTest
import Common

class PhoneNumberTests: XCTestCase {

    func test_validateMobileNumber_forInvalidInputs() {
        let phoneNumbers = ["", "1", "1234567"]
        for phoneNumber in phoneNumbers {
            let result = validateMobileNumber(phoneNumber, ValidationMessage.invalidMobileNumber)
            XCTAssertFalse(result.isValid)
            XCTAssertTrue(result.validationResult == ValidationMessage.invalidMobileNumber)
        }
    }

    func test_validateMobileNumber_forValidInputs() {
        let phoneNumbers = ["12345678", "1234567890"]
        for phoneNumber in phoneNumbers {
            let result = validateMobileNumber(phoneNumber, ValidationMessage.invalidMobileNumber)
            XCTAssertTrue(result.isValid)
            XCTAssert(result.validationResult == "")
        }
    }
    
}
