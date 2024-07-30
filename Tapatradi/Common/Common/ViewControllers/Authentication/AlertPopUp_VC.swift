//
//  AlertPopUp_VC.swift
//  Common
//
//  Created by Admin on 22/02/23.
//

import UIKit

protocol NewLeadsWork {
    func newLeadsWork(back:Bool)
}

class AlertPopUp_VC: UIViewController {

    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet weak var viewSubmit: UIView!
    var delegate:NewLeadsWork!
    
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
            self.delegate.newLeadsWork(back: true)
        }
    }
    
    
    @IBAction func actionSubmit(_ sender: UIButton) {
        dismiss(animated: true) {
            self.delegate.newLeadsWork(back: false)
        }
    }
    

}
