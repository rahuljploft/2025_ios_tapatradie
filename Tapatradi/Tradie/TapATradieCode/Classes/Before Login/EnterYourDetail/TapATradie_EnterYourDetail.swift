//
//  EnterYourDetail.swift
//  TapATradie
//
//  Created by Apple on 20/04/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class TapATradie_EnterYourDetail: UIViewController {
    
    @IBOutlet weak var tfvFullName: MaterialTextFieldView!
    @IBOutlet weak var btnGetStarted: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btnGetStarted.isUserInteractionEnabled = true
        tfvFullName.placeHolder = "Full Name"
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_ :)))
        self.view.addGestureRecognizer(tap)
        tfvFullName.hideImg = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        TapATradie_kAppDelegate.TapATradie_currentVC = self
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        self.view.endEditing(true)
    }
    
    @IBAction func actionBack(_ sender: Any) {
        self.self.navigationController?.popViewController(animated: true)
    }
    
    func validateGenericString(_ string: String) -> Bool {
        return string.range(of: ".*[$&+:;=\\\\?#|/<>^*()%!].*", options: .regularExpression) == nil
    }
    
    
    @IBAction func actionGetStarted(_ sender: Any) {
        
        print(validateGenericString(tfvFullName.textField.text ?? ""))
        if !validateGenericString(tfvFullName.textField.text ?? "") {
            let alert = UIAlertController(title: "Tap A Tradie", message: "Special character are not allowed in name!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel))
            self.present(alert, animated: true)
            
            return
        }
        
        
        if tfvFullName.status == .varified {
            let param = TapATradie_params()
            param["fullname"] = tfvFullName.textField.text
            
            Http.instance().json(TapATradie_api_user_register_step2, param, "POST", aai: true, popup: true, prnt: true, nil, nil, sync: false, defaultCalling: false) { (json, paras, str, data) in
                let jsonExp = json as? NSDictionary
                
                if jsonExp != nil {
                    if jsonExp?.number("success").intValue == SESSIONEXPIRED {
                       TapATradie_kAppDelegate.TapATradie_sessionExpired(self)
                    
                    return
                    }
                }
                
                if let json = json as? NSDictionary {
                    if json.number("success").intValue == 1 {
                        let user = UserDefaults.standard
                        user.set(self.tfvFullName.textField.text, forKey: TapATradie_Key_User_full_name)
                        user.synchronize()
                        
                        let vc = TapATradie_story_Auth.TapATradie_viewController("SeeTradiesArround")
                        self.navigationController?.pushViewController(vc!, animated: true)
                    } else {
                        Http.alert("", json.string("message"))
                    }
                }
            }
        } else {
            tfvFullName?.showError()
            
            tfvFullName?.lblMsg.isHidden = false
            tfvFullName?.lblMsg.text = emptyFullname
        }
    }
}

extension TapATradie_EnterYourDetail: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        (textField.superview as? MaterialTextFieldView)?.endEditing()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        (textField.superview as? MaterialTextFieldView)?.beginEditing()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let str = textField.text! + string
        
        if str.count > 255 {
            return false
        } else if textField.text!.count <= 1 && string.count == 0 {
            (textField.superview as? MaterialTextFieldView)?.status = .error
            (textField.superview as? MaterialTextFieldView)?.showError()
            
            (textField.superview as? MaterialTextFieldView)?.lblMsg.isHidden = false
            (textField.superview as? MaterialTextFieldView)?.lblMsg.text = emptyFullname
        } else {
            (textField.superview as? MaterialTextFieldView)?.status = .varified
            (textField.superview as? MaterialTextFieldView)?.showNoError()
            
            (textField.superview as? MaterialTextFieldView)?.lblMsg.isHidden = false
            (textField.superview as? MaterialTextFieldView)?.lblMsg.text = ""
        }
            
            
            /*if textField.text!.count < 2 {
            (textField.superview as? MaterialTextFieldView)?.status = .error
            (textField.superview as? MaterialTextFieldView)?.showError()
        } else if textField.text!.count == 3 && string.count == 0 {
            (textField.superview as? MaterialTextFieldView)?.status = .error
            (textField.superview as? MaterialTextFieldView)?.showError()
        } else if str.count == 3 {
            (textField.superview as? MaterialTextFieldView)?.status = .varified
            (textField.superview as? MaterialTextFieldView)?.showNoError()
        }*/
        
        return true
    }
}

let emptyFullname = "Full name can't be empty."
let wrongFullname = "Invalid Full name can't be empty."
