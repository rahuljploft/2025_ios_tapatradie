//
//  CancelSubscriptionPopUp_VC.swift
//  Tradie
//
//  Created by Admin on 06/02/23.
//

import UIKit

protocol CancelSubscritpion {
    func cancelSubscriptionDele()
}

class CancelSubscriptionPopUp_VC: UIViewController {

    @IBOutlet weak var viewMainCard: UIView!
    @IBOutlet weak var viewNo: UIView!
    @IBOutlet weak var viewYes: UIView!
    var delegate: CancelSubscritpion!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.layer.backgroundColor = UIColor.black.withAlphaComponent(0.5).cgColor
        
        viewMainCard.layer.cornerRadius = 12
        viewMainCard.layer.shadowColor = UIColor.gray.cgColor
        viewMainCard.layer.shadowRadius = 2
        viewMainCard.layer.shadowOffset = .zero
        viewMainCard.layer.shadowOpacity = 0.5
        
        viewNo.layer.cornerRadius = 12
        viewNo.layer.shadowColor = UIColor.gray.cgColor
        viewNo.layer.shadowRadius = 2
        viewNo.layer.shadowOffset = .zero
        viewNo.layer.shadowOpacity = 0.5
        
        viewYes.layer.cornerRadius = 12
        viewYes.layer.shadowColor = UIColor.gray.cgColor
        viewYes.layer.shadowRadius = 2
        viewYes.layer.shadowOffset = .zero
        viewYes.layer.shadowOpacity = 0.5
    }
    
    @IBAction func actionCancel(_ sender: Any) {
        dismiss(animated: true)
    }
    
    
    @IBAction func actionYes(_ sender: UIButton) {
        dismiss(animated: true) {
            self.delegate.cancelSubscriptionDele()
        }
    }
    

}
