//
//  IdentityVerification.swift
//  Tradie
//
//  Created by Apple on 07/05/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

let key_identityverification = "key_identityverification"
let key_primaryservices = "key_primaryservices"

class IdentityVerification: UIViewController {
    
    @IBOutlet weak var headerView: HeaderView!
    
    @IBOutlet weak var tfmFullName: MaterialTextFieldView!
    @IBOutlet weak var tfmEmail: MaterialTextFieldView!
    //@IBOutlet weak var tfmCountry: MaterialTextFieldView!
    @IBOutlet weak var tfmCity: MaterialTextFieldView!
    @IBOutlet weak var tfmGender: MaterialTextFieldView!
    @IBOutlet weak var tfmProfessionalExperience: MaterialTextFieldView!
    @IBOutlet weak var tfmPhoneNumber: MaterialTextFieldView!
    @IBOutlet weak var tfmWebsiteLink: MaterialTextFieldView!
    @IBOutlet weak var tvAboutMe: UITextView!
    
    @IBOutlet weak var lblAboutUsPlaceHolder: UILabel!
    
    @IBOutlet weak var cnstLblAboutUsPlaceholder: NSLayoutConstraint!
    @IBAction func actionBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func setData () {
        print("Key_User_full_name-\(Key_User_full_name.getUserValue())-")
        
        strCountry = (Key_User_country1.getUserValue() as? String) ?? ""
        
        tfmFullName.setData(Key_User_full_name)
        
        tfmEmail.setData(Key_User_email)
        
        tfmCity.setData(Key_User_city1)
        
        //tfmCountry.setData(Key_User_country)
        tfmCity.setData(Key_User_city)
        
        tfmGender.setData(Key_User_gender)
        
        tfmProfessionalExperience.setData(Key_User_professional_experience, " years")
        
        tfmPhoneNumber.setData(Key_User_phone_number_withCode)
        
        tfmWebsiteLink.setData(Key_User_website_link)
        
        if let value = Key_User_about_me.getUserValue() as? String {
            tvAboutMe.text = value
            self.cnstLblAboutUsPlaceholder.constant = -10
        }
        
        
        //MARK: Update Himanshu
        let tfmFullName = tfmFullName.textField?.text ?? ""
        let tfmEmail = tfmEmail.textField?.text ?? ""
        let tfmCity = tfmCity.textField?.text ?? ""
        //let tfmGender = tfmGender.textField.text ?? ""
        //let tfmProfessionalExperience = tfmProfessionalExperience.textField.text ?? ""
        let tfmPhoneNumber = tfmPhoneNumber.textField?.text ?? ""
        let tfmWebsiteLink = tfmWebsiteLink.textField?.text ?? ""
        print(tfmFullName)
        print(tfmCity)
        if tfmFullName == "" {
            self.tfmFullName.imgValidation?.isHidden = true
        }else{
            self.tfmFullName.imgValidation?.isHidden = false
        }
        
        if tfmEmail == "" {
            self.tfmEmail.imgValidation?.isHidden = true
        }else{
            self.tfmEmail.imgValidation?.isHidden = false
        }
        
        if tfmCity == "" {
            self.tfmCity.imgValidation?.isHidden = true
        }else{
            self.tfmCity.imgValidation?.isHidden = false
        }
        
//        if tfmGender == "" {
//            self.tfmGender.imgValidation?.isHidden = true
//        }else{
//            self.tfmGender.imgValidation?.isHidden = false
//        }
        
//        if tfmProfessionalExperience == "" {
//            self.tfmProfessionalExperience.imgValidation?.isHidden = true
//        }else{
//            self.tfmProfessionalExperience.imgValidation?.isHidden = false
//        }
        
        if tfmPhoneNumber == "" {
            self.tfmPhoneNumber.imgValidation?.isHidden = true
        }else{
            self.tfmPhoneNumber.imgValidation?.isHidden = false
        }
        
        if tfmWebsiteLink == "" {
            self.tfmWebsiteLink.imgValidation?.isHidden = true
        }else{
            self.tfmWebsiteLink.imgValidation?.isHidden = false
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        kAppDelegate.currentVC = self
        headerView.updateData()
    }
    
    var strCountry:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getCountries ()
        
        tfmFullName.placeHolder = "Full Name"
        tfmFullName.messageText = "*Required"
        
        tfmEmail.placeHolder = "Email"
        tfmEmail.messageText = "*Required"
        //tfmEmail.isEnabled = false
        
        /*
        tfmCountry.placeHolder = "Country"
        tfmCountry.messageText = "Assistive text"
        tfmCountry.isEnabled = false
        tfmCountry.tag = 15
        tfmCountry.hideRight = true
        tfmCountry.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_ :))))
        */
        
        tfmCity.placeHolder = "City"
        tfmCity.messageText = "*Required"
        
        tfmGender.placeHolder = "Gender"
        tfmGender.messageText = "*Required"
        tfmGender.isEnabled = false
        tfmGender.tag = 11
        tfmGender.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_ :))))
        
        tfmProfessionalExperience.placeHolder = "Select Professional Experience"
        tfmProfessionalExperience.messageText = "*Required"
        tfmProfessionalExperience.isEnabled = false
        tfmProfessionalExperience.tag = 12
        tfmProfessionalExperience.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_ :))))
        
        tfmPhoneNumber.placeHolder = "Phone Number"
        tfmPhoneNumber.messageText = "*Required"
        tfmPhoneNumber.keyboardType = UIKeyboardType.phonePad
        
        tfmWebsiteLink.placeHolder = "Website Link"
        tfmWebsiteLink.messageText = "Optional"
        
        tfmGender.hideRight = true
        tfmProfessionalExperience.hideRight = true
        
        tvAboutMe.superview?.border(tfmWebsiteLink.borderColor, CGFloat(tfmWebsiteLink.radious), CGFloat(tfmWebsiteLink.borderWidth))
        
        setData ()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_ :)))
        self.view.addGestureRecognizer(tap)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setData ()
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        self.view.endEditing(true)
        
        let view = sender?.view
        
        if (view?.tag)! == 15 {
            pickerType = PickerType.country
            addPickerView (true)
        } else if (view?.tag)! == 11 {
            pickerType = PickerType.gender
            addPickerView (true)
        } else if (view?.tag)! == 12 {
            pickerType = PickerType.professional
            addPickerView (false)
        }
    }
    
    @IBAction func actionSave(_ sender: Any) {
//        if kAppDelegate.boolSubscriptionExpired {
//            Http.alert("", "Your subscription has been expired", [self, "Subscribe", "Cancel"])
//
//            return
//        }
        
        if validate() {
            let param = params()
            
            param["fullname"] = tfmFullName.textField.text
            param["email"] = tfmEmail.textField.text
            param["country"] = strCountry//tfmCountry.textField.text
            param["city"] = tfmCity.textField.text
            param["gender"] = ""
            param["professional_experience"] = tfmProfessionalExperience.textField.text
            param["phone_number"] = tfmPhoneNumber.textField.text
            param["website_link"] = tfmWebsiteLink.textField.text
            param["about_me"] = tvAboutMe.text
            
            Http.instance().json(api_provider_identify_verification_update, param, "POST", aai: true, popup: true, prnt: true, nil, nil, sync: false, defaultCalling: false) { (json, para, str, http, data) in
                let jsonExp = json as? NSDictionary
                
                if jsonExp != nil {
                    if jsonExp?.number("success").intValue == SESSIONEXPIRED {
                       kAppDelegate.sessionExpired(self)
                    
                    return
                    }
                }
                
                let json = json as? NSDictionary
                
                if json != nil {
                    if json?.number("success").intValue == 1 {
                        Key_User_about_me.setUserValue(param["about_me"] as Any)
                        Key_User_city.setUserValue(param["city"] as Any)
                        Key_User_country.setUserValue(param["country"] as Any)
                        Key_User_email.setUserValue(param["email"] as Any)
                        Key_User_full_name.setUserValue(param["fullname"] as Any)
                        Key_User_gender.setUserValue(param["gender"] as Any)
                        Key_User_phone_number.setUserValue(param["phone_number"] as Any)
                        Key_User_professional_experience.setUserValue(param["professional_experience"] as Any)
                        Key_User_website_link.setUserValue(param["website_link"] as Any)
                        
                        self.navigationController?.popViewController(animated: true)
                    }
                    
                    Http.alert("", json?.string("message"))
                }
            }
        }
    }
    
    @IBOutlet var viewPicker: UIView!
    @IBOutlet weak var pkr: UIPickerView!
    
    @IBAction func actionCancel(_ sender: Any) {
        viewPicker.removeFromSuperview()
        
        if boolGenderPicker {
            tfmGender.endEditing()
        } else {
            tfmProfessionalExperience.endEditing()
        }
    }
    
    @IBAction func actionDone(_ sender: Any) {
        viewPicker.removeFromSuperview()
        let index = pkr.selectedRow(inComponent: 0)
        
        if pickerType == .gender {
            if index > 0 {
                tfmGender.textField.text = arrGender[index]
                tfmGender.status = .varified
            } else {
                tfmGender.status = .nodata
                tfmGender.textField.text = ""
            }
            
            tfmGender.endEditing()
        } else if pickerType == .country {
            /*let row = pkr.selectedRow(inComponent: 0)
            
            let ob = countryJSON?.data[row]
            selectedCountry = ob
            tfmCountry.textField.text = ob?.name
            
            tfmCountry.beginEditing()
            
            tfmCountry?.status = .varified
            tfmCountry?.showNoError()
            tfmCountry?.lblMsg.text = "Assistive text"*/
        } else {
            /*if index <= 0 {
                tfmProfessionalExperience.textField.text = "\(index+1) year"
            } else {
                tfmProfessionalExperience.textField.text = "\(index+1) years"
            }*/
            
            if index <= 0 {
                tfmProfessionalExperience.textField.text =  "\(index+1) year"
            } else {
                if index == (totalExperience-1) {
                    tfmProfessionalExperience.textField.text =  "\(index+1)+ years"
                } else {
                    tfmProfessionalExperience.textField.text =  "\(index+1) years"
                }
            }
            
            tfmProfessionalExperience.status = .varified
            
            tfmProfessionalExperience.endEditing()
        }
        
        /*if boolGenderPicker {
            if index > 0 {
                tfmGender.textField.text = arrGender[index]
                tfmGender.status = .varified
            } else {
                tfmGender.status = .nodata
                tfmGender.textField.text = ""
            }
            
            tfmGender.endEditing()
        } else {
            if index <= 0 {
                tfmProfessionalExperience.textField.text = "\(index+1) year"
            } else {
                tfmProfessionalExperience.textField.text = "\(index+1) years"
            }
            
            tfmProfessionalExperience.status = .varified
            
            tfmProfessionalExperience.endEditing()
        }*/
    }
    
    var boolGenderPicker = false
    
    let arrGender = ["Male", "Female", "Other"]
    
    func openCountriesPicker () {
        viewPicker.frame = self.view.frame
        self.view.addSubview(viewPicker)
        pkr.delegate = self
        pkr.dataSource = self
        pkr.reloadAllComponents()
    }
    
    @IBAction func actionDone1(_ sender: Any) {
        viewPicker.removeFromSuperview()
        
        /*let row = pkr.selectedRow(inComponent: 0)
        
        let ob = countryJSON?.data[row]
        selectedCountry = ob*/
        /*tfmCountry.textField.text = ob?.name
        
        tfmCountry.beginEditing()
        
        tfmCountry?.status = .varified
        tfmCountry?.showNoError()
        tfmCountry?.lblMsg.text = "Assistive text"*/
    }
    
    //var selectedCountry: Country!
    
    @IBAction func actionCancel1(_ sender: Any) {
        viewPicker.removeFromSuperview()
    }
    
    var countryJSON: CountryJSON?
    
    var pickerType: PickerType! = .none
}

enum PickerType {
    case gender
    case country
    case professional
    case none
}

extension IdentityVerification: AlertDelegate {
    func alertZero() {
        let vc = story_Payment.viewController("ChooseSubscripiton") as? ChooseSubscripiton
        vc?.boolFromMenu = false
        self.navigationController?.pushViewController(vc!, animated: false)
    }
    
    func alertOne() {
        
    }

    func getCountries () {
        let param = params()
        
        Http.instance().json(api_get_country_list, param, "POST", aai: true, popup: true, prnt: false, nil, nil, sync: false, defaultCalling: false) { (json, paras, str, data) in
            let jsonExp = json as? NSDictionary
            
            if jsonExp != nil {
                if jsonExp?.number("success").intValue == SESSIONEXPIRED {
                   kAppDelegate.sessionExpired(self)
                    
                    return
                }
            }
            
            if data != nil {
                do {
                    self.countryJSON = try JSONDecoder().decode(CountryJSON.self, from: data!)
                } catch let error {
                    print("Error: \(error)")
                }
            }
        }
    }
}

let totalExperience = 10

extension IdentityVerification: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerType == .gender {
            return arrGender.count
        } else if pickerType == .country {
            if countryJSON != nil {
                return (countryJSON?.data.count)!
            }
            
            return 0
        } else {
            return totalExperience
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerType == .gender {
            return arrGender[row]
        } else if pickerType == .country {
            let ob = countryJSON?.data[row]
            return ob?.name
        } else {
            if row <= 0 {
                return "\(row+1) year"
            } else {
                if row == (totalExperience-1) {
                    return "\(row+1)+ years"
                } else {
                    return "\(row+1) years"
                }
            }
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
    }
}

extension IdentityVerification: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        UIView.animate(withDuration: 0.1) {
            self.cnstLblAboutUsPlaceholder.constant = -10
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.count == 0 {
            UIView.animate(withDuration: 0.1) {
                self.cnstLblAboutUsPlaceholder.constant = 7
            }
        } else if textView.text.count > 0 {
            UIView.animate(withDuration: 0.1) {
                self.cnstLblAboutUsPlaceholder.constant = -10
            }
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            
            return false
        }
        
        return true
    }
}

extension IdentityVerification: UITextFieldDelegate {
    
    func validate () -> Bool {
        var msg: String? = nil
        
        print(tfmFullName.textField.text?.count ?? 0)
        if (tfmFullName.textField.text?.count ?? 0) >= 255 {
            msg = "Please enter character less then 255 in name!"
            showAlert(msgVal: "Please enter character less then 255 in name!")
        }
        
        print(validateGenericString(tfmFullName.textField.text ?? ""))
        if !validateGenericString(tfmFullName.textField.text ?? "") {
            msg = "Special character are not allowed in name!"
            showAlert(msgVal: "Special character are not allowed in name!")
        }
        
        print(tfmEmail.textField.text?.count ?? 0)
        if (tfmEmail.textField.text?.count ?? 0) >= 255 {
            msg = "Please enter character less then 255 in email!"
            showAlert(msgVal: "Please enter character less then 255 in email!")
        }
        
        
        print(tfmCity.textField.text?.count ?? 0)
        if (tfmCity.textField.text?.count ?? 0) >= 255 {
            msg = "Please enter character less then 255 in city!"
            showAlert(msgVal: "Please enter character less then 255 in city!")
        }
        
        print(validateGenericString(tfmCity.textField.text ?? ""))
        if !validateGenericString(tfmCity.textField.text ?? "") {
            msg = "Special character are not allowed in city name!"
            showAlert(msgVal: "Special character are not allowed in city name!")
        }
        
        
        print(tfmWebsiteLink.textField.text?.count ?? 0)
        if (tfmWebsiteLink.textField.text?.count ?? 0) >= 255 {
            msg = "Please enter character less then 80 in website link!"
            showAlert(msgVal: "Please enter character less then 255 in website link!")
        }
        
        if (tfmWebsiteLink.textField.text?.count ?? 0) > 0 {
//            let bool = tfmWebsiteLink.textField.text?.isValidURL
//            if bool == false {
//                msg = "Please enter valid website link!"
//                showAlert(msgVal: "Please enter valid website link!")
//            }
//            if isValidUrl(url: tfmWebsiteLink.textField.text ?? "") == false {
//                msg = "Please enter valid website link!"
//                showAlert(msgVal: "Please enter valid website link!")
//            }
        }
        
        
        
        
        print(tvAboutMe.text.count)
        if (tvAboutMe.text.count) >= 500 {
            msg = "Please enter character less then 500 in about us!"
            showAlert(msgVal: "Please enter character less then 500 in about us!")
        }
        
        if !validateGenericString_website_aboutus(tfmWebsiteLink.textField.text ?? "") {
            msg = "Special character are not allowed in website!"
            showAlert(msgVal: "Special character are not allowed in website!")
        }
        
        if !validateGenericString_website_aboutus(tvAboutMe.text ?? "") {
            msg = "Special character are not allowed in about me!"
            showAlert(msgVal: "Special character are not allowed in about me!")
        }
        
        
        
       
        
        
        if tfmFullName.status == .nodata {
            msg = "Please enter full name."
            showAlert(msgVal: "Please enter full name.")
        }
        else if tfmFullName.status == .error {
            msg = "Invalid full name."
            showAlert(msgVal: "Invalid full name.")
        }
        else if tfmEmail.status == .nodata {
            msg = "Please enter full name."
            showAlert(msgVal: "Please enter email.")
        }
        else if tfmEmail.status == .error {
            msg = "Please enter a valid email address."
            showAlert(msgVal: "Please enter a valid email address.")
        }
        else if tfmCity.status == .nodata {
            msg = "City can not be empty!."
            showAlert(msgVal: "City can not be empty!")
        }
        else if tfmCity.status == .error {
            msg = "City can not be empty!"
            showAlert(msgVal: "City can not be empty!")
        }
        else if tfmProfessionalExperience.status == .nodata {
            msg = "Please select professional experience!"
            showAlert(msgVal: "Please select professional experience!")
        }
        else if tfmProfessionalExperience.status == .error {
            msg = "Invalid professional experience!"
            showAlert(msgVal: "Invalid professional experience!")
        }
        else if tfmPhoneNumber.status == .nodata {
            msg = "Please enter phone number."
            showAlert(msgVal: "Please enter phone number!")
        }
        else if tfmPhoneNumber.status == .error {
            msg = "Invalid phone number."
            showAlert(msgVal: "Invalid phone number!")
        }
        else if tvAboutMe.text.count == 0 {
            msg = "About me can not be empty!"
            showAlert(msgVal: "About me can not be empty!")
        }
        
        if msg == nil {
            return true
        } else {
            tfmFullName.checkEmpty(30, "Full name can't be empty.")
            if tfmEmail.textField.text!.count > 0 {
                tfmEmail.validateEmail(true)
            }
            tfmCity.checkEmpty(20, "City can't be empty.")
            tfmGender.checkEmpty(20, "Please select gender.")
            tfmProfessionalExperience.checkEmpty(20, "Please select professional experience.")
            tfmPhoneNumber.checkEmpty(20, "Phone number can't be empty.")
            
            if tvAboutMe.text.count == 0 {
                tvAboutMe.superview?.border(UIColor.hexColor(0xB00020), CGFloat(tfmWebsiteLink.radious), CGFloat(tfmWebsiteLink.borderWidth))
                lblAboutUsPlaceHolder.textColor = UIColor.hexColor(0xB00020)
            } else {
                tvAboutMe.superview?.border(tfmWebsiteLink.borderColor, CGFloat(tfmWebsiteLink.radious), CGFloat(tfmWebsiteLink.borderWidth))
                lblAboutUsPlaceHolder.textColor = tfmWebsiteLink.borderColor
            }
            
            return false
        }
    }
    
    func isValidUrl(url: String) -> Bool {
        let urlRegEx = "^(https?://)?(www\\.)?([-a-z0-9]{1,63}\\.)*?[a-z0-9][-a-z0-9]{0,61}[a-z0-9]\\.[a-z]{2,6}(/[-\\w@\\+\\.~#\\?&/=%]*)?$"
        let urlTest = NSPredicate(format:"SELF MATCHES %@", urlRegEx)
        let result = urlTest.evaluate(with: url)
        return result
    }
    
    func validateGenericString(_ string: String) -> Bool {
        return string.range(of: ".*[$&+:;=\\\\?#|/<>^*()%!].*", options: .regularExpression) == nil
    }
    
    func validateGenericString_website_aboutus(_ string: String) -> Bool {
        return string.range(of: ".*[$&+;=?#|<>^*()%!].*", options: .regularExpression) == nil
    }
    
    func showAlert(msgVal:String) {
        let alert = UIAlertController(title: "Tap A Tradie", message: "\(msgVal)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel))
        self.present(alert, animated: true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        print("textFieldShouldReturn: ",textField.text)
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        (textField.superview as? MaterialTextFieldView)?.endEditing()
        
        print("EndEditing",textField.text)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        (textField.superview as? MaterialTextFieldView)?.beginEditing()
        
        let superV = (textField.superview as? MaterialTextFieldView)
        
        if superV == tfmGender {
            textField.resignFirstResponder()
            self.view.endEditing(true)
            addPickerView (true)
        } else if superV == tfmProfessionalExperience {
            textField.resignFirstResponder()
            self.view.endEditing(true)
            addPickerView (false)
        }
    }
    
    func addPickerView (_ boolGender: Bool) {
        boolGenderPicker = boolGender
        
        if boolGender {
            tfmGender.beginEditing()
        } else {
            tfmProfessionalExperience.beginEditing()
        }
        
        pkr.delegate = self
        pkr.dataSource = self
        
        pkr.reloadAllComponents()
        
        viewPicker.frame = self.view.bounds
        self.view.addSubview(viewPicker)
        
        self.view.endEditing(true)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let str = textField.text! + string
        
        let superV = (textField.superview as? MaterialTextFieldView)
        
        if superV == tfmPhoneNumber {
            if str.count > 8 {
                return false
            } else if textField.text!.count <= 1 && string.count == 0 {
                (textField.superview as? MaterialTextFieldView)?.status = .error
                (textField.superview as? MaterialTextFieldView)?.showError()
                (textField.superview as? MaterialTextFieldView)?.lblMsg.text = "Phone number can't be empty."
            } else if textField.text!.count < 7 {
                (textField.superview as? MaterialTextFieldView)?.status = .error
                (textField.superview as? MaterialTextFieldView)?.lblMsg.text = "invalid mobile."
                (textField.superview as? MaterialTextFieldView)?.showError()
            } else if textField.text!.count == 8 && string.count == 0 {
                (textField.superview as? MaterialTextFieldView)?.status = .error
                (textField.superview as? MaterialTextFieldView)?.lblMsg.text = "invalid mobile."
                (textField.superview as? MaterialTextFieldView)?.showError()
            } else if str.count == 8 {
                (textField.superview as? MaterialTextFieldView)?.status = .varified
                (textField.superview as? MaterialTextFieldView)?.showNoError()
            }
            
            
        } else if superV == tfmEmail {
            if textField.text!.count <= 1 && string.count == 0 {
                (textField.superview as? MaterialTextFieldView)?.status = .nodata
                //MARK: Himanshu Update
                //(textField.superview as? MaterialTextFieldView)?.showNoValidation()
                (textField.superview as? MaterialTextFieldView)?.custon()
                (textField.superview as? MaterialTextFieldView)?.lblMsg.text = emptyEmailMsg
            } else {
                if str.count > 0 {
                    let bool = validEmail (str)
                    
                    if bool {
                        (textField.superview as? MaterialTextFieldView)?.status = .varified
                        (textField.superview as? MaterialTextFieldView)?.showNoError()
                    } else {
                        (textField.superview as? MaterialTextFieldView)?.status = .error
                        (textField.superview as? MaterialTextFieldView)?.lblMsg.text = wrongEmailMsg
                        (textField.superview as? MaterialTextFieldView)?.showError()
                    }
                } else {
                    (textField.superview as? MaterialTextFieldView)?.status = .varified
                    (textField.superview as? MaterialTextFieldView)?.showNoError()
                }
            }
        } else if superV == tfmWebsiteLink {
            let bool = textField.text?.isValidURL
            
            if textField.text!.count <= 1 && string.count == 0 {
                (textField.superview as? MaterialTextFieldView)?.status = .nodata
                (textField.superview as? MaterialTextFieldView)?.showNoValidation()
                (textField.superview as? MaterialTextFieldView)?.lblMsg.text = "Optional"
            } else if bool == false {
                //(textField.superview as? MaterialTextFieldView)?.status = .error
                //(textField.superview as? MaterialTextFieldView)?.lblMsg.text = "invalid website link."
                //(textField.superview as? MaterialTextFieldView)?.showError()
            } else {
                (textField.superview as? MaterialTextFieldView)?.status = .varified
                (textField.superview as? MaterialTextFieldView)?.showNoError()
            }
        } else if superV == tfmFullName || superV == tfmCity {
            if textField.text!.count <= 1 && string.count == 0 {
                (textField.superview as? MaterialTextFieldView)?.status = .nodata
                (textField.superview as? MaterialTextFieldView)?.showNoValidation()
                (textField.superview as? MaterialTextFieldView)?.lblMsg.text = "*Required"
            } /*else if textField.text!.count < 3 {
                (textField.superview as? MaterialTextFieldView)?.status = .error
                
                if superV == tfmFullName {
                    (textField.superview as? MaterialTextFieldView)?.lblMsg.text = "Full name."
                } else if superV == tfmCountry {
                    (textField.superview as? MaterialTextFieldView)?.lblMsg.text = "invalid country."
                } else if superV == tfmCity {
                    (textField.superview as? MaterialTextFieldView)?.lblMsg.text = "invalid city."
                }
                
                (textField.superview as? MaterialTextFieldView)?.showError()
            }*/ else {
                (textField.superview as? MaterialTextFieldView)?.status = .varified
                (textField.superview as? MaterialTextFieldView)?.showNoError()
            }
        }
        
        if (textField.superview as? MaterialTextFieldView)?.status == .varified {
            (textField.superview as? MaterialTextFieldView)?.lblMsg.text = "*Required"
        }
        
        
        //MARK: Update Himanshu
        
        if textField == tfmFullName.textField {
//            let tfmFullName = tfmFullName.textField.text ?? ""
//            print("Text: ",textField.text)
//            if tfmFullName.count == 1 {
//                self.tfmFullName.imgValidation?.isHidden = true
//            }else{
//                self.tfmFullName.imgValidation?.isHidden = false
//            }
            
            if tfmFullName.status == .nodata {
                self.tfmFullName.imgValidation?.isHidden = true
            }else{
                self.tfmFullName.imgValidation?.isHidden = false
            }
        }
        
        if textField == tfmEmail.textField {
//            let tfmEmail = tfmEmail.textField.text ?? ""
//            print(tfmEmail)
//            if tfmEmail.count == 1 {
//                self.tfmEmail.imgValidation?.isHidden = true
//            }else{
//                self.tfmEmail.imgValidation?.isHidden = false
//            }
            print("Nodata")
            if tfmEmail.status == .nodata {
                self.tfmPhoneNumber.imgValidation?.isHidden = true
            }else{
                self.tfmPhoneNumber.imgValidation?.isHidden = false
            }
        }
        
        
        if textField == tfmCity.textField {
//            let tfmCity = tfmCity.textField.text ?? ""
//            print(tfmCity)
//            if tfmCity.count == 1 {
//                self.tfmCity.imgValidation?.isHidden = true
//            }else{
//                self.tfmCity.imgValidation?.isHidden = false
//            }
            
            if tfmCity.status == .nodata {
                self.tfmCity.imgValidation?.isHidden = true
            }else{
                self.tfmCity.imgValidation?.isHidden = false
            }
        }
        
        
        if textField == tfmPhoneNumber.textField {
//            let tfmPhoneNumber = tfmPhoneNumber.textField.text ?? ""
//            print(tfmPhoneNumber)
//            if tfmPhoneNumber.count == 1 {
//                self.tfmPhoneNumber.imgValidation?.isHidden = true
//            }else{
//                self.tfmPhoneNumber.imgValidation?.isHidden = false
//            }
            
            if tfmPhoneNumber.status == .nodata {
                self.tfmPhoneNumber.imgValidation?.isHidden = true
            }else{
                self.tfmPhoneNumber.imgValidation?.isHidden = false
            }
        }
        
        return true
    }
}

extension String {
    var isValidURL: Bool {
        let detector = try! NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
        if let match = detector.firstMatch(in: self, options: [], range: NSRange(location: 0, length: self.utf16.count)) {
            // it is a link, if the match covers the whole string
            return match.range.length == self.utf16.count
        } else {
            return false
        }
    }
}
