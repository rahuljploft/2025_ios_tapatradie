//
//  MaterialTextField.swift
//  TapATradie
//
//  Created by Apple on 19/04/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

enum FieldStatus {
    
    case none
    case varified
    case notvarified
    case error
    case nodata
    
}

extension UIView {
    var parentViewController: UIViewController? {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder!.next
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
        }
        return nil
    }
}

class MaterialTextFieldView: UIView {
    override open func draw(_ rect: CGRect) {
        delegate = self.parentViewController as? UITextFieldDelegate
        addSubViews ()
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
    }
    
    var status: FieldStatus = .none
    
    var borderWidth = 1
    var radious = 4
    var hideImg = false
    var placeHolderGap = 15
    var tfFontSize = 14
    var placeHolderfontSize = 12
    var msgFontSize = 12
    var textCout = 0
    var tfFontFamily = "GTWalsheimPro-Light"
    var placeHolderfontFamily = "GTWalsheimPro-Light"
    var msgFontFamily = "GTWalsheimPro-Light"
    
    var messageText = "Required"
    var placeHolder = "Mobile No."
    var text = ""
    
    var textColor = UIColor.TapATradie_hexColor(0x343432)
    
    var textFieldBackgroundColor = UIColor.clear
    
    var placeHolderColor = UIColor.TapATradie_hexColor(0x696969)
    var borderColor = UIColor.TapATradie_hexColor(0xB0B0B0)
    var messageColor = UIColor.TapATradie_hexColor(0x90908E)
    
    var messageErrorColor = UIColor.TapATradie_hexColor(0xC11B1B)
    var borderErrorColor = UIColor.TapATradie_hexColor(0xC11B1B)
    var placeHolderErrorColor = UIColor.TapATradie_hexColor(0xC11B1B)
    
    var textField: UITextField!
    var lblMsg: UILabel!
    var delegate: UITextFieldDelegate?
    var lblPlace: UILabel!
    
    var keyboardType: UIKeyboardType! = .default
    
    var autocapitalizationType: UITextAutocapitalizationType? = .sentences
    
    func addSubViews () {
        let height = self.frame.size.height
        
        let tfH = 3 * (height / 4)
        
        let placeH = tfH / 2
        let extra: CGFloat = 14
        
        lblPlace = UILabel(frame: CGRect(x: CGFloat(placeHolderGap)-(extra/2), y: 18, width: 0, height: placeH))
        lblPlace.text = placeHolder
        lblPlace.backgroundColor = UIColor.white
        lblPlace.textAlignment = .center
        if placeHolderfontFamily.count > 0 {
            lblPlace.font = UIFont(name: placeHolderfontFamily, size: CGFloat(placeHolderfontSize))
        }
        lblPlace.numberOfLines = 0
        lblPlace.sizeToFit()
        lblPlace.frame.size.width = lblPlace.frame.size.width + extra
        self.addSubview(lblPlace)
        
        textField = UITextField(frame: CGRect(x: 0, y: 0, width: self.frame.size.width, height: tfH))
        textField.border(borderColor, CGFloat(radious), CGFloat(borderWidth))
        if tfFontFamily.count > 0 {
            textField.font = UIFont(name: tfFontFamily, size: CGFloat(tfFontSize))
        }
        textField.delegate = delegate
        textField.padding1(placeHolderGap)
        textField.keyboardType = keyboardType
        
        if autocapitalizationType != nil {
            textField.autocapitalizationType = autocapitalizationType!
        } else {
            textField.autocapitalizationType = .none
        }
        
        textField.text = text
        self.addSubview(textField)
        
        let msgH = height / 4
        let lblMsg = UILabel(frame: CGRect(x: CGFloat(placeHolderGap), y: tfH + 5, width: self.frame.size.width, height: msgH))
        
        //print("msgFontFamily-\(msgFontFamily)-\(msgFontSize)-\(CGFloat(msgFontSize))-")
        
        if msgFontFamily.count > 0 {
            let font = UIFont(name: msgFontFamily, size: CGFloat(msgFontSize))
            //print("font-\(font)-")
            lblMsg.font = font//UIFont(name: msgFontFamily, size: CGFloat(msgFontSize))
        }
        
        lblMsg.text = messageText
        lblMsg.textColor = UIColor.red
        
        self.addSubview(lblMsg)
        self.lblMsg = lblMsg
        
        imgValidation = UIImageView(frame: CGRect(x: textField.frame.size.width - 30, y: (textField.frame.size.height/2) - 10, width: 20, height: 20))
        
        if hideImg == false {
            imgValidation?.image = UIImage(named: "green_check")
        }else{
            imgValidation?.image = UIImage(named: "")
        }
        
        //#imageLiteral(resourceName: "Validation Check")
        self.addSubview(imgValidation!)
        
        btnClear = UIButton(frame: CGRect(x: textField.frame.size.width - 50, y: 0, width: 50, height: textField.frame.size.height))
        btnClear!.addTarget(self, action: #selector(self.actionClearData(_:)), for: .touchUpInside)
        self.addSubview(btnClear!)
        
        btnClear?.isHidden = true
        
        lblMsg.textColor = messageColor
        textField.layer.borderColor = borderColor.cgColor
        textField.textColor = textColor
        lblPlace.textColor = placeHolderColor
        
        if text.count > 0 {
            let place = lblPlace.frame
            self.addSubview(lblPlace)
            self.lblPlace.frame.origin.y = (place.size.height / 2) * (-1)
        } else {
            status = .nodata
        }
        
        var lbl61: UILabel?
        
        for vv in self.subviews {
            //print("vvv-\(vv)-")
            
            if let lbl = vv as? UILabel {
                if lbl.text == "+61" {
                    lbl61 = lbl
                    break
                }
            }
        }
        
        if lbl61 != nil {
            self.addSubview(lbl61!)
            
            textField.padding1(Int(lbl61!.frame.origin.x + lbl61!.frame.size.width))
            lblPlace.frame.origin.x = lbl61!.frame.origin.x + lbl61!.frame.size.width
        }
    }
    
    @objc func actionClearData (_ sender: UIButton) {
        textField.text = ""
        
        textField.resignFirstResponder()
        
        endEditing ()
        
        showNoValidation ()
    }
    
    var btnClear: UIButton?
    var imgValidation: UIImageView?
    
    func showError () {
        imgValidation?.image = #imageLiteral(resourceName: "Validation Cross")
        btnClear?.isHidden = false
        
        lblMsg.textColor = messageErrorColor
        textField.layer.borderColor = borderErrorColor.cgColor
        lblPlace.textColor = placeHolderErrorColor
        
        lblMsg.isHidden = true
    }
    
    func showNoError () {
        imgValidation?.image = UIImage(named: "green_check")// #imageLiteral(resourceName: "Validation Check")
        btnClear?.isHidden = true
        print(textField.text?.count)
        lblMsg.textColor = messageColor
        textField.layer.borderColor = borderColor.cgColor
        lblPlace.textColor = placeHolderColor
        
        lblMsg.isHidden = true
    }
    
    func customDes() {
        imgValidation?.image = UIImage(named: "")// #imageLiteral(resourceName: "Validation Check")
        btnClear?.isHidden = true
        
        lblMsg?.textColor = messageColor
        textField?.layer.borderColor = borderColor.cgColor
        lblPlace?.textColor = placeHolderColor
        lblMsg?.isHidden = true
    }
    
    func showNoValidation () {
        imgValidation?.image = UIImage(named: "green_check")//#imageLiteral(resourceName: "Validation Check")
        btnClear?.isHidden = true
        
        lblMsg.textColor = messageColor
        textField.layer.borderColor = borderColor.cgColor
        lblPlace.textColor = placeHolderColor
        
        lblMsg.isHidden = false
    }
    
    func beginEditing () {
        let place = lblPlace.frame
        self.addSubview(lblPlace)
        
        UIView.animate(withDuration: 0.1) {
            self.lblPlace.frame.origin.y = (place.size.height / 2) * (-1)
        }
    }
    
    func endEditing () {
        if textField.text?.count == 0 {
            self.addSubview((self.lblPlace)!)
            
            UIView.animate(withDuration: 0.1) {
                self.lblPlace.frame.origin.y = 18
            }
        }
    }
}

let MAX_LENGTH_PHONENUMBER = 15
let ACCEPTABLE_NUMBERS     = "0123456789"

extension MaterialTextFieldView {
    func numberOnly (_ chr: Int, _ text: String, _ string: String, _ msg: String = "invalid") -> Bool {
        let newLength: Int = text.count + string.count
        let numberOnly = NSCharacterSet.init(charactersIn: ACCEPTABLE_NUMBERS).inverted
        let strValid = string.rangeOfCharacter(from: numberOnly) == nil
        
        var bool = (strValid && (newLength <= MAX_LENGTH_PHONENUMBER))
        
        if bool {
            let str = text + string
            
            if str.count > 0 {
                let int = Int(str)
                
                if int == 0 {
                    bool = false
                }
            }
        }
        
        if textField.text!.count <= 1 && string.count == 0 {
            (textField.superview as? MaterialTextFieldView)?.status = .nodata
            (textField.superview as? MaterialTextFieldView)?.showNoValidation()
            (textField.superview as? MaterialTextFieldView)?.lblMsg.text = "Required"
        } else if bool == false {
            (textField.superview as? MaterialTextFieldView)?.status = .error
            (textField.superview as? MaterialTextFieldView)?.lblMsg.text = msg
            (textField.superview as? MaterialTextFieldView)?.showError()
        } else {
            (textField.superview as? MaterialTextFieldView)?.status = .varified
            (textField.superview as? MaterialTextFieldView)?.showNoError()
        }
        
        return bool
    }
    
    func characters (_ chr: Int, _ text: String, _ string: String, _ msg: String = "invalid") {
        if textField.text!.count <= 1 && string.count == 0 {
            (textField.superview as? MaterialTextFieldView)?.status = .nodata
            (textField.superview as? MaterialTextFieldView)?.showNoValidation()
            (textField.superview as? MaterialTextFieldView)?.lblMsg.text = "Required"
        } else if textField.text!.count < chr {
            (textField.superview as? MaterialTextFieldView)?.status = .error
            (textField.superview as? MaterialTextFieldView)?.lblMsg.text = msg
            (textField.superview as? MaterialTextFieldView)?.showError()
        } else {
            (textField.superview as? MaterialTextFieldView)?.status = .varified
            (textField.superview as? MaterialTextFieldView)?.showNoError()
        }
    }
    
    func email (_ text: String, _ string: String, _ msg: String = "invalid") {
        if textField.text!.count <= 1 && string.count == 0 {
            (textField.superview as? MaterialTextFieldView)?.status = .nodata
            (textField.superview as? MaterialTextFieldView)?.showNoValidation()
            (textField.superview as? MaterialTextFieldView)?.lblMsg.text = "Required"
        } else {
            let bool = TapATradie_validEmail (text)
            
            if bool {
                (textField.superview as? MaterialTextFieldView)?.status = .varified
                (textField.superview as? MaterialTextFieldView)?.showNoError()
            } else {
                (textField.superview as? MaterialTextFieldView)?.status = .error
                (textField.superview as? MaterialTextFieldView)?.lblMsg.text = msg
                (textField.superview as? MaterialTextFieldView)?.showError()
            }
        }
    }
    
    func mobile (_ chr: Int, _ text: String, _ string: String, _ msg: String = "invalid") -> Bool {
        if text.count > 13 {
            return false
        } else if textField.text!.count <= 1 && string.count == 0 {
            (textField.superview as? MaterialTextFieldView)?.status = .nodata
            (textField.superview as? MaterialTextFieldView)?.showNoValidation()
            (textField.superview as? MaterialTextFieldView)?.lblMsg.text = "Required"
        } else if textField.text!.count < (chr - 1) {
            (textField.superview as? MaterialTextFieldView)?.status = .error
            (textField.superview as? MaterialTextFieldView)?.lblMsg.text = "minimum \(chr) digit required."
            (textField.superview as? MaterialTextFieldView)?.showError()
        } else if textField.text!.count == chr && string.count == 0 {
            (textField.superview as? MaterialTextFieldView)?.status = .error
            (textField.superview as? MaterialTextFieldView)?.lblMsg.text = "minimum \(chr) digit required."
            (textField.superview as? MaterialTextFieldView)?.showError()
        } else if text.count >= chr {
            (textField.superview as? MaterialTextFieldView)?.lblMsg.text = ""
            (textField.superview as? MaterialTextFieldView)?.status = .varified
            (textField.superview as? MaterialTextFieldView)?.showNoError()
        }
        
        return true
    }
    
    func validateMobile (_ chr: Int, _ empty: String = emptyMobileMsg, _ wrong: String = wrongMobileMsg) -> Bool {
        if textField.text!.count > 13 {
            return false
        } else if textField.text!.count == 0 {
            (textField.superview as? MaterialTextFieldView)?.status = .nodata
            (textField.superview as? MaterialTextFieldView)?.showError()
            (textField.superview as? MaterialTextFieldView)?.lblMsg.text = empty
            (textField.superview as? MaterialTextFieldView)?.lblMsg.isHidden = false
            return false
        } else if textField.text!.count < chr {
            (textField.superview as? MaterialTextFieldView)?.status = .error
            (textField.superview as? MaterialTextFieldView)?.lblMsg.text = wrong
            (textField.superview as? MaterialTextFieldView)?.showError()
            (textField.superview as? MaterialTextFieldView)?.lblMsg.isHidden = false
            return false
        } else if text.count >= chr {
            (textField.superview as? MaterialTextFieldView)?.lblMsg.text = ""
            (textField.superview as? MaterialTextFieldView)?.status = .varified
            (textField.superview as? MaterialTextFieldView)?.showNoError()
            (textField.superview as? MaterialTextFieldView)?.lblMsg.isHidden = true
        }
        
        return true
    }
    
    func validateEmail (_ boolOptional: Bool = false) {
        if textField.text!.count == 0 {
            if boolOptional {
                (textField.superview as? MaterialTextFieldView)?.status = .error
                (textField.superview as? MaterialTextFieldView)?.lblMsg.text = emptyEmailMsg
                (textField.superview as? MaterialTextFieldView)?.showError()
                
                (textField.superview as? MaterialTextFieldView)?.lblMsg.isHidden = false
            } else {
                (textField.superview as? MaterialTextFieldView)?.status = .varified
                (textField.superview as? MaterialTextFieldView)?.lblMsg.text = ""
                
                (textField.superview as? MaterialTextFieldView)?.showNoError()
            }
        } else {
            let bool = TapATradie_validEmail (textField.text!)
            
            if bool {
                (textField.superview as? MaterialTextFieldView)?.status = .varified
                (textField.superview as? MaterialTextFieldView)?.showNoError()
                (textField.superview as? MaterialTextFieldView)?.lblMsg.text = ""
            } else {
                (textField.superview as? MaterialTextFieldView)?.status = .error
                (textField.superview as? MaterialTextFieldView)?.lblMsg.text = wrongEmailMsg
                (textField.superview as? MaterialTextFieldView)?.showError()
            }
            
            (textField.superview as? MaterialTextFieldView)?.lblMsg.isHidden = false
        }
    }
    
    func checkEmpty (_ chr: Int, _ empty: String) {
        if textField.text!.count > 30 {
            
        } else if textField.text!.count == 0 {
            (textField.superview as? MaterialTextFieldView)?.status = .error
            (textField.superview as? MaterialTextFieldView)?.showError()
            (textField.superview as? MaterialTextFieldView)?.lblMsg.text = empty
            (textField.superview as? MaterialTextFieldView)?.lblMsg.isHidden = false
        } else if textField.text!.count > 0 {
            (textField.superview as? MaterialTextFieldView)?.status = .varified
            (textField.superview as? MaterialTextFieldView)?.lblMsg.text = ""
            (textField.superview as? MaterialTextFieldView)?.showNoError()
            (textField.superview as? MaterialTextFieldView)?.lblMsg.isHidden = false
        }
    }
}

let emptyMobileMsg = "Mobile no. can't be empty"
let wrongMobileMsg = "Please enter valid mobile no"

let emptyEmailMsg = "Email can't be empty"
let wrongEmailMsg = "Please enter a valid email address"
