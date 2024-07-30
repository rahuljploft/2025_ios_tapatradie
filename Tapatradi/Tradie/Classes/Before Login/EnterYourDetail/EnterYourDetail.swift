//
//  EnterYourDetail.swift
//  Tradie
//
//  Created by Apple on 20/04/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class EnterYourDetail: BaseVC {
    var selectionStatus = false
    @IBOutlet weak var img_Checkbox: UIImageView!
    @IBOutlet weak var tfvFullName: MaterialTextFieldView!
    @IBOutlet weak var tfvEmail: MaterialTextFieldView!
    @IBOutlet weak var tfvCountry: MaterialTextFieldView!
    @IBOutlet weak var tfvCity: MaterialTextFieldView!
    
    @IBOutlet weak var btnGetStarted: UIButton!
    
    override func viewWillAppear(_ animated: Bool) {
        kAppDelegate.currentVC = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        tfvFullName.placeHolder = "Full Name"
        tfvEmail.placeHolder = "Email"
        tfvCountry.placeHolder = "Country"
        tfvCity.placeHolder = "City"
        
        tfvFullName.messageText = "*Required"
        tfvEmail.messageText = "*Required"
        tfvEmail.keyboardType = UIKeyboardType.emailAddress
        
        tfvCountry.messageText = "*Required"
        tfvCity.messageText = "*Required"
        
        tfvCountry.isEnabled = false
        tfvCountry.tag = 11
        tfvCountry.hideRight = true
        tfvCountry.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_ :))))
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_ :)))
        self.view.addGestureRecognizer(tap)
        
        self.tfvFullName.imgValidation?.isHidden = true
        self.tfvEmail.imgValidation?.isHidden = true
        self.tfvCountry.imgValidation?.isHidden = true
        self.tfvCity.imgValidation?.isHidden = true
        getCountries ()
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        if sender?.view?.tag == 11 {
            openCountriesPicker()
        }
        
        self.view.endEditing(true)
    }
    
    @IBAction func actionBack(_ sender: Any) {
        self.self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func Action_CheckBoxSelect(_ sender: UIButton) {
        if selectionStatus == true {
            selectionStatus = false
            img_Checkbox.image = UIImage(named: "EmptyCheckBox")
        }else{
            selectionStatus = true
            img_Checkbox.image = UIImage(named: "SelectedCheckBox")
        }
    }
    
    
    @IBAction func Actino_TermsCondition(_ sender: UIButton) {
        "https://www.tapatradie.com/terms-conditions".openAsUrl()
    }
    
    @IBAction func Actino_PrivacyPolicy(_ sender: UIButton) {
        "https://www.tapatradie.com/privacy-policy".openAsUrl()
    }
    
    
    func validate () -> Bool {
        //tfvFullName.checkEmpty(30, "Full name can't be empty.")
//        if tfvEmail.textField.text!.count > 0 {
//            tfvEmail.validateEmail(true)
//        }
        //tfvEmail.validEmailCheck(10, "Please enter valid email")
        //tfvEmail.checkEmpty(10, "Please Enter your Email.")
        //tfvCountry.checkEmpty(20, "Please select country.")
        //tfvCity.checkEmpty(20, "City can't be empty.")
        
        if tfvFullName.status == .nodata {
            Http.alert("", "Full name can not be empty!")
            return false
        } else if tfvFullName.status == .error {
            Http.alert("", "Please enter valid full name.")
            return false
        } else if tfvEmail.status == .nodata {
             Http.alert("", "Email address can not be empty!")
             return false
         }else if tfvEmail.status == .error {
            Http.alert("", "Please enter valid email.")
            return false
//        } else if tfvCountry.status == .nodata {
//            //Http.alert("", "Please enter country.")
//            return false
//        } else if tfvCountry.status == .error {
//            //Http.alert("", "Please enter valid country.")
//            return false
//        } else if tfvCity.status == .nodata {
//            //Http.alert("", "Please enter city.")
//            return false
//        } else if tfvCity.status == .error {
//            //Http.alert("", "Please enter valid city.")
//            return false
        }
        else if selectionStatus == false {
            //Http.alert("", "Please agree terms & conditions for EULA")
            
            Http.alert("", "Please check that you accept Terms & Condition and Privacy Policy")


            return false
        }
        return true
    }
    
    @IBAction func actionGetStarted(_ sender: Any) {
        if validate () == false {
            return
        }
        
        
        let serviceIdSet = userDefaultsNew.string(forKey: "serviceIdTradi")
        let latitudeValNewSet = userDefaultsNew.string(forKey: "latitudeValNewTradi")
        let longitudeValNewSet = userDefaultsNew.string(forKey: "longitudeValNewTradi")
        let leadTypeSet = userDefaultsNew.string(forKey: "leadTypeTradi")
        let addressValNewSet = userDefaultsNew.string(forKey: "addressValNewTradi")
        
        let param = params()
        param["fullname"] = tfvFullName.textField.text
        param["email"] = tfvEmail.textField.text
        //param["country"] = tfvCountry.textField.text
        //param["city"] = tfvCity.textField.text
        param["service_id"] = serviceIdSet
        param["services_type"] = leadTypeSet
        param["latitude"] = latitudeValNewSet
        param["longitude"] = longitudeValNewSet
        param["address"] = addressValNewSet
        
        print(param)
        
        Http.instance().json(api_provider_register_step2, param, "POST", aai: true, popup: true, prnt: true, nil, nil, sync: false, defaultCalling: false) { (json, paras, str, data) in
            let jsonExp = json as? NSDictionary
            
            if jsonExp != nil {
                if jsonExp?.number("success").intValue == SESSIONEXPIRED {
                    kAppDelegate.sessionExpired(self)
                    return
                }
            }
            
            if let json = json as? NSDictionary {
                if json.number("success").intValue == 1 {
                    let user = UserDefaults.standard
                    user.set(self.tfvFullName.textField.text, forKey: Key_User_full_name)
                    user.set(self.tfvEmail.textField.text, forKey: Key_User_email)
                    //user.set(self.tfvCountry.textField.text, forKey: Key_User_country1)
                    //user.set(self.tfvCity.textField.text, forKey: Key_User_city1)
                    user.synchronize()
                    
                    let newJson = json.dictionary("data") as? NSDictionary
                    let redirect = newJson?.number("redirect").intValue ?? 0
                    print(redirect)
                    if redirect == 1 {
                        let vc = story_Profile.viewController("PrimaryBusiness") as? PrimaryBusiness
                        vc?.isFromRegister = true
                        self.navigationController?.pushViewController(vc!, animated: true)
                    }else if redirect == 2{
                        let vc = story_Profile.viewController("SelectServiceType") as! SelectServiceType
                        self.navigationController?.pushViewController(vc, animated: true)
                    }else if redirect == 3{
                        let vc = story_Profile.viewController("Profile") as! Profile
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                    
                    
                    
//                    let vc = story_Profile.viewController("PrimaryBusiness") as? PrimaryBusiness
//                    vc?.isFromRegister = true
//                    self.navigationController?.pushViewController(vc!, animated: true)
                    
//                    let vc = story_Profile.viewController("Profile") as! Profile
//                    self.navigationController?.pushViewController(vc, animated: true)
                    
                } else {
                    Http.alert("", json.string("message"))
                }
            }
        }
    }
    
    @IBOutlet var viewPicker: UIView!
    
    @IBOutlet weak var pkr: UIPickerView!
    
    func openCountriesPicker () {
        viewPicker.frame = UIScreen.main.bounds
        self.view.addSubview(viewPicker)
        pkr.delegate = self
        pkr.dataSource = self
        pkr.reloadAllComponents()
    }
    
    @IBAction func actionDone(_ sender: Any) {
        viewPicker.removeFromSuperview()
        
        let row = pkr.selectedRow(inComponent: 0)
        
        let ob = countryJSON?.data[row]
        selectedCountry = ob
        tfvCountry.textField.text = ob?.name
        
        tfvCountry.beginEditing()
        
        tfvCountry?.status = .varified
        tfvCountry?.showNoError()
        tfvCountry?.lblMsg.text = "Assistive text"
    }
    
    var selectedCountry: Country!
    
    @IBAction func actionCancel(_ sender: Any) {
        viewPicker.removeFromSuperview()
    }
    
    var countryJSON: CountryJSON?
}

extension EnterYourDetail {
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

extension EnterYourDetail: UITextFieldDelegate {
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
        
        let superV = (textField.superview as? MaterialTextFieldView)
        
        if superV == tfvFullName || tfvCountry == superV || tfvCity == superV {
            if str.count > 50 {
                return false
            } else if textField.text!.count <= 1 && string.count == 0 {
                (textField.superview as? MaterialTextFieldView)?.status = .nodata
                (textField.superview as? MaterialTextFieldView)?.showNoValidation()
                (textField.superview as? MaterialTextFieldView)?.lblMsg.text = "*Requiered"
                //btnGetStarted.isUserInteractionEnabled = false
            } else if textField.text!.count < 1 {
                (textField.superview as? MaterialTextFieldView)?.status = .error
                (textField.superview as? MaterialTextFieldView)?.showError()
                //btnGetStarted.isUserInteractionEnabled = false
            } else if textField.text!.count == 1 && string.count == 0 {
                (textField.superview as? MaterialTextFieldView)?.status = .error
                (textField.superview as? MaterialTextFieldView)?.showError()
                //btnGetStarted.isUserInteractionEnabled = false
            } else if str.count == 3 {
                (textField.superview as? MaterialTextFieldView)?.status = .varified
                (textField.superview as? MaterialTextFieldView)?.showNoError()
                (textField.superview as? MaterialTextFieldView)?.lblMsg.text = ""
                //btnGetStarted.isUserInteractionEnabled = true
            }
        } else if tfvEmail == superV {
            if textField.text!.count <= 1 && string.count == 0 {
                (textField.superview as? MaterialTextFieldView)?.status = .nodata
                (textField.superview as? MaterialTextFieldView)?.showNoValidation()
                (textField.superview as? MaterialTextFieldView)?.lblMsg.text = ""
            } else {
                let bool = validEmail (str)
                
                if bool {
                    (textField.superview as? MaterialTextFieldView)?.status = .varified
                    (textField.superview as? MaterialTextFieldView)?.showNoError()
                } else {
                    (textField.superview as? MaterialTextFieldView)?.status = .error
                    (textField.superview as? MaterialTextFieldView)?.lblMsg.text = wrongEmailMsg
                    (textField.superview as? MaterialTextFieldView)?.showError()
                    
                    (textField.superview as? MaterialTextFieldView)?.lblMsg.isHidden = false
                }
            }
        }
        
        
        
        if textField == tfvFullName.textField {
            if tfvFullName.status == .nodata {
                self.tfvFullName.imgValidation?.isHidden = true
            }else{
                self.tfvFullName.imgValidation?.isHidden = false
            }
        }
        
        if textField == tfvCity.textField {
            if tfvCity.status == .nodata {
                self.tfvCity.imgValidation?.isHidden = true
            }else{
                self.tfvCity.imgValidation?.isHidden = false
            }
        }
        
        
        return true
    }
}


extension EnterYourDetail: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if countryJSON != nil {
            return (countryJSON?.data.count)!
        }
        
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let ob = countryJSON?.data[row]
        return ob?.name
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
    }
}
