//
//  GradientView.swift
//  Common
//
//  Created by Aman Maharjan on 27/10/2021.
//

import Foundation
import UIKit

open class GradientView: UIView {
    
    @IBInspectable open var startColor: UIColor = .clear { didSet { updateColors() } }
    @IBInspectable open var endColor: UIColor = .black { didSet { updateColors() } }

    override open class var layerClass: AnyClass {
        return CAGradientLayer.classForCoder()
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        let gradientLayer = layer as! CAGradientLayer
        gradientLayer.startPoint = CGPoint(x: 0.25, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 0.75, y: 0.5)
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
    }
    
    private func updateColors() {
        self.configureColors(start: self.startColor, end: self.endColor)
    }
    
    open func configureColors(start: UIColor, end: UIColor) {
        let gradientLayer = layer as! CAGradientLayer
        gradientLayer.colors = [start.cgColor, end.cgColor]
    }

}

