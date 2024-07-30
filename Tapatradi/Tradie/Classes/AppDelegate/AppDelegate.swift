//
//  AppDelegate.swift
//  Tradie
//
//  Created by Apple on 18/04/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import CoreLocation
import GooglePlaces
import IQKeyboardManager

import Firebase
import FirebaseCore
import FirebaseMessaging
import UserNotifications
import Common
import AVFoundation
import FBSDKCoreKit

import AppTrackingTransparency
import AdSupport


var tokenSecret = ""
var ipSecret = ""

let Key_step1 = "Key_step1"
let Key_step2 = "Key_step2"
let Key_step3 = "Key_step3"
let Key_step4 = "Key_step4"
let Key_step5 = "Key_step5"
let user_submit_approval_btn = "user_submit_approval_btn"

let story_Auth = "Authentication"
let story_Home = "Home"
let story_Tradie = "Tradie"
let story_Profile = "Profile"
let story_Payment = "Payment"

let KEY_ACCESSTOEKN = "access-token"
let Key_Introduction = "Key_Introduction"


let Key_User_phone_number_withCode = "Key_User_phone_number_withCode"
let Key_User_rating = "Key_User_rating"
let Key_User_about_me = "Key_User_about_me"
let Key_User_access = "Key_User_access"
let Key_User_business_name = "Key_User_business_name"
let Key_User_city = "Key_User_city"
let Key_User_country = "Key_User_country"
let Key_User_city1 = "Key_User_city1"
let Key_User_country1 = "Key_User_country1"
let Key_User_dob = "Key_User_dob"
let Key_User_email = "Key_User_email"
let Key_User_full_name = "Key_User_full_name"
let Key_User_gender = "Key_User_gender"
let Key_User_id = "Key_User_id"
let Key_User_last_login = "Key_User_last_login"
let Key_User_latitude = "Key_User_latitude"
let Key_User_license_number = "Key_User_license_number"
let Key_User_longitude = "Key_User_longitude"
let Key_User_mobile = "Key_User_mobile"
let Key_User_online = "Key_User_online"
let Key_User_phone_number = "Key_User_phone_number"
let Key_User_professional_experience = "Key_User_professional_experience"
let Key_User_profile_pic = "Key_User_profile_pic"
let Key_User_register_complete = "Key_User_register_complete"
let Key_User_status = "Key_User_status"
let Key_User_verified = "Key_User_verified"
let Key_User_website_link = "Key_User_website_link"

let IAP_URL = "https://sandbox.itunes.apple.com/verifyReceipt"
//let IAP_URL = "https://buy.itunes.apple.com/verifyReceipt"
let IAP_Password = "0ce1f883a9904f6c8b987ed3c2e55a00"

let kAppDelegate = UIApplication.shared.delegate as! AppDelegate


extension String {
    func getUserValue () -> Any? {
        let user = UserDefaults.standard
        return user.value(forKey: self)
    }
    
    func setUserValue (_ value: Any) {
        //print("value-\(value)-")
        if value != nil {
            let user = UserDefaults.standard
            user.set("\(value)", forKey: self)
            user.synchronize()
        }
    }
    
    func removeUserValue () {
        let user = UserDefaults.standard
        user.removeObject(forKey: self)
        user.synchronize()
    }
    
    func clearUserData () {
        Key_User_website_link.removeUserValue()
        Key_User_about_me.removeUserValue()
        Key_User_rating.removeUserValue()
        Key_User_access.removeUserValue()
        Key_User_business_name.removeUserValue()
        Key_User_city.removeUserValue()
        Key_User_country.removeUserValue()
        Key_User_dob.removeUserValue()
        Key_User_email.removeUserValue()
        Key_User_full_name.removeUserValue()
        Key_User_gender.removeUserValue()
        Key_User_id.removeUserValue()
        Key_User_last_login.removeUserValue()
        Key_User_latitude.removeUserValue()
        Key_User_license_number.removeUserValue()
        Key_User_longitude.removeUserValue()
        Key_User_mobile.removeUserValue()
        Key_User_online.removeUserValue()
        Key_User_phone_number.removeUserValue()
        Key_User_professional_experience.removeUserValue()
        Key_User_profile_pic.removeUserValue()
        Key_User_register_complete.removeUserValue()
        Key_User_status.removeUserValue()
        Key_User_verified.removeUserValue()
        Key_User_website_link.removeUserValue()
    }
}

func getPrimaryServiceKey () -> String {
    return "\(key_primaryservices)_\(Key_User_id.getUserValue()!)"
}

func getIdentificationVerificationKey () -> String {
    return "\(key_identityverification)_\(Key_User_id.getUserValue()!)"
}

extension UIApplication {
    class var statusBarBackgroundColor: UIColor? {
        get {
            return (shared.value(forKey: "statusBar") as? UIView)?.backgroundColor
        } set {
            (shared.value(forKey: "statusBar") as? UIView)?.backgroundColor = newValue
        }
    }
}

let EXPIRYDATEFORMATE = "dd/MM/yyyy HH:mm"

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var TapATradie_backgroundTask: UIBackgroundTaskIdentifier = .invalid
    var TapATradie_boolAppInBackground = false
    
    var TapATradie_player: AVAudioPlayer?
    var TapATradie_currentVC: UIViewController?
    var TapATradie_navigationController : UINavigationController?
    var TapATradie_obAddresses: TapATradie_Addresses?
    var TapATradie_locationManager:CLLocationManager?
    
    var boolSubscriptionExpired = true
    var boolPurchasedFromIAP = true
    var TapATradie_maTabItems = NSMutableArray()
    var purchaseTrailDays = 7
    var purchasePrice: Float = 4.99
    
    var currentVC: UIViewController?
    
    var boolCallOnline = false
    
    var boolShowChangeProviderStatus = false
    
    var window: UIWindow?
    var navigationController : UINavigationController?
    
    func setUserAddressBusiness (_ ob: Addresses) {
        let id = Key_User_id.getUserValue()
        
        if id != nil {
            if ob.address != nil && ob.latitude != nil && ob.longitude != nil {
                if (ob.address?.count ?? 0) > 0 && (ob.latitude?.count ?? 0) > 0 && (ob.longitude?.count ?? 0) > 0 {
                    let user = UserDefaults.standard
                    user.set((ob.address)!, forKey: "Business_user_selected_address_\(id!)")
                    user.set((ob.latitude)!, forKey: "Business_user_selected_address_lat_\(id!)")
                    user.set((ob.longitude)!, forKey: "Business_user_selected_address_long_\(id!)")
                    
                    if let city = ob.city {
                        user.set(city, forKey: "Business_user_selected_address_city_\(id!)")
                    }
                    
                    if let state = ob.state {
                        user.set(state, forKey: "Business_user_selected_address_state_\(id!)")
                    }
                    
                    if let country = ob.country {
                        user.set(country, forKey: "Business_user_selected_address_country_\(id!)")
                    }
                    
                    user.synchronize()
                }
            }
        }
    }
    
    func getUserAddressBusiness () -> Addresses? {
        let id = Key_User_id.getUserValue()
        
        if id != nil {
            let user = UserDefaults.standard
            
            let address = user.object(forKey: "Business_user_selected_address_\(id!)") as? String
            let latitude = user.object(forKey: "Business_user_selected_address_lat_\(id!)") as? String
            let longitude = user.object(forKey: "Business_user_selected_address_long_\(id!)") as? String
            
            let city = user.object(forKey: "Business_user_selected_address_city_\(id!)") as? String
            let state = user.object(forKey: "Business_user_selected_address_state_\(id!)") as? String
            let country = user.object(forKey: "Business_user_selected_address_country_\(id!)") as? String
            
            if address != nil &&
                latitude != nil &&
                longitude != nil {
                
                if address!.count > 0 && latitude!.count > 0 && longitude!.count > 0 {
                    let ob = Addresses("")
                    
                    ob.locationName = "Home"
                    ob.address = address
                    ob.latitude = latitude
                    ob.longitude = longitude
                    
                    ob.city = city
                    ob.state = state
                    ob.country = country
                    
                    return ob
                }
            }
        }
        
        return nil
    }
    
    func setUserAddress (_ ob: Addresses) {
        let id = Key_User_id.getUserValue()
        
        if id != nil {
            if ob.address != nil && ob.latitude != nil && ob.longitude != nil {
                let user = UserDefaults.standard
                user.set((ob.address)!, forKey: "user_selected_address_\(id!)")
                user.set((ob.latitude)!, forKey: "user_selected_address_lat_\(id!)")
                user.set((ob.longitude)!, forKey: "user_selected_address_long_\(id!)")
                
                if let city = ob.city {
                    user.set(city, forKey: "user_selected_address_city_\(id!)")
                }
                
                if let state = ob.state {
                    user.set(state, forKey: "user_selected_address_state_\(id!)")
                }
                
                if let country = ob.country {
                    user.set(country, forKey: "user_selected_address_country_\(id!)")
                }
                
                user.synchronize()
                
                self.sendAddressToServer()
            }
        }
    }
    
    func getUserAddress () -> Addresses? {
        let id = Key_User_id.getUserValue()
        
        if id != nil {
            let user = UserDefaults.standard
            
            let address = user.object(forKey: "user_selected_address_\(id!)") as? String
            let latitude = user.object(forKey: "user_selected_address_lat_\(id!)") as? String
            let longitude = user.object(forKey: "user_selected_address_long_\(id!)") as? String
            
            let city = user.object(forKey: "user_selected_address_city_\(id!)") as? String
            let state = user.object(forKey: "user_selected_address_state_\(id!)") as? String
            let country = user.object(forKey: "user_selected_address_country_\(id!)") as? String
            
            if address != nil &&
                latitude != nil &&
                longitude != nil {
                
                if address!.count > 0 && latitude!.count > 0 && longitude!.count > 0 {
                    let ob = Addresses("")
                    
                    ob.locationName = "Home"
                    ob.address = address
                    ob.latitude = latitude
                    ob.longitude = longitude
                    
                    ob.city = city
                    ob.state = state
                    ob.country = country
                    
                    return ob
                }
            }
        }
        
        return nil
    }
    
    func customeFonts () {
        for family: String in UIFont.familyNames
        {
            print(family)
            for names: String in UIFont.fontNames(forFamilyName: family) {
                print("== \(names)")
            }
        }
    }
    
    func tgtgt () {
        let jjjj = "1234567"
        
        let ff = Int(jjjj)! % 10
        let arrr = jjjj.components(separatedBy: "")
        
        print("arrr-\(arrr)-\(ff)-")
    }
    
    func getAddress () {
        //let ob = getAddressOrLatLong(nil, nil, "indore india", false)
        
        //print("Ob-\(ob?.lat)-\(ob?.long)-")
    }
    
    func countryCodes () -> NSArray? {
        do {
            let path = Bundle.main.path(forResource: "country.json", ofType: "")
            let string = try String(contentsOfFile: path!, encoding: .utf8)
            
            //print("string-\(string[6060])-")
            //print("string-\(string[6061])-")
            //print("string-\(string[6062])-")
            //print("string-\(string.convertToJson())-")
            
            return string.json() as? NSArray
        } catch {
            print("text3-)-")
        }
        
        return nil
    }
    
    @objc func sendLocationToServerTimer () {
        print("sendLocationToServerTimer")
    }
    
    func callPurchaseDateAPI () {
        DispatchQueue.global().async {
            self.callPurchaseDateAPIThread ()
        }
    }
    
    var boolAllowTestingPopup = false
    var idTestingUser: String? = nil
    
    func allowTestingPopup () -> Bool {
        //print("allowTestingPopup boolAllowTestingPopup-[\(boolAllowTestingPopup)]-[\(idTestingUser)]-")
        
        if boolAllowTestingPopup && idTestingUser != nil {
            if idTestingUser!.count > 0 {
                if let userId = Key_User_id.getUserValue() as? String {
                    if let arr = idTestingUser?.components(separatedBy: ",") {
                        
                        print("1allowTestingPopup arr-[\(arr)]-")
                        
                        for i in 0..<arr.count {
                            let id = arr[i]
                            
                            print("--------[\(id)]-[\(userId)]-")
                            
                            if arr[i] == userId {
                                return true
                            }
                        }
                    }
                }
            }
        }
        
        return false
    }
    
    func callPurchaseDateAPIThread() {
        let url = URL(string: api_get_free_date)!
        
        print("url-\(url)-")
        
        do {
            let data = try Data(contentsOf: url)
            if let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? NSDictionary {
                let allowtestingpopup = json.string("allowtestingpopup")
                if allowtestingpopup == "1" {
                    self.boolAllowTestingPopup = true
                } else {
                    self.boolAllowTestingPopup = false
                }
                self.idTestingUser = json.string("testinguserid")
                print("11allowTestingPopup boolAllowTestingPopup-[\(self.boolAllowTestingPopup)]-[\(self.idTestingUser)]-")
                let date = json.string("date")
                print("json-\(json)-")
                if date.count == 10 {
                    self.savePurchaseDate(date)
                    self.boolWaitForAPIResponce = false
                }
            }
        } catch {
            print("API calling failed.")
        }
    }
    
    var boolWaitForAPIResponce = true
    var subscriptionExpire: SubscriptionExpire?
    
    func requestPermission() {
        if #available(iOS 14, *) {
            ATTrackingManager.requestTrackingAuthorization { status in
                switch status {
                case .authorized:
                    // Tracking authorization dialog was shown
                    // and we are authorized
                    print("Authorized")
                    Settings.setAdvertiserTrackingEnabled(true)
                    
                    // Now that we are authorized we can get the IDFA
                    print(ASIdentifierManager.shared().advertisingIdentifier)
                case .denied:
                    // Tracking authorization dialog was
                    // shown and permission is denied
                    print("Denied")
                case .notDetermined:
                    // Tracking authorization dialog has not been shown
                    print("Not Determined")
                case .restricted:
                    print("Restricted")
                @unknown default:
                    print("Unknown")
                }
            }
        }
    }
    
    let gcmMessageIDKey = "gcm.Message_Getepay_M"
    var player: AVAudioPlayer?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        ApplicationDelegate.shared.application(
            application,
            didFinishLaunchingWithOptions: launchOptions
        )
        
        NetworkReachabilityService.shared.startNetworkMonitoring()
        
        accessTokenAPI()
        setupIAP()
        saveDefaultPurchaseDate ()
        callPurchaseDateAPI ()
        while boolWaitForAPIResponce {
            print("boolWaitForAPIResponce-\(boolWaitForAPIResponce)-")
            sleep(1)
        }
        getAddress ()
        //UIApplication.statusBarBackgroundColor = .blue
        IQKeyboardManager.shared().isEnabled = true
        initTabbar ()
        locationPermission ()
        GMSPlacesClient.provideAPIKey("AIzaSyAKBtULxvzVH8VHh5kdWxYrmVlzQ6RgUC8")
        let vc: UIViewController? = navToViewController ()
        window = UIWindow(frame: UIScreen.main.bounds)
        self.navigationController = UINavigationController(rootViewController: vc!)
        self.navigationController?.isNavigationBarHidden = true
        self.window?.rootViewController = self.navigationController
        self.window?.makeKeyAndVisible()
        notification (application, launchOptions)
        SocketIOManager.shared.create()
        UIApplication.shared.statusBarStyle = .lightContent
        getAppVersionFromServer ()
        Config.shared.registerFonts()
        NavigationManager.shared.navigationController = self.navigationController
        
        
        //MARK: Himanshu Update
        //FirebaseApp.configure()
        //CodeUpdate 16/06/2021---------------
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        application.registerForRemoteNotifications()
        Messaging.messaging().delegate = self
        let token = Messaging.messaging().fcmToken
        print("FCM token   ttttttttttttttttttttt===================: \(token ?? "")")
        //MARK: uncomment for Notification Update by Himanshu Jangid
        //firebase_token = token ?? ""
        self.SetupPushNotification(application: application)
        return true
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

    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    //MARK: APNS Work Start Here --
    
    //MARK: APNS - Setup appdelegate for push notifications
    func SetupPushNotification(application: UIApplication) -> () {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.sound,.badge])
        {(granted,error) in
            if granted{
                DispatchQueue.main.async {
                    application.registerForRemoteNotifications()
                }
            } else {
                print("User Notification permission denied: \(error?.localizedDescription ?? "error")")
            }
        }
    }
    
    //MARK: APNS - Will register app on apns to receieve token
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        print("Successful registration. Token is:")
        
        firebase_token = "\(tokenString(deviceToken))"
        print(tokenString(deviceToken)) // this method will convert token "Data" to string formate
    }
    
    //MARK: APNS - Failed registration. Explain why.
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register for remote notifications: \(error.localizedDescription)")
    }
    
    
    //MARK: APNS - In this method app will receive notifications in [userInfo]
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        print(userInfo)
        
    }
    
    
    //MARK: APNS - code to make a token string
    func tokenString(_ deviceToken:Data) -> String{
        let bytes = [UInt8](deviceToken)
        var token = ""
        for byte in bytes{
            token += String(format: "%02x",byte)
        }
        return token
    }
    
    
    //MARK: APNS Wor End Here --
    func setupIAP() {
        //Http.startActivityIndicator()
        SwiftyStoreKit.completeTransactions(atomically: true) { purchases in
            print("Harish G1-\(purchases)-")
            for purchase in purchases {
                switch purchase.transaction.transactionState {
                case .purchased, .restored:
                    let downloads = purchase.transaction.downloads
                    if !downloads.isEmpty {
                        //print("91HCG-\(purchase.transaction.transactionState.debugDescription): \(purchase.productId)")
                        SwiftyStoreKit.start(downloads)
                    } else if purchase.needsFinishTransaction {
                        //print("92HCG-\(purchase.transaction.transactionState.debugDescription): \(purchase.productId)")
                        // Deliver content from server, then:
                        SwiftyStoreKit.finishTransaction(purchase.transaction)
                    } else {
                        //print("93HCG-\(purchase.transaction.transactionState.debugDescription): \(purchase.productId)")
                    }
                case .failed, .purchasing, .deferred:
                break // do nothing
                @unknown default:
                    break // do nothing
                }
            }
            
            if self.subscriptionExpire != nil {
                //self.subscriptionExpire?.pushVC (boolPurchased)
            }
        }
        
        SwiftyStoreKit.updatedDownloadsHandler = { downloads in
            print("Harish G2-\(downloads)-")
            
            // contentURL is not nil if downloadState == .finished
            let contentURLs = downloads.compactMap { $0.contentURL }
            if contentURLs.count == downloads.count {
                print("Saving: \(contentURLs)")
                SwiftyStoreKit.finishTransaction(downloads[0].transaction)
            }
        }
    }
    
    func navToViewController () -> UIViewController? {
        
        
        let userRoll = "\(UserDefaults.standard.string(forKey: "userRoll") ?? "")"
        print("User Roll Value: \(userRoll)")
        
        if userRoll == "provider" {
            Config.shared.appRole = "provider"
            var vc: BaseVC?
            let user = UserDefaults.standard
            if user.object(forKey: Key_Introduction) == nil {
                vc = story_Auth.viewController("Introduction") as? BaseVC
            } else {
                if Key_User_id.getUserValue() == nil {
                    return story_Auth.viewController("ChooseOptionScreen_VC") as? ChooseOptionScreen_VC
                } else {
                    let user = UserDefaults.standard
                    let value = user.object(forKey: getPrimaryServiceKey ())
                    let step1 = user.object(forKey: Key_step1) as? String
                    let step2 = user.object(forKey: Key_step2) as? String
                    let step3 = user.object(forKey: Key_step3) as? String
                    let step4 = user.object(forKey: Key_step4) as? String
                    let profilePic = Key_User_profile_pic.getUserValue() as! String

                    if step1 != nil && step2 != nil && step3 != nil && step4 != nil {
                        let s1 = Int(step1!)
                        let s2 = Int(step2!)
                        let s3 = Int(step3!)
                        let s4 = Int(step4!)
                        if s1 == 0 || s2 == 0 || s3 == 0 || s4 == 0 || profilePic.count == 0 {
                            vc = story_Profile.viewController("Profile") as! Profile
                            vc?.step1_VC = step1
                            vc?.step2_VC = step2
                            vc?.step3_VC = step3
                            vc?.step4_VC = step4
                            vc?.boolFromRegistration = false
                            vc?.boolFromLaunch = true
                        }else{
                            vc = story_Tradie.viewController("MyBookings") as! MyBookings
                            vc?.step1_VC = step1
                            vc?.step2_VC = step2
                            vc?.step3_VC = step3
                            vc?.step4_VC = step4
                            vc?.boolFromRegistration = false
                            vc?.boolFromLaunch = true
                        }
                    }else{
                        vc = story_Tradie.viewController("MyBookings") as! MyBookings
                        vc?.step1_VC = step1
                        vc?.step2_VC = step2
                        vc?.step3_VC = step3
                        vc?.step4_VC = step4
                        vc?.boolFromRegistration = false
                        vc?.boolFromLaunch = true
                    }
                }
            }
            return vc
        }else{
            Config.shared.appRole = "user"
            var vc: UIViewController!
            let user = UserDefaults.standard
            if user.object(forKey: TapATradie_Key_Introduction) == nil {
                vc = TapATradie_story_Auth.TapATradie_viewController("Introduction")
            } else {
                if TapATradie_Key_User_id.TapATradie_getUserValue() == nil {
                    return story_Auth.viewController("ChooseOptionScreen_VC") as? ChooseOptionScreen_VC
                } else {
                    let add = TapATradie_getUserAddress()
                    if add == nil {
                        if (TapATradie_Key_User_full_name.TapATradie_getUserValue() as! String).count == 0 {
                            vc = TapATradie_story_Auth.TapATradie_viewController("EnterYourDetail")
                        }else{
                            vc = TapATradie_story_Auth.TapATradie_viewController("SeeTradiesArround")
                        }
                    } else {
                        if (TapATradie_Key_User_full_name.TapATradie_getUserValue() as! String).count == 0 {
                            vc = TapATradie_story_Auth.TapATradie_viewController("EnterYourDetail")
                        } else {
                            vc = TapATradie_story_Home.TapATradie_viewController("Home")
                        }
                    }
                }
            }
            return vc
        }
    }
    
    func isPurchased () -> Bool {
        let user = UserDefaults.standard
        
        if let val = user.object(forKey: "isPurchased_ipa") as? String {
            if val == "1" {
                return true
            }
        }
        
        return false
    }
    
    func setPurchased () {
        let user = UserDefaults.standard
        user.setValue("1", forKey: "isPurchased_ipa")
        user.synchronize()
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        self.boolAppInBackground = true
        
        registerBackgroundTask(application)
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    var sliderPushed = false
    var sliderPushed1 = false
    
    var backgroundTask: UIBackgroundTaskIdentifier = .invalid
    var boolAppInBackground = false
    
    func registerBackgroundTask(_ application: UIApplication) {
        DispatchQueue.global().async {
            sleep(15)
            
            DispatchQueue.main.async {
                self.registerBackgroundTaskThread(application)
            }
        }
    }
    
    func registerBackgroundTaskThread(_ application: UIApplication) {
        if self.boolAppInBackground {
            backgroundTask = UIApplication.shared.beginBackgroundTask { [weak self] in
                self?.registerBackgroundTask(application)
            }
            assert(backgroundTask != .invalid)
        }
        print("In Background Timer. 3")
        DispatchQueue.global().async {
            self.boolAppInBackground = true
            while self.boolAppInBackground {
                DispatchQueue.global().async {
                    kAppDelegate.locationManager?.startUpdatingLocation()
                    kAppDelegate.locationManager?.allowsBackgroundLocationUpdates = false
                    kAppDelegate.locationManager?.startMonitoringVisits()
                    if kAppDelegate.locationManager != nil {
                        let lat = kAppDelegate.locationManager?.location?.coordinate.latitude
                        let lng = kAppDelegate.locationManager?.location?.coordinate.longitude
                        
                        if lat != nil && lng != nil {
                            if lat != 0.0 && lng != 0.0 {
                                print("lat in back testing-\(lat)-\(lng)-")
                            }
                        }
                    }
                }
                sleep(15)
            }
        }
    }
    
    func endBackgroundTask() {
        print("In Background Timer. 5")
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        boolAppInBackground = false
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func generateAccessToken () {
        let user = UserDefaults.standard
        print("user.object(forKey: KEY_ACCESSTOEKN)-\(user.object(forKey: KEY_ACCESSTOEKN))-")
        if user.object(forKey: KEY_ACCESSTOEKN) == nil {
            print(params())
            Http.instance().json(api_generate_access_token, params(), "POST", aai: false, popup: false, prnt: true, nil, nil, sync: false, defaultCalling: true) { (json, paras, str, data) in
                if let json = json as? NSDictionary {
                    if json.number("success").intValue == 1 {
                        let token = json.string("token")
                        if token.count > 0 {
                            user.set(token, forKey: KEY_ACCESSTOEKN)
                            user.synchronize()
                        }
                    }
                }
            }
        }
    }
    
    
    func generateAccessToken_new() {
        let user = UserDefaults.standard
        print("user.object(forKey: KEY_ACCESSTOEKN)-\(user.object(forKey: KEY_ACCESSTOEKN))-")
        Http.instance().json(api_generate_access_token, params(), "POST", aai: false, popup: false, prnt: true, nil, nil, sync: false, defaultCalling: true) { (json, paras, str, data) in
            if let json = json as? NSDictionary {
                if json.number("success").intValue == 1 {
                    print(json.string("token"))
                    let token = json.string("token")
                    user.set(token, forKey: KEY_ACCESSTOEKN)
                }
            }
        }
    }
    
    
    
    func tabItems() -> NSMutableArray {
        return maTabItems
    }
    
    
    func initTabbar () {
        maTabItems.removeAllObjects()
        
        maTabItems.add(NSMutableDictionary(dictionary: ["isselected": false,
                                                        "title": "Profile",
                                                        "selected" : #imageLiteral(resourceName: "Group 3904-1") as Any,
                                                        "unselected" : #imageLiteral(resourceName: "Group 3904") as Any]))
        maTabItems.add(NSMutableDictionary(dictionary: ["isselected": true,
                                                        "title": "New Leads",
                                                        "selected" : #imageLiteral(resourceName: "home") as Any,
                                                        "unselected" : #imageLiteral(resourceName: "home-1") as Any]))
        maTabItems.add(NSMutableDictionary(dictionary: ["isselected": false,
                                                        "title": "",
                                                        "selected" : #imageLiteral(resourceName: "Rectangle 1564") as Any,
                                                        "unselected" : #imageLiteral(resourceName: "Rectangle 1564") as Any]))
        maTabItems.add(NSMutableDictionary(dictionary: ["isselected": false,
                                                        "title": "History",
                                                        "selected" : #imageLiteral(resourceName: "appointment (1)-1") as Any,
                                                        "unselected" : #imageLiteral(resourceName: "appointment (1)") as Any]))
        maTabItems.add(NSMutableDictionary(dictionary: ["isselected": false,
                                                        "title": "Premium",
                                                        "selected" : #imageLiteral(resourceName: "Group 107701") as Any,
                                                        "unselected" : #imageLiteral(resourceName: "Group 10770") as Any]))
        /*maTabItems.add(NSMutableDictionary(dictionary: ["isselected": false,
                                                        "title": "Help",
                                                        "selected" : #imageLiteral(resourceName: "Group 4100") as Any,
                                                        "unselected" : #imageLiteral(resourceName: "help") as Any]))*/
    }
    
    var maTabItems = NSMutableArray()
    
    func setSelectedTabbar (_ row: Int) {
        for i in 0..<kAppDelegate.tabItems().count {
            let md = kAppDelegate.tabItems()[i] as! NSMutableDictionary
            if i == row {
                md["isselected"] = true
            } else {
                md["isselected"] = false
            }
            
            kAppDelegate.tabItems().replaceObject(at: i, with: md)
        }
    }
    
    func tabbarClicked (_ indexPath: IndexPath, _ nav: UINavigationController?) {
        setSelectedTabbar (indexPath.row)
        
        var boolAlready = true
        
        let arr = nav?.viewControllers
        
        for i in 0..<arr!.count {
            let vc = arr![i]
            
            if (vc is MyBookings && indexPath.row == 1) ||
                (vc is MyBookings && indexPath.row == 3) ||
                (vc is ChooseSubscripiton && indexPath.row == 4) ||
                (vc is Profile && indexPath.row == 0) {
                
                if (vc is MyBookings && indexPath.row == 1) && (arr!.count - 1) == i {
                    let vcc = vc as? MyBookings
                    vcc?.boolCurrent = true
                    vcc?.viewWillAppear(true)
                    return
                } else if (vc is MyBookings && indexPath.row == 3) && (arr!.count - 1) == i {
                    let vcc = vc as? MyBookings
                    vcc?.boolCurrent = false
                    vcc?.viewWillAppear(true)
                    return
                }
                
                if indexPath.row == 1 {
                    let vcc = vc as? MyBookings
                    vcc?.boolCurrent = true
                    
                    if vcc != nil {
                        nav?.popToViewController(vcc!, animated: false)
                    }
                    
                    return
                } else if indexPath.row == 3 {
                    let vcc = vc as? MyBookings
                    vcc?.boolCurrent = false
                    
                    if vcc != nil {
                        nav?.popToViewController(vcc!, animated: false)
                    }
                    
                    return
                }
                
                nav?.popToViewController(vc, animated: false)
                
                boolAlready = false
                break
            }
        }
        
        if boolAlready {
            switch indexPath.row {
            case 1:
                let vc = story_Tradie.viewController("MyBookings") as? MyBookings
                vc?.boolCurrent = true
                nav?.pushViewController(vc!, animated: false)
                break
            case 3:
                let vc = story_Tradie.viewController("MyBookings") as? MyBookings
                vc?.boolCurrent = false
                nav?.pushViewController(vc!, animated: false)
                break
            case 2:
                /*let vc = story_Tradie.viewController("MyBookings") as? MyBookings
                vc?.boolCurrent = false
                nav?.pushViewController(vc!, animated: false)*/
                break
            case 4:
                let vc = story_Payment.viewController("ChooseSubscripiton")
                nav?.pushViewController(vc!, animated: false)
                break
            case 0:
                let vc = story_Profile.viewController("Profile")
                nav?.pushViewController(vc!, animated: false)
                break
            default:
                break
            }
        }
    }
    
    func logout (_ vc: UIViewController) {
        let param = params()
        Http.instance().json(api_logout, param, "POST", aai: true, popup: true, prnt: true, nil, nil, sync: false, defaultCalling: false) { (json, paras, str, data) in
            let json = json as? NSDictionary
            
            if json != nil {
                if json?.number("success").intValue == 1 {
                    kAppDelegate.subscribeToFirebase(false)
                    let arr = vc.navigationController?.viewControllers
                    "".clearUserData()
                    
                    let user = UserDefaults.standard
                    user.removeObject(forKey: KEY_ACCESSTOEKN)
                    user.synchronize()
                    
                    self.generateAccessToken ()
                    
                    for vv in arr! {
                        if vv is Login {
                            vc.navigationController?.popToViewController(vv, animated: true)
                            
                            return
                        }
                    }
                    
//                    let loginViewController = Route.login(model: LoginScreenData(title: UIImage(named: "Login Title")!)).controller as! LoginViewController
//                    loginViewController.delegate = NavigationManager.shared
//                    vc.navigationController?.pushViewController(loginViewController, animated: true)
                    
                    let story = UIStoryboard(name: "Authentication", bundle: nil)
                    let vc = story.instantiateViewController(withIdentifier: "ChooseOptionScreen_VC") as! ChooseOptionScreen_VC
                    self.navigationController?.pushViewController(vc, animated: true)

                }
                
                Http.alert("", json?.string("message"))
            }
        }
    }
    
    var locationManager:CLLocationManager?
    
    func staticLocation () -> (lat: Double?, lng: Double?) {
        if locationManager == nil {
            locationPermission ()
        } else if locationManager != nil {
            locationManager?.startUpdatingLocation()
            
            if locationManager?.location != nil {
                if locationManager?.location?.coordinate != nil {
                    if locationManager?.location?.coordinate.latitude != nil && locationManager?.location?.coordinate.longitude != nil {
                        if locationManager?.location?.coordinate.latitude != 0.0 && locationManager?.location?.coordinate.longitude != 0.0 {
                            return ((locationManager?.location?.coordinate.latitude)!, (locationManager?.location?.coordinate.longitude)!)
                        }
                    }
                }
            }
        }
        
        //return (-31.957945, 115.864694)
        return (nil, nil)
    }
    
    func locationPermission () {
        if kAppDelegate.locationManager == nil {
            kAppDelegate.locationManager = CLLocationManager()
            kAppDelegate.locationManager?.delegate = self
            kAppDelegate.locationManager?.requestAlwaysAuthorization()
            // For use in foreground
            //kAppDelegate.locationManager?.requestWhenInUseAuthorization()
            kAppDelegate.locationManager?.allowsBackgroundLocationUpdates = true
            //kAppDelegate.locationManager?.startMonitoringVisits()
            //kAppDelegate.locationManager?.startMonitoringSignificantLocationChanges()
            if CLLocationManager.locationServicesEnabled() {
                
            }
            
            kAppDelegate.locationManager?.desiredAccuracy = kCLLocationAccuracyBest
            kAppDelegate.locationManager?.startUpdatingLocation()
        }
    }
    
    func setLocationCurrentAddress () {
        let ob = kAppDelegate.staticLocation()
        
        if ob.lat != nil && ob.lng != nil {
            if ob.lat != 0.0 && ob.lng != 0.0 {
                kAppDelegate.boolShowChangeProviderStatus = true
                let ob2 = getAddressOrLatLong(ob.lat! as NSNumber, ob.lng! as NSNumber, nil, false)
                let ob1 = Addresses("")
                ob1.locationName = "Home"
                ob1.address = ob2!.address
                ob1.latitude = "\(ob.lat!)"
                ob1.longitude = "\(ob.lng!)"
                if let city = ob2?.city {
                    ob1.city = city
                }
                if let state = ob2?.state {
                    ob1.state = state
                }
                if let country = ob2?.country {
                    ob1.country = country
                }
                kAppDelegate.setUserAddress(ob1)
            }
        }
    }
    
    func sessionExpired (_ vc: UIViewController) {
        kAppDelegate.subscribeToFirebase(false)
        let arr = vc.navigationController?.viewControllers
        "".clearUserData()
        let user = UserDefaults.standard
        user.removeObject(forKey: KEY_ACCESSTOEKN)
        user.synchronize()
        self.generateAccessToken ()
        for vv in arr! {
            if vv is Login {
                vc.navigationController?.popToViewController(vv, animated: true)
                return
            }
        }
        
//        let loginViewController = Route.login(model: LoginScreenData(title: UIImage(named: "Login Title")!)).controller as! LoginViewController
//        loginViewController.delegate = NavigationManager.shared
//        vc.navigationController?.pushViewController(loginViewController, animated: true)
        
        let story = UIStoryboard(name: "Authentication", bundle: nil)
        let vc = story.instantiateViewController(withIdentifier: "ChooseOptionScreen_VC") as! ChooseOptionScreen_VC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func getTradieStatus () -> String {
        var online = Key_User_online.getUserValue()
        
        if online == nil {
            online = "0"
            Key_User_online.setUserValue("0")
        }
        
        if "\(online!)" == "1" {
            return "1"
        } else {
            return "0"
        }
    }
    
    func sendAddressToServer () {
        var online = Key_User_online.getUserValue()
        if online == nil {
            online = "0"
            Key_User_online.setUserValue("0")
        }
        let param = params()
        param["online"] = "\(online!)"
        Http.instance().json(api_provider_online_status, param, "POST", aai: false, popup: false, prnt: true, nil, nil, sync: false, defaultCalling: false) { (json, para, str, http, data) in
            
        }
        param["location_name"] = "home"
        param["address"] = param.string("online_address")
        
        print(param)
        
        Http.instance().json(api_provider_add_address, param, "POST", aai: false, popup: false, prnt: true, nil, nil, sync: false, defaultCalling: false) { (json, para, str, http, data) in
        }
    }
    
    var purchaseDate = "2019-10-01"
    
    func saveDefaultPurchaseDate () {
        let user = UserDefaults.standard
        
        let date = user.object(forKey: purchaseDate) as? String
        
        if date == nil {
            user.set (purchaseDate, forKey: purchaseDate)
        }
        
        user.synchronize()
    }
    
    func savePurchaseDate (_ date: String) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dttt = dateFormatter.date(from: date)
        
        if dttt != nil {
            let user = UserDefaults.standard
            user.set (date, forKey: purchaseDate)
            user.synchronize()
        }
    }
    
    func getPurchaseDate () -> String {
        let user = UserDefaults.standard
        
        let date = user.object(forKey: purchaseDate) as? String
        
        if date != nil {
            return date!
        }
        
        return purchaseDate
    }
    
    func boolIAPPurchased () -> (purchased: Bool, date: Date?) {
        //return (false, nil)
        
        let user = UserDefaults.standard
        
        if let time = user.object(forKey: "IAPPurchasedTimeMS") as? Double {
            let date = Date.init(timeIntervalSince1970: time/1000)
            
            print("IAPPurchasedTimeMS [\(time)] [\(date)]")
            
            let date1 = Date()
            
            print("date-\(date)-")
            
            let int = date1.timeIntervalSince(date)
            
            if int > 0 {
                print("purchase now")
                
                return (false, date)
            } else {
                print("purchased")
                
                return (true, date)
            }
        }
        
        return (false, nil)
    }
    
    func setPurchasedDate (_ time: Double) {
        let user = UserDefaults.standard
        user.set(time, forKey: "IAPPurchasedTimeMS")
        user.synchronize()
    }
    
    //original_transaction_id
    
    func setOriginalTransactionId (_ oti: String) {
        if oti.count > 0 {
            let user = UserDefaults.standard
            user.setValue(oti, forKey: "iap_original_transaction_id")
            user.synchronize()
        }
    }
    
    func getOriginalTransactionId () -> String? {
        let user = UserDefaults.standard
        
        return user.object(forKey: "iap_original_transaction_id") as? String
    }
    
    //MARK: - Facebook
    
//    func applicationDidBecomeActive(_ application: UIApplication) {
//        boolAppInBackground = false
//
//        requestPermission()
//
//        //AppEvents.activateApp()
//    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return ApplicationDelegate.shared.application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
    }
    
    @available(iOS 9.0, *)
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {
        return ApplicationDelegate.shared.application(
            app,
            open: url,
            sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
            annotation: options[UIApplication.OpenURLOptionsKey.annotation]
        )
    }
    
    var serverCustomerId = ""
    func isLoginUserDeviceUser () -> Bool {
        if serverCustomerId.count > 0 {
            if let oti = kAppDelegate.getOriginalTransactionId() {
                if serverCustomerId == oti {
                    return true
                }
            }
        }
        
        return false
    }
    
    var serverExpiryDate: Date?
    func isServerDateNotExpired () -> Bool {
        if serverExpiryDate != nil {
            let cDate = Date()
            
            let int = cDate.timeIntervalSince(serverExpiryDate!)
            
            if int > 0 {
                return false
            } else {
                return true
            }
        }
        
        return false
    }
}

func isFreeTrialExpired () -> Bool {
    //let dat1Oct2019 = "2019-10-01".getDate("yyyy-MM-dd")
    //let dat1Oct2019 = "2019-08-06".getDate("yyyy-MM-dd")
    
    let dat1Oct2019 = kAppDelegate.getPurchaseDate ().getDate("yyyy-MM-dd")
    
    print("dat1Oct2019-\(dat1Oct2019)-")
    
    let date = Date()
    //let date = "2019-10-01".getDate("yyyy-MM-dd")
    
    let diff = date.all(from: dat1Oct2019)
    
    if diff.year! >= 0 && diff.month! >= 0 && diff.day! >= 0 && diff.hour! >= 0 && diff.minute! >= 0 && diff.second! >= 0 {
        return true
    }
    
    return false
}

extension AppDelegate: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse:
            locationPermission()
            break
        case .denied:
            break
        case .notDetermined:
            break
        case .restricted:
            break
        case .authorizedAlways:
            locationPermission()
            break
        default:
            break
        }
    }
}

func params () -> NSMutableDictionary {
    let md = NSMutableDictionary()
    
    md["device_id"] = "\(UIDevice.current.identifierForVendor!.uuidString)_provider"
    md["device_type"] = "2"
    md["api_key"] = "$2a$06$hsTL2DeUKS5pUV.YlY/CSuVesppz0ha4hZdcsB7gN8VKRQRBwKct6"
    md["role"] = "provider"
    
    let user = UserDefaults.standard
    
    if let token = user.object(forKey: KEY_ACCESSTOEKN) as? String {
        md["access_token"] = token
    }
    
    let userId = Key_User_id.getUserValue()
    
    if userId != nil {
        md["uid"] = userId!
    }
    
    let ob = kAppDelegate.getUserAddress()
    
    if ob?.latitude != nil && ob?.longitude != nil {
        md["latitude"] = (ob?.latitude)!
        md["longitude"] = (ob?.longitude)!
        md["online_address"] = (ob?.address)!
        
        if let city = ob?.city {
            md["city"] = city
        }
        
        if let state = ob?.state {
            md["state"] = state
        }
        
        if let country = ob?.country {
            md["country"] = country
        }
    }
    
    if let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
        md["version"] = appVersion
    }
    
    return md
}

extension String {
    func viewController (_ vc: String) -> UIViewController? {
        
        let storyboard = UIStoryboard(name: self, bundle: nil)
                
        let vc = storyboard.instantiateViewController(withIdentifier: vc)
        
        return vc
    }
}

struct ProfileJSON: Codable {
    let success, step1, step2, step3: String
    let step4, step5: String
    let data: DataClass
}

struct DataClass: Codable {
    let id: String
    let fullName, email, mobile, gender: String
    let dob, otp, country, city: String
    let professionalExperience, phoneNumber, websiteLink, aboutMe: String
    let businessName, licenseNumber, password, profilePic: String
    let latitude, longitude, status, createdOn: String
    let createdBy: String
    let updatedOn: String
    let updatedBy: String
    let access, lastLogin: String
    let registerComplete, online, verified, submitForApproval: String
    let rating: String?
    let user_submit_approval_btn: String
    let google, facebook, googleRating, googleBusinessName: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case fullName = "full_name"
        case email, mobile, gender, dob, otp, country, city
        case professionalExperience = "professional_experience"
        case phoneNumber = "phone_number"
        case websiteLink = "website_link"
        case aboutMe = "about_me"
        case businessName = "business_name"
        case licenseNumber = "license_number"
        case password
        case profilePic = "profile_pic"
        case latitude, longitude, status
        case createdOn = "created_on"
        case createdBy = "created_by"
        case updatedOn = "updated_on"
        case updatedBy = "updated_by"
        case access
        case user_submit_approval_btn
        case lastLogin = "last_login"
        case registerComplete = "register_complete"
        case submitForApproval = "submit_for_approval"
        case online, verified, rating, google, facebook, googleRating
        case googleBusinessName = "google_business_name"
    }
}

func get12HourTime (_ convert_time: String) -> String {
    
    if convert_time.count == 5 {
        let arr = convert_time.components(separatedBy: ":")
        
        if arr.count == 2 {
            var hour = Int(arr[0])!
            
            var ampm = "a.m."
            
            if hour > 12 {
                hour -= 12
                ampm = "p.m."
            }
            
            return "\(hour):\(arr[1]) \(ampm)"
        }
        
        return convert_time
    } else {
        return convert_time.replacingOccurrences(of: "AM", with: "a.m.").replacingOccurrences(of: "PM", with: "p.m.")
    }
}

func getStatusColor (_ text: String) -> UIColor {
    if text.lowercased() == "new lead" {
        return UIColor.black
    } else if text.lowercased() == "confirmed" {
        return UIColor.hexColor(0x3BAA34)
    } else if text.lowercased() == "accepted" {
        return UIColor.hexColor(0x57A4FF)
    } else if text.lowercased() == "completed" {
        return UIColor.hexColor(0xDB5B1B)
    } else if text.lowercased() == "pending" {
        return  UIColor.hexColor(0xFFBC42)
    } else if text.lowercased() == "declined" {
        return UIColor.black
    } else if text.lowercased() == "rejected" {
        return UIColor.black
    } else if text.lowercased() == "disputed" {
        return UIColor.hexColor(0xEF4136)
    }
    
    return UIColor.black
}

func submitForApprovalClicked (_ key: String) -> Bool {
    let obb = StoreToDevice("submitForApproval", key)
    let data = obb.getStoredData()
    
    if data != nil {
        if (data?.count)! > 0 {
            return true
        }
    }
    
    return false
}

func submitForApprovalSave (_ key: String) {
    let obb = StoreToDevice("submitForApproval", key)
    obb.setDeviceStoredData("1")
}



func getMapPin (_ serviceName: String) -> UIImage {
    if serviceName.lowercased().subString("electrician".lowercased()) {
        return #imageLiteral(resourceName: "electrician")
    } else if serviceName.lowercased().subString("plumber".lowercased()) {
        return #imageLiteral(resourceName: "plumber")
    } else if serviceName.lowercased().subString("carpenter".lowercased()) {
        return #imageLiteral(resourceName: "lawn moving")
    } else if serviceName.lowercased().subString("tiler".lowercased()) {
        return #imageLiteral(resourceName: "tiler")
    } else if serviceName.lowercased().subString("painter".lowercased()) {
        return #imageLiteral(resourceName: "painter")
    } else if serviceName.lowercased().subString("plasterer".lowercased()) {
        return #imageLiteral(resourceName: "plasterer")
    } else if serviceName.lowercased().subString("landscaper".lowercased()) {
        return #imageLiteral(resourceName: "landscraper")
    } else if serviceName.lowercased().subString("labourer".lowercased()) {
        return #imageLiteral(resourceName: "labourer")
    } else if serviceName.lowercased().subString("bricklayer".lowercased()) {
        return #imageLiteral(resourceName: "bricklayer")
    } else if serviceName.lowercased().subString("lawn".lowercased()) {
        return #imageLiteral(resourceName: "lawn moving")
    }
    
    return UIImage(named: "mappin")!
}

enum Downloading {
    case downloading
    case canDownload
    case noData
}

// MARK: New version checking

extension AppDelegate: AlertDelegate {
    func alertZero() {
        exit(0)
    }
    
    func alertOne() {
        if let url = "itms://itunes.apple.com/us/app/tradie/id1473400813".url {
            UIApplication.shared.open(url, options: [:]) { (bool) in
                exit(0)
            }
        }
    }
    
    func getAppVersionFromServer () {
        if let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            if let double = Double(appVersion.replacingOccurrences(of: ".", with: "")) {
                let av = Int(double * 1000.0)

                if av > 0 {
                    let param = params()
                    Http.instance().json(api_get_versions, param, "POST", aai: true, popup: true, prnt: true, nil, nil, sync: false, defaultCalling: false) { (json, paras, str, data) in
                        let jsonExp = json as? NSDictionary

                        if let paymentSetting = jsonExp?["paymentSetting"] as? Int {
                            print("paymentSetting",paymentSetting)
                            if paymentSetting == 1 {
                                paymentSettingStatus = true
                            }else{
                                paymentSettingStatus = false
                            }
                        }
                        print("paymentSettingStatus : ",paymentSettingStatus)
                        if jsonExp != nil {
                            if jsonExp?.number("success").intValue == 1 {
                                if let dt = jsonExp?["data"] as? NSDictionary {
                                    if let double1 = Double(dt.string("Tradie_version_ios").replacingOccurrences(of: ".", with: "")) {
                                        let av1 = Int(double1 * 1000.0)
                                        print("Double av-[\(double)]-[\(av)]-")
                                        print("Double av1-[\(double1)]-[\(av1)]-")
                                        if av1 > av {
                                            print("Update App")
                                            Http.alert("A new version \(dt.string("Tradie_version_ios")) of Tradie is available.", "Install it now from App Store.", [self, "CANCEL", "INSTALL"])
                                        } else {
                                            print("Don't Update App")
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

extension String {
    var url: URL? {
        if let str = addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
            return URL(string: str)
        }
        return nil
    }
}


//MARK: Himanshu Update - 05/04/2021
extension AppDelegate: UNUserNotificationCenterDelegate, MessagingDelegate {
    

    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        print("------Check Check",userInfo)
        //Text_to_Voice(msg: "\(userInfo)")
        completionHandler([[.alert, .sound, .badge]])
    }
    
    

    func playSound() {
        print("PlaySound")
        
        
        guard let url = Bundle.main.url(forResource: "soundring", withExtension: "mp3") else { return }

        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)

            /* The following line is required for the player to work on iOS 11. Change the file type accordingly*/
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)

            /* iOS 10 and earlier require the following line:
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileTypeMPEGLayer3) */

            guard let player = player else { return }

            player.play()

        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func Text_to_Voice(msg: String){
        playSound()
    }
    
    
//    func readAllBadge () {
//        let param = params()
//        Http.instance().json(api_read_badge_notification, param, "POST", aai: false, popup: false, prnt: true, nil, nil, sync: false, defaultCalling: false) { (json, paras, str, data) in
//            
//            let json = json as? NSDictionary
//            
//            if json != nil {
//                if json?.number("success").intValue == 1 {
//                    //UIApplication.shared.applicationIconBadgeNumber = 0
//                }
//            }
//        }
//    }
    
    func badgeCount (_ count: Int) {
        //UIApplication.shared.applicationIconBadgeNumber = count
        let param = params()
        Http.instance().json(api_get_unread_notification_count, param, "POST", aai: false, popup: false, prnt: false, nil, nil, sync: false, defaultCalling: false) { (json, paras, str, data) in
            let json = json as? NSDictionary
            if json != nil {
                if json?.number("success").intValue == 1 {
                    let badge_count = json?.number("badge_count").intValue
                    if badge_count != nil {
                        //UIApplication.shared.applicationIconBadgeNumber = badge_count!
                    }
                }
            }
        }
    }
    
    func notification (_ application: UIApplication, _ launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        //FirebaseApp.configure()
        //registerForPushNotifications (application)
        subscribeToFirebase (true)
        if let option = launchOptions {
            let info = option[UIApplication.LaunchOptionsKey.remoteNotification]
            let dt = info as? NSDictionary
            if dt != nil {
                openScreenOnNotification(dt!)
            }
        }
    }
    
//    private func registerForPushNotifications(_ application: UIApplication) {
//        UNUserNotificationCenter.current().delegate = self
//        Messaging.messaging().delegate = self
//        Messaging.messaging().isAutoInitEnabled = true
//
//        if #available(iOS 12, *) {
//            UNUserNotificationCenter.current().requestAuthorization(options:[.badge, .alert, .sound]){ (granted, error) in }
//            application.registerForRemoteNotifications()
//        } else if #available(iOS 10.0, *) {
//            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound], completionHandler: {_, _ in })
//        } else {
//            let settings: UIUserNotificationSettings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
//            application.registerUserNotificationSettings(settings)
//        }
//        application.registerForRemoteNotifications()
//    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, openSettingsFor notification: UNNotification?) {
        let userInfo = notification?.request.content.userInfo as? NSDictionary
        print("Harish 3 userNotificationCenter-\(userInfo)-")
    }
    
    // App in background and user clicked notification
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        print("1Harish openScreenOnNotification-\(userInfo)-")
        
        openScreenOnNotification(userInfo as NSDictionary)
        
        readNotification (userInfo as NSDictionary)
            
        completionHandler()
    }
    
    func readNotification (_ userInfo: NSDictionary) {
            
        let id = userInfo.string("notificationId")
 
        if id.count > 0 {
                
            let param = params()
            
            param["notification_id"] = id
            
            Http.instance().json(api_read_notification, param, "POST", aai: true, popup: true, prnt: true, nil, nil, sync: false, defaultCalling: false) { (json, paras, str, data) in
                    
                let jsonExp = json as? NSDictionary
                if jsonExp != nil {
                    if jsonExp?.string("success") == "1" {
                        
                    }
                }
            }
        }
    }
    

    
//    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
//        let token = deviceToken.map({ String(format: "%02.2hhx", $0)}).joined()
//        print("Harish token-\(token)-")
//        firebase_token = token
//
//       // UserDefaults.standard.set(token, forKey: <#T##String#>)
//        Messaging.messaging().apnsToken = deviceToken
//    }
    
//    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
//        print("Harish 4 userInfo-\(userInfo)-")
//        //Http.alert("", "Notification 5")
//    }
//
//    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
//                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
//        print("Harish 5 userInfo-\(userInfo)-")
//        //Http.alert("", "Notification 6")
//        completionHandler(.newData)
//    }
    
    
//    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
//                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
//        if let messageID = userInfo[gcmMessageIDKey] {
//            print("Message ID: \(messageID)")
//        }
//        print(userInfo)
//        completionHandler(UIBackgroundFetchResult.newData)
//    }
    
    
    func application(_ application: UIApplication, didReceiveRemoteNotification
       userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        print("APN recieved")
        // print(userInfo)
        
        let state = application.applicationState
        switch state {
            
        case .inactive:
            print("Inactive")
            application.applicationIconBadgeNumber = application.applicationIconBadgeNumber + 1
            
        case .background:
            print("Background")
            // update badge count here
            application.applicationIconBadgeNumber = application.applicationIconBadgeNumber + 1
            
        case .active:
            print("Active")

        }
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // reset badge count
        boolAppInBackground = false
        //MARK: Badge Icon
        application.applicationIconBadgeNumber = 0
        //requestPermission()
        
    }
    
    
    func subscribeToFirebase (_ bool: Bool) {
        if Key_User_id.getUserValue() != nil {
            let uid = Key_User_id.getUserValue()
            let topic = "tradie_\(uid!)"
            
            print("Harish topic-\(topic)")
            
            if bool {
                Messaging.messaging().subscribe(toTopic: topic)
            } else {
                Messaging.messaging().unsubscribe(fromTopic: topic)
            }
        }
    }
    
    func openScreenOnNotification (_ info: NSDictionary) {
        //print("info-\(info.string("action"))-\(info.string("slug"))-\(info)-")
            
        let action = info.string("action").lowercased()
        
        if currentVC != nil {
            let nav = currentVC?.navigationController
            
            if nav != nil {
                let vc = story_Tradie.viewController("MyBookings") as? MyBookings
                
                if action == "reject" || action == "completed" {
                    vc?.boolCurrent = false
                } else {
                    vc?.boolCurrent = true
                }
                
                nav?.pushViewController(vc!, animated: true)
            } else {
                let vc = story_Tradie.viewController("MyBookings") as? MyBookings
                
                if action == "reject" || action == "completed" {
                    vc?.boolCurrent = false
                } else {
                    vc?.boolCurrent = true
                }
                
                let navigationController = UINavigationController.init(rootViewController: vc!)
                navigationController.isNavigationBarHidden = true
                self.window?.rootViewController = navigationController
                self.window?.makeKeyAndVisible()
            }
        } else {
            let vc = story_Tradie.viewController("MyBookings") as? MyBookings
            
            if action == "reject" || action == "completed" {
                vc?.boolCurrent = false
            } else {
                vc?.boolCurrent = true
            }
            let navigationController = UINavigationController.init(rootViewController: vc!)
            navigationController.isNavigationBarHidden = true
            self.window?.rootViewController = navigationController
            self.window?.makeKeyAndVisible()
        }
    }
    
    
}
