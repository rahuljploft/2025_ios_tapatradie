//
//  CountryFlagService.swift
//  Common
//
//  Created by Aman Maharjan on 24/09/2021.
//

import Foundation
import FlagKit

public protocol CountryFlagServiceProtocol {
    func flag(for countryCode: String) -> UIImage?
}

public class CountryFlagService: CountryFlagServiceProtocol {
    
    public static var shared = CountryFlagService()
    
    private init() { }
    
    public func flag(for countryCode: String) -> UIImage? {
        return Flag(countryCode: countryCode)?.image(style: .none)
    }
    
}
