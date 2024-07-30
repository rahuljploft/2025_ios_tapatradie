//
//  SubscPopUP_VC.swift
//  Tradie
//
//  Created by Admin on 23/02/23.
//

import UIKit

class SubscPopUP_VC: UIViewController {


        @IBOutlet weak var cardView: UIView!
        @IBOutlet weak var btnCancel: UIButton!
        @IBOutlet weak var btnSubmit: UIButton!
        @IBOutlet weak var viewSubmit: UIView!
        var parentVC:MyBookings!
        
        override func viewDidLoad() {
            super.viewDidLoad()
            view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
            cardView.layer.cornerRadius = 12
            btnCancel.clipsToBounds = true
            btnCancel.layer.cornerRadius = 5
            viewSubmit.clipsToBounds = true
            viewSubmit.layer.cornerRadius = 5
            viewSubmit.layer.borderWidth = 1
            viewSubmit.layer.borderColor = UIColor.gray.cgColor
        }
        
        @IBAction func actionCancel(_ sender: UIButton) {
            dismiss(animated: true) {
                //self.parentVC.navigatetoPremium()
            }
        }
        
        
        @IBAction func actionSubmit(_ sender: UIButton) {
            dismiss(animated: true) {
                self.parentVC.navigatetoPremium()
            }
        }
        

    }
