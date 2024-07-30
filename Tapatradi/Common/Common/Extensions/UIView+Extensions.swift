//
//  UIView+Extensions.swift
//  Common
//
//  Created by Aman Maharjan on 15/09/2021.
//

import Foundation
import UIKit

public extension UIView {
    
    func loadViewFromNib(nibName: String, frame: CGRect) -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: nibName, bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.frame = frame
        return view
    }
    
    var parentViewController: UIViewController? {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder!.next
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
        }
        return nil
    }
    
    func border(_ color: UIColor?, _ cornerRadius: CGFloat, _ borderWidth: CGFloat) {
        self.layer.masksToBounds = true
        if color != nil { self.layer.borderColor = color?.cgColor }
        self.layer.cornerRadius = cornerRadius
        self.layer.borderWidth = borderWidth
    }
    
}
