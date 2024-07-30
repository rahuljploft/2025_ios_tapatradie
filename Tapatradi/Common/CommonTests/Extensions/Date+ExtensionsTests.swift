//
//  Date+Extensions.swift
//  CommonTests
//
//  Created by Aman Maharjan on 11/09/2021.
//

import XCTest
import Common

class Date_ExtensionsTests: XCTestCase {
    
    func test_dateComponent_ReturnsDatePartOnly() {
        var components = DateComponents()
        components.year = 2021
        components.month = 9
        components.day = 11
        components.hour = 11
        components.minute = 14
        components.second = 30
        components.nanosecond = 10
        let date = Calendar.current.date(from: components)
        
        components.hour = 0
        components.minute = 0
        components.second = 0
        components.nanosecond = 0
        let dateOnly = Calendar.current.date(from: components)
        
        XCTAssert(date!.dateComponent == dateOnly)
    }
}
