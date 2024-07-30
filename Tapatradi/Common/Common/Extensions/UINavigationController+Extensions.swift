//
//  UIViewController+Extensions.swift
//  CommonTests
//
//  Created by Aman Maharjan on 13/09/2021.
//

import Foundation
import UIKit

public extension UINavigationController {
    
    func push(viewController: UIViewController, animated: Bool = true) {
        self.pushViewController(viewController, animated: animated)
    }
    
}
