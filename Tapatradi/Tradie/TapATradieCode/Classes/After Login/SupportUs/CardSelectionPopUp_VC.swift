//
//  CardSelectionPopUp_VC.swift
//  Tradie
//
//  Created by Admin on 06/02/23.
//

import UIKit

enum PaymentOption {
    case stripe
    case inapp
    case other
}

protocol SelectedPaymentOption {
    func selectPaymentMethod(peymentMethod:PaymentOption)
}

class CardSelectionPopUp_VC: UIViewController {

    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var inappView: UIView!
    @IBOutlet weak var stripeView: UIView!
    @IBOutlet weak var btnView: UIView!
    var delegate:SelectedPaymentOption?
    var paymentOption : PaymentOption = .other
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cardView.layer.maskedCorners = [.layerMaxXMinYCorner,.layerMinXMinYCorner]
        cardView.layer.cornerRadius = 18
        
        inappView.layer.cornerRadius = 10
        inappView.layer.shadowColor = UIColor.gray.cgColor
        inappView.layer.shadowOffset = .zero
        inappView.layer.shadowRadius = 1.5
        inappView.layer.shadowOpacity = 0.5
        
        stripeView.layer.cornerRadius = 10
        stripeView.layer.shadowColor = UIColor.gray.cgColor
        stripeView.layer.shadowOffset = .zero
        stripeView.layer.shadowRadius = 1.5
        stripeView.layer.shadowOpacity = 0.5
        
        btnView.clipsToBounds = true
        btnView.layer.cornerRadius = 10
        
    }
    
    
    @IBAction func actionStripe(_ sender: UIButton) {
        
        paymentOption = .stripe
        inappView.layer.borderColor = UIColor.systemOrange.cgColor
        inappView.layer.borderWidth = 0
        inappView.layer.cornerRadius = 10
        inappView.layer.shadowColor = UIColor.gray.cgColor
        inappView.layer.shadowOffset = .zero
        inappView.layer.shadowRadius = 1.5
        inappView.layer.shadowOpacity = 0.5
        
        stripeView.layer.cornerRadius = 10
        stripeView.layer.borderColor = UIColor.systemOrange.cgColor
        stripeView.layer.borderWidth = 2
        stripeView.layer.shadowColor = UIColor.systemOrange.cgColor
        stripeView.layer.shadowOffset = .zero
        stripeView.layer.shadowRadius = 0.5
        stripeView.layer.shadowOpacity = 0.5
    }
    
    @IBAction func actionInApp(_ sender: UIButton) {
        
        paymentOption = .inapp
        
        stripeView.layer.borderColor = UIColor.systemOrange.cgColor
        stripeView.layer.borderWidth = 0
        stripeView.layer.cornerRadius = 10
        stripeView.layer.shadowColor = UIColor.gray.cgColor
        stripeView.layer.shadowOffset = .zero
        stripeView.layer.shadowRadius = 1.5
        stripeView.layer.shadowOpacity = 0.5
        
        
        inappView.layer.cornerRadius = 10
        inappView.layer.borderColor = UIColor.systemOrange.cgColor
        inappView.layer.borderWidth = 2
        inappView.layer.shadowColor = UIColor.systemOrange.cgColor
        inappView.layer.shadowOffset = .zero
        inappView.layer.shadowRadius = 0.5
        inappView.layer.shadowOpacity = 0.5
    }
    
    @IBAction func actionContinue(_ sender: UIButton) {
        if paymentOption == .inapp || paymentOption == .stripe {
            if delegate != nil {
                dismiss(animated: true) {
                    self.delegate?.selectPaymentMethod(peymentMethod: self.paymentOption)
                }
            }else{
                let alert = UIAlertController(title: "Tap A Tradie", message: "Something went Wrong.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel))
                self.present(alert, animated: true)
            }
        }else{
            let alert = UIAlertController(title: "Tap A Tradie", message: "Please select payment method first", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel))
            self.present(alert, animated: true)
        }
    }
    
}
