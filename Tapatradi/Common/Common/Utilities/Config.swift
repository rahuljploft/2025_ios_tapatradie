//
//  Config.swift
//  Common
//
//  Created by Aman Maharjan on 29/09/2021.
//

import Foundation
import UIKit

public enum Endpoint: String {
    case getOtp = "user-otp-registration"
}

public class Config {
    
    public static var shared = Config()
    
    private init() { }
    
    public var appRole: String = ""
    
    public func registerFonts() {
        let fonts = Bundle(for: Self.self).urls(forResourcesWithExtension: "ttf", subdirectory: nil)
        fonts?.forEach({ url in
            CTFontManagerRegisterFontsForURL(url as CFURL, .process, nil)
        })
    }
    
}
