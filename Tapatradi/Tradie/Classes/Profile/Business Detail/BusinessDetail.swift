//
//  BusinessDetail.swift
//  Tradie
//
//  Created by Apple on 07/05/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class BusinessDetail: UIViewController, UpdateAddress {
    func updateAddress(address: String, latitude: String, longitude: String) {
        updatedLatitude = latitude
        updatedLongitude = longitude
        updatedAddress = address
        lblAddress.text = address
        headerView.addressButton.setTitle(address, for: .normal)
        viewAddress.isHidden = false
    }
    
    var updatedLatitude = ""
    var updatedLongitude = ""
    var updatedAddress = ""
    
    @IBOutlet weak var viewAddress: UIView!
    
    @IBOutlet weak var headerView: HeaderView!
    @IBOutlet var lblRadious: UILabel!
    @IBOutlet var sliderRadious: UISlider!
    @IBAction func radiousChanged (_ slider: UISlider?) {
        
        lblRadious.text = "\(Int((slider?.value)!)) km"
    }
    
    @IBAction func actionBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var tfmBusinessName: MaterialTextFieldView!
    @IBOutlet weak var tfmLicenseNumber: MaterialTextFieldView!
    @IBOutlet weak var tfmHouseFlatNo: MaterialTextFieldView!
    @IBOutlet weak var tfmStreetLocalityColony: MaterialTextFieldView!
    @IBOutlet weak var tfmPincode: MaterialTextFieldView!
    @IBOutlet weak var tfmCountry: MaterialTextFieldView!
    @IBOutlet weak var tfmState: MaterialTextFieldView!
    @IBOutlet weak var tfmCity: MaterialTextFieldView!
    
    override func viewWillAppear(_ animated: Bool) {
        kAppDelegate.currentVC = self
        headerView.updateData()
        print(tfmBusinessName.textField?.text ?? "")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        viewAddress.layer.cornerRadius = 5
        viewAddress.layer.shadowColor = UIColor.gray.cgColor
        viewAddress.layer.shadowOffset = .zero
        viewAddress.layer.shadowRadius = 2
        viewAddress.layer.shadowOpacity = 0.5
        let address = kAppDelegate.getUserAddress()?.address ?? ""
        print(address)
        if address != "" {
            viewAddress.isHidden = false
        }else{
            viewAddress.isHidden = true
        }
        
        lblAddress.text = address
        
        tfmBusinessName.placeHolder = "Business Name"
        print(tfmBusinessName.textField?.text ?? "")
        tfmBusinessName.messageText = "Required"
        
        tfmLicenseNumber.placeHolder = "License Number"
        tfmLicenseNumber.messageText = "Optional"
        tfmLicenseNumber.hideRight = true
        
        tfmHouseFlatNo.placeHolder = "House/Flat No."
        tfmHouseFlatNo.messageText = "*Required"
        
        tfmStreetLocalityColony.placeHolder = "Street"
        tfmStreetLocalityColony.messageText = "*Required"
        
        tfmPincode.placeHolder = "Postcode/Zip code"
        tfmPincode.messageText = "*Required"
        tfmPincode.keyboardType = UIKeyboardType.numberPad
        
        tfmCountry.placeHolder = "Country"
        tfmCountry.messageText = "*Required"
        tfmCountry.isEnabled = false
        tfmCountry.tag = 11
        tfmCountry.hideRight = true
        tfmCountry.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_ :))))
        
        tfmState.placeHolder = "State"
        tfmState.messageText = "*Required"
        /*tfmState.isEnabled = false
        tfmState.tag = 12
        tfmState.hideRight = true
        tfmState.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_ :))))*/
        
        tfmCity.placeHolder = "City"
        tfmCity.messageText = "*Required"
        /*tfmCity.isEnabled = false
        tfmCity.tag = 13
        tfmCity.hideRight = true
        tfmCity.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_ :))))*/
        
        getData()
        
        getCountries ()
    }
    
    @IBAction func actionLocationSet(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AllowLocationNew_VC") as! AllowLocationNew_VC
        vc.delegate = self
        self.present(vc, animated: true)
    }
    
    
    var businessDetailJSON: BusinessDetailJSON?
    
    func getData () {
        let param = params()
        
        Http.instance().json(api_provider_get_business_detail, param, "POST", aai: true, popup: true, prnt: true, nil, nil, sync: false, defaultCalling: false) { (json, paras, str, data) in
            let jsonExp = json as? NSDictionary
            
            if jsonExp != nil {
                if jsonExp?.number("success").intValue == SESSIONEXPIRED {
                   kAppDelegate.sessionExpired(self)
                    
                    return
                }
            }
            
            if data != nil {
                do {
                    self.businessDetailJSON = try JSONDecoder().decode(BusinessDetailJSON.self, from: data!)
                    self.setData ()
                } catch let error {
                    print("Error: \(error)")
                }
            }
        }
    }
    
    func setData () {
        if businessDetailJSON?.userData != nil {
            tfmBusinessName.setText((businessDetailJSON?.userData.businessName)!)
            tfmLicenseNumber.setText((businessDetailJSON?.userData.licenseNumber)!)
            
            if (businessDetailJSON?.userData.verified)! == 1 {
                tfmLicenseNumber.imgValidation?.isHidden = false
                tfmLicenseNumber.showNoError()
            }
            
            if businessDetailJSON?.userData.workingRadius != nil {
                if let rad = businessDetailJSON?.userData.workingRadius {
                    
                    var rd = rad
                    
                    if rd < 10 {
                        rd = 10
                    }
                    
                    lblRadious.text = "\(rd) km"
                    sliderRadious.value = Float(rd)
                }
            }
            
        }
        
        if businessDetailJSON?.businessData != nil {
            if businessDetailJSON?.businessData?.houseNo != nil {
                tfmHouseFlatNo.setText((businessDetailJSON?.businessData?.houseNo)!)
            }
            
            if businessDetailJSON?.businessData?.street != nil {
                tfmStreetLocalityColony.setText((businessDetailJSON?.businessData?.street)!)
            }
            
            if businessDetailJSON?.businessData?.pincode != nil {
                tfmPincode.setText((businessDetailJSON?.businessData?.pincode)!)
            }
            
            if businessDetailJSON?.businessData?.country != nil {
                tfmCountry.setText((businessDetailJSON?.businessData?.country)!)
            }
            
            if businessDetailJSON?.businessData?.city != nil {
                tfmCity.setText((businessDetailJSON?.businessData?.city)!)
            }
            
            if businessDetailJSON?.businessData?.state != nil {
                tfmState.setText((businessDetailJSON?.businessData?.state)!)
            }
            
            setAddress ()
        }
        
        
        
        let tfmBusinessName = tfmBusinessName.textField.text ?? ""
        let tfmHouseFlatNo = tfmHouseFlatNo.textField.text ?? ""
        let tfmStreetLocalityColony = tfmStreetLocalityColony.textField.text ?? ""
        let tfmPincode = tfmPincode.textField.text ?? ""
        let tfmState = tfmState.textField.text ?? ""
        let tfmCity = tfmCity.textField.text ?? ""
        print(tfmBusinessName)
        if tfmBusinessName == "" {
            self.tfmBusinessName.imgValidation?.isHidden = true
        }else{
            self.tfmBusinessName.imgValidation?.isHidden = false
        }
        
        if tfmHouseFlatNo == "" {
            self.tfmHouseFlatNo.imgValidation?.isHidden = true
        }else{
            self.tfmHouseFlatNo.imgValidation?.isHidden = false
        }
        
        if tfmStreetLocalityColony == "" {
            self.tfmStreetLocalityColony.imgValidation?.isHidden = true
        }else{
            self.tfmStreetLocalityColony.imgValidation?.isHidden = false
        }
        
        if tfmPincode == "" {
            self.tfmPincode.imgValidation?.isHidden = true
        }else{
            self.tfmPincode.imgValidation?.isHidden = false
        }
        
        if tfmState == "" {
            self.tfmState.imgValidation?.isHidden = true
        }else{
            self.tfmState.imgValidation?.isHidden = false
        }
        
        if tfmCity == "" {
            self.tfmCity.imgValidation?.isHidden = true
        }else{
            self.tfmCity.imgValidation?.isHidden = false
        }
        
    }
    
    func setAddress () {
        let ob = kAppDelegate.getUserAddressBusiness()
        
        //if ob == nil {
            let address = "\(tfmHouseFlatNo.textField.text ?? "") \(tfmStreetLocalityColony.textField.text ?? "") \(tfmCity.textField.text ?? "") \(tfmState.textField.text ?? "") \(tfmCountry.textField.text ?? "") \(tfmPincode.textField.text ?? "")"
            
            let addd = getAddressOrLatLong(nil, nil, address, false)
            
            let ob1 = Addresses("")
            
            ob1.locationName = "Home"
            ob1.address = address
            
            if addd != nil {
                if addd?.lat != nil {
                    ob1.latitude = "\((addd?.lat)!)"
                }
                
                if addd?.long != nil {
                    ob1.longitude = "\((addd?.long)!)"
                }
                
                if let city = addd?.city {
                    ob1.city = city
                }
                
                if let state = addd?.state {
                    ob1.state = state
                }
                
                if let country = addd?.country {
                    ob1.country = country
                }
            }
            
            kAppDelegate.setUserAddressBusiness(ob1)
        //}
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        self.view.endEditing(true)
        
        openCountriesPicker()
    }
    
    @IBOutlet var viewPicker: UIView!
    
    @IBOutlet weak var pkr: UIPickerView!
    
    func openCountriesPicker () {
        if countryJSON?.data == nil {
            return
        }
        
        if countryJSON!.data.count == 0 {
            Http.alert("", "Country data not available.")
            return
        }
        
        viewPicker.frame = self.view.frame
        self.view.addSubview(viewPicker)
        
        pkr.reloadAllComponents()
    }
    
    @IBAction func actionDone(_ sender: Any) {
        viewPicker.removeFromSuperview()
        
        let row = pkr.selectedRow(inComponent: 0)
        
        print("row-\(row)-")
        
        let ob = countryJSON?.data[row]
        selectedCountry = ob
        tfmCountry.textField.text = ob?.name
        
        tfmCountry.beginEditing()
        
        tfmCountry?.status = .varified
        tfmCountry?.showNoError()
        tfmCountry?.lblMsg.text = "*Required"
    }
    
    var selectedCountry: Country!
    
    @IBAction func actionCancel(_ sender: Any) {
        viewPicker.removeFromSuperview()
    }
    
    @IBAction func actionConfirm(_ sender: Any) {
//        if kAppDelegate.boolSubscriptionExpired {
//            Http.alert("", "Your subscription has been expired", [self, "Subscribe", "Cancel"])
//
//            return
//        }
        
        if validate () {
            let param = params()
            
            let ob = kAppDelegate.getUserAddress()
            
            
            
            
            
            if updatedLatitude != "" {
                ob?.latitude = "\(updatedLatitude)"
                param["latitude"] = "\(updatedLatitude)"
            }
            
            if updatedLongitude != "" {
                ob?.longitude = "\(updatedLongitude)"
                param["longitude"] = "\(updatedLongitude)"
            }
            if updatedAddress != "" {
                ob?.address = "\(updatedAddress)"
                param["online_address"] = "\(updatedAddress)"
            }
            
            param["online"] = "0"
            
            param["business_name"] = tfmBusinessName.textField.text
            param["license_number"] = tfmLicenseNumber.textField.text
            param["house_no"] = tfmHouseFlatNo.textField.text
            param["street"] = tfmStreetLocalityColony.textField.text
            param["pincode"] = tfmPincode.textField.text
            param["country"] = tfmCountry.textField.text
            param["state"] = tfmState.textField.text
            param["city"] = tfmCity.textField.text
            param["working_radius"] = Int(sliderRadious.value)
            print(param)
            let address = "\(tfmHouseFlatNo.textField.text!) \(tfmStreetLocalityColony.textField.text!) \(tfmCity.textField.text!) \(tfmState.textField.text!) \(tfmCountry.textField.text!) \(tfmPincode.textField.text!)"
            
            
            
            
            let ob1 = getAddressOrLatLong(nil, nil, address, false)
            
            if ob1?.lat != nil && ob1?.long != nil {
            } else {
                Http.alert("", "Please enter correct address.")
                return
            }
            
            setAddress ()
            
            Http.instance().json(api_provider_business_detail_update, param, "POST", aai: true, popup: true, prnt: true, nil, nil, sync: false, defaultCalling: false) { (json, paras, str, data) in
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
                        self.navigationController?.popViewController(animated: true)
                    }
                    
                    Http.alert("", json?.string("message"))
                }
            }
        }
    }
    
    var countryJSON: CountryJSON?
}

extension BusinessDetail: UITextFieldDelegate {
    
    func validateGenericString(_ string: String) -> Bool {
        return string.range(of: ".*[$&+:;=\\\\?#|/<>^*()%!].*", options: .regularExpression) == nil
    }
    
    func validateGenericString_website_aboutus(_ string: String) -> Bool {
        return string.range(of: ".*[$&+;=?#|<>^*()%!].*", options: .regularExpression) == nil
    }
    
    
    
    func validate () -> Bool {
        var msg: String? = nil
        
        
        print(tfmBusinessName.textField.text?.count ?? 0)
        if (tfmBusinessName.textField.text?.count ?? 0) >= 255 {
            msg = "Please enter character less then 255 in business name!"
            showAlert(msgVal: "Please enter character less then 255 in business name!")
        }
        
        print(validateGenericString(tfmBusinessName.textField.text ?? ""))
        if !validateGenericString(tfmBusinessName.textField.text ?? "") {
            msg = "Special character are not allowed in business name!"
            showAlert(msgVal: "Special character are not allowed in business name!")
        }
        
        print(tfmLicenseNumber.textField.text?.count ?? 0)
        if (tfmLicenseNumber.textField.text?.count ?? 0) >= 255 {
            msg = "Please enter character less then 255 in license number!"
            showAlert(msgVal: "Please enter character less then 255 in license number!")
        }
        
        print(validateGenericString(tfmLicenseNumber.textField.text ?? ""))
        if !validateGenericString(tfmLicenseNumber.textField.text ?? "") {
            msg = "Special character are not allowed in license number!"
            showAlert(msgVal: "Special character are not allowed in license number!")
        }
        
        print(tfmHouseFlatNo.textField.text?.count ?? 0)
        if (tfmHouseFlatNo.textField.text?.count ?? 0) >= 255 {
            msg = "Please enter character less then 255 in house flat no!"
            showAlert(msgVal: "Please enter character less then 255 in house flat no!")
        }
        
        print(validateGenericString(tfmHouseFlatNo.textField.text ?? ""))
        if !validateGenericString(tfmHouseFlatNo.textField.text ?? "") {
            msg = "Special character are not allowed in flat no!"
            showAlert(msgVal: "Special character are not allowed in flat no!")
        }
        
        print(tfmStreetLocalityColony.textField.text?.count ?? 0)
        if (tfmStreetLocalityColony.textField.text?.count ?? 0) >= 255 {
            msg = "Please enter character less then 255 in street!"
            showAlert(msgVal: "Please enter character less then 255 in street!")
        }
        
        print(validateGenericString(tfmStreetLocalityColony.textField.text ?? ""))
        if !validateGenericString(tfmStreetLocalityColony.textField.text ?? "") {
            msg = "Special character are not allowed in street name!"
            showAlert(msgVal: "Special character are not allowed in street name!")
        }
        
        print(tfmPincode.textField.text?.count ?? 0)
        if (tfmPincode.textField.text?.count ?? 0) >= 255 {
            msg = "Please enter character less then 255 in pincode!"
            showAlert(msgVal: "Please enter character less then 255 in pincode!")
        }
        
        
        print(tfmState.textField.text?.count ?? 0)
        if (tfmState.textField.text?.count ?? 0) >= 255 {
            msg = "Please enter character less then 255 in state!"
            showAlert(msgVal: "Please enter character less then 255 in state!")
        }
        
        print(validateGenericString(tfmState.textField.text ?? ""))
        if !validateGenericString(tfmState.textField.text ?? "") {
            msg = "Special character are not allowed in state name!"
            showAlert(msgVal: "Special character are not allowed in state name!")
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
        
        
        if !validateGenericString(tfmPincode.textField.text ?? "") {
            msg = "Special character are not allowed in pincode!"
            showAlert(msgVal: "Special character are not allowed in pincode!")
        }
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        if tfmBusinessName.status == .nodata {
            msg = "Business name can not be empty!"
            showAlert(msgVal: "Business name can not be empty!")
        }
        else if tfmBusinessName.status == .error {
            msg = "Business name can not be empty!"
            showAlert(msgVal: "Business name can not be empty!")
        }
        else if tfmHouseFlatNo.status == .nodata {
            msg = "House/Flat number can not be empty!"
            showAlert(msgVal: "House/Flat number can not be empty!")
        }
        else if tfmHouseFlatNo.status == .error {
            msg = "House/Flat number can not be empty!"
            showAlert(msgVal: "House/Flat number can not be empty!")
        }
        
        else if tfmStreetLocalityColony.status == .nodata {
            msg = "Street name can not be empty!"
            showAlert(msgVal: "Street name can not be empty!")
        }
        else if tfmStreetLocalityColony.status == .error {
            msg = "Street name can not be empty!"
            showAlert(msgVal: "Street name can not be empty!")
        }
            
        else if tfmPincode.status == .nodata {
            msg = "Postcode number can not be empty!"
            showAlert(msgVal: "Postcode number can not be empty!")
        }
        else if tfmPincode.status == .error {
            msg = "Postcode number minimum 4 digit!"
            showAlert(msgVal: "Postcode number minimum 4 digit!")
        }
            
        else if tfmCountry.status == .nodata {
            msg = "Please select country!"
            showAlert(msgVal: "Please select country!")
        }
        else if tfmCountry.status == .error {
            msg = "Invalid country."
            showAlert(msgVal: "Invalid country.")
        }
            
        else if tfmState.status == .nodata {
            msg = "State can not be empty!"
            showAlert(msgVal: "State can not be empty!")
        }
        else if tfmState.status == .error {
            msg = "State can not be empty!"
            showAlert(msgVal: "State can not be empty!")
        }
            
        else if tfmCity.status == .nodata {
            msg = "City can not be empty!"
            showAlert(msgVal: "City can not be empty!")
        }
        else if tfmCity.status == .error {
            msg = "City can not be empty!"
            showAlert(msgVal: "City can not be empty!")
        }
        else if (lblAddress.text ?? "") == "" {
            msg = "Please select your service location first!"
            showAlert(msgVal: "Please select your service location first!")
        }
        
        
        
        if msg == nil {
            return true
        } else {
            //Http.alert("", msg!)
            
            tfmBusinessName.checkEmpty(30, "Business name can't empty.")
            tfmHouseFlatNo.checkEmpty(30, "House/Flat No can't empty.")
            tfmStreetLocalityColony.checkEmpty(30, "Street can't empty.")
            tfmPincode.checkEmpty(30, "Postcode/Zip code can't empty.")
            tfmCountry.checkEmpty(30, "Please select country.")
            tfmState.checkEmpty(30, "Please select state.")
            tfmCity.checkEmpty(30, "Please select city.")
            
            return false
        }
    }
    
    func showAlert(msgVal:String) {
        let alert = UIAlertController(title: "Tap A Tradie", message: "\(msgVal)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel))
        self.present(alert, animated: true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        (textField.superview as? MaterialTextFieldView)?.endEditing()

    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        (textField.superview as? MaterialTextFieldView)?.beginEditing()
        
        let superV = (textField.superview as? MaterialTextFieldView)
       
        if superV == tfmCountry {
            textField.resignFirstResponder()
            self.view.endEditing(true)
            //addPickerView (true)
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let superV = (textField.superview as? MaterialTextFieldView)
        
     
        if textField.text!.count <= 1 && string.count == 0 {
            (textField.superview as? MaterialTextFieldView)?.status = .nodata
            (textField.superview as? MaterialTextFieldView)?.showNoValidation()
            (textField.superview as? MaterialTextFieldView)?.lblMsg.text = "Required"
        } else if textField.text!.count < 1 {
            (textField.superview as? MaterialTextFieldView)?.status = .error
            
            if superV == tfmState {
                (textField.superview as? MaterialTextFieldView)?.lblMsg.text = "invalid state."
            } else if superV == tfmCountry {
                (textField.superview as? MaterialTextFieldView)?.lblMsg.text = "invalid country."
            } else if superV == tfmCity {
                (textField.superview as? MaterialTextFieldView)?.lblMsg.text = "invalid city."
            }
            
            if string.count == 0 {
                (textField.superview as? MaterialTextFieldView)?.showError()
            }
        } else {
            (textField.superview as? MaterialTextFieldView)?.status = .varified
            (textField.superview as? MaterialTextFieldView)?.showNoError()
        }
        
        if (textField.superview as? MaterialTextFieldView)?.status == .varified {
            (textField.superview as? MaterialTextFieldView)?.lblMsg.text = "*Required"
        }
        
        
        
        if textField == tfmBusinessName.textField {
//            let tfmBusinessName = tfmBusinessName.textField.text ?? ""
//            if tfmBusinessName.count == 1 {
//                self.tfmBusinessName.imgValidation?.isHidden = true
//            }else{
//                self.tfmBusinessName.imgValidation?.isHidden = false
//            }
            
            if tfmBusinessName.status == .nodata {
                self.tfmBusinessName.imgValidation?.isHidden = true
            }else{
                self.tfmBusinessName.imgValidation?.isHidden = false
            }
        }
        
        if textField == tfmHouseFlatNo.textField {
//            let tfmHouseFlatNo = tfmHouseFlatNo.textField.text ?? ""
//            if tfmHouseFlatNo.count == 1 {
//                self.tfmHouseFlatNo.imgValidation?.isHidden = true
//            }else{
//                self.tfmHouseFlatNo.imgValidation?.isHidden = false
//            }
            
            if tfmHouseFlatNo.status == .nodata {
                self.tfmHouseFlatNo.imgValidation?.isHidden = true
            }else{
                self.tfmHouseFlatNo.imgValidation?.isHidden = false
            }
        }
        
        if textField == tfmStreetLocalityColony.textField {
//            let tfmStreetLocalityColony = tfmStreetLocalityColony.textField.text ?? ""
//            if tfmStreetLocalityColony.count == 1 {
//                self.tfmStreetLocalityColony.imgValidation?.isHidden = true
//            }else{
//                self.tfmStreetLocalityColony.imgValidation?.isHidden = false
//            }
            
            if tfmStreetLocalityColony.status == .nodata {
                self.tfmStreetLocalityColony.imgValidation?.isHidden = true
            }else{
                self.tfmStreetLocalityColony.imgValidation?.isHidden = false
            }
        }
        
        if textField == tfmPincode.textField {
//            let tfmPincode = tfmPincode.textField.text ?? ""
//            if tfmPincode.count == 1 {
//                self.tfmPincode.imgValidation?.isHidden = true
//            }else{
//                self.tfmPincode.imgValidation?.isHidden = false
//            }
            
            if tfmPincode.status == .nodata {
                self.tfmPincode.imgValidation?.isHidden = true
            }else{
                self.tfmPincode.imgValidation?.isHidden = false
            }
        }
        
        if textField == tfmState.textField {
//            let tfmState = tfmState.textField.text ?? ""
//            if tfmState.count == 1 {
//                self.tfmState.imgValidation?.isHidden = true
//            }else{
//                self.tfmState.imgValidation?.isHidden = false
//            }
//
            if tfmState.status == .nodata {
                self.tfmState.imgValidation?.isHidden = true
            }else{
                self.tfmState.imgValidation?.isHidden = false
            }
            
        }
        
        if textField == tfmCity.textField {
//            let tfmCity = tfmCity.textField.text ?? ""
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
        
        if textField == tfmLicenseNumber.textField {
            if textField.text!.count <= 1 && string.count == 0 {
                (textField.superview as? MaterialTextFieldView)?.lblMsg.text = "Optional"
            }
        }
        
        return true
    }
}

extension BusinessDetail: AlertDelegate {
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

extension BusinessDetail: UIPickerViewDelegate, UIPickerViewDataSource {
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

struct CountryJSON: Codable {
    let success: Int
    let message: String
    let data: [Country]
}

struct Country: Codable {
    let id: Int
    let name, countryCode: String
    let mobileCode: Int
    let status: StatusC
    
    enum CodingKeys: String, CodingKey {
        case id, name
        case countryCode = "country_code"
        case mobileCode = "mobile_code"
        case status
    }
}

enum StatusC: String, Codable {
    case active = "active"
}

struct BusinessDetailJSON: Codable {
    let success: Int
    let message: String
    let userData: UserDataBD
    let businessData: BusinessDataBD?
    
    enum CodingKeys: String, CodingKey {
        case success, message
        case userData = "user_data"
        case businessData = "business_data"
    }
}

struct BusinessDataBD: Codable {
    let id, uid: Int?
    let houseNo, street, pincode, country: String?
    let state, city, latitude, longitude: String?
    
    enum CodingKeys: String, CodingKey {
        case id, uid
        case houseNo = "house_no"
        case street, pincode, country, state, city, latitude, longitude
    }
}

struct UserDataBD: Codable {
    let id: Int
    let fullName, email, mobile, gender: String
    let dob, country, city, professionalExperience: String
    let phoneNumber, websiteLink, aboutMe, businessName: String
    let licenseNumber, profilePic, latitude, longitude: String
    let status, access, lastLogin: String
    let registerComplete, online, verified, workingRadius: Int
    
    enum CodingKeys: String, CodingKey {
        case id
        case workingRadius = "working_radius"
        case fullName = "full_name"
        case email, mobile, gender, dob, country, city
        case professionalExperience = "professional_experience"
        case phoneNumber = "phone_number"
        case websiteLink = "website_link"
        case aboutMe = "about_me"
        case businessName = "business_name"
        case licenseNumber = "license_number"
        case profilePic = "profile_pic"
        case latitude, longitude, status, access
        case lastLogin = "last_login"
        case registerComplete = "register_complete"
        case online, verified
    }
}
