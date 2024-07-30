//
//  LocaleService.swift
//  Common
//
//  Created by Aman Maharjan on 27/09/2021.
//

import Foundation

protocol LocaleServiceProtocol {
    var countryCode: String? { get }
}

public class LocaleService: LocaleServiceProtocol {
    
    public static var shared = LocaleService()
    
    private init() { }
    
    public var countryCode: String? { Locale.current.regionCode }
    
}
