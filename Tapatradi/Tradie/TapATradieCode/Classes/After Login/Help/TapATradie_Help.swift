//
//  Help.swift
//  TapATradie
//
//  Created by Apple on 09/05/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import MessageUI

class TapATradie_Help: UIViewController, MFMailComposeViewControllerDelegate {
    
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet var viewC: [UIView]!
    @IBOutlet weak var btnSend: UIButton!
    
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtMsg: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewC.map({($0 as UIView).setCornerRadiusWithBorder(cornerRadius: 2, clipsToBound: false, borderWidth: 0.25, borderColor: UIColor(named: "#000000")?.cgColor)})
        btnSend.setCornerRadiusWithBorder(cornerRadius: 6)
    }
    
    
    
    
    
    
    
    
    @IBAction func actionEmail(_ sender: Any) {
        if MFMailComposeViewController.canSendMail() {
            guard let email = lblEmail.text else { return }
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients([email])
            mail.setMessageBody("", isHTML: true)
            
            present(mail, animated: true)
        } else {
            Http.alert("", "Please configure your email.")
        }
    }
    
    
    @IBAction func btnSendTapped(_ sender: UIButton) {
        if validate() {
            if MFMailComposeViewController.canSendMail() {
                guard let email = lblEmail.text else { return }
                let mail = MFMailComposeViewController()
                mail.mailComposeDelegate = self
                mail.setToRecipients([email])
                mail.setMessageBody(txtMsg.text!, isHTML: true)
                if txtEmail.text! != ""{
                    mail.setPreferredSendingEmailAddress(txtEmail.text!)
                }
                
                present(mail, animated: true)
            } else {
                Http.alert("", "Please configure your email.")
            }
        }

    }
    
    
    func validate() -> Bool {
            
            
            if (txtName.text?.count ?? 0) >= 255 {
                alert(msg: "Please enter character less then 255 in name!")
                return false
            }
            
            if (txtEmail.text?.count ?? 0) >= 255 {
                alert(msg: "Please enter character less then 255 in email!")
                return false
            }
            
            if (txtMsg.text?.count ?? 0) >= 255 {
                alert(msg: "Please enter character less then 255 in message!")
                return false
            }
            
            
            print(validateGenericString(txtName.text ?? ""))
            if !validateGenericString(txtName.text ?? "") {
                alert(msg: "Special character are not allowed in name!")
                return false
            }
            
            print(validateGenericString(txtMsg.text ?? ""))
            if !validateGenericString(txtMsg.text ?? "") {
                alert(msg: "Special character are not allowed in message!")
                return false
            }
            
            
            if (txtName.text ?? "") == "" {
                alert(msg: "Please enter name first!")
                return false
            }else if (txtEmail.text ?? "") == "" {
                alert(msg: "Please enter email first!")
                return false
            }else if (txtMsg.text ?? "") == "" {
                alert(msg: "Please enter message first!")
                return false
            }
            return true
        }


        func validateGenericString(_ string: String) -> Bool {
            return string.range(of: ".*[$&+:;=\\\\?#|/<>^*()%!].*", options: .regularExpression) == nil
        }
    
    func alert(msg:String) {
        let alert = UIAlertController(title: "Tap A Tradie", message: "\(msg)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel))
        self.present(alert, animated: true)
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
}
