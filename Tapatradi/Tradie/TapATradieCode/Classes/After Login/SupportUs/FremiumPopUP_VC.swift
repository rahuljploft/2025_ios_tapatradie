//
//  FremiumPopUP_VC.swift
//  Tradie
//
//  Created by Admin on 24/02/23.
//

import UIKit

protocol UpdateData {
    func updateData()
}

class FremiumPopUP_VC: UIViewController {
    
    @IBOutlet weak var btnPurchase: UIButton!
    @IBOutlet weak var vuewButton: UIView!
    @IBOutlet weak var cardView: UIView!
    var delegate:UpdateData!
    
    var SubscriptionImage = ""
    var Title = ""
    var first = ""
    var second = ""
    var third = ""
    var four = ""
    var five = ""
    var six = ""
    var seven = ""
    var eight = ""
    
    @IBOutlet weak var viewSix: UIView!
    @IBOutlet weak var viewSeven: UIView!
    @IBOutlet weak var viewEight: UIView!
    
    @IBOutlet weak var imgSubscription: UIImageView!
    @IBOutlet weak var lbl_Title: UILabel!
    @IBOutlet weak var lbl_first: UILabel!
    @IBOutlet weak var lbl_second: UILabel!
    @IBOutlet weak var lbl_third: UILabel!
    @IBOutlet weak var lbl_four: UILabel!
    @IBOutlet weak var lbl_five: UILabel!
    @IBOutlet weak var lbl_six: UILabel!
    @IBOutlet weak var lbl_seven: UILabel!
    @IBOutlet weak var lbl_eight: UILabel!
    var continueVal = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if continueVal == true {
            btnPurchase.setTitle("Continue", for: .normal)
        }else{
            btnPurchase.setTitle("Purchase", for: .normal)
        }
       
        
        
        if six == "" {
            viewSix.isHidden = true
        }else{
            viewSix.isHidden = false
        }
        
        
        if seven == "" {
            viewSeven.isHidden = true
        }else{
            viewSeven.isHidden = false
        }
        
        if eight == "" {
            viewEight.isHidden = true
        }else{
            viewEight.isHidden = false
        }
        
        imgSubscription.image = UIImage(named: "\(SubscriptionImage)")
        lbl_Title.text = Title
        lbl_first.text = first
        lbl_second.text = second
        lbl_third.text = third
        lbl_four.text = four
        lbl_five.text = five
        lbl_six.text = six
        lbl_seven.text = seven
        lbl_eight.text = eight
        
        vuewButton.clipsToBounds = true
        vuewButton.layer.cornerRadius = 5
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        cardView.layer.cornerRadius = 15
        cardView.layer.shadowColor = UIColor.gray.cgColor
        cardView.layer.shadowOffset = .zero
        cardView.layer.shadowRadius = 2
        cardView.layer.shadowOpacity = 0.5
    }
    
    
    @IBAction func actionClose(_ sender: UIButton) {
        dismiss(animated: true) {}
    }
    
    @IBAction func actionContinue(_ sender: UIButton) {
        dismiss(animated: true) {
            self.delegate.updateData()
        }
    }
    
}
