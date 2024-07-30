//
//  MobileVerification.swift
//  TapATradie
//
//  Created by Apple on 20/04/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
var firebase_token = ""

var tokenSecret = ""
var ipSecret = ""

class MobileVerification: UIViewController {
    
    var facebookID: String?
    var countryCode: String?
    
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
    @IBOutlet weak var lblMessage: UILabel!
    
    var mobileNumber = ""
    
    var countDownTime = 30
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        kAppDelegate.currentVC = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        DispatchQueue.main.async {
            //self.starttimer()
        }
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
    @IBAction func Action_Back(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
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
            DispatchQueue.main.async {
                self.verifyOTp()
            }
            
        }
    }
    
    func verifyOTp() {
        let usernew = UserDefaults.standard
        let token = "\(usernew.object(forKey: KEY_ACCESSTOEKN) ?? "")"
        print(token)
        
        let otp = tf1.text! + tf2.text! + tf3.text! + tf4.text!
        if otp.count == 4 {
            let param = params()
            param["access_token"] = token
            param["otp"] = otp
            param["firebase_token"] = firebase_token
            param["mobile"] = mobileNumber
            //param["uid"] = uid
            param["uid"] = ""
            if facebookID != nil {
                param["facebook_id"] = facebookID!
            }
            if countryCode != nil {
                param["country_code"] = countryCode!
            }
            clearOTP ()
            Http.instance().json(api_user_verify_otp, param, "POST", aai: true, popup: true, prnt: true, nil, nil, sync: false, defaultCalling: false) { (json, paras, str, data) in
                let jsonExp = json as? NSDictionary
                if jsonExp != nil {
                    if jsonExp?.number("success").intValue == SESSIONEXPIRED {
                       kAppDelegate.sessionExpired(self)
                    return
                    }
                }
                if data != nil {
                    do {
                        self.userData = try JSONDecoder().decode(UserData.self, from: data!)
                    } catch let error {
                        print("Error: \(error)")
                    }
                }
                if let json = json as? NSDictionary {
                    if json.number("success").intValue == 1 {
                        let user = UserDefaults.standard
                        let numberWithCode = "\((self.userData.data.country_code ?? "").replacingOccurrences(of: "++", with: "+")) \(self.userData.data.mobile ?? "")"
                        user.set(numberWithCode, forKey: Key_User_mobile_withCode)
                        user.set(self.userData.data.aboutMe, forKey: Key_User_about_me)
                        user.set(self.userData.data.access, forKey: Key_User_access)
                        user.set(self.userData.data.businessName, forKey: Key_User_business_name)
                        user.set(self.userData.data.city, forKey: Key_User_city)
                        user.set(self.userData.data.country, forKey: Key_User_country)
                        user.set(self.userData.data.dob, forKey: Key_User_dob)
                        user.set(self.userData.data.email, forKey: Key_User_email)
                        user.set(self.userData.data.fullName, forKey: Key_User_full_name)
                        user.set(self.userData.data.gender, forKey: Key_User_gender)
                        user.set(self.userData.data.id, forKey: Key_User_id)
                        user.set(self.userData.data.lastLogin, forKey: Key_User_last_login)
                        user.set(self.userData.data.latitude, forKey: Key_User_latitude)
                        user.set(self.userData.data.licenseNumber, forKey: Key_User_license_number)
                        user.set(self.userData.data.longitude, forKey: Key_User_longitude)
                        user.set(self.userData.data.mobile, forKey: Key_User_mobile)
                        user.set(self.userData.data.online, forKey: Key_User_online)
                        user.set(self.userData.data.phoneNumber, forKey: Key_User_phone_number)
                        user.set(self.userData.data.professionalExperience, forKey: Key_User_professional_experience)
                        user.set(self.userData.data.profilePic, forKey: Key_User_profile_pic)
                        user.set(self.userData.data.registerComplete, forKey: Key_User_register_complete)
                        user.set(self.userData.data.verified, forKey: Key_User_verified)
                        user.set(self.userData.data.websiteLink, forKey: Key_User_website_link)
                        user.set(self.userData.data.status, forKey: Key_User_status)
                        user.synchronize()
                        var vc: UIViewController?
                        print("self.userData.address-\(self.userData.address)-")
                        if self.userData.address != nil {
                            let ob1 = Addresses("")
                            ob1.locationName = "Home"
                            ob1.address = self.userData.address.address
                            ob1.latitude = self.userData.address.latitude
                            ob1.longitude = self.userData.address.longitude
                            ob1.city = self.userData.address.city
                            ob1.state = self.userData.address.state
                            ob1.country = self.userData.address.country
                            kAppDelegate.setUserAddress(ob1)
                        }
                        if (Key_User_full_name.getUserValue() as! String).count == 0 {
                            vc = story_Auth.viewController("EnterYourDetail")
                        } else {
                            var boolGoToSeeTradie = true
                            if self.userData.address.address!.count > 0 {
                                boolGoToSeeTradie = false
                            }
                            if boolGoToSeeTradie {
                                vc = story_Auth.viewController("SeeTradiesArround")
                            } else {
                                vc = story_Home.viewController("Home")
                            }
                        }
                        
                        self.navigationController?.pushViewController(vc!, animated: true)
                    } else {
                        //Http.alert("", json.string("message"))
                        self.alertVal(msg: json.string("message"))
                    }
                }
            }
            
            
        }else {
            //Http.alert("", "Please enter valid OTP.")
            
            if otp.count == 0 {
                lblMessage.text = emptyOTP
            } else {
                lblMessage.text = wrongOTP
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
    
    var userData: UserData!
    
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
    
    
    func resendOTP() {
        clearOTP ()
        
        let param = params()
 
        param["phone_number"] = mobileNumber
        param["uid"] = uid
        param["accessType"] = "user"
        
        if countryCode != nil {
            param["country_code"] = countryCode!
        }
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
}

let emptyOTP = "OTP can't be empty."
let wrongOTP = "Invalid OTP."

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
    let success: Int
    let message: String
    let data: UserInfo
    let address: Address
}

class Address: Codable {
    let address: String?
    let latitude: String?
    let longitude: String?
    var city, country, state: String?
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
            "device_id" : "\(UIDevice.current.identifierForVendor?.uuidString ?? "")",
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
            DispatchQueue.main.async {
                self.verifyOTp()
            }
            
        }

        task.resume()
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
            "device_id": "\(UIDevice.current.identifierForVendor!.uuidString)",
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

        let postString = MobileVerification.getPostString(params: params)
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
