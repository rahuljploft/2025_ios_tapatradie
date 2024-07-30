//
//  Login.swift
//  TapATradie
//
//  Created by Apple on 19/04/19.
//  Copyright © 2019 Apple. All rights reserved.
//

//let SESSIONEXPIRED = 2

import UIKit
import FBSDKLoginKit
//import FacebookCore

//import FacebookLogin
//import FBSDKLoginKit

class TapATradie_Login: UIViewController {
    var userData: TapATradie_UserData!
    
    
//    @IBOutlet weak var btnFaceBook: FBLoginButton!
    
    var facebookID: String?
    
    @IBOutlet weak var tfvMobile: MaterialTextFieldView!
    
    @IBOutlet weak var flagImage: UIImageView!
    @IBOutlet weak var btnLoginSignup: UIButton!
    
    var countryCodes: NSArray?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        countryCodes = TapATradie_kAppDelegate.TapATradie_countryCodes()
        
//        btnFacebook.border5(4)
        
        let user = UserDefaults.standard
        user.set("1", forKey: TapATradie_Key_Introduction)
        user.removeObject(forKey: TapATradie_KEY_ACCESSTOEKN)
        user.synchronize()
        
        TapATradie_kAppDelegate.TapATradie_generateAccessToken()
        
        tfvMobile.keyboardType = .numberPad
        //tfvMobile.keyboardType = UIKeyboardType.emailAddress
        tfvMobile.autocapitalizationType = UITextAutocapitalizationType.none
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_ :)))
        self.view.addGestureRecognizer(tap)
        
        findCountry ()
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        self.view.endEditing(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        TapATradie_kAppDelegate.TapATradie_currentVC = self
        
        //tfvMobile.textField.text = ""
        //tfvMobile?.endEditing()
        
        facebookID = nil
        
        //self.btnFacebook.isHidden = false
        self.btnLoginSignup.setTitle("LOGIN/SIGNUP", for: .normal)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        /*self.view.endEditing(true)
        tfvMobile.textField.text = ""
        tfvMobile?.endEditing()*/
    }
    
    @IBAction func actionSignInSignUp(_ sender: Any) {
        self.view.endEditing(true)
        
        if tfvMobile.validateMobile(8) == false {
            //Http.alert("", "Please enter email.")
            
            return
        }
        
        let param = TapATradie_params()
        param["mobile"] = tfvMobile.textField.text
        param["country_code"] = lblCountryCode.text?.replacingOccurrences(of: "+", with: "")
        
        if facebookID != nil {
            param["facebook_id"] = facebookID!
        }
        
        Http.instance().json(TapATradie_api_user_otp_registration, param, "POST", aai: true, popup: true, prnt: true, nil, nil, sync: false, defaultCalling: false) { (json, paras, str, data) in
            
            if let json = json as? NSDictionary {
                if json.number("success").intValue == 1 {
                    DispatchQueue.main.async {
                        let vc = TapATradie_story_Auth.TapATradie_viewController("MobileVerification") as? TapATradie_MobileVerification
                        vc?.mobileNumber = self.tfvMobile.textField.text!
                        vc?.facebookID = self.facebookID
                        vc?.countryCode = self.lblCountryCode.text?.replacingOccurrences(of: "+", with: "")
                        
                        self.tfvMobile.textField.text = ""
                        self.tfvMobile?.endEditing()
                        
                        vc?.uid = json.string("uid")
                        self.navigationController?.pushViewController(vc!, animated: true)
                    }
                    
                } else {
                    Http.alert("", json.string("message"))
                }
            }
        }
    }
    
    @IBOutlet weak var lblCountryCode: UILabel!
    
    @IBAction func actionCountryCode(_ sender: Any) {
        self.view.endEditing(true)
        
        viewCountryCode.frame = UIScreen.main.bounds
        self.view.addSubview(viewCountryCode)
    }
    
    @IBOutlet weak var tblCountryCode: UITableView!
    @IBOutlet weak var viewCountryCode: UIView!
    
    @IBAction func actionCloseCountryCode(_ sender: Any) {
        viewCountryCode.removeFromSuperview()
    }
    
    func findCountry () {
        guard let countryCodes = countryCodes else { return }
        guard countryCodes.count > 0 else { return }
        
        TapATradie_kAppDelegate.TapATradie_locationManager?.startUpdatingLocation()
        
        guard TapATradie_kAppDelegate.TapATradie_locationManager != nil else { return }
        
        let latitude = TapATradie_kAppDelegate.TapATradie_locationManager?.location?.coordinate.latitude as NSNumber?
        let longitude = TapATradie_kAppDelegate.TapATradie_locationManager?.location?.coordinate.longitude as NSNumber?
        print("coordinates: (\(latitude!), \(longitude!))")
        
        guard latitude != 0.0 && longitude != 0.0 else { return }
        
        TapATradie_getAddressOrLatLongApple(latitude, longitude, nil, false) {[weak self] (address) in
            guard address?.country != nil else { return }
            for i in 0..<countryCodes.count {
                if let country = countryCodes[i] as? NSDictionary {
                    if address!.country?.lowercased() == country.string("name").lowercased() {
                        self?.lblCountryCode.text = "+\(country.string("phonecode")) ▾"
                        self?.flagImage.image = UIImage(named: country.string("iso").lowercased())
                        break
                    }
                }
            }
        }
    }
    
    //MARK: - Facebook
    
//    @IBAction func actionFacebookLogin(_ sender: Any) {
//        tfvMobile.textField.text = ""
//
//        let loginManager = LoginManager()
//
//        loginManager.logOut()
//
//        loginManager.logIn(permissions: [.publicProfile, .email], viewController: nil) { loginResult in
//            Http.startActivityIndicator()
//
//            self.loginManagerDidComplete(loginResult)
//        }
//    }
//
//    func loginManagerDidComplete(_ result: LoginResult) {
//
//        switch result {
//            case .cancelled:
//                Http.stopActivityIndicator()
//            break
//            case .failed(let error):
//                Http.stopActivityIndicator()
//            break
//
//            case .success(let _, let _, let _):
//
//                let req = GraphRequest(graphPath: "me", parameters: ["fields":"first_name,last_name,email, picture.type(large)"], tokenString: AccessToken.current?.tokenString, version: nil, httpMethod: HTTPMethod(rawValue: "GET"))
//
//                req.start(completionHandler: { (test, result, error) in
//                    if(error == nil) {
//                        let data:[String:AnyObject] = result as! [String : AnyObject]
//
//                        print("data-\(data)-")
//
//                        let email = data["email"] as! String
//
//                        let dictProfile = data["picture"] as! [String : AnyObject]
//
//                        let fbUserId = data["id"] as! String
//
//                        let firstName = data["first_name"] as! String
//                        let lastName = data["last_name"] as! String
//
//                        self.socialMediaLogin(strSocailMedia: "facebook", strEmail: email, strFristName: firstName, strLastName: lastName, strAuthId: fbUserId, fullname: "\(firstName) \(lastName)")
//                    } else {
//                        Http.stopActivityIndicator()
//                    }
//                })
//            break
//        }
//    }
//
//    func socialMediaLogin(strSocailMedia: String, strEmail: String, strFristName: String, strLastName: String, strAuthId: String, fullname: String?) {
//
//        // api_user_facebook_login
//
//        DispatchQueue.global().async {
//            sleep(2)
//
//            self.facebookID = strAuthId
//
//            if self.facebookID != nil {
//
//                let param = params()
//
//                param["facebook_id"] = strAuthId
//
//                Http.instance().json(api_user_facebook_login, param, "POST", aai: false, popup: true, prnt: true, nil, nil, sync: false, defaultCalling: false) { (json, paras, str, data) in
//
//                    if let json = json as? NSDictionary {
//                        if json.number("success").intValue == 1 {
//                            var boolGoLogin = true
//
//                            if let dict = json["data"] as? NSDictionary {
//                                if dict.count == 0 {
//                                    self.facebookID = strAuthId
//
//                                    boolGoLogin = false
//
//                                    Http.alert("", "Please enter your mobile number to signup")
//                                    self.btnFacebook.isHidden = true
//                                    self.btnLoginSignup.setTitle("Facebook Signup", for: .normal)
//                                }
//                            }
//
//                            if let arr = json["data"] as? NSArray {
//                                if arr.count == 0 {
//                                    self.facebookID = strAuthId
//
//                                    boolGoLogin = false
//
//                                    Http.alert("", "Please enter your mobile number to signup")
//                                    self.btnFacebook.isHidden = true
//                                    self.btnLoginSignup.setTitle("Facebook Signup", for: .normal)
//                                }
//                            }
//
//                            if boolGoLogin {
//                                if data != nil {
//                                    do {
//                                        self.userData = try JSONDecoder().decode(UserData.self, from: data!)
//                                    } catch let error {
//                                        print("Error: \(error)")
//                                    }
//                                }
//
//                                if json.number("success").intValue == 1 {
//                                    let user = UserDefaults.standard
//                                    user.set(self.userData.data.aboutMe, forKey: Key_User_about_me)
//                                    user.set(self.userData.data.access, forKey: Key_User_access)
//                                    user.set(self.userData.data.businessName, forKey: Key_User_business_name)
//                                    user.set(self.userData.data.city, forKey: Key_User_city)
//                                    user.set(self.userData.data.country, forKey: Key_User_country)
//                                    user.set(self.userData.data.dob, forKey: Key_User_dob)
//                                    user.set(self.userData.data.email, forKey: Key_User_email)
//                                    user.set(self.userData.data.fullName, forKey: Key_User_full_name)
//                                    user.set(self.userData.data.gender, forKey: Key_User_gender)
//                                    user.set(self.userData.data.id, forKey: Key_User_id)
//                                    user.set(self.userData.data.lastLogin, forKey: Key_User_last_login)
//                                    user.set(self.userData.data.latitude, forKey: Key_User_latitude)
//                                    user.set(self.userData.data.licenseNumber, forKey: Key_User_license_number)
//                                    user.set(self.userData.data.longitude, forKey: Key_User_longitude)
//                                    user.set(self.userData.data.mobile, forKey: Key_User_mobile)
//                                    user.set(self.userData.data.online, forKey: Key_User_online)
//                                    user.set(self.userData.data.phoneNumber, forKey: Key_User_phone_number)
//                                    user.set(self.userData.data.professionalExperience, forKey: Key_User_professional_experience)
//                                    user.set(self.userData.data.profilePic, forKey: Key_User_profile_pic)
//                                    user.set(self.userData.data.registerComplete, forKey: Key_User_register_complete)
//                                    user.set(self.userData.data.verified, forKey: Key_User_verified)
//                                    user.set(self.userData.data.websiteLink, forKey: Key_User_website_link)
//                                    user.set(self.userData.data.status, forKey: Key_User_status)
//                                    user.synchronize()
//
//                                    var vc: UIViewController?
//
//                                    print("self.userData.address-\(self.userData.address)-")
//
//                                    if self.userData.address != nil {
//                                        let ob1 = Addresses("")
//
//                                        ob1.locationName = "Home"
//
//                                        ob1.address = self.userData.address.address
//                                        ob1.latitude = self.userData.address.latitude
//                                        ob1.longitude = self.userData.address.longitude
//
//                                        ob1.city = self.userData.address.city
//                                        ob1.state = self.userData.address.state
//                                        ob1.country = self.userData.address.country
//
//                                        kAppDelegate.setUserAddress(ob1)
//                                    }
//
//                                    if (Key_User_full_name.getUserValue() as! String).count == 0 {
//                                        vc = story_Auth.viewController("EnterYourDetail")
//                                    } else {
//                                        var boolGoToSeeTradie = true
//
//                                        if self.userData.address.address!.count > 0 {
//                                            boolGoToSeeTradie = false
//                                        }
//
//                                        if boolGoToSeeTradie {
//                                            vc = story_Auth.viewController("SeeTradiesArround")
//                                        } else {
//                                            vc = story_Home.viewController("Home")
//                                        }
//                                    }
//
//                                    self.navigationController?.pushViewController(vc!, animated: true)
//                                } else {
//                                    Http.alert("", json.string("message"))
//                                }
//                            }
//                        } else {
//                            Http.alert("", json.string("message"))
//                        }
//                    }
//
//                    Http.stopActivityIndicator()
//                }
//            } else {
//                Http.stopActivityIndicator()
//            }
//        }
//    }
}

//protocol CountryCodeCellDelegate {
//    func cellClick (_ indexPath: IndexPath)
//}

class TapATradie_CountryCodeCell: UITableViewCell {
    @IBOutlet weak var lbl: UILabel!
    @IBOutlet weak var img: UIImageView!
    
    var indexPath: IndexPath!
    var delegate: CountryCodeCellDelegate!
    
    @IBAction func actionCellClick (_ sender: Any) {
        delegate.cellClick(indexPath)
    }
    
    override func awakeFromNib() {
        
    }
}

extension TapATradie_Login: UITableViewDelegate, UITableViewDataSource, CountryCodeCellDelegate {
    func cellClick (_ indexPath: IndexPath) {
        if let country = countryCodes![indexPath.row] as? NSDictionary {
            lblCountryCode.text = "+\(country.string("phonecode")) ▾"
            flagImage.image = UIImage(named: country.string("iso").lowercased())
            //print("1indexPath-\(country.string("phonecode"))-")
        }
        
        viewCountryCode.removeFromSuperview()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if countryCodes != nil {
            return countryCodes!.count
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CountryCodeCell") as! TapATradie_CountryCodeCell
        
        cell.indexPath = indexPath
        cell.delegate = self
        
        if let country = countryCodes![indexPath.row] as? NSDictionary {
            /*{
                id = 1;
                iso = AF;
                iso3 = AFG;
                name = AFGHANISTAN;
                nicename = Afghanistan;
                numcode = 4;
                phonecode = 93;
            },*/
            
            cell.img.image = UIImage(named: "\(country.string("iso").lowercased()).png")
            cell.lbl.text = "\(country.string("nicename")) (\(country.string("phonecode")))"
        }
        
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print("2indexPath-\(indexPath.row)-")
    }
}

extension TapATradie_Login: UITextFieldDelegate {
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
        btnLoginSignup.isUserInteractionEnabled = true
        
        let str = textField.text! + string
        
        if str.count > 20 {
            return false
        } else if textField.text!.count <= 1 && string.count == 0 {
            (textField.superview as? MaterialTextFieldView)?.status = .nodata
            (textField.superview as? MaterialTextFieldView)?.showNoValidation()
            
            (textField.superview as? MaterialTextFieldView)?.lblMsg.text = emptyMobileMsg
            (textField.superview as? MaterialTextFieldView)?.lblMsg.isHidden = false
            
            btnLoginSignup.isUserInteractionEnabled = false
        } else if textField.text!.count >= 8 && string.count == 0 {
            (textField.superview as? MaterialTextFieldView)?.status = .error
            (textField.superview as? MaterialTextFieldView)?.showError()
            
            (textField.superview as? MaterialTextFieldView)?.lblMsg.text = wrongMobileMsg
            (textField.superview as? MaterialTextFieldView)?.lblMsg.isHidden = false
            btnLoginSignup.isUserInteractionEnabled = false
        } else if str.count >= 8 {
            (textField.superview as? MaterialTextFieldView)?.status = .varified
            (textField.superview as? MaterialTextFieldView)?.showNoError()
            btnLoginSignup.isUserInteractionEnabled = true
        } else if textField.text!.count < 7 {
            (textField.superview as? MaterialTextFieldView)?.status = .error
            (textField.superview as? MaterialTextFieldView)?.showError()
            
            (textField.superview as? MaterialTextFieldView)?.lblMsg.text = wrongMobileMsg
            (textField.superview as? MaterialTextFieldView)?.lblMsg.isHidden = false
            
            btnLoginSignup.isUserInteractionEnabled = false
        }
        
        return true
    }
}

import CoreLocation

public func TapATradie_getAddressOrLatLongApple (_ lat: NSNumber?, _ long: NSNumber?,_ addr: String?, _ prnt: Bool, handler: @escaping (AddressObject?) -> Swift.Void) {
//    let reach = ReachabilityKrishna.init(hostname: "google.com")
    if prnt {
        print("lat-\(String(describing: lat))-")
        print("long-\(String(describing: long))-")
        print("addr-\(String(describing: addr))-")
    }
    if lat == nil && long == nil && addr == nil {
        handler(nil)
    } else {
//        if (reach?.isReachable)! {
            if lat == nil && long == nil {
                let ceo: CLGeocoder = CLGeocoder()
                
                ceo.geocodeAddressString(addr!) { (placemarks, error) in
                    print("placemarks-\(placemarks)-")
                    print("error-\(error)-")
                    
                    if (error != nil) {
                        print("reverse geodcode fail: \(error!.localizedDescription)")
                        
                        //handler (nil, nil)
                        
                        let ob = AddressObject(nil)
                        
                        ob.address = addr
                        //ob.country = country
                        
                        handler(ob)
                    }
                    
                    if placemarks != nil {
                        let pm = placemarks! as [CLPlacemark]
                        if pm.count > 0 {
                            let pm = placemarks![0]
                            
                            let location = pm.location
                            
                            let ob = AddressObject(nil)
                            
                            if location != nil {
                                ob.lat = "\(location!.coordinate.latitude)"
                                ob.long = "\(location!.coordinate.longitude)"
                            }
                            
                            ob.address = addr
                            ob.country = pm.country
                            
                            handler(ob)
                        }
                    }
                }
            } else {
                TapATradie_getAddressFromLatLonApple((lat?.doubleValue)!, (long?.doubleValue)!) { (add, country) in
                    //print("getAddressFromLatLon Add-\(add)-\(country)-")
                    let ob = AddressObject(nil)
                    ob.address = add
                    ob.country = country
                    
                    handler(ob)
                }
            }
//        } else {
//            handler(nil)
//        }
    }
}

func TapATradie_getAddressFromLatLonApple(_ lat: Double, _ lon: Double, handler: @escaping (String?, String?) -> Swift.Void) {
    var center : CLLocationCoordinate2D = CLLocationCoordinate2D()
    
    let ceo: CLGeocoder = CLGeocoder()
    
    center.latitude = lat
    center.longitude = lon
    
    let loc: CLLocation = CLLocation(latitude:center.latitude, longitude: center.longitude)
    
    ceo.reverseGeocodeLocation(loc, completionHandler:
        {(placemarks, error) in
            if (error != nil) {
                print("reverse geodcode fail: \(error!.localizedDescription)")
                
                handler (nil, nil)
            }
            
            if placemarks != nil {
                let pm = placemarks! as [CLPlacemark]
                if pm.count > 0 {
                    let pm = placemarks![0]
                    
                    var addressString : String = ""
                    
                    if pm.subLocality != nil {
                        addressString = addressString + pm.subLocality! + ", "
                    }
                    if pm.thoroughfare != nil {
                        addressString = addressString + pm.thoroughfare! + ", "
                    }
                    if pm.locality != nil {
                        addressString = addressString + pm.locality! + ", "
                    }
                    if pm.country != nil {
                        addressString = addressString + pm.country! + ", "
                    }
                    if pm.postalCode != nil {
                        addressString = addressString + pm.postalCode! + " "
                    }
                    
                    handler (addressString, pm.country)
                }
                
            } else {
                handler (nil, nil)
            }
    })
}
