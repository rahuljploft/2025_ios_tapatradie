//
//  CustomTextFieldViewModelTests.swift
//  CommonTests
//
//  Created by Aman Maharjan on 24/09/2021.
//

import XCTest
import Common
import UIKit

class MockCountryFlagService: CountryFlagServiceProtocol {
    func flag(for countryCode: String) -> UIImage? { return UIImage() }
}

class CustomTextFieldViewModelTests: XCTestCase {

    func testExample() throws {
        let countryFlagService = MockCountryFlagService()
        let viewModel = CustomTextFieldViewModel(countryFlagService: countryFlagService)
        
        viewModel.set(country: Country(id: 13, iso: "AU", iso3: "AUS", name: "AUSTRALIA", niceName: "Australia", numericCode: 36, phoneCode: 61))
        
        viewModel.phoneCode.bind { countryCode in
            XCTAssertEqual(countryCode, " +61")
        }
        viewModel.countryFlag.bind { countryFlag in
            XCTAssertNotNil(countryFlag)
        }
    }
    
}
