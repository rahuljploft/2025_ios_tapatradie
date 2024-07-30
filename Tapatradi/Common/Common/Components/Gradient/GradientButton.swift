//
//  GradientButton.swift
//  Common
//
//  Created by Aman Maharjan on 15/10/2021.
//

import Foundation
import UIKit

public enum ColorOption: Int {
    case one = 1
    case two = 2
    case three = 3
    
    public var colors: [CGColor] {
        switch self {
        case .one:
            return [
                UIColor(red: 0.859, green: 0.357, blue: 0.106, alpha: 1).cgColor,
                UIColor(red: 0.925, green: 0.58, blue: 0.133, alpha: 1).cgColor
            ]
        case .two:
            return [
                UIColor(red: 0.949, green: 0.718, blue: 0.412, alpha: 1).cgColor,
                UIColor(red: 1, green: 0.893, blue: 0.837, alpha: 1).cgColor
            ]
        case .three:
            return [
                UIColor(red: 0.937, green: 0.647, blue: 0.502, alpha: 1).cgColor,
                UIColor(red: 0.965, green: 0.8, blue: 0.714, alpha: 1).cgColor
            ]
        }
    }
}

public enum InsetOption: Int {
    case one = 1
    case two = 2
    case three = 3
    
    public var insets: UIEdgeInsets {
        switch self {
        case .one:
            return UIEdgeInsets(top: 12, left: 15, bottom: 12, right: 15)
        case .two:
            return UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
        case .three:
            return UIEdgeInsets(top: 5, left: 20, bottom: 5, right: 20)
        }
    }
}

@IBDesignable public class GradientButton: UIButton {
    
    private let cornerRadius = CGFloat(4)
    
    @IBInspectable public var showGradient: Bool = true
    {
        didSet {
            (layer as! CAGradientLayer).colors = nil
            if (showGradient) { configureGradient() }
            setNeedsDisplay()
        }
    }
    
    public var colorOption = ColorOption.one
    @IBInspectable var colorOptionValue: Int = 1 {
        didSet {
            guard let colorOption = ColorOption(rawValue: colorOptionValue) else { return }
            self.colorOption = colorOption
        }
    }
    
    @IBInspectable public var borderColor: UIColor = UIColor.black
    
    @IBInspectable public var borderWidth: CGFloat = 0
    
    public var insetOption = InsetOption.one
    @IBInspectable public var insetOptionValue: Int = 1 {
        didSet {
            guard let insetOption = InsetOption(rawValue: insetOptionValue) else { return }
            self.insetOption = insetOption
        }
    }
    
    override open class var layerClass: AnyClass {
        return CAGradientLayer.classForCoder()
    }
    
    private func configureGradient() {
        let layer = self.layer as! CAGradientLayer
        layer.colors = colorOption.colors
        layer.startPoint = CGPoint(x: 0.25, y: 0.5)
        layer.endPoint = CGPoint(x: 0.75, y: 0.5)
    }
    
    private func configureShadow() {
        layer.shadowColor = UIColor(red: 0.537, green: 0.227, blue: 0.071, alpha: 0.1).cgColor
        layer.shadowOpacity = 1
        layer.shadowRadius = 40
        layer.shadowOffset = CGSize(width: 0, height: 4)
    }
    
    override public func awakeFromNib() {
        if (insetOption == .three) {
            titleLabel?.font = FontResource.gtWalsheimProMedium.with(size: 10)
        }
        else {
            titleLabel?.font = FontResource.gtWalsheimProMedium.with(size: 12)
        }
        
        if contentEdgeInsets == UIEdgeInsets.zero { contentEdgeInsets = insetOption.insets }
        
        backgroundColor = .white
        if (showGradient) { configureGradient() }
        configureShadow()
        layer.cornerRadius = cornerRadius
        layer.borderWidth = borderWidth
        layer.borderColor = borderColor.cgColor
    }
}
