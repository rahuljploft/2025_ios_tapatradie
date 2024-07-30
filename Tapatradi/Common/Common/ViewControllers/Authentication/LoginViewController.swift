//
//  LoginViewController.swift
//  Common
//
//  Created by Aman Maharjan on 15/09/2021.
//

import Foundation
import UIKit
import FBSDKLoginKit
import DialCountries
import PhoneNumberKit

public protocol LoginViewControllerDelegate {
    func otpGenerated(userId: Int, phoneCode: String, mobile: String, code: Int, serviceIdTr: String?, latitudeValNewTr: String?, longitudeValNewTr: String?, leadTypeTr: String?, addressValNewTr: String?)
    
    func otpGenerated_TapATradie(userId: Int, phoneCode: String, mobile: String, code: Int, serviceIdTr: String?, latitudeValNewTr: String?, longitudeValNewTr: String?, leadTypeTr: String?, addressValNewTr: String?)
}

var loginShowStatus = false

public class LoginViewController: UIViewController, UpdateCountry {
    
    @IBOutlet weak var btn_LogSignUp: UIButton!
    
    @IBOutlet weak var activityMonitor: UIActivityIndicatorView!
    
    @IBOutlet weak var txt_MobileNumber: UITextField!
    @IBOutlet weak var lbl_TextError: UILabel!
    @IBOutlet weak var View_Mobile: UIView!
    @IBOutlet weak var lbl_CountryCode: UILabel!
    @IBOutlet weak var titleImage: UIImageView!
    @IBOutlet weak var btnFB: FBLoginButton!
    @IBOutlet weak var Img_CheckMark: UIImageView!
    
    //MARK: Properties
    var validate = false
    var country_PhoneCode = ""
    var country_flag = ""
    var country_Code = "IN"
    let phoneNumberKit = PhoneNumberKit()
    public var model: LoginScreenData!
    public var delegate: LoginViewControllerDelegate?
    
    
    public override func viewDidLoad() {
        Img_CheckMark.isHidden = true
        lbl_TextError.isHidden = true
        View_Mobile.layer.cornerRadius = 10
        View_Mobile.layer.borderColor = UIColor.darkGray.cgColor
        View_Mobile.layer.borderWidth = 0.5
        titleImage.image = model.title
        txt_MobileNumber.delegate = self
        print("Tradie and Tap A Tradie - CommonFile")
        
        CommonLocalStorageService.shared.introductionComplete = true
        CommonApiService.shared.generateAccessToken { accessToken in
            guard accessToken.success == 1 else { return }
            CommonLocalStorageService.shared.accessToken = accessToken.token
            DispatchQueue.main.async {}
        }
        
        if let token = AccessToken.current, !token.isExpired {
            print("User is logged in, do work such as go to next view controller.")
            let request = FBSDKLoginKit.GraphRequest(graphPath: "me", parameters: ["fields": "id, email, name"], tokenString: token.tokenString, version: nil, httpMethod: .get)
            request.start { (connection, result, error) in
                print("Result is", result)
            }
        }else{
            btnFB.permissions = ["public_profile", "email"]
            btnFB.delegate = self
        }
        let currentCountry = Country.getCurrentCountry()
        lbl_CountryCode.text = "\(currentCountry?.flag ?? "") \(currentCountry?.dialCode ?? "") ▾"
        self.country_PhoneCode = "\(currentCountry?.dialCode ?? "")"
        self.country_Code = "\(currentCountry?.code  ?? "")"
        print(self.country_Code)
        print("\(currentCountry?.title ?? "")")
        print("\(currentCountry?.name ?? "")")
        print("\(currentCountry?.code ?? "")")
        print("\(currentCountry?.dialCode ?? "")")
        
        
    }
    
    public override func viewWillAppear(_ animated: Bool) {
//        if loginShowStatus == false {
//            view.isHidden = true
//        }else{
//            view.isHidden = false
//        }
        
    }
    
    private func getCountryFromCurrentLocale() -> Country1? {
        guard let countryCode = LocaleService.shared.countryCode else { return nil }
        return CountryService.shared.asDictionary[countryCode]
    }
    
    @IBAction func actionBack(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ChooseIntrestNew_VC") as! ChooseIntrestNew_VC
        self.navigationController?.push(viewController: vc,animated: true)
    }
    
    
    @IBAction func Action_CountryCode(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "Test") as! Test
        vc.modalPresentationStyle = .overFullScreen
        vc.delegate = self
        self.present(vc, animated: true, completion: nil)
    }
    
    func updateCountry(code: String, phoneCode: String, name: String, flag: String) {
        self.txt_MobileNumber.text = ""
        print(phoneCode)
        country_PhoneCode = phoneCode
        country_Code = code
        lbl_CountryCode.text = "\(flag) +\(phoneCode) ▾"
    }
    
    
    
    
    
    
    func accessTokenAPI() {
        
        var ip = ""
        
        if let wifiIp = getAddress(for: .wifi) {
            ip = wifiIp
        } else if let cellular = getAddress(for: .cellular) {
            ip = cellular
        }
                
        print(Config.shared.appRole)
        var devideID = UIDevice.current.identifierForVendor?.uuidString ?? ""
        if "\(Config.shared.appRole)" == "provider" {
            devideID = "\(devideID)_provider"
        }
        
        let params = [
            "api_key": "$2a$06$hsTL2DeUKS5pUV.YlY/CSuVesppz0ha4hZdcsB7gN8VKRQRBwKct6",
            "device_id": "\(devideID)",
            "ip":"\(ip)"
        ]
   
        let Server = "https://api.tapatradie.com/"
        //let Server = "http://3.109.98.222:3349/"
        let BaseUrl = "\(Server)v6/api/"
        
        let get_services_list_withoutkey = "\(BaseUrl)ganerateCookies"
        let url = URL(string: "\(get_services_list_withoutkey)")

        print(params)
        print(url)
        
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        request.timeoutInterval = 180
        request.addValue("application/json", forHTTPHeaderField: "Accept")

        let postString = LoginViewController.getPostString(params: params)
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
                        self.callLogin()
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

    
    
    
    
    
    
    @IBAction func actionLogin(_ sender: UIButton) {
        accessTokenAPI()
    }
    
   
    func callLogin() {
        
        
        print("0---d0a0sd0000000")
        
        
        
        btn_LogSignUp.isUserInteractionEnabled = false
        if validate == true {
            activityMonitor.startAnimating()
            let phoneCode = country_PhoneCode.replacingOccurrences(of: "+", with: "")
            let mobile = txt_MobileNumber.text ?? ""
            
            CommonApiService.shared.generateOtp(String(phoneCode), mobile) { [weak self] otp in
                self?.btn_LogSignUp.isUserInteractionEnabled = true
                guard otp.success == 1 else {
                    AlertService.shared.showError(message: "Invalid mobile number")
                    return
                }
                print("otp:-", otp)
                DispatchQueue.main.async {
                    self?.activityMonitor.stopAnimating()
                    //self?.activityMonitor.isHidden = true
                    if Config.shared.appRole == "provider" {
                        self?.delegate?.otpGenerated(userId: otp.userId ?? 0, phoneCode: String(phoneCode), mobile: mobile, code: otp.otpCode ?? 0, serviceIdTr: serviceId, latitudeValNewTr: latitudeValNew, longitudeValNewTr: longitudeValNew, leadTypeTr: leadType,addressValNewTr: addressValNew)
                    }else{
                        self?.delegate?.otpGenerated_TapATradie(userId: otp.userId ?? 0, phoneCode: String(phoneCode), mobile: mobile, code: otp.otpCode ?? 0, serviceIdTr: serviceId, latitudeValNewTr: latitudeValNew, longitudeValNewTr: longitudeValNew, leadTypeTr: leadType,addressValNewTr: addressValNew)
                        
                    }
                }
            }
        }else{
            self.btn_LogSignUp.isUserInteractionEnabled = true
            let alert = UIAlertController(title: "Tap A Tradie", message: "Enter Valid Mobile Number!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
   
}

extension LoginViewController: UITextFieldDelegate {
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        //lbl_TextError.text = "Text Field Should Not Be Empty"
    }
    
    public func textFieldDidChangeSelection(_ textField: UITextField) {
        let countVal = txt_MobileNumber.text ?? ""
        let count = countVal.count
        var mobileNumberCode = ""
        var number = "+\(country_PhoneCode)\(countVal)"
        number = number.replacingOccurrences(of: "++", with: "")
        number = number.replacingOccurrences(of: "+", with: "")
        print("\(number)")
        do {
            let phoneNumber = try phoneNumberKit.parse(number)
            mobileNumberCode = phoneNumber.regionID ?? ""
            print("Done")
        }catch {
            mobileNumberCode = "Generic parser error"
            //print("Generic parser error")
        }
        
        print(country_Code)
        print(mobileNumberCode)
        
        if country_Code == mobileNumberCode {
            lbl_TextError.isHidden = true
            Img_CheckMark.isHidden = false
            Img_CheckMark.image = UIImage(named: "Validation Check")
            View_Mobile.layer.borderColor = UIColor.systemGreen.cgColor
            validate = true
        }else{
            validate = false
            if count > 0 {
                Img_CheckMark.isHidden = false
                Img_CheckMark.image = UIImage(named: "Validation Cross")
                View_Mobile.layer.borderColor = UIColor.systemRed.cgColor
                lbl_TextError.isHidden = false
                lbl_TextError.text = "Please enter valid mobile Number!"
            }else{
                Img_CheckMark.isHidden = false
                Img_CheckMark.image = UIImage(named: "Validation Cross")
                View_Mobile.layer.borderColor = UIColor.systemRed.cgColor
                lbl_TextError.isHidden = false
                lbl_TextError.text = "Mobile number can not be empty!"
            }
            
        }
    }
}


extension LoginViewController: CustomTextFieldDelegate {
    
    func customTextField(validate text: String) -> (isValid: Bool, validationResult: String) {
        return text.validate([
            (validateRequired, ValidationMessage.requiredMobileNumber),
            (validateMobileNumber, ValidationMessage.invalidMobileNumber)
        ])
    }
    
}


//MARK: - faceBook Delegate

extension LoginViewController: LoginButtonDelegate{
    
    
    public func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
     
        let token = result?.token?.tokenString
        
        let request = FBSDKLoginKit.GraphRequest(graphPath: "me", parameters: ["fields": "id, email, name"], tokenString: token, version: nil, httpMethod: .get)
        request.start { (connection, result, error) in
            print("Result is", result)
        }
    }
    
    public func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        print("Log Out")
    }
    
    
}


extension String {

    static func emojiFlag(for countryCode: String) -> String! {
        func isLowercaseASCIIScalar(_ scalar: Unicode.Scalar) -> Bool {
            return scalar.value >= 0x61 && scalar.value <= 0x7A
        }

        func regionalIndicatorSymbol(for scalar: Unicode.Scalar) -> Unicode.Scalar {
            precondition(isLowercaseASCIIScalar(scalar))

            // 0x1F1E6 marks the start of the Regional Indicator Symbol range and corresponds to 'A'
            // 0x61 marks the start of the lowercase ASCII alphabet: 'a'
            return Unicode.Scalar(scalar.value + (0x1F1E6 - 0x61))!
        }

        let lowercasedCode = countryCode.lowercased()
        guard lowercasedCode.count == 2 else { return nil }
        guard lowercasedCode.unicodeScalars.reduce(true, { accum, scalar in accum && isLowercaseASCIIScalar(scalar) }) else { return nil }

        let indicatorSymbols = lowercasedCode.unicodeScalars.map({ regionalIndicatorSymbol(for: $0) })
        return String(indicatorSymbols.map({ Character($0) }))
    }
}



