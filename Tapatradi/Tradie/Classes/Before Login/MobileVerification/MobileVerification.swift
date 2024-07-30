//
//  MobileVerification.swift
//  Tradie
//
//  Created by Apple on 20/04/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import StoreKit
import Common
//import TapATradie

var firebase_token = ""


var serviceIdTradi = ""
var latitudeValNewTradi = ""
var longitudeValNewTradi = ""
var leadTypeTradi = ""
var addressValNewTradi = ""
let userDefaultsNew = UserDefaults.standard

class BaseVC: UIViewController {
    var boolFromLaunch = false
    var boolFromRegistration = true
    var step1_VC: String?
    var step2_VC: String?
    var step3_VC: String?
    var step4_VC: String?
}

class MobileVerification: UIViewController {
    var facebookID: String?
    var countryCode: String?
    
    var profileJSON: ProfileJSON?
    
    var purchasedDeviceType = ""
    var otp:String = ""
    
    var boolServerPuchase = false
    var boolApplePuchase = false
    
    
    @IBOutlet weak var tf1: UITextField!
    @IBOutlet weak var tf2: UITextField!
    @IBOutlet weak var tf3: UITextField!
    @IBOutlet weak var tf4: UITextField!
    
    @IBAction func actionTextChack(_ tf: UITextField) {
        if (tf.text?.count)! == 0 {
            if tf == tf1 {
            } else if tf == tf2 {
            } else if tf == tf3 {
            } else if tf == tf4 {
            }
        } else {
            reset ()
            
            if tf == tf1 {
                tf2.becomeFirstResponder()
            } else if tf == tf2 {
                tf3.becomeFirstResponder()
            } else if tf == tf3 {
                tf4.becomeFirstResponder()
            } else if tf == tf4 {
            }
        }
        
        enableBubmit ()
    }
    
    func reset () {
        tf1.text = getText (tf1.text!)
        tf2.text = getText (tf2.text!)
        tf3.text = getText (tf3.text!)
        tf4.text = getText (tf4.text!)
    }
    
    func getText (_ text: String) -> String {
        if text.count == 0 {
            return ""
        } else {
            let ff = Int(text)! % 10
            
            return "\(ff)"
        }
    }
    
    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet weak var lblMobileNumber: UILabel!
    @IBOutlet weak var lblCountDown: UILabel!
    
    var mobileNumber = ""
    var countDownTime = 30
    
    override func viewWillAppear(_ animated: Bool) {
        kAppDelegate.currentVC = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        userDefaultsNew.set(serviceIdTradi, forKey: "serviceIdTradi")
        userDefaultsNew.set(latitudeValNewTradi, forKey: "latitudeValNewTradi")
        userDefaultsNew.set(longitudeValNewTradi, forKey: "longitudeValNewTradi")
        userDefaultsNew.set(leadTypeTradi, forKey: "leadTypeTradi")
        userDefaultsNew.set(addressValNewTradi, forKey: "addressValNewTradi")
        
        let user = UserDefaults.standard
        user.removeObject(forKey: KEY_ACCESSTOEKN)
        print(user.object(forKey: KEY_ACCESSTOEKN))
        tokenGnerate()
        //kAppDelegate.generateAccessToken_new()
        
        
        kAppDelegate.serverExpiryDate = nil
        kAppDelegate.serverCustomerId = ""
        
        kAppDelegate.boolSubscriptionExpired = true
        
        btnSubmit.isUserInteractionEnabled = true
        
        lblMobileNumber.text = "+\(countryCode ?? "") \(mobileNumber)"
        lblCountDown.text = "0.\(countDownTime)"
        
        tf1.backgroundColor = UIColor.white
        tf2.backgroundColor = UIColor.white
        
        tf3.backgroundColor = UIColor.white
        tf4.backgroundColor = UIColor.white
        
        tf1.border5(4)
        tf2.border5(4)
        tf3.border5(4)
        tf4.border5(4)
        
        tf1.shadow()
        tf2.shadow()
        tf3.shadow()
        tf4.shadow()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_ :)))
        self.view.addGestureRecognizer(tap)
        
        //AlertService.shared.showError(message: "Otp is \(otp)")
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        DispatchQueue.main.async {
            //self.starttimer()
        }
    }
    
    @IBAction func Action_Back(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    func starttimer () {
        DispatchQueue.main.async {
            while true {
                self.countDownTime -= 1
                
                DispatchQueue.global().async {
                    print("self.countDownTime-\(self.countDownTime)-")
                    
                    self.updateTimerText ()
                }
                
                if self.countDownTime < 0 {
                    break
                }
                
                sleep(1)
            }
        }
    }
    
    func updateTimerText () {
        DispatchQueue.main.async {
            if self.countDownTime > 9 {
                self.lblCountDown.text = "0.\(self.countDownTime)"
            } else {
                self.lblCountDown.text = "0.0\(self.countDownTime)"
            }
        }
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        self.view.endEditing(true)
    }
    
    @IBAction func actionSubmit(_ sender: Any) {
        let usernew = UserDefaults.standard
        
        print(usernew.object(forKey: KEY_ACCESSTOEKN) ?? "")
        let token = "\(usernew.object(forKey: KEY_ACCESSTOEKN) ?? "")"
        print(token)
        if token == "" {
            let user = UserDefaults.standard
            user.removeObject(forKey: KEY_ACCESSTOEKN)
            //user.synchronize()
            //kAppDelegate.generateAccessToken_new()
            self.tokenGnerate()
        }else{
            let otp = tf1.text! + tf2.text! + tf3.text! + tf4.text!
            if otp.count == 4 {
                let param = params()
                param["access_token"] = token
                param["otp"] = otp
                param["mobile"] = mobileNumber
                //param["uid"] = uid
                param["uid"] = ""
                param["firebase_token"] = firebase_token
                if facebookID != nil {
                    param["facebook_id"] = facebookID!
                }
                
                if countryCode != nil {
                    param["country_code"] = countryCode!
                }
                
                clearOTP ()
                
                print(param)
                
                Http.instance().json(api_provider_verify_otp, param, "POST", aai: true, popup: true, prnt: true, nil, nil, sync: false, defaultCalling: false) { (json, paras, str, data) in
                    
                    let jsonExp = json as? NSDictionary
                    
                    if jsonExp != nil {
                        if jsonExp?.number("success").intValue == SESSIONEXPIRED {
                            kAppDelegate.sessionExpired(self)
                            
                            let user = UserDefaults.standard
                            user.removeObject(forKey: KEY_ACCESSTOEKN)
                            user.synchronize()
                            kAppDelegate.generateAccessToken ()
                        return
                        }
                    }
                    
                    var json = json as? NSDictionary
                    json = json?.getMutable(nil)
                    
                    if json == nil {
                        Http.stopActivityIndicator()
                        return
                    }
                    
                    var s1 = (json?.toString1())!.replacingOccurrences(of: "<null>", with: "")
                    
                    //MARK: Himanshu update Resolve Issues.
                    s1 = s1.replacingOccurrences(of: "\n", with: "")
                    
                    let data = s1.data(using: String.Encoding.utf8)
                    
                    if data != nil {
                        do {
                            self.userData = try JSONDecoder().decode(UserData.self, from: data!)
                            
                            //self.setUserData ()
                        } catch let error {
                            print("Error: \(error)")
                        }
                    }
                    
                    if let json = json as? NSDictionary {
                        
                        
                        if json.number("success").intValue == 1 {
                            self.setUserData ()
                            print("New Condition Update")
                            //subscriptionStatus = false
//                            let paymentFail = true
//                            if paymentFail {
//                                let story = UIStoryboard(name: "Home", bundle: nil)
//                                let vc = story.instantiateViewController(withIdentifier: "PaymentScreenVC") as! PaymentScreenVC
//                                vc.modalPresentationStyle = .overFullScreen
//                                self.present(vc, animated: true)
//                            }else{
                                self.goNextAfterOTPVerification ()
//                            }
                        } else {
                            //Http.alert("", json.string("message"))
                            self.alertVal(msg: json.string("message"))
                        }
                    }
                }
            } else {
                if otp.count == 0 {
                    lblMessage.text = emptyOTP
                } else {
                    lblMessage.text = wrongOTP
                }
            }

        }
        
    }
    
    func alertVal(msg:String){
        let alertVC = UIAlertController(title: "", message: msg, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "Ok", style: .default, handler: { aler in
            self.tf1.becomeFirstResponder()
        }))
        self.present(alertVC, animated: true, completion: nil)
    }
    
    func setUserData () {
        if self.userData.data != nil {
            let ob1 = Addresses("")
            
            ob1.locationName = "Home"
            
            ob1.address = self.userData.data?.onlineAddress
            ob1.latitude = self.userData.data?.latitude
            ob1.longitude = self.userData.data?.longitude
            
            ob1.city = self.userData.data?.city
            ob1.state = self.userData.data?.state
            ob1.country = self.userData.data?.country
            
            kAppDelegate.setUserAddress(ob1)
        }
        
        let user = UserDefaults.standard
        let numberWithCode = "\(self.userData.data?.country_code ?? "") \(self.userData.data?.mobile ?? "")"
        
        user.set(numberWithCode, forKey: Key_User_phone_number_withCode)
        user.set(self.userData.data?.aboutMe, forKey: Key_User_about_me)
        user.set(self.userData.data?.access, forKey: Key_User_access)
        user.set(self.userData.data?.businessName, forKey: Key_User_business_name)
        user.set(self.userData.data?.city, forKey: Key_User_city)
        user.set(self.userData.data?.country, forKey: Key_User_country)
        user.set(self.userData.data?.dob, forKey: Key_User_dob)
        user.set(self.userData.data?.email, forKey: Key_User_email)
        user.set(self.userData.data?.fullName, forKey: Key_User_full_name)
        user.set(self.userData.data?.gender, forKey: Key_User_gender)
        user.set(self.userData.data?.id, forKey: Key_User_id)
        user.set(self.userData.data?.lastLogin, forKey: Key_User_last_login)
        user.set(self.userData.data?.latitude, forKey: Key_User_latitude)
        user.set(self.userData.data?.licenseNumber, forKey: Key_User_license_number)
        user.set(self.userData.data?.longitude, forKey: Key_User_longitude)
        user.set(self.userData.data?.mobile, forKey: Key_User_mobile)
        user.set(self.userData.data?.online, forKey: Key_User_online)
        user.set(self.userData.data?.phoneNumber, forKey: Key_User_phone_number)
        user.set(self.userData.data?.professionalExperience, forKey: Key_User_professional_experience)
        user.set(self.userData.data?.profilePic, forKey: Key_User_profile_pic)
        user.set(self.userData.data?.registerComplete, forKey: Key_User_register_complete)
        user.set(self.userData.data?.verified, forKey: Key_User_verified)
        user.set(self.userData.data?.websiteLink, forKey: Key_User_website_link)
        user.set(self.userData.data?.status, forKey: Key_User_status)
        user.synchronize()
    }
    
    var userData: UserData!
    
    func checkProfile () {
        var profileJSON: ProfileJSON?
        
        let param = params()
        
        Http.instance().json(api_provider_profile_steps, param, "POST", aai: true, popup: true, prnt: true, nil, nil, sync: false, defaultCalling: false) { (json, paras, str, data) in
            
            let jsonExp = json as? NSDictionary
            
            if jsonExp != nil {
                if jsonExp?.number("success").intValue == SESSIONEXPIRED {
                   kAppDelegate.sessionExpired(self)
                    
                    return
                }
            }
            
            var json = json as? NSDictionary
            json = json?.getMutable(nil)
            
            if json == nil {
                Http.stopActivityIndicator()
                
                return
            }
            
            if jsonExp != nil {
                print(jsonExp)
                let dictData = jsonExp?["data"] as? NSDictionary
                print(dictData)
                if let value = dictData?.number("user_submit_approval_btn").intValue {
                    print(value)
                    let user = UserDefaults.standard
                    user.set("\(value)", forKey: user_submit_approval_btn)
                }
            }
            
            var s1 = (json?.toString1())!.replacingOccurrences(of: "<null>", with: "")
            
            //MARK: Himanshu update Resolve Issues.
            s1 = s1.replacingOccurrences(of: "\n", with: "")
            
            let data = s1.data(using: String.Encoding.utf8)
            
            if data != nil {
                do {
                    profileJSON = try JSONDecoder().decode(ProfileJSON.self, from: data!)
                    
                    if profileJSON != nil {
                        let user = UserDefaults.standard
                        
                        if profileJSON?.data.rating != nil {
                            user.set(profileJSON?.data.rating, forKey: Key_User_rating)
                        }
                        
                        user.set(profileJSON?.step1, forKey: Key_step1)
                        user.set(profileJSON?.step2, forKey: Key_step2)
                        user.set(profileJSON?.step3, forKey: Key_step3)
                        user.set(profileJSON?.step4, forKey: Key_step4)
                        user.set(profileJSON?.step5, forKey: Key_step5)
                        //user.set(profileJSON?.data.user_submit_approval_btn, forKey: user_submit_approval_btn)
                        user.synchronize()
                        
                        self.profileJSON = profileJSON
                        
                        self.getSubcriptionDetailsFromServer ()
                    }
                } catch let error {
                    print("Error: \(error)")
                }
            }
        }
    }
    
    func clearOTP () {
        tf1.text = ""
        tf2.text = ""
        tf3.text = ""
        tf4.text = ""
    }
    
    var uid = ""
    
    @IBAction func actionResendOTP(_ sender: Any) {
        accessTokenAPI()
    }
    
    
    func accessTokenAPI() {
        
        var ip = ""
        
        if let wifiIp = getAddress(for: .wifi) {
            ip = wifiIp
        } else if let cellular = getAddress(for: .cellular) {
            ip = cellular
        }
        
        let params = [
            "api_key": "$2a$06$hsTL2DeUKS5pUV.YlY/CSuVesppz0ha4hZdcsB7gN8VKRQRBwKct6",
            "device_id": "\(UIDevice.current.identifierForVendor!.uuidString)_provider",
            "ip":"\(ip)"
        ]
        let get_services_list_withoutkey = "\(BaseUrl)ganerateCookies"
        let url = URL(string: "\(get_services_list_withoutkey)")

        print(params)
        print(url)
        
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        request.timeoutInterval = 180
        request.addValue("application/json", forHTTPHeaderField: "Accept")

        let postString = AppDelegate.getPostString(params: params)
        request.httpBody = postString.data(using: .utf8)

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let dataVal = data {
                let json = try! JSONSerialization.jsonObject(with: dataVal, options: [])
                print("Response :- \(json)")
                let jsonDict = json as? NSDictionary
                let status = (jsonDict?["success"] as? Int) ?? 0
                if status == 1 {
                    let tokenSec = (jsonDict?["data"] as? String) ?? ""
                    print("\(tokenSec)")
                    tokenSecret = "\(tokenSec)"
                    ipSecret = "\(ip)"
                    DispatchQueue.main.async {
                        self.resendOTP()
                    }
                }
            }
        }
        task.resume()
    }
    
    
    
    
    func getAddress(for network: Network) -> String? {
        var address: String?
        var ifaddr: UnsafeMutablePointer<ifaddrs>?
        guard getifaddrs(&ifaddr) == 0 else { return nil }
        guard let firstAddr = ifaddr else { return nil }
        for ifptr in sequence(first: firstAddr, next: { $0.pointee.ifa_next }) {
            let interface = ifptr.pointee
            let addrFamily = interface.ifa_addr.pointee.sa_family
            if addrFamily == UInt8(AF_INET) || addrFamily == UInt8(AF_INET6) {
                let name = String(cString: interface.ifa_name)
                if name == network.rawValue {
                    var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                    getnameinfo(interface.ifa_addr, socklen_t(interface.ifa_addr.pointee.sa_len),
                                &hostname, socklen_t(hostname.count),
                                nil, socklen_t(0), NI_NUMERICHOST)
                    address = String(cString: hostname)
                }
            }
        }
        freeifaddrs(ifaddr)
        return address
    }
    
    
    enum Network: String {
        case wifi = "en0"
        case cellular = "pdp_ip0"
    }
    
    static func getPostString(params:[String:Any]) -> String {
        var data = [String]()
        for(key, value) in params
        {
            data.append(key + "=\(value)")
        }
        return data.map { String($0) }.joined(separator: "&")
    }

    
    
    func resendOTP() {
        clearOTP ()
        let param = params()
 
        //param["mobile"] = mobileNumber
        param["uid"] = uid
        
        if countryCode != nil {
            param["country_code"] = countryCode!
        }
        
        param["phone_number"] = mobileNumber
        
        param["accessType"] = "provider"
        param["token"] = tokenSecret
        param["ip"] = ipSecret
        
        
        
        Http.instance().json(api_resent_otp, param, "POST", aai: true, popup: true, prnt: true, nil, nil, sync: false, defaultCalling: false) { (json, paras, str, data) in
            
            let jsonExp = json as? NSDictionary
            
            if jsonExp != nil {
                if jsonExp?.number("success").intValue == SESSIONEXPIRED {
                   kAppDelegate.sessionExpired(self)
                    
                    return
                }
            }
            
            if let json = json as? NSDictionary {
                Http.alert("", json.string("message"))
            }
        }
    }
    
    var boolDelete = false
    
    @IBOutlet weak var lblMessage: UILabel!
}

extension MobileVerification: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        return true
    }
    
    func enableBubmit () {
        let otp = tf1.text! + tf2.text! + tf3.text! + tf4.text!
        
        if otp.count == 0 {
            lblMessage.text = emptyOTP
        } else if otp.count < 4 {
            lblMessage.text = wrongOTP
        } else {
            lblMessage.text = ""
        }
    }
}

class UserData: Codable {
    let success: String?
    let message: String?
    let data: UserInfo?
    let address: Address?
}

class Address: Codable {
    let address: String?
    let latitude: String?
    let longitude: String?
}

let emptyOTP = "OTP can't be empty."
let wrongOTP = "Invalid OTP."

//MARK: - Payment at registration decision

extension MobileVerification {
    func goNextAfterOTPVerification () {
        var vc: UIViewController?
        print(Key_User_full_name.getUserValue())
//        if Key_User_full_name.getUserValue() == nil {
//            print("EnterYourDetail")
//            vc = story_Auth.viewController("EnterYourDetail")
//            self.navigationController?.pushViewController(vc!, animated: true)
//        } else if (Key_User_full_name.getUserValue() as? String)?.count == 0 {
//            print("EnterYourDetail")
//            vc = story_Auth.viewController("EnterYourDetail")
//            self.navigationController?.pushViewController(vc!, animated: true)
//        } else {
            self.checkProfile ()
//        }
    }
    
    func paymentNext () {
        let profilePic = Key_User_profile_pic.getUserValue() as! String
        if profileJSON != nil {
            if  Int((profileJSON?.step1)!) == 0 || Int((profileJSON?.step2)!) == 0 || Int((profileJSON?.step3)!) == 0 || Int((profileJSON?.step4)!) == 0 || Int((profileJSON?.step5)!) == 0 || profilePic.count == 0 || Int((profileJSON?.data.user_submit_approval_btn)!) == 0 {
                //MARK: Himanshu Update NavigationChange
                let vc = story_Profile.viewController("Profile") as! Profile
                vc.profileJSON = profileJSON
                self.navigationController?.pushViewController(vc, animated: true)
            } else {
                let vc = story_Tradie.viewController("MyBookings") as! MyBookings
                self.navigationController?.pushViewController(vc, animated: true)
            }
        } else {
            let vc = story_Tradie.viewController("MyBookings") as! MyBookings
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}


//MARK: - Subcription detail from server

extension MobileVerification {
    func getSubcriptionDetailsFromServer () {
        kAppDelegate.boolPurchasedFromIAP = true        
        boolServerPuchase = false
        Http.instance().json(api_get_current_subscription, params(), "POST", aai: true, popup: true, prnt: true, nil, nil, sync: false, defaultCalling: true) { (json, para, ss, ht, data) in                        
            if let json = json as? NSDictionary {
                if let data = json["data"] as? NSDictionary {
                    let isFebVal = data.number("isFab")
                    print("isFeb == ",isFebVal)
                    if isFebVal == 0 {
                        isFeb = 0
                    }else if isFebVal == 1 {
                        isFeb = 1
                    }else{
                        isFeb = 0
                    }
                    
                    
                    let cancelStatus = data.string("status")
                    print(cancelStatus)
                    cancelStatusVal = "\(cancelStatus)"
                    
                    let timestamp = data.string("end_date")
                    
                    self.purchasedDeviceType = data.string("device_type")
                    
                    if timestamp.count > 0 {
                        let time = data.number("end_date").doubleValue
                        kAppDelegate.serverCustomerId = data.string("ios_customer_id")
                        
                        var date: Date = Date()
                        
                        if timestamp.count == 13 {
                            date = Date.init(timeIntervalSince1970: time/1000)
                        } else {
                            date = Date.init(timeIntervalSince1970: time)
                        }
                        
                        kAppDelegate.serverExpiryDate = date
                        
                        let date1 = Date()
                        
                        print("Expiry date-[\(date)]-current-[\(date1)]")
                        
                        let int = date1.timeIntervalSince(date)
                        
                        if int > 0 {
                            print("x1 Not purchased----[]-")
                        } else {
                            self.boolServerPuchase = true
                            
                            kAppDelegate.boolPurchasedFromIAP = false
                            
                            print("Purchased-----")
                        }
                    }
                }
                
                
                
                if let paymentSetting = json["paymentSetting"] as? Int {
                    print("paymentSetting",paymentSetting)
                    if paymentSetting == 1 {
                        paymentSettingStatus = true
                    }else{
                        paymentSettingStatus = false
                        subscriptionStatus = true
                    }
                        
                }
                print("paymentSettingStatus : ",paymentSettingStatus)
                
                
                
            }
            
//            if self.boolServerPuchase {
                self.paymentNext()
//            } else {
//                let vc = PaymentAtRegistration.viewController()
//                vc.boolFromRegistration = false
//                self.navigationController?.pushViewController(vc, animated: true)
//            }
            
            
        }
    }
}


extension MobileVerification {
    
    func tokenGnerate() {
        guard let url = URL(string: api_generate_access_token) else {
            self.alertVal(msg: "Url Not Found")
            return
        }
        var request = URLRequest(url: url)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        let parameters: [String: Any] = [
            "api_key" : "$2a$06$hsTL2DeUKS5pUV.YlY/CSuVesppz0ha4hZdcsB7gN8VKRQRBwKct6",
            "device_id" : "\(UIDevice.current.identifierForVendor?.uuidString ?? "")_provider",
            "device_type" : "2",
            "role" : "provider",
            "version" : "\(UIDevice.current.systemVersion)",
        ]
        print(parameters)
        request.httpBody = parameters.percentEncoded()

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let dataval = data else {
                return
            }
            
            let json = try? JSONSerialization.jsonObject(with: dataval, options: .mutableContainers) as? [String:AnyObject]
            let value = json as? NSDictionary
            let token = value?["token"] as? String
            let user = UserDefaults.standard
            print(user.object(forKey: KEY_ACCESSTOEKN) ?? "")
            user.set("\(token ?? "")", forKey: KEY_ACCESSTOEKN)
            print(user.object(forKey: KEY_ACCESSTOEKN) ?? "")
        }

        task.resume()
    }
    

}


extension Dictionary {
    func percentEncoded() -> Data? {
        return map { key, value in
            let escapedKey = "\(key)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
            let escapedValue = "\(value)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
            return escapedKey + "=" + escapedValue
        }
        .joined(separator: "&")
        .data(using: .utf8)
    }
}

