//
//  FrequentlyAskedQuestion.swift
//  TapATradie
//
//  Created by MacBook Air on 10/05/22.
//

import UIKit

class FrequentlyAskedQuestion: UIViewController {

    @IBOutlet weak var CardView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        CardView.layer.cornerRadius = 10
        CardView.layer.shadowColor = UIColor.gray.cgColor
        CardView.layer.shadowOffset = .zero
        CardView.layer.shadowOpacity = 0.5
        CardView.layer.shadowRadius = 2 
    }

}
