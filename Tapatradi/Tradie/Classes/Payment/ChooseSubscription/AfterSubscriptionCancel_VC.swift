//
//  AfterSubscriptionCancel_VC.swift
//  Tradie
//
//  Created by Admin on 06/02/23.
//

import UIKit
protocol cancelFinalPopup {
    func finalCancel()
}

class AfterSubscriptionCancel_VC: UIViewController {

    @IBOutlet weak var viewLogo: UIView!
    @IBOutlet weak var viewMainCard: UIView!
    @IBOutlet weak var viewYes: UIView!
    @IBOutlet weak var lbl_date: UILabel!
    var delegate: cancelFinalPopup!
    var endDate = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        view.layer.backgroundColor = UIColor.black.withAlphaComponent(0.5).cgColor
        viewLogo.clipsToBounds = true
        viewLogo.layer.cornerRadius = 5
        
        lbl_date.text = "You have cancelled your Tapatradie Premium Subscription which will end on \(endDate)"
        
        viewMainCard.layer.cornerRadius = 12
        viewMainCard.layer.shadowColor = UIColor.gray.cgColor
        viewMainCard.layer.shadowRadius = 2
        viewMainCard.layer.shadowOffset = .zero
        viewMainCard.layer.shadowOpacity = 0.5
        
        viewYes.layer.cornerRadius = 12
        viewYes.layer.shadowColor = UIColor.gray.cgColor
        viewYes.layer.shadowRadius = 2
        viewYes.layer.shadowOffset = .zero
        viewYes.layer.shadowOpacity = 0.5
    }
    
    @IBAction func actionYes(_ sender: UIButton) {
        dismiss(animated: true) {
            self.delegate.finalCancel()
        }
    }
    

}
