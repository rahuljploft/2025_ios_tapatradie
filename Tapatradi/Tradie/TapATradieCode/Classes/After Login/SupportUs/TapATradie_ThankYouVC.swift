//
//  ThankYouVC.swift
//  TapATradie
//
//  Created by Sarjan Singh on 24/01/22.
//

import UIKit

protocol TapATradie_ThankyouDelegate: AnyObject{
    func thankyouDismissed()
}

class TapATradie_ThankYouVC: UIViewController {

    
    @IBOutlet weak var btnOk: UIButton!
    @IBOutlet weak var viewThankYou: UIView!
    
    weak var delegate: TapATradie_ThankyouDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewThankYou.layer.cornerRadius = 8
    }
        
    @IBAction func btnOktapped(_ sender: UIButton) {
        self.dismiss(animated: true) {
            self.delegate?.thankyouDismissed()
        }
    }

}
