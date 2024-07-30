//
//  FontResource.swift
//  Common
//
//  Created by Aman Maharjan on 23/09/2021.
//

import Foundation
import UIKit

enum FontResource: String {
    case latoRegular = "Lato-Regular"
    case gtWalsheimProLight = "GTWalsheimPro-Light"
    case gtWalsheimProMedium = "GTWalsheimPro-Medium"
    case gtWalsheimProRegular = "GTWalsheimPro-Regular"
    case gtWalsheimProBold = "GTWalsheimPro-Bold"
    
    func with(size: CGFloat) -> UIFont? {
        return UIFont(name: self.rawValue, size: size)
    }
    
}
