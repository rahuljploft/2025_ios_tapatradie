//
//  String+Extensions.swift
//  Common
//
//  Created by Aman Maharjan on 17/09/2021.
//

import Foundation
import UIKit

public extension String {
    
    func validate(_ validationFunctions: [((String, String) -> (isValid: Bool, validationResult: String), validtionResult: String)]) -> (isValid: Bool, validationResult: String) {
        for (validate, validationResult) in validationFunctions {
            let result = validate(self, validationResult)
            if !result.isValid { return result }
        }
        return (true, "")
    }
    
    func openAsUrl() {
        guard let url = URL(string: self) else { return }
        guard UIApplication.shared.canOpenURL(url) else { return }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
}
