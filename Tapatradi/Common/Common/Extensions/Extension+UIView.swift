//
//  Extension+UIView.swift
//  Urban Clap
//
//  Created by JPLoft_2 on 05/10/21.
//

import Foundation
import UIKit


//MARK: - Add Shadow to view

public extension UIView {

    func addShadow(offset: CGSize = .zero, color: UIColor = .gray, radius: CGFloat = 3.0, opacity: Float = 0.50, cornerRadius:CGFloat = 10) {
        
        layer.masksToBounds = false
        layer.shadowOffset = offset
        layer.shadowColor = color.cgColor
        layer.shadowRadius = radius
        layer.shadowOpacity = opacity
        layer.cornerRadius = cornerRadius

        let backgroundCGColor = backgroundColor?.cgColor
        backgroundColor = nil
        layer.backgroundColor =  backgroundCGColor
        
    }
}


//MARK: - Set Corner Radius to view

public extension UIView{
    
    func setCornerRadiusWithBorder(cornerRadius:CGFloat = 10, clipsToBound:Bool = true, borderWidth:CGFloat = 0.0, borderColor:CGColor? = UIColor.clear.cgColor){
        
        self.layer.cornerRadius = cornerRadius
        self.clipsToBounds = clipsToBound
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = borderColor ?? UIColor.gray.cgColor
        
    }
    
}
