//
//  CustomTextFieldViewModel.swift
//  Common
//
//  Created by Aman Maharjan on 24/09/2021.
//

import Foundation
import UIKit

public class CustomTextFieldViewModel {
    
    private let countryFlagService: CountryFlagServiceProtocol
    
    public let country = Box<Country1?>(nil)
    public let phoneCode = Box<String?>(nil)
    public let countryFlag = Box<UIImage?>(nil)
    
    public init(countryFlagService: CountryFlagServiceProtocol) {
        self.countryFlagService = countryFlagService
    }
    
    public func set(country: Country1?) {
        if let country = country {
            self.phoneCode.value = " +\(country.phoneCode)"
            self.countryFlag.value = countryFlagService.flag(for: country.iso)
        }
        else {
            self.phoneCode.value = nil
            self.countryFlag.value = nil
        }
    }
    
}
