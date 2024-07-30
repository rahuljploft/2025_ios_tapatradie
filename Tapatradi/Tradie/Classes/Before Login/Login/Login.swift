//
//  Login.swift
//  Tradie
//
//  Created by Apple on 19/04/19.
//  Copyright © 2019 Apple. All rights reserved.
//

//9713541062
//0600

let SESSIONEXPIRED = 2

import UIKit
//import FacebookLogin
import AuthenticationServices

class Login: BaseVC {
    @IBOutlet weak var btnShowDetails: UIButton!
    
    // TODO: unnecessary (remove)
    @IBAction func actionShowDetails(_ sender: Any) {
        let oti = kAppDelegate.getOriginalTransactionId()
        
        let dvc = "\(UIDevice.current.identifierForVendor!.uuidString)_provider"
        
        Http.alert("-[\(oti)]-", "-[\(dvc)]-")
    }
    
    @IBOutlet weak var btnAppleLogin: UIButton!
    
    var userData: UserData!
    
    @IBOutlet weak var flagImage: UIImageView!
    @IBOutlet weak var tfvMobile: MaterialTextFieldView!
    
    var facebookID: String?
    
    @IBOutlet weak var btnFacebook: UIButton!
    @IBOutlet weak var btnLoginSignup: UIButton!
    
    var countryCodes: NSArray?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnFacebook.border5(4)
        btnAppleLogin.border5(4)
        
//        countryCodes = kAppDelegate.countryCodes()
        
        let user = UserDefaults.standard
        user.set("1", forKey: Key_Introduction)
        user.removeObject(forKey: KEY_ACCESSTOEKN)
        user.synchronize()
        
        kAppDelegate.generateAccessToken()
        
        tfvMobile.keyboardType = .numberPad
        //tfvMobile.keyboardType = UIKeyboardType.emailAddress
        tfvMobile.autocapitalizationType = UITextAutocapitalizationType.none
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_ :)))
        self.view.addGestureRecognizer(tap)
        
//        findCountry ()
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        self.view.endEditing(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        kAppDelegate.currentVC = self
        
        facebookID = nil
        
        self.btnAppleLogin.isHidden = true
        self.btnFacebook.isHidden = true
        
        self.btnLoginSignup.setTitle("LOGIN/SIGNUP", for: .normal)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        /*self.view.endEditing(true)
        tfvMobile.textField.text = ""
        tfvMobile?.endEditing()*/
    }
    
    @IBAction func actionSignInSignUp(_ sender: Any) {
        if tokenSecret == "" {
            accessTokenAPI()
        }else{
            signUP()
        }
        
    }
    
    
    func signUP() {
        
        self.view.endEditing(true)
        
        let bool = true//validEmail (tfvMobile.textField.text!)
        
        if tfvMobile.validateMobile(8) == false {
            return
        }
        
        let param = params()
        param["phone_number"] = tfvMobile.textField.text
        param["country_code"] = lblCountryCode.text?.replacingOccurrences(of: "+", with: "")
        
        param["accessType"] = "provider"
        param["token"] = tokenSecret
        param["ip"] = ipSecret
        
        
        if facebookID != nil {
            param["facebook_id"] = facebookID!
        }
        
        print(param)
        
        Http.instance().json(api_provider_otp_registration, param, "POST", aai: true, popup: true, prnt: true, nil, nil, sync: false, defaultCalling: false) { (json, paras, str, data) in
            print("Harish 2")
            if let json = json as? NSDictionary {
                if json.number("success").intValue == 1 {
                    let vc = story_Auth.viewController("MobileVerification") as? MobileVerification
                    vc?.mobileNumber = self.tfvMobile.textField.text!
                    vc?.countryCode = self.lblCountryCode.text?.replacingOccurrences(of: "+", with: "")
                    vc?.otp = String(json.number("otp").intValue)
                    
                    self.tfvMobile.textField.text = ""
                    self.tfvMobile?.endEditing()
                    
                    vc?.uid = json.string("uid")
                    self.navigationController?.pushViewController(vc!, animated: true)
                } else {
                    Http.alert("", json.string("message"))
                }
            }
        }
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
                        self.signUP()
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
    
//    func findCountry () {
//        guard let countryCodes = countryCodes else { return }
//        guard countryCodes.count > 0 else { return }
//
//        kAppDelegate.locationManager?.startUpdatingLocation()
//
//        guard kAppDelegate.locationManager != nil else { return }
//
//        let latitude = kAppDelegate.locationManager?.location?.coordinate.latitude as NSNumber?
//        let longitude = kAppDelegate.locationManager?.location?.coordinate.longitude as NSNumber?
//        print("coordinates: (\(latitude!), \(longitude!))")
//
//        guard latitude != 0.0 && longitude != 0.0 else { return }
//
//        getAddressOrLatLongApple(latitude, longitude, nil, false) {[weak self] (address) in
//            guard address?.country != nil else { return }
//            for i in 0..<countryCodes.count {
//                if let country = countryCodes[i] as? NSDictionary {
//                    if address!.country?.lowercased() == country.string("name").lowercased() {
//                        self?.lblCountryCode.text = "+\(country.string("phonecode")) ▾"
//                        self?.flagImage.image = UIImage(named: country.string("iso").lowercased())
//                        break
//                    }
//                }
//            }
//        }
//    }
    
    //MARK: - Facebook
    
    @IBAction func actionFacebook(_ sender: Any) {
        /*let loginManager = LoginManager()
    
        loginManager.logOut()
    
        loginManager.logIn(permissions: [.publicProfile, .email], viewController: nil) { loginResult in
            Http.startActivityIndicator()
        
            self.loginManagerDidComplete(loginResult)
        }*/
    }
        
        /*func loginManagerDidComplete(_ result: LoginResult) {
            
            switch result {
                case .cancelled:
                    Http.stopActivityIndicator()
                break
                case .failed(let error):
                    Http.stopActivityIndicator()
                break
                
                case .success(let _, let _, let _):
                    
                    let req = GraphRequest(graphPath: "me", parameters: ["fields":"first_name,last_name,email, picture.type(large)"], tokenString: AccessToken.current?.tokenString, version: nil, httpMethod: HTTPMethod(rawValue: "GET"))
                    
                    req.start(completionHandler: { (test, result, error) in
                        if(error == nil) {
                            let data:[String:AnyObject] = result as! [String : AnyObject]
                            
                            print("data-\(data)-")
                            
                            let email = data["email"] as! String
                            
                            let dictProfile = data["picture"] as! [String : AnyObject]

                            let fbUserId = data["id"] as! String
                      
                            let firstName = data["first_name"] as! String
                            let lastName = data["last_name"] as! String
                            
                            self.socialMediaLogin(strSocailMedia: "facebook", strEmail: email, strFristName: firstName, strLastName: lastName, strAuthId: fbUserId, fullname: "\(firstName) \(lastName)")
                        } else {
                            Http.stopActivityIndicator()
                        }
                    })
                break
            }
        }*/

        func socialMediaLogin(strSocailMedia: String, strEmail: String, strFristName: String, strLastName: String, strAuthId: String, fullname: String?) {
            
            // api_user_facebook_login
            
            DispatchQueue.global().async {
                sleep(2)
                
                self.facebookID = strAuthId
            
                if self.facebookID != nil {
                
                    let param = params()
                
                    param["facebook_id"] = strAuthId
                
                    Http.instance().json(api_user_facebook_login, param, "POST", aai: false, popup: true, prnt: true, nil, nil, sync: false, defaultCalling: false) { (json, paras, str, data) in
                        
                        if let json = json as? NSDictionary {
                            if json.number("success").intValue == 1 {
                                var boolGoLogin = true
                                
                                if let dict = json["data"] as? NSDictionary {
                                    if dict.count == 0 {
                                        self.facebookID = strAuthId
                                        
                                        boolGoLogin = false
                                        
                                        Http.alert("", "Please enter your mobile number to signup")
                                        self.btnFacebook.isHidden = true
                                        self.btnAppleLogin.isHidden = true
                                        self.btnLoginSignup.setTitle("Facebook Signup", for: .normal)
                                        
                                        if strSocailMedia == "applelogin" {
                                            self.btnLoginSignup.setTitle("Apple Login Signup", for: .normal)
                                        }
                                    }
                                }
                                
                                if let arr = json["data"] as? NSArray {
                                    if arr.count == 0 {
                                        self.facebookID = strAuthId
                                        
                                        boolGoLogin = false
                                        
                                        Http.alert("", "Please enter your mobile number to signup")
                                        self.btnFacebook.isHidden = true
                                        self.btnAppleLogin.isHidden = true
                                        self.btnLoginSignup.setTitle("Facebook Signup", for: .normal)
                                        
                                        if strSocailMedia == "applelogin" {
                                            self.btnLoginSignup.setTitle("Sign in with Apple Signup", for: .normal)
                                        }
                                    }
                                }
                                
                                if boolGoLogin {
                                    
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
                                            self.goNext ()
                                        } else {
                                            Http.alert("", json.string("message"))
                                        }
                                    }
                                }
                            } else {
                                Http.alert("", json.string("message"))
                            }
                        }
                        
                        Http.stopActivityIndicator()
                    }
                } else {
                    Http.stopActivityIndicator()
                }
            }
        }
    
    func setUserData () {
        if self.userData.data != nil {
            let ob1 = Addresses("")
            
            ob1.locationName = "Home"
            
            ob1.address = self.userData.data?.onlineAddress
            ob1.latitude = self.userData.data?.latitude
            ob1.longitude = self.userData.data?.longitude
            
            kAppDelegate.setUserAddress(ob1)
        }
        
        let user = UserDefaults.standard
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
    
    func goNext () {
        setUserData ()
        
        var vc: UIViewController?
                
//        if Key_User_full_name.getUserValue() == nil {
//            vc = story_Auth.viewController("EnterYourDetail")
//            self.navigationController?.pushViewController(vc!, animated: true)
//        } else if (Key_User_full_name.getUserValue() as? String)?.count == 0 {
//            vc = story_Auth.viewController("EnterYourDetail")
//            self.navigationController?.pushViewController(vc!, animated: true)
//        } else {
            self.checkProfile ()
//        }
    }
    
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
                        
                        // || (Key_User_register_complete.getUserValue() as! Int) == 0
                        
                        if  Int((profileJSON?.step1)!) == 0 || Int((profileJSON?.step2)!) == 0 || Int((profileJSON?.step3)!) == 0 || Int((profileJSON?.step4)!) == 0 || Int((profileJSON?.step5)!) == 0 || Int((profileJSON?.data.user_submit_approval_btn)!) == 0 {
                            let vc = story_Profile.viewController("Profile") as! Profile
                            vc.profileJSON = profileJSON
                            self.navigationController?.pushViewController(vc, animated: true)
                        } else {
                            let vc = story_Tradie.viewController("MyBookings") as! MyBookings
                            self.navigationController?.pushViewController(vc, animated: true)
                        }
                    }
                    
                    //print("self.profileJSON-\(profileJSON)-")
                } catch let error {
                    print("Error: \(error)")
                }
            }
        }
    }
    
    @IBAction func actionAppleLogin(_ sender: Any) {
        if #available(iOS 13.0, *) {
            let appleIDProvider = ASAuthorizationAppleIDProvider()
            let request = appleIDProvider.createRequest()
            request.requestedScopes = [.fullName, .email]
            let authorizationController = ASAuthorizationController(authorizationRequests: [request])
            authorizationController.delegate = self
            authorizationController.presentationContextProvider = self as? ASAuthorizationControllerPresentationContextProviding //as! ASAuthorizationControllerPresentationContextProviding
            authorizationController.performRequests()
        } else {
            Http.alert("", "Sign in with Apple not available below ios version 13.0")
        }
    }
}

extension Login: ASAuthorizationControllerDelegate {
    // ASAuthorizationControllerDelegate function for authorization failed
    
    @available(iOS 13.0, *)
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print(error.localizedDescription)
    }
    
    // ASAuthorizationControllerDelegate function for successful authorization
    @available(iOS 13.0, *)
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            // Create an account as per your requirement
            let appleId = appleIDCredential.user
            let appleUserFirstName = appleIDCredential.fullName?.givenName
            let appleUserLastName = appleIDCredential.fullName?.familyName
            let appleUserEmail = appleIDCredential.email
            let fullName = appleUserFirstName ?? "" + " " + (appleUserLastName ?? "")
            
            if let firstName = appleIDCredential.fullName?.givenName,
                let lastName = appleIDCredential.fullName?.familyName,
                let email = appleIDCredential.email,
                let id = appleIDCredential.identityToken {
                print("\(firstName)")
                
                print("appleId-[\(id)]-")
                print("appleUserFirstName-[\(email)]-")
                print("appleUserLastName-[\(firstName)]-")
                print("appleUserEmail-[\(lastName)]-")
                
                /*var param = [String:Any]()
                param[kAPIParam.Name.rawValue] = firstName + " " + lastName
                param[kAPIParam.Email.rawValue] = email
                param[kAPIParam.SocialLoginId.rawValue] = id
                param[kAPIParam.SocialLoginType.rawValue] = "apple"
                */
                //self.gmailLoginApi(param)
                
                //self.socialMediaLogin(strSocailMedia: "facebook", strEmail: email, strFristName: firstName, strLastName: lastName, strAuthId: fbUserId, fullname: "\(firstName) \(lastName)")
                
                //self.socialMediaLogin(strSocailMedia: "applelogin", strEmail: appleUserEmail ?? "", strFristName: appleUserFirstName ?? "", strLastName: appleUserLastName ?? "", strAuthId: appleId, fullname: "\(appleUserFirstName ?? "") \(appleUserLastName ?? "")")
                
                return
            } else {
                //self.showAnnouncment(withMessage: "Email and other field is required")
                
                //Http.alert("Tap A Tradie", "Email and other field is required")
                
                //return
            }
            
            //Write your code
        } else if let passwordCredential = authorization.credential as? ASPasswordCredential {
            let appleUsername = passwordCredential.user
            let applePassword = passwordCredential.password
            //Write your code
        }
        
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            print("1appleIDCredential-[\(appleIDCredential)]-")
            // Create an account as per your requirement
            let appleId = "applelogin" + appleIDCredential.user
            let appleUserFirstName = appleIDCredential.fullName?.givenName
            let appleUserLastName = appleIDCredential.fullName?.familyName
            let appleUserEmail = appleIDCredential.email
            print("appleId-[\(appleId)]-")
            print("appleUserFirstName-[\(appleUserFirstName)]-")
            print("appleUserLastName-[\(appleUserLastName)]-")
            print("appleUserEmail-[\(appleUserEmail)]-")
            
            self.socialMediaLogin(strSocailMedia: "applelogin", strEmail: appleUserEmail ?? "", strFristName: appleUserFirstName ?? "", strLastName: appleUserLastName ?? "", strAuthId: appleId, fullname: "\(appleUserFirstName ?? "") \(appleUserLastName ?? "")")
            
            //Write your code
        } else if let passwordCredential = authorization.credential as? ASPasswordCredential {
            let appleUsername = passwordCredential.user
            let applePassword = passwordCredential.password
            print("appleUsername-[\(appleUsername)]-")
            print("applePassword-[\(applePassword)]-")
            //Write your code
            print("2appleIDCredential-[\(passwordCredential)]-")
        }
    }
    
}

protocol CountryCodeCellDelegate {
    func cellClick (_ indexPath: IndexPath)
}

class CountryCodeCell: UITableViewCell {
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

extension Login: UITableViewDelegate, UITableViewDataSource, CountryCodeCellDelegate {
    func cellClick (_ indexPath: IndexPath) {
        if let country = countryCodes![indexPath.row] as? NSDictionary {
            lblCountryCode.text = "+\(country.string("phonecode")) ▾"
            flagImage.image = UIImage(named: country.string("iso").lowercased())
            //print("1indexPath-\(country)-")
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "CountryCodeCell") as! CountryCodeCell
        
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
        print("2indexPath-\(indexPath.row)-")
    }
}

extension Login: UITextFieldDelegate {
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

//import CoreLocation

//public func getAddressOrLatLongApple (_ lat: NSNumber?, _ long: NSNumber?,
//                                 _ addr: String?, _ prnt: Bool, handler: @escaping (AddressObject?) -> Swift.Void) {
//    let reach = ReachabilityKrishna.init(hostname: "google.com")
//    if prnt {
//        print("lat-\(String(describing: lat))-")
//        print("long-\(String(describing: long))-")
//        print("addr-\(String(describing: addr))-")
//    }
//    if lat == nil && long == nil && addr == nil {
//        handler(nil)
//    } else {
//        if (reach?.isReachable)! {
//            if lat == nil && long == nil {
//                let ceo: CLGeocoder = CLGeocoder()
//
//                ceo.geocodeAddressString(addr!) { (placemarks, error) in
//                    print("placemarks-\(placemarks)-")
//                    print("error-\(error)-")
//
//                    if (error != nil) {
//                        print("reverse geodcode fail: \(error!.localizedDescription)")
//
//                        //handler (nil, nil)
//
//                        let ob = AddressObject(nil)
//
//                        ob.address = addr
//                        //ob.country = country
//
//                        handler(ob)
//                    }
//
//                    if placemarks != nil {
//                        let pm = placemarks! as [CLPlacemark]
//                        if pm.count > 0 {
//                            let pm = placemarks![0]
//
//                            let location = pm.location
//
//                            let ob = AddressObject(nil)
//
//                            if location != nil {
//                                ob.lat = "\(location!.coordinate.latitude)"
//                                ob.long = "\(location!.coordinate.longitude)"
//                            }
//
//                            ob.address = addr
//                            ob.country = pm.country
//
//                            handler(ob)
//                        }
//                    }
//                }
//            } else {
//                getAddressFromLatLonApple((lat?.doubleValue)!, (long?.doubleValue)!) { (add, country) in
//                    //print("getAddressFromLatLon Add-\(add)-\(country)-")
//                    let ob = AddressObject(nil)
//                    ob.address = add
//                    ob.country = country
//
//                    handler(ob)
//                }
//            }
//        } else {
//            handler(nil)
//        }
//    }
//}
//
//func getAddressFromLatLonApple(_ lat: Double, _ lon: Double, handler: @escaping (String?, String?) -> Swift.Void) {
//    var center : CLLocationCoordinate2D = CLLocationCoordinate2D()
//
//    let ceo: CLGeocoder = CLGeocoder()
//
//    center.latitude = lat
//    center.longitude = lon
//
//    let loc: CLLocation = CLLocation(latitude:center.latitude, longitude: center.longitude)
//
//    ceo.reverseGeocodeLocation(loc, completionHandler:
//        {(placemarks, error) in
//            if (error != nil) {
//                print("reverse geodcode fail: \(error!.localizedDescription)")
//
//                handler (nil, nil)
//            }
//
//            if placemarks != nil {
//                let pm = placemarks! as [CLPlacemark]
//                if pm.count > 0 {
//                    let pm = placemarks![0]
//
//                    var addressString : String = ""
//
//                    if pm.subLocality != nil {
//                        addressString = addressString + pm.subLocality! + ", "
//                    }
//                    if pm.thoroughfare != nil {
//                        addressString = addressString + pm.thoroughfare! + ", "
//                    }
//                    if pm.locality != nil {
//                        addressString = addressString + pm.locality! + ", "
//                    }
//                    if pm.country != nil {
//                        addressString = addressString + pm.country! + ", "
//                    }
//                    if pm.postalCode != nil {
//                        addressString = addressString + pm.postalCode! + " "
//                    }
//
//                    handler (addressString, pm.country)
//                }
//
//            } else {
//                handler (nil, nil)
//            }
//    })
//}
