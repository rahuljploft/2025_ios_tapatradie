//
//  CustomView.swift
//  Common
//
//  Created by Aman Maharjan on 27/10/2021.
//

import Foundation
import UIKit

@IBDesignable public class CustomView: UIView {
    
    @IBInspectable public var cornerRadius: CGFloat = 4
    @IBInspectable public var borderWidth: CGFloat = 0
    @IBInspectable public var borderColor: UIColor = UIColor.hexColor(0xD2D2D2)
    
    private func configure() {
        layer.cornerRadius = cornerRadius
        layer.borderWidth = borderWidth
        layer.borderColor = borderColor.cgColor
    }
    
    public override func awakeFromNib() {
        configure()
    }
    
    public override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        configure()
    }
    
}
