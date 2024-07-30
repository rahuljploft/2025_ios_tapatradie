//
//  BackgroundView.swift
//  Common
//
//  Created by Aman Maharjan on 18/10/2021.
//

import Foundation
import UIKit

@IBDesignable class BackgroundView: UIView {
    
    static let nibName = "\(BackgroundView.self)"
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet var view: UIView!
    
    @IBInspectable var backgroundImage: UIImage? {
        didSet {
            guard let backgroundImage = backgroundImage else { return }
            imageView.image = backgroundImage
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        view = loadViewFromNib(nibName: Self.nibName, frame: self.bounds)
        addSubview(view)
    }
    
}
