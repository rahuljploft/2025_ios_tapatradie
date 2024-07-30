//
//  AlertService.swift
//  Common
//
//  Created by Aman Maharjan on 05/10/2021.
//

import Foundation
import UIKit

public class AlertService {
    
    public static var shared = AlertService()
    
    private init() { }
        
    public func showError(title: String = "Error",message: String) {
        let title = title
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        UIApplication.shared.rootViewController?.present(alertController, animated: true, completion: nil)
    }
}
