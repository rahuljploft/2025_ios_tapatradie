//
//  DefaultTextField.swift
//  Common
//
//  Created by Aman Maharjan on 19/10/2021.
//

import Foundation
import UIKit

public class DefaultTextField: UITextField {
    
    @IBInspectable var inset: CGFloat = 15
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        
        borderStyle = .none
        layer.borderColor = UIColor.black.cgColor
        layer.borderWidth = 0.25
        layer.cornerRadius = 6
        
        font = FontResource.gtWalsheimProLight.with(size: 14)
        textColor = UIColor.hexColor(0x343432)
    }
    
    public override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: inset, dy: inset)
    }

    public override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return textRect(forBounds: bounds)
    }
    
}
