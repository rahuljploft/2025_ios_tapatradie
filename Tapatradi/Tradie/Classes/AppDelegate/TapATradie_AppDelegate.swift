//
//  TapATradie_AppDelegate.swift
//  Tradie
//
//  Created by Admin on 07/03/24.
//

import UIKit
import CoreLocation
import GooglePlaces
import IQKeyboardManager

import AVFoundation
import Firebase
import FirebaseCore
import FirebaseMessaging
import UserNotifications
import Common
import SystemConfiguration

import FBSDKCoreKit

import AppTrackingTransparency
import AdSupport

let TapATradie_story_Auth = "TapATradie_Authentication"
let TapATradie_story_Home = "TapATradie_Home"
let TapATradie_story_Tradie = "TapATradie_Tradie"
let TapATradie_story_Invite = "TapATradie_Invite"

let TapATradie_KEY_ACCESSTOEKN = "access-token"
let TapATradie_Key_Introduction = "Key_Introduction"

let TapATradie_Key_User_about_me = "Key_User_about_me"
let TapATradie_Key_User_access = "Key_User_access"
let TapATradie_Key_User_business_name = "Key_User_business_name"
let TapATradie_Key_User_city = "Key_User_city"
let TapATradie_Key_User_country = "Key_User_country"
let TapATradie_Key_User_dob = "Key_User_dob"
let TapATradie_Key_User_email = "Key_User_email"
let TapATradie_Key_User_full_name = "Key_User_full_name"
let TapATradie_Key_User_gender = "Key_User_gender"
let TapATradie_Key_User_id = "Key_User_id"
let TapATradie_Key_User_last_login = "Key_User_last_login"
let TapATradie_Key_User_latitude = "Key_User_latitude"
let TapATradie_Key_User_license_number = "Key_User_license_number"
let TapATradie_Key_User_longitude = "Key_User_longitude"
let TapATradie_Key_User_mobile = "Key_User_mobile"
let TapATradie_Key_User_online = "Key_User_online"
let TapATradie_Key_User_phone_number = "Key_User_phone_number"
let TapATradie_Key_User_professional_experience = "Key_User_professional_experience"
let TapATradie_Key_User_profile_pic = "Key_User_profile_pic"
let TapATradie_Key_User_register_complete = "Key_User_register_complete"
let TapATradie_Key_User_status = "Key_User_status"
let TapATradie_Key_User_verified = "Key_User_verified"
let TapATradie_Key_User_website_link = "Key_User_website_link"
let TapATradie_Key_User_mobile_withCode = "Key_User_mobile_withCode"
let TapATradie_kAppDelegate = UIApplication.shared.delegate as! AppDelegate

extension String {
    func TapATradie_getUserValue () -> Any? {
        let user = UserDefaults.standard
        return user.value(forKey: self)
    }
    
    func TapATradie_setUserValue (_ value: String) {
        let user = UserDefaults.standard
        user.set(value, forKey: self)
        user.synchronize()
    }
    
    func TapATradie_removeUserValue () {
        let user = UserDefaults.standard
        user.removeObject(forKey: self)
        user.synchronize()
    }
    
    func TapATradie_clearUserData () {
        TapATradie_Key_User_website_link.TapATradie_removeUserValue()
        TapATradie_Key_User_about_me.TapATradie_removeUserValue()
        TapATradie_Key_User_access.TapATradie_removeUserValue()
        TapATradie_Key_User_business_name.TapATradie_removeUserValue()
        TapATradie_Key_User_city.TapATradie_removeUserValue()
        TapATradie_Key_User_country.TapATradie_removeUserValue()
        TapATradie_Key_User_dob.TapATradie_removeUserValue()
        TapATradie_Key_User_email.TapATradie_removeUserValue()
        TapATradie_Key_User_full_name.TapATradie_removeUserValue()
        TapATradie_Key_User_gender.TapATradie_removeUserValue()
        TapATradie_Key_User_id.TapATradie_removeUserValue()
        TapATradie_Key_User_last_login.TapATradie_removeUserValue()
        TapATradie_Key_User_latitude.TapATradie_removeUserValue()
        TapATradie_Key_User_license_number.TapATradie_removeUserValue()
        TapATradie_Key_User_longitude.TapATradie_removeUserValue()
        TapATradie_Key_User_mobile.TapATradie_removeUserValue()
        TapATradie_Key_User_online.TapATradie_removeUserValue()
        TapATradie_Key_User_phone_number.TapATradie_removeUserValue()
        TapATradie_Key_User_professional_experience.TapATradie_removeUserValue()
        TapATradie_Key_User_profile_pic.TapATradie_removeUserValue()
        TapATradie_Key_User_register_complete.TapATradie_removeUserValue()
        TapATradie_Key_User_status.TapATradie_removeUserValue()
        TapATradie_Key_User_verified.TapATradie_removeUserValue()
        TapATradie_Key_User_website_link.TapATradie_removeUserValue()
    }
}

extension NSMutableDictionary {
    func TapATradie_addStaticLocation () {
        let boolStaticLocation = false
        
        if boolStaticLocation {
            self["address"] = "105A, Tilak Nagar Extension, Tilak nagar"
            self["latitude"] = "22.718860"
            self["longitude"] = "75.895921"
        }
    }
}


class TapATradie_ABC {
    var a: Int = 10
    var a_b: Int = 8
    
    func ccc () {
        let ob = TapATradie_ABC()
        
        print("---\(ob.a)-")
        print("---\(ob.a_b)-")
    }
}

extension AppDelegate {
    
    func TapATradie_setUserAddress (_ ob: TapATradie_Addresses) {
        let id = TapATradie_Key_User_id.TapATradie_getUserValue()
        print(id)
        if id != nil {
            
            print("ob.address-[\(ob.address)]-")
            print("ob.latitude-[\(ob.latitude)]-")
            print("ob.longitude-[\(ob.longitude)]-")
            print("ob.city-[\(ob.city)]-")
            print("ob.state-[\(ob.state)]-")
            print("ob.country-[\(ob.country)]-")
            
            if ob.address != nil && ob.latitude != nil && ob.longitude != nil
             && ob.city != nil && ob.state != nil  && ob.country != nil {
                if (ob.address?.count)! > 0 && (ob.latitude?.count)! > 0 && (ob.longitude?.count)! > 0 && (ob.country?.count)! > 0 {
                    
                    let user = UserDefaults.standard
                    user.set((ob.address)!, forKey: "user_selected_address_\(id!)")
                    user.set((ob.latitude)!, forKey: "user_selected_address_lat_\(id!)")
                    user.set((ob.longitude)!, forKey: "user_selected_address_long_\(id!)")
                    
                    user.set((ob.city)!, forKey: "user_selected_address_city_\(id!)")
                    user.set((ob.state)!, forKey: "user_selected_address_state_\(id!)")
                    user.set((ob.country)!, forKey: "user_selected_address_country_\(id!)")
                    
                    user.synchronize()
                }
            }
        }
    }
    
    func TapATradie_getUserAddress () -> TapATradie_Addresses? {
        let id = TapATradie_Key_User_id.TapATradie_getUserValue()
        
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
                longitude != nil &&
                city != nil &&
                state != nil &&
                country != nil {
                
                if address!.count > 0 && latitude!.count > 0 && longitude!.count > 0 {
                    let ob = TapATradie_Addresses("")
                    
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
    
    func TapATradie_customeFonts () {
        for family: String in UIFont.familyNames
        {
            print(family)
            for names: String in UIFont.fontNames(forFamilyName: family) {
                print("== \(names)")
            }
        }
    }
    
    func TapATradie_tgtgt () {
        let jjjj = "1234567"
        
        let ff = Int(jjjj)! % 10
        let arrr = jjjj.components(separatedBy: "")
        
        print("arrr-\(arrr)-\(ff)-")
    }
    
    func TapATradie_countryCodes () -> NSArray? {
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
    
    
    func TapATradie_tokenString(_ deviceToken:Data) -> String{
        let bytes = [UInt8](deviceToken)
        var token = ""
        for byte in bytes{
            token += String(format: "%02x",byte)
        }
        //MARK: APNS - this token will be passed to your backend that can be written in php, js, .net etc.
        return token
    }
    
    private func TapATradie_registerForPushNotifications(_ application: UIApplication) {
        UNUserNotificationCenter.current().delegate = self
        Messaging.messaging().delegate = self
        Messaging.messaging().isAutoInitEnabled = true
        
        if #available(iOS 12, *) {
            UNUserNotificationCenter.current().requestAuthorization(options:[.badge, .alert, .sound]){ (granted, error) in }
            //UNUserNotificationCenter.current().requestAuthorization(options://[.badge, .alert, .sound, .provisional, .providesAppNotificationSettings, .criticalAlert]){ (granted, error) in }
            application.registerForRemoteNotifications()
        } else if #available(iOS 10.0, *) {
            // for iOS 10 and above
            
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound], completionHandler: {_, _ in })
        } else {
            let settings: UIUserNotificationSettings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()
        
        Messaging.messaging().delegate = self
        let token = Messaging.messaging().fcmToken
        print("FCM token   ttttttttttttttttttttt===================: \(token ?? "")")
        //MARK: uncomment for Notification Update by Himanshu Jangid
        //firebase_token = token ?? ""
    }
    
   
    
    func TapATradie_registerBackgroundTask(_ application: UIApplication) {
        TapATradie_backgroundTask = UIApplication.shared.beginBackgroundTask { [weak self] in
            //self?.registerBackgroundTask(application)
        }
        
        assert(TapATradie_backgroundTask != .invalid)
        
        print("In Background Timer. 3")
        
        DispatchQueue.global().async {
            self.TapATradie_boolAppInBackground = true
            
            while self.TapATradie_boolAppInBackground {
                DispatchQueue.global().async {
                    TapATradie_kAppDelegate.TapATradie_locationManager?.startUpdatingLocation()
                    TapATradie_kAppDelegate.TapATradie_locationManager?.allowsBackgroundLocationUpdates = false
                    TapATradie_kAppDelegate.TapATradie_locationManager?.startMonitoringVisits()
                    
                    if TapATradie_kAppDelegate.TapATradie_locationManager != nil {
                        let lat = TapATradie_kAppDelegate.TapATradie_locationManager?.location?.coordinate.latitude
                        let lng = TapATradie_kAppDelegate.TapATradie_locationManager?.location?.coordinate.longitude
                        
                        if lat != nil && lng != nil {
                        if lat != 0.0 && lng != 0.0 {
                            print("lat-\(lat)-\(lng)-")
                            
                            /*self.titleString = "\(Date())"
                             self.subtitleString = "\(Date())"
                             self.bodyMessage = "\(Date())"
                             
                             self.callLocalNotification()*/
                        }
                        }
                    }
                }
                
                sleep(15)
            }
        }
    }
    
    func TapATradie_generateAccessToken () {
        let user = UserDefaults.standard
        print(TapATradie_params())
        //if user.object(forKey: KEY_ACCESSTOEKN) == nil {
            Http.instance().json(TapATradie_api_generate_access_token, TapATradie_params(), "POST", aai: false, popup: false, prnt: true, nil, nil, sync: false, defaultCalling: true) { (json, paras, str, data) in
                if let json = json as? NSDictionary {
                    if json.number("success").intValue == 1 {
                        let token = json.string("token")
                        
                        if token.count > 0 {
                            user.set(token, forKey: TapATradie_KEY_ACCESSTOEKN)
                            user.synchronize()
                        }
                    }
                }
            }
        //}
    }
    
    func TapATradie_tabItems() -> NSMutableArray {
        return TapATradie_maTabItems
    }
    
    func TapATradie_initTabbar () {
        TapATradie_maTabItems.removeAllObjects()
        
        TapATradie_maTabItems.add(NSMutableDictionary(dictionary: ["isselected": true,
                                                        "title": "Home",
                                                        "selected": #imageLiteral(resourceName: "Home Selected") as Any,
                                                        "unselected": #imageLiteral(resourceName: "Home Selected") as Any]))
        TapATradie_maTabItems.add(NSMutableDictionary(dictionary: ["isselected": false,
                                                        "title": "Bookings",
                                                        "selected": #imageLiteral(resourceName: "Bookings Selected") as Any,
                                                        "unselected": #imageLiteral(resourceName: "Bookings") as Any]))
        TapATradie_maTabItems.add(NSMutableDictionary(dictionary: ["isselected": false,
                                                        "title": "Help",
                                                        "selected": #imageLiteral(resourceName: "Help Selected") as Any,
                                                        "unselected": #imageLiteral(resourceName: "Help") as Any]))
        TapATradie_maTabItems.add(NSMutableDictionary(dictionary: ["isselected": false,
                                                        "title": "Profile",
                                                        "selected": #imageLiteral(resourceName: "Profile Selected") as Any,
                                                        "unselected": #imageLiteral(resourceName: "Profile") as Any]))
    }
    
   
    
    func TapATradie_setSelectedTabbar2 (_ row: Int) {
        for i in 0..<TapATradie_kAppDelegate.TapATradie_tabItems().count {
            let md = TapATradie_kAppDelegate.TapATradie_tabItems()[i] as! NSMutableDictionary
            if i == row {
                md["isselected"] = true
            } else {
                md["isselected"] = false
            }
            
            TapATradie_kAppDelegate.TapATradie_tabItems().replaceObject(at: i, with: md)
        }
    }
    
    func TapATradie_tabbarClicked (_ indexPath: IndexPath, _ nav: UINavigationController?) {
        for i in 0..<TapATradie_kAppDelegate.TapATradie_tabItems().count {
            let md = TapATradie_kAppDelegate.TapATradie_tabItems()[i] as! NSMutableDictionary
            if i == indexPath.row {
                md["isselected"] = true
            } else {
                md["isselected"] = false
            }
            
            TapATradie_kAppDelegate.TapATradie_tabItems().replaceObject(at: i, with: md)
        }
        
        var boolAlready = true
        
        let arr = nav?.viewControllers
        
        for vc in arr! {
            if (vc is TapATradie_Home && indexPath.row == 0) ||
                (vc is TapATradie_MyBookings && indexPath.row == 1) ||
                (vc is TapATradie_Help && indexPath.row == 2) ||
                (vc is TapATradie_MyProfile && indexPath.row == 3) {
                
                nav?.popToViewController(vc, animated: false)
                boolAlready = false
                break
            }
        }
        
        if boolAlready {
            switch indexPath.row {
            case 0:
                let vc = TapATradie_story_Home.TapATradie_viewController("Home")
                nav?.pushViewController(vc!, animated: false)
                break
            case 1:
                let vc = TapATradie_story_Tradie.TapATradie_viewController("MyBookings")
                
                print("KKKK-[\(vc)]-")
                
                nav?.pushViewController(vc!, animated: false)
                break
            case 2:
                let vc = TapATradie_story_Home.TapATradie_viewController("Help")
                nav?.pushViewController(vc!, animated: false)
                break
            case 3:
                let vc = TapATradie_story_Tradie.TapATradie_viewController("MyProfile")
                nav?.pushViewController(vc!, animated: false)
                break
            default:
                break
            }
        }
    }
    
    func TapATradie_logout (_ vc: UIViewController) {
        let param = TapATradie_params()
        Http.instance().json(TapATradie_api_logout, param, "POST", aai: true, popup: true, prnt: true, nil, nil, sync: false, defaultCalling: false) { (json, paras, str, data) in
            let json = json as? NSDictionary
            
            if json != nil {
                if json?.number("success").intValue == 1 {
                    //UIApplication.shared.applicationIconBadgeNumber = 0
                    TapATradie_kAppDelegate.TapATradie_subscribeToFirebase (false)
                    let arr = vc.navigationController?.viewControllers
                    "".TapATradie_clearUserData()
                    let user = UserDefaults.standard
                    user.removeObject(forKey: TapATradie_KEY_ACCESSTOEKN)
                    user.synchronize()
                    self.TapATradie_generateAccessToken ()
                    for vv in arr! {
                        if vv is TapATradie_Login {
                            vc.navigationController?.popToViewController(vv, animated: true)
                            return
                        }
                    }
//                    let loginViewController = Route.login(model: LoginScreenData(title: UIImage(named: "Slogan")!)).controller as! LoginViewController
//                    loginViewController.delegate = TapATradie_NavigationManager.shared
//                    vc.navigationController?.pushViewController(loginViewController, animated: true)
                    
                    let story = UIStoryboard(name: "Authentication", bundle: nil)
                    let vc = story.instantiateViewController(withIdentifier: "ChooseOptionScreen_VC") as! ChooseOptionScreen_VC
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                
                Http.alert("", json?.string("message"))
            }
        }
    }
    
    
    
    func TapATradie_staticLocation () -> (lat: Double?, lng: Double?) {
        if TapATradie_locationManager == nil {
            TapATradie_locationPermission ()
        } else if TapATradie_locationManager != nil {
            TapATradie_locationManager?.startUpdatingLocation()
            
            if TapATradie_locationManager?.location != nil {
                if TapATradie_locationManager?.location?.coordinate != nil {
                    if TapATradie_locationManager?.location?.coordinate.latitude != nil && TapATradie_locationManager?.location?.coordinate.longitude != nil {
                        if TapATradie_locationManager?.location?.coordinate.latitude != 0.0 && TapATradie_locationManager?.location?.coordinate.longitude != 0.0 {
                            return ((TapATradie_locationManager?.location?.coordinate.latitude)!, (TapATradie_locationManager?.location?.coordinate.longitude)!)
                        }
                    }
                }
            }
        }
        
        //return (-31.957945, 115.864694)
        return (nil, nil)
    }
    
    func TapATradie_locationPermission () {
        if TapATradie_kAppDelegate.TapATradie_locationManager == nil {
            TapATradie_kAppDelegate.TapATradie_locationManager = CLLocationManager()
            
            TapATradie_kAppDelegate.TapATradie_locationManager?.delegate = self
            
            //kAppDelegate.locationManager?.requestAlwaysAuthorization()
            // For use in foreground
            TapATradie_kAppDelegate.TapATradie_locationManager?.requestWhenInUseAuthorization()

            if CLLocationManager.locationServicesEnabled() {
            }
            
            TapATradie_kAppDelegate.TapATradie_locationManager?.desiredAccuracy = kCLLocationAccuracyBest
            TapATradie_kAppDelegate.TapATradie_locationManager?.startUpdatingLocation()
        }
    }
    
    func TapATradie_sessionExpired (_ vc: UIViewController) {
        
        TapATradie_kAppDelegate.TapATradie_subscribeToFirebase (false)
        
        let arr = vc.navigationController?.viewControllers
        
        "".TapATradie_clearUserData()
        
        let user = UserDefaults.standard
        user.removeObject(forKey: TapATradie_KEY_ACCESSTOEKN)
        user.synchronize()
        
        self.TapATradie_generateAccessToken ()
        
        for vv in arr! {
            if vv is TapATradie_Login {
                vc.navigationController?.popToViewController(vv, animated: true)
                
                return
            }
        }
        
//        let loginViewController = Route.login(model: LoginScreenData(title: UIImage(named: "Slogan")!)).controller as! LoginViewController
//        loginViewController.delegate = TapATradie_NavigationManager.shared
//        vc.navigationController?.pushViewController(loginViewController, animated: true)
        
        let story = UIStoryboard(name: "Authentication", bundle: nil)
        let vc = story.instantiateViewController(withIdentifier: "ChooseOptionScreen_VC") as! ChooseOptionScreen_VC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func TapATradie_requestPermission() {
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

}

func TapATradie_params () -> NSMutableDictionary {
    let md = NSMutableDictionary()
    
    md["device_id"] = UIDevice.current.identifierForVendor!.uuidString
    md["device_type"] = "2"
    md["api_key"] = "$2a$06$hsTL2DeUKS5pUV.YlY/CSuVesppz0ha4hZdcsB7gN8VKRQRBwKct6"
    md["role"] = "user"
    
    let user = UserDefaults.standard
    
    if let token = user.object(forKey: TapATradie_KEY_ACCESSTOEKN) as? String {
        md["access_token"] = token
    }
    
    let userId = TapATradie_Key_User_id.TapATradie_getUserValue()
    
    if userId != nil {
        md["uid"] = userId!
    }
    
    let ob = TapATradie_kAppDelegate.TapATradie_getUserAddress()
    
    if ob?.latitude != nil && ob?.longitude != nil {
        md["latitude"] = (ob?.latitude!)!
        md["longitude"] = (ob?.longitude!)!
        
        md["city"] = (ob?.city!)!
        md["country"] = (ob?.country!)!
        md["state"] = (ob?.state!)!
    }
    
    if let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
        md["version"] = appVersion
    }
    
    return md
}

extension String {
    func TapATradie_viewController (_ vc: String) -> UIViewController? {
        let storyboard = UIStoryboard(name: self, bundle: nil)
        print("HCG VC-[\(vc)]-")
        let vc = storyboard.instantiateViewController(withIdentifier: vc)
        
        return vc
    }
}

extension AppDelegate {
    func TapATradie_readAllBadge () {

    }
    
    func TapATradie_badgeCount (_ count: Int) {
        
    }
    
   
    
    func TapATradie_readNotification (_ userInfo: NSDictionary) {
       
    }
    

    
    func TapATradie_playSound() {
        print("PlaySound")
        
        
        guard let url = Bundle.main.url(forResource: "soundring", withExtension: "mp3") else { return }

        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)

            /* The following line is required for the player to work on iOS 11. Change the file type accordingly*/
            TapATradie_player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)

            /* iOS 10 and earlier require the following line:
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileTypeMPEGLayer3) */

            guard let player = TapATradie_player else { return }

            player.play()

        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func TapATradie_Text_to_Voice(msg: String){
        TapATradie_playSound()
    }
    
    func TapATradie_subscribeToFirebase (_ bool: Bool) {
        if TapATradie_Key_User_id.TapATradie_getUserValue() != nil {
            let uid = TapATradie_Key_User_id.TapATradie_getUserValue()
            
            let topic = "tradieuser_\(uid!)"
            
            print("Harish topic-\(topic)")
            
            if bool {
                Messaging.messaging().subscribe(toTopic: topic)
            } else {
                Messaging.messaging().unsubscribe(fromTopic: topic)
            }
        }
    }
    
    func TapATradie_openScreenOnNotification (_ info: NSDictionary) {
        //print("info-\(info.string("action"))-\(info.string("slug"))-\(info)-")
        
        let action = info.string("action").lowercased()
        
        if TapATradie_currentVC != nil {
            let nav = TapATradie_currentVC?.navigationController
            
            if nav != nil {
                let vc = TapATradie_story_Tradie.TapATradie_viewController("MyBookings") as? TapATradie_MyBookings
                
                if action == "reject" || action == "completed" {
                    vc?.boolCurrent = false
                } else {
                    vc?.boolCurrent = true
                }
                
                nav?.pushViewController(vc!, animated: true)
            } else {
                let vc = TapATradie_story_Tradie.TapATradie_viewController("MyBookings") as? TapATradie_MyBookings
                
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
            let vc = TapATradie_story_Tradie.TapATradie_viewController("MyBookings") as? TapATradie_MyBookings
            
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

enum TapATradie_Downloading {
    case downloading
    case canDownload
    case noData
}

extension AppDelegate {
    
    func TapATradie_getAppVersionFromServer () {
        
    }
}

class NetworkUtils{
    
    static func TapATradie_isNetworkReachable() -> Bool {
        var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        var flags: SCNetworkReachabilityFlags = SCNetworkReachabilityFlags(rawValue: 0)
        if SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) == false {
            return false
        }

        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        let ret = (isReachable && !needsConnection)
        return ret
    }
}
