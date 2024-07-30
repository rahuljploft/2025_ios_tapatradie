//
//  RegisterView.swift
//  TapATradie
//
//  Created by Aman Maharjan on 15/10/2021.
//

import Foundation
import UIKit

@IBDesignable class RegisterView: UIView {
    
    @IBOutlet var view: UIView!
    @IBOutlet weak var registerNowButton: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        initView()
        initRegisterButton()
    }
    
    private func initView() {
        view = loadViewFromNib(nibName: "RegisterView", frame: self.bounds)
        view.backgroundColor = .white

        let layer = CAGradientLayer()
        layer.colors = [
          UIColor(red: 0.859, green: 0.357, blue: 0.106, alpha: 1).cgColor,
          UIColor(red: 0.925, green: 0.58, blue: 0.133, alpha: 1).cgColor
        ]
        layer.startPoint = CGPoint(x: 0.25, y: 0.5)
        layer.endPoint = CGPoint(x: 0.75, y: 0.5)
        layer.frame = view.bounds
        
        view.layer.insertSublayer(layer, at: 0)
        self.addSubview(view)
    }
    
    public func initRegisterButton() {
        let padding = CGFloat(10)
        registerNowButton.contentEdgeInsets = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        registerNowButton.layer.cornerRadius = 4
        registerNowButton.layer.borderColor = UIColor.white.cgColor
        registerNowButton.layer.borderWidth = 2
        
        registerNowButton.layer.shadowColor = UIColor(red: 0.639, green: 0.267, blue: 0.078, alpha: 0.25).cgColor
        registerNowButton.layer.shadowOpacity = 1
        registerNowButton.layer.shadowRadius = 40
        registerNowButton.layer.shadowOffset = CGSize(width: 0, height: 4)
    }
    
    @IBAction func registerNow_touchUpInside(_ sender: UIButton) {
        guard let url = URL(string: "https://apps.apple.com/us/app/tradie/id1473400813") else { return }
        UIApplication.shared.open(url)
    }
    
}
