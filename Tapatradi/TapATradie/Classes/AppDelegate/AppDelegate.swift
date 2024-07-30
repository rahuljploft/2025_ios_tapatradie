//
//  AppDelegate.swift
//  TapATradie
//
//  Created by Apple on 18/04/19.
//  Copyright © 2019 Apple. All rights reserved.
//

//tapatradie.com

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

let story_Auth = "Authentication"
let story_Home = "Home"
let story_Tradie = "Tradie"
let story_Invite = "Invite"

let KEY_ACCESSTOEKN = "access-token"
let Key_Introduction = "Key_Introduction"

let Key_User_about_me = "Key_User_about_me"
let Key_User_access = "Key_User_access"
let Key_User_business_name = "Key_User_business_name"
let Key_User_city = "Key_User_city"
let Key_User_country = "Key_User_country"
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
let Key_User_mobile_withCode = "Key_User_mobile_withCode"
let kAppDelegate = UIApplication.shared.delegate as! AppDelegate

/*
Tradie:
8899090909
user:
9876789098
*/

extension String {
    func getUserValue () -> Any? {
        let user = UserDefaults.standard
        return user.value(forKey: self)
    }
    
    func setUserValue (_ value: String) {
        let user = UserDefaults.standard
        user.set(value, forKey: self)
        user.synchronize()
    }
    
    func removeUserValue () {
        let user = UserDefaults.standard
        user.removeObject(forKey: self)
        user.synchronize()
    }
    
    func clearUserData () {
        Key_User_website_link.removeUserValue()
        Key_User_about_me.removeUserValue()
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

extension NSMutableDictionary {
    func addStaticLocation () {
        let boolStaticLocation = false
        
        if boolStaticLocation {
            self["address"] = "105A, Tilak Nagar Extension, Tilak nagar"
            self["latitude"] = "22.718860"
            self["longitude"] = "75.895921"
        }
    }
}


class ABC {
    var a: Int = 10
    var a_b: Int = 8
    
    func ccc () {
        let ob = ABC()
        
        print("---\(ob.a)-")
        print("---\(ob.a_b)-")
    }
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var currentVC: UIViewController?
    
    var window: UIWindow?
    var navigationController : UINavigationController?
    var obAddresses: Addresses?
    
    func setUserAddress (_ ob: Addresses) {
        let id = Key_User_id.getUserValue()
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
                longitude != nil &&
                city != nil &&
                state != nil &&
                country != nil {
                
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
    var player: AVAudioPlayer?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        print("---------------\("I\\U")-----")
        
        if  NetworkUtils.isNetworkReachable() == true {
             print("true")
         }else{
             sleep(200000000)
         }
        
        NetworkReachabilityService.shared.startNetworkMonitoring()
        IQKeyboardManager.shared().isEnabled = true
        initTabbar ()
        locationPermission ()
        //requestPermission()
        //requestPermission()
        GMSPlacesClient.provideAPIKey("AIzaSyAKBtULxvzVH8VHh5kdWxYrmVlzQ6RgUC8")
        var vc: UIViewController!
        let user = UserDefaults.standard
        if user.object(forKey: Key_Introduction) == nil {
            vc = story_Auth.viewController("Introduction")
        } else {
            if Key_User_id.getUserValue() == nil {
                let loginViewController = Route.login(model: LoginScreenData(title: UIImage(named: "Slogan")!)).controller as! LoginViewController
                loginViewController.delegate = NavigationManager.shared
                vc = loginViewController
            } else {
                let add = getUserAddress()
                
                if add == nil {
                    if (Key_User_full_name.getUserValue() as! String).count == 0 {
                        vc = story_Auth.viewController("EnterYourDetail")
                    }else{
                        vc = story_Auth.viewController("SeeTradiesArround")
                    }
                } else {
                    if (Key_User_full_name.getUserValue() as! String).count == 0 {
                        vc = story_Auth.viewController("EnterYourDetail")
                    } else {
                        vc = story_Home.viewController("Home")
                    }
                }
            }
        }
        
        //vc = story_Tradie.viewController("TrackTradie")
        
        window = UIWindow(frame: UIScreen.main.bounds)
        
        self.navigationController = UINavigationController(rootViewController: vc!)
        self.navigationController?.isNavigationBarHidden = true
        self.window?.rootViewController = self.navigationController
        self.window?.makeKeyAndVisible()
        
        notification (application, launchOptions)
        
        SocketIOManager.shared.create()
        
        UIApplication.shared.statusBarStyle = .lightContent
        
        ApplicationDelegate.shared.application(
            application,
            didFinishLaunchingWithOptions: launchOptions
        )
        
        getAppVersionFromServer ()
        
        Config.shared.appRole = "user"
        Config.shared.registerFonts()
        NavigationManager.shared.navigationController = self.navigationController
        
        self.SetupPushNotification(application: application)
        return true
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
        print("one")
        print(userInfo)
        
    }
    
    
    //MARK: APNS - code to make a token string
    func tokenString(_ deviceToken:Data) -> String{
        let bytes = [UInt8](deviceToken)
        var token = ""
        for byte in bytes{
            token += String(format: "%02x",byte)
        }
        //MARK: APNS - this token will be passed to your backend that can be written in php, js, .net etc.
        return token
    }
    
    //MARK: APNS Wor End Here --
    
    
    
    
    func showBedge () {
        //UIApplication.shared.applicationIconBadgeNumber = 10
    }
    
    func notification (_ application: UIApplication, _ launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        //FirebaseApp.configure()
        
        registerForPushNotifications (application)
        
        subscribeToFirebase (true)
        
        if let option = launchOptions {
            let info = option[UIApplication.LaunchOptionsKey.remoteNotification]
            let dt = info as? NSDictionary
            
            if dt != nil {
                print("2Harish openScreenOnNotification-\(dt)-")

                openScreenOnNotification(dt!)
            }
        }
    }
    
    private func registerForPushNotifications(_ application: UIApplication) {
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
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        registerBackgroundTask(application)
        
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    var backgroundTask: UIBackgroundTaskIdentifier = .invalid
    var boolAppInBackground = false
    
    func registerBackgroundTask(_ application: UIApplication) {
        backgroundTask = UIApplication.shared.beginBackgroundTask { [weak self] in
            //self?.registerBackgroundTask(application)
        }
        
        assert(backgroundTask != .invalid)
        
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
    
    func endBackgroundTask() {
        print("In Background Timer. 5")
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        boolAppInBackground = false
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        
        readAllBadge ()
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func generateAccessToken () {
        let user = UserDefaults.standard
        print(params())
        //if user.object(forKey: KEY_ACCESSTOEKN) == nil {
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
        //}
    }
    
    func tabItems() -> NSMutableArray {
        return maTabItems
    }
    
    
    func initTabbar () {
        maTabItems.removeAllObjects()
        
        maTabItems.add(NSMutableDictionary(dictionary: ["isselected": true,
                                                        "title": "Home",
                                                        "selected": #imageLiteral(resourceName: "Home Selected") as Any,
                                                        "unselected": #imageLiteral(resourceName: "Home Selected") as Any]))
        maTabItems.add(NSMutableDictionary(dictionary: ["isselected": false,
                                                        "title": "Bookings",
                                                        "selected": #imageLiteral(resourceName: "Bookings Selected") as Any,
                                                        "unselected": #imageLiteral(resourceName: "Bookings") as Any]))
        maTabItems.add(NSMutableDictionary(dictionary: ["isselected": false,
                                                        "title": "Help",
                                                        "selected": #imageLiteral(resourceName: "Help Selected") as Any,
                                                        "unselected": #imageLiteral(resourceName: "Help") as Any]))
        maTabItems.add(NSMutableDictionary(dictionary: ["isselected": false,
                                                        "title": "Profile",
                                                        "selected": #imageLiteral(resourceName: "Profile Selected") as Any,
                                                        "unselected": #imageLiteral(resourceName: "Profile") as Any]))
    }
    
    var maTabItems = NSMutableArray()
    
    func setSelectedTabbar2 (_ row: Int) {
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
        for i in 0..<kAppDelegate.tabItems().count {
            let md = kAppDelegate.tabItems()[i] as! NSMutableDictionary
            if i == indexPath.row {
                md["isselected"] = true
            } else {
                md["isselected"] = false
            }
            
            kAppDelegate.tabItems().replaceObject(at: i, with: md)
        }
        
        var boolAlready = true
        
        let arr = nav?.viewControllers
        
        for vc in arr! {
            if (vc is Home && indexPath.row == 0) ||
                (vc is MyBookings && indexPath.row == 1) ||
                (vc is Help && indexPath.row == 2) ||
                (vc is MyProfile && indexPath.row == 3) {
                
                nav?.popToViewController(vc, animated: false)
                boolAlready = false
                break
            }
        }
        
        if boolAlready {
            switch indexPath.row {
            case 0:
                let vc = story_Home.viewController("Home")
                nav?.pushViewController(vc!, animated: false)
                break
            case 1:
                let vc = story_Tradie.viewController("MyBookings")
                
                print("KKKK-[\(vc)]-")
                
                nav?.pushViewController(vc!, animated: false)
                break
            case 2:
                let vc = story_Home.viewController("Help")
                nav?.pushViewController(vc!, animated: false)
                break
            case 3:
                let vc = story_Tradie.viewController("MyProfile")
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
                    //UIApplication.shared.applicationIconBadgeNumber = 0
                    
                    kAppDelegate.subscribeToFirebase (false)
                    
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
                    
                    let loginViewController = Route.login(model: LoginScreenData(title: UIImage(named: "Slogan")!)).controller as! LoginViewController
                    loginViewController.delegate = NavigationManager.shared
                    vc.navigationController?.pushViewController(loginViewController, animated: true)
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
            
            //kAppDelegate.locationManager?.requestAlwaysAuthorization()
            // For use in foreground
            kAppDelegate.locationManager?.requestWhenInUseAuthorization()

            if CLLocationManager.locationServicesEnabled() {
            }
            
            kAppDelegate.locationManager?.desiredAccuracy = kCLLocationAccuracyBest
            kAppDelegate.locationManager?.startUpdatingLocation()
        }
    }
    
    func sessionExpired (_ vc: UIViewController) {
//        let arr = vc.navigationController?.viewControllers
//
//        var bool = true
//
//        if arr != nil {
//            for vc in arr! {
//                if vc is Login {
//                    bool = false
//                    self.currentVC?.navigationController?.popToViewController(vc, animated: true)
//                    break
//                }
//            }
//        }
//
//        if bool {
//            let loginViewController = Route.login(model: LoginScreenData(title: UIImage(named: "Login Title")!)).controller as! LoginViewController
//            loginViewController.delegate = NavigationManager.shared
//            self.currentVC?.navigationController!.pushViewController(loginViewController, animated: true)
//        }
        
        
        kAppDelegate.subscribeToFirebase (false)
        
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
        
        let loginViewController = Route.login(model: LoginScreenData(title: UIImage(named: "Slogan")!)).controller as! LoginViewController
        loginViewController.delegate = NavigationManager.shared
        vc.navigationController?.pushViewController(loginViewController, animated: true)
        
        
    }
    
    //MARK: - Facebook
//
//    func applicationDidBecomeActive(_ application: UIApplication) {
//        boolAppInBackground = false
//        //MARK: Himanshu Changes 18/06/2022
//        requestPermission()
//        //AppEvents.activateApp()
//    }
    
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

    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return ApplicationDelegate.shared.application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
    }
    
    @available(iOS 9.0, *)
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {
        return ApplicationDelegate.shared.application(
            app,
            open: url,
            options: options
        )
    }
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
    
    md["device_id"] = UIDevice.current.identifierForVendor!.uuidString
    md["device_type"] = "2"
    md["api_key"] = "$2a$06$hsTL2DeUKS5pUV.YlY/CSuVesppz0ha4hZdcsB7gN8VKRQRBwKct6"
    md["role"] = "user"
    
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
    func viewController (_ vc: String) -> UIViewController? {
        let storyboard = UIStoryboard(name: self, bundle: nil)
        print("HCG VC-[\(vc)]-")
        let vc = storyboard.instantiateViewController(withIdentifier: vc)
        
        return vc
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate, MessagingDelegate {
    func readAllBadge () {
        //UIApplication.shared.applicationIconBadgeNumber = 0
        
        let param = params()
        
        Http.instance().json(api_read_badge_notification, param, "POST", aai: false, popup: false, prnt: true, nil, nil, sync: false, defaultCalling: false) { (json, paras, str, data) in
            
            let json = json as? NSDictionary
            
            if json != nil {
                if json?.number("success").intValue == 1 {
                    //UIApplication.shared.applicationIconBadgeNumber = 0
                }
            }
        }
    }
    
    func badgeCount (_ count: Int) {
        //UIApplication.shared.applicationIconBadgeNumber = count
        
        let param = params()
        
        Http.instance().json(api_get_unread_notification_count, param, "POST", aai: false, popup: false, prnt: true, nil, nil, sync: false, defaultCalling: false) { (json, paras, str, data) in
            
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
        
        //MARK: Badge Icon
        application.applicationIconBadgeNumber = 0
        
        boolAppInBackground = false
        requestPermission()
    }
    
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, openSettingsFor notification: UNNotification?) {
        let userInfo = notification?.request.content.userInfo as? NSDictionary
        print("Harish 3 userNotificationCenter-\(userInfo)-")
        //Http.alert("", "Notification 2")
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
    
//    // If app open then here we will receive Notification
//    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
//
//        let userInfo = notification.request.content.userInfo as? NSDictionary
//        print("Harish 2 userNotificationCenter-\(userInfo)-")
//        //Http.alert("", "Notification 4")
//        completionHandler([.alert, .badge, .sound])
//
//        if userInfo != nil {
//            if let order_status = userInfo!["order_status"] as? String {
//                /*if order_status == "on-going" {
//                    if vcMerchantOrders != nil {
//                        vcMerchantOrders?.merchantList("1")
//                    }
//                }*/
//            } else {
//                //Http.alert("1", "\(userInfo)")
//            }
//        }
//    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        print(userInfo)
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
    
    
    
    
    
//    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
//        let token = deviceToken.map({ String(format: "%02.2hhx", $0)}).joined()
//        print("Harish token-\(token)-")
//        Messaging.messaging().apnsToken = deviceToken
//    }
//
//    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
//        print("Harish 4 userInfo-\(userInfo)-")
//        //Http.alert("", "Notification 5")
//    }
//
//    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
//                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
//        print("Harish 5 userInfo-\(userInfo)-")
//        //Http.alert("", "Notification 6")
//
//        completionHandler(.newData)
//    }
    
    func subscribeToFirebase (_ bool: Bool) {
        if Key_User_id.getUserValue() != nil {
            let uid = Key_User_id.getUserValue()
            
            let topic = "tradieuser_\(uid!)"
            
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
        if let url = "itms://itunes.apple.com/us/app/tap-a-tradie/id1473400994".url {
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
                        /*
                         "Tap_a_tradie_android" = "1.11";
                         "Tap_a_tradie_ios" = "1.8";
                         "Tradie_version_android" = "1.21";
                         "Tradie_version_ios" = "1.15";
                         */
                        if jsonExp != nil {
                            if jsonExp?.number("success").intValue == 1 {
                                if let dt = jsonExp?["data"] as? NSDictionary {
                                    if let double1 = Double(dt.string("Tap_a_tradie_ios").replacingOccurrences(of: ".", with: "")) {
                                        let av1 = Int(double1 * 1000.0)
                                        
                                        print("Double av-[\(double)]-[\(av)]-")
                                        print("Double av1-[\(double1)]-[\(av1)]-")
                                        
                                        if av1 > av {
                                            print("Update App")
                                            Http.alert("A new version \(dt.string("Tap_a_tradie_ios")) of Tap a Tradie is available.", "Install it now from App Store.", [self, "CANCEL", "INSTALL"])
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




class NetworkUtils{
    
    static func isNetworkReachable() -> Bool {
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
