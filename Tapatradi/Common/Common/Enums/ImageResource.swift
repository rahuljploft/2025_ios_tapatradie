//
//  ImageResource.swift
//  Common
//
//  Created by Aman Maharjan on 17/09/2021.
//

import Foundation
import UIKit

enum ImageResource: String {
    case validationCheck = "green_check"//"Validation Check"
    case validationCross = "Validation Cross"
    
    var image: UIImage? {
        let bundle = Bundle(for: DummyClass.self)
        return UIImage(named: self.rawValue, in: bundle, with: nil)
    }
}
