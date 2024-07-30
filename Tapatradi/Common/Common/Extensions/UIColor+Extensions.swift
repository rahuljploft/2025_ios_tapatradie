//
//  UIColor+Extensions.swift
//  Common
//
//  Created by Aman Maharjan on 15/09/2021.
//

import Foundation
import UIKit

public extension UIColor {
    
    static func hexColor(_ rgb: UInt32, alpha: Double=1.0) -> UIColor {
        let red = CGFloat((rgb & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgb & 0xFF00) >> 8)/256.0
        let blue = CGFloat(rgb & 0xFF)/256.0
        return UIColor(red: red, green: green, blue: blue, alpha: CGFloat(alpha))
    }
    
}
