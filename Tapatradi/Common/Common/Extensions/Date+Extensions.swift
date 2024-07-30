//
//  Date+Extensions.swift
//  TapATradie
//
//  Created by Aman Maharjan on 03/09/2021.
//  Copyright © 2021 Tap A Tradie Pty Ltd. All rights reserved.
//

import Foundation

public extension Date {
    
    var dateComponent: Date? {
        let calender = Calendar.current
        let dateComponents = calender.dateComponents([.year, .month, .day], from: self)
        return calender.date(from: dateComponents)
    }
    
}
