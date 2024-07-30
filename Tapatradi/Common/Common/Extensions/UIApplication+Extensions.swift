//
//  UIWindow+Extensions.swift
//  Common
//
//  Created by Aman Maharjan on 30/09/2021.
//

import UIKit

public extension UIApplication {
    
    var rootViewController: UIViewController? {
        return UIApplication.shared.windows.first?.rootViewController
    }
    
    var safeAreaInsets: UIEdgeInsets {
        return UIApplication.shared.windows.filter {$0.isKeyWindow}.first!.safeAreaInsets
    }
    
}
