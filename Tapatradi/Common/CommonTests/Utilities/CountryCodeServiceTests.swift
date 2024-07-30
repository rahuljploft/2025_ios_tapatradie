//
//  CountryCodes.swift
//  CommonTests
//
//  Created by Aman Maharjan on 15/09/2021.
//

import XCTest
import Common

class CountryCodeServiceTests: XCTestCase {

    func test_CountryCodes_toDictionary_convertsCountryArrayToDictionary() {
        let countries = [
            Country(id: 149, iso: "NP", iso3: "NPL", name: "NEPAL", niceName: "Nepal", numericCode: 524, phoneCode: 977),
            Country(id: 0, iso: "AA", iso3: nil, name: "A TEST", niceName: "A Test", numericCode: nil, phoneCode: 0)]
        let dictionary = CountryService.shared.toDictionary(countries)
        XCTAssertTrue(dictionary["NP"] == countries[0])
        XCTAssertTrue(dictionary["AA"] == countries[1])
    }

}
