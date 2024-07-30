//
//  GradientView.swift
//  Common
//
//  Created by Aman Maharjan on 27/10/2021.
//

import Foundation
import UIKit

@IBDesignable public class GradientView: CustomView {
    @IBInspectable public var startColor: UIColor = .black { didSet { updateColors() }}
    @IBInspectable public var endColor: UIColor = .white { didSet { updateColors() }}
    @IBInspectable public var startLocation: Double =   0.25 { didSet { updateLocations() }}
    @IBInspectable public var endLocation: Double =   0.75 { didSet { updateLocations() }}
    @IBInspectable public var horizontalMode: Bool =  false { didSet { updatePoints() }}
    @IBInspectable public var diagonalMode: Bool =  false { didSet { updatePoints() }}
    
    @IBInspectable var colorOptionValue: Int = 1 {
        didSet {
            guard let colorOption = ColorOption(rawValue: colorOptionValue) else { return }
            startColor = UIColor(cgColor: colorOption.colors[0])
            endColor = UIColor(cgColor: colorOption.colors[1])
            updateColors()
        }
    }

    override public class var layerClass: AnyClass { CAGradientLayer.self }

    var gradientLayer: CAGradientLayer { layer as! CAGradientLayer }

    private func updatePoints() {
        if horizontalMode {
            gradientLayer.startPoint = diagonalMode ? .init(x: 1, y: 0) : .init(x: 0, y: 0.5)
            gradientLayer.endPoint   = diagonalMode ? .init(x: 0, y: 1) : .init(x: 1, y: 0.5)
        } else {
            gradientLayer.startPoint = diagonalMode ? .init(x: 0, y: 0) : .init(x: 0.5, y: 0)
            gradientLayer.endPoint   = diagonalMode ? .init(x: 1, y: 1) : .init(x: 0.5, y: 1)
        }
    }
    
    private func updateLocations() {
        gradientLayer.locations = [startLocation as NSNumber, endLocation as NSNumber]
    }
    
    private func updateColors() {
        gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
    }
    
    override public func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        updatePoints()
        updateLocations()
        updateColors()
    }

}
