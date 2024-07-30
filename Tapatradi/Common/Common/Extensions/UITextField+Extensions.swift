//
//  UITextField+Extensions.swift
//  Common
//
//  Created by Aman Maharjan on 15/09/2021.
//

import Foundation
import UIKit

public extension UITextField {
    
    // TODO: refactor the name later
    func padding1 (_ pad: Int) {
        DispatchQueue.main.async {
            let paddingView = UIView(frame: CGRect(x: 0,
                                                   y: 0,
                                                   width: pad,
                                                   height: Int(self.frame.size.height)))
            self.leftView = paddingView
            self.leftViewMode = UITextField.ViewMode.always
        }
    }
    
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    
    func setRightPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
    
}
