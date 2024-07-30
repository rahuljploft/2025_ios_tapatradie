//
//  PaymentAtRegistration.swift
//  Tradie
//
//  Created by mac on 26/06/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import StoreKit

class PaymentAtRegistration: BaseVC {
    static func viewController () -> PaymentAtRegistration {
        return "Payment".viewController("PaymentAtRegistration") as! PaymentAtRegistration
    }
    
    var boolDeviceUser = false
    
    var purchasedDeviceType = ""
    
    //var boolFromRegistration = true
    
    var boolServerPuchase = false
    var boolApplePuchase = false
    
    @IBOutlet weak var aiPurchase: UIActivityIndicatorView!
    
    @IBOutlet weak var viewShadowImages: UIView!
    
    @IBOutlet weak var viewOnlineOfflineRightCross: UIView!
    @IBOutlet weak var viewOblineOfflineRightCrossInner: UIView!
    
    @IBAction func actionOnlineOffline(_ sender: Any) {
        var online = Key_User_online.getUserValue()
        
        if online == nil {
            Key_User_online.setUserValue("0")
            online = "0"
        }
        
        if "\(online ?? "")" == "1" {
            actionRightOnlineOffline("")
        } else {
            viewOnlineOfflineRightCross.frame = self.view.bounds
            self.view.addSubview(viewOnlineOfflineRightCross)
        }
    }
    
    @IBOutlet weak var btnCancelSubcription: UIButton?
    
    @IBAction func actionCancelSubcription (_ sender: Any) {
        if let url = URL(string: "https://apps.apple.com/account/subscriptions") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    @IBAction func actionCrossOnlineOffline(_ sender: Any) {
        viewOnlineOfflineRightCross.removeFromSuperview()
    }
    
    var profileJSON: ProfileJSON?
    
    @IBOutlet weak var cltnTabbar: UICollectionView!
    
    @IBOutlet weak var imgOnline: UIImageView!
    
    @IBOutlet weak var lblNextRenewDate: UILabel!
    
    @IBAction func actionBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBOutlet weak var lblExpireMessage: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lblNextRenewDate.text = ""
        
        cltnTabbar.isHidden = true
        imgOnline.superview?.isHidden = true
        viewShadowImages.isHidden = true
        
        borderForDots ()
        
        lblExpireMessage.text = "A AUD $4.99 weekly purchase will be applied to your iTunes/AppleID account. Subscriptions will automatically renew unless canceled within 24-hours before the end of the current period. You can cancel anytime with your iTunes account settings. Any unused portion of a free trial will be forfeited if you purchase a subscription."
    }
    
    /*override*/ func viewWillAppear1(_ animated: Bool) {
        
        setOnlineOfflineImage ()
        
        let obc = kAppDelegate.boolIAPPurchased ()
        
        print("Harish HCG-1-")
        
        if kAppDelegate.boolSubscriptionExpired {
            print("Harish HCG-2-")
            self.btnPurchaseWeekly.isHidden = false
            
            if obc.date == nil {
                print("Harish HCG-3-")
                //verifyNow ()
            } else {
                print("Harish HCG-4-")
                getSubcriptionDetails ()
                
                self.setSubscriptionButtonTitle (obc.date)
            }
        } else {
            print("Harish HCG-5-")
            self.btnPurchaseWeekly.isHidden = true
            
            getSubcriptionDetails ()
        }
        
        self.updateCancelSubcriptionButton ()
    }
    
    func updateCancelSubcriptionButton () {
        DispatchQueue.main.async {
            self.btnCancelSubcription?.isHidden = !self.btnPurchaseWeekly.isHidden
            
            if kAppDelegate.boolSubscriptionExpired == false && kAppDelegate.boolPurchasedFromIAP == false {
                self.btnCancelSubcription?.isHidden = true
            }
            
            print("self.boolApplePuchase-1-==========-[\(self.boolApplePuchase)]-[\(self.boolServerPuchase)]-")
        }
    }
    
    func showSubscriptionPopup (_ title: String, _ msg: String) {
        AlertView.instance.present(title, msg) { (result) in
            if result == "actionSendReceiptToServer" {
                let md = NSMutableDictionary()
                
                var recpt = "receipt not available"
                
                if let receiptFileURL = Bundle.main.appStoreReceiptURL {
                    let receiptData = try? Data(contentsOf: receiptFileURL)
                    
                    if let recieptString = receiptData?.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0)) {
                        recpt = recieptString
                    }
                }
                
                md["receipt"] = recpt
                
                //self.saveReceiptDataToServer (md)
            }
            
        }
    }
    
    @IBAction func actionWeeklySubcription (_ sender: Any) {
        print("dasdasdasdas-[\(boolDeviceUser)]-")
        
        if kAppDelegate.isLoginUserDeviceUser() {
            purchase()
        } else {
            if let oti = kAppDelegate.getOriginalTransactionId(), oti.count > 0 {
                Http.alert("", "You have subscribed with some other mobile number. Please login with the same mobile number to use this feature.", [self, "Logout", "Cancel"])
            } else {
                purchase()
            }
        }
    }
    
    func purchase() {
        Http.startActivityIndicator()
        self.startAIPurchasing ()
        
        SwiftyStoreKit.purchaseProduct("tradie.com.purchase.weekly", atomically: true) { result in
            Http.stopActivityIndicator()
            self.stopAIPurchased()
            
            let dat = Date()
            print("result-[\(dat)]-\(result)-")
            
            if case .success(let purchase) = result {
                switch purchase.transaction.transactionState {
                case .purchased:
                    let downloads = purchase.transaction.downloads
                    if !downloads.isEmpty {
                        print("51HCG-\(purchase.transaction.transactionState.debugDescription): \(purchase.productId)")
                        SwiftyStoreKit.start(downloads)
                    } else if purchase.needsFinishTransaction {
                        print("52HCG-\(purchase.transaction.transactionState.debugDescription): \(purchase.productId)")
                        // Deliver content from server, then:
                        SwiftyStoreKit.finishTransaction(purchase.transaction)
                    } else {
                        print("53HCG-\(purchase.transaction.transactionState.debugDescription): \(purchase.productId)")
                    }
                case .restored:
                    
                    let downloads = purchase.transaction.downloads
                    if !downloads.isEmpty {
                        print("511HCG-\(purchase.transaction.transactionState.debugDescription): \(purchase.productId)")
                        SwiftyStoreKit.start(downloads)
                    } else if purchase.needsFinishTransaction {
                        print("521HCG-\(purchase.transaction.transactionState.debugDescription): \(purchase.productId)")
                        // Deliver content from server, then:
                        SwiftyStoreKit.finishTransaction(purchase.transaction)
                    } else {
                        print("531HCG-\(purchase.transaction.transactionState.debugDescription): \(purchase.productId)")
                    }
                    
                    
                case .failed, .purchasing, .deferred:
                break // do nothing
                @unknown default:
                    break // do nothing
                }
                
                let downloads = purchase.transaction.downloads
                if !downloads.isEmpty {
                    SwiftyStoreKit.start(downloads)
                }
                // Deliver content from server, then:
                if purchase.needsFinishTransaction {
                    SwiftyStoreKit.finishTransaction(purchase.transaction)
                }
            }
            
            self.getPuchaseDataFromApple ()
        }
    }
    
    func sendPurchaseDataToServer (_ receipt: NSDictionary, _ dt: NSDictionary) {
        print("receipt-[\(receipt)]-")
        
        let notify_type = "INITIAL_SETUP"
        
        let expires_date_ms = dt.number("expires_date_ms").intValue
        let sevendays = 60 * 60 * 24 * 7
        
        let param = params()
        param["customer_id"] = dt.string("original_transaction_id")
                
        param["purchase_start_date"] = expires_date_ms - sevendays
        param["purchase_end_date"] = expires_date_ms
        param["sevendays"] = sevendays
        
        if dt.string("is_trial_period") == "false" {
            param["is_trial"] = "0"
        } else {
            param["is_trial"] = "1"
        }
        
        param["notify_type"] = notify_type
        param["transaction_id"] = dt.string("transaction_id")
        param["product_id"] = dt.string("product_id")
        param["environment"] = receipt.string("environment")
        param["raw_data"] = "\(receipt)"
        
        print("api_ios_purchase_membership param-[\(param)]-")
        
        Http.instance().json(api_ios_purchase_membership, param, "POST", aai: true, popup: false, prnt: true, nil, nil, sync: false, defaultCalling: true) { (json, para, ss, ht, data) in
            print("3Harish json-\(json)-")
            
        }
    }
    
    func setSubscriptionButtonTitle (_ date: Date?) {
        print("Harish HCG-6-")
        if date != nil {
            print("Harish HCG-7-")
            let date = date!
            
            let date1 = Date()
            
            print("expiry date-\(date)-")
            print("current date-\(date1)-")
            
            let int = date1.timeIntervalSince(date)
            
            print("int-[\(int)]-")
     
            self.btnPurchaseWeekly.setImage(#imageLiteral(resourceName: "left-arrow"), for: .normal)
            self.btnPurchaseWeekly.setImage(UIImage(), for: .normal)
            
            if int > 0 {
                print("Harish HCG-8-")
                print("purchase now")
                
                self.btnPurchaseWeekly.setTitle("SUBSCRIBE NOW", for: .normal)
                
                self.btnPurchaseWeekly.setImage(#imageLiteral(resourceName: "left-arrow"), for: .normal)
                
                self.btnPurchaseWeekly.isHidden = false
                
                kAppDelegate.boolSubscriptionExpired = true
            } else {
                print("Harish HCG-9-")
                print("y2 purchased")
                
                kAppDelegate.boolSubscriptionExpired = false
                kAppDelegate.setPurchased()
                
                self.btnPurchaseWeekly.isHidden = true
                
                self.getDeviceUser ()
            }
            
            if kAppDelegate.allowTestingPopup() {
                showSubscriptionPopup ("Popup 6", "3-pdate-[\(date)]-cdate-[\(date1)]-")
            }
            
            lblNextRenewDate.text = "Next renew date is : \(date.getStringDate(EXPIRYDATEFORMATE))"
        } else {
            
            if kAppDelegate.allowTestingPopup() {
                showSubscriptionPopup ("Popup 7", "2-[h-date-nil]-")
            }
            
            self.btnPurchaseWeekly.setTitle("START \(kAppDelegate.purchaseTrailDays) DAYS FREE TRAIL", for: .normal)
            
            self.btnPurchaseWeekly.setImage(UIImage(), for: .normal)
            
            self.btnPurchaseWeekly.isHidden = false
        }
        
        Http.stopActivityIndicator()
        self.stopAIPurchased()
        
        self.updateCancelSubcriptionButton ()
    }
    
    func verifyReceipt(completion: @escaping (VerifyReceiptResult) -> Void) {
        SwiftyStoreKit.verifyReceipt(using: appleValidator, completion: completion)
    }
    
    @IBAction func actionYearlySubcription(_ sender: Any) {
        
    }
    
    @IBAction func actionRestorePurchases(_ sender: Any) {
        restorePurchases()
    }
    
    func restorePurchases() {
        Http.startActivityIndicator()
        self.startAIPurchasing ()
        
        SwiftyStoreKit.restorePurchases(atomically: true) { results in
            //Http.stopActivityIndicator()
            //self.stopAIPurchased()
            
            for purchase in results.restoredPurchases {
                
                switch purchase.transaction.transactionState {
                case .purchased, .restored:
                    let downloads = purchase.transaction.downloads
                    if !downloads.isEmpty {
                        print("51HCG-\(purchase.transaction.transactionState.debugDescription): \(purchase.productId)")
                        SwiftyStoreKit.start(downloads)
                    } else if purchase.needsFinishTransaction {
                        print("52HCG-\(purchase.transaction.transactionState.debugDescription): \(purchase.productId)")
                        // Deliver content from server, then:
                        SwiftyStoreKit.finishTransaction(purchase.transaction)
                    } else {
                        print("53HCG-\(purchase.transaction.transactionState.debugDescription): \(purchase.productId)")
                    }
                    
                case .failed, .purchasing, .deferred:
                break // do nothing
                @unknown default:
                    break // do nothing
                }
            }
            
            self.getPuchaseDataFromApple ()
        }
    }
    
    @IBOutlet weak var btnPurchaseWeekly: UIButton!
    @IBOutlet weak var btnPurchaseYearly: UIButton!
    
    func borderForDots () {
        lbl1.border5(3)
        lbl2.border5(3)
        lbl3.border5(3)
        lbl4.border5(3)
    }
    
    @IBOutlet weak var lbl1: UILabel!
    @IBOutlet weak var lbl2: UILabel!
    @IBOutlet weak var lbl3: UILabel!
    @IBOutlet weak var lbl4: UILabel!

    @IBAction func actionTermsCondition(_ sender: Any) {
        let vc = story_Home.viewController("WebPage") as! WebPage
        vc.linkType = .iap_termsncondition
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func actionPrivacyPolicy(_ sender: Any) {
        let vc = story_Home.viewController("WebPage") as! WebPage
        vc.linkType = .iap_privacypolicy
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func actionRightOnlineOffline(_ sender: Any) {
        viewOnlineOfflineRightCross.removeFromSuperview()
        
        var online = Key_User_online.getUserValue()
        
        if online == nil {
            online = "0"
            Key_User_online.setUserValue("0")
        }
        
        let param = params()
        
        if "\(online!)" == "1" {
            param["online"] = "0"
        } else {
            param["online"] = "1"
        }
        
        Http.instance().json(api_provider_online_status, param, "POST", aai: true, popup: true, prnt: false, nil, nil, sync: false, defaultCalling: false) { (json, para, str, http, data) in
            let json = json as? NSDictionary
            
            if json != nil {
                if json?.number("success").intValue == 1 {
                    
                    if "\(online!)" == "1" {
                        Key_User_online.setUserValue("0")
                    } else {
                        Key_User_online.setUserValue("1")
                    }
                    
                    DispatchQueue.main.async {
                        self.setOnlineOfflineImage ()
                    }
                }
                
                //Http.alert("", json?.string("message"))
            }
            
            let jsonExp = json as? NSDictionary
            
            if jsonExp != nil {
                if jsonExp?.number("success").intValue == SESSIONEXPIRED {
                    kAppDelegate.sessionExpired(self)
                    
                    return
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setOnlineOfflineImage ()
        
        getSubcriptionDetailsFromServer ()
    }
}

extension PaymentAtRegistration {
    func getSubcriptionDetailsFromServer () {
        kAppDelegate.boolPurchasedFromIAP = true
        boolServerPuchase = false        
        Http.instance().json(api_get_current_subscription, params(), "POST", aai: true, popup: true, prnt: true, nil, nil, sync: false, defaultCalling: true) { (json, para, ss, ht, data) in
            //print("114Harish json-\(json)-")
            
            var boolData = false
            
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
                        boolData = true
                        
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
            
            if boolData {
                if self.boolServerPuchase {
                    self.goNext()
                } else if kAppDelegate.isLoginUserDeviceUser () {
                    self.getPuchaseDataFromApple ()
                } else {
                    self.btnCancelSubcription?.isHidden = true
                    self.btnPurchaseWeekly.isHidden = false
                }
            } else {
                self.btnCancelSubcription?.isHidden = true
                self.btnPurchaseWeekly.isHidden = false
                
                self.getIAPDetails ()
            }
        }
    }
    
    func getSubcriptionDetails (_ firstCall: Bool = true) {
        kAppDelegate.boolPurchasedFromIAP = true
        Http.startActivityIndicator()
        boolServerPuchase = false
        Http.instance().json(api_get_current_subscription, params(), "POST", aai: false, popup: true, prnt: true, nil, nil, sync: false, defaultCalling: true) { (json, para, ss, ht, data) in
            //print("114Harish json-\(json)-")
            
            if let json = json as? NSDictionary {
 
                
                
                if let data = json["data"] as? NSDictionary {
                    //if data.string("status") == "active" {
                    let timestamp = data.string("end_date")
                    
                    let ios_customer_id = data.string("ios_customer_id")
                    
                    self.purchasedDeviceType = data.string("device_type")
                    
                    if let oti = kAppDelegate.getOriginalTransactionId() {
                        if ios_customer_id == oti {
                            self.boolDeviceUser = true
                        }
                    }
                    
                    let cancelStatus = data.string("status")
                    print(cancelStatus)
                    cancelStatusVal = "\(cancelStatus)"
                    
                    if timestamp.count > 0 {
                        let time = data.number("end_date").doubleValue
                        
                        var date: Date = Date()
                        
                        if timestamp.count == 13 {
                            date = Date.init(timeIntervalSince1970: time/1000)
                        } else {
                            date = Date.init(timeIntervalSince1970: time)
                        }
                        
                        let date1 = Date()
                        
                        let int = date1.timeIntervalSince(date)
                        
                        print("Expiry date-[\(date)]-current-[\(date1)]-[\(int)]-")
                        
                        if int > 0 {
                            print("2Not purchased-----")
                        } else {
                            self.purchsed()
                            
                            self.boolServerPuchase = true
                            
                            kAppDelegate.boolPurchasedFromIAP = false
                            
                            kAppDelegate.setPurchasedDate (time)
                            
                            print("Purchased-----")
                        }
                    } else {
                        if timestamp.count == 0 {
                            kAppDelegate.boolPurchasedFromIAP = false
                            
                            self.boolServerPuchase = false
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
            
            if (self.boolApplePuchase && self.boolDeviceUser) || self.boolServerPuchase {
                self.goNext()
            } else {
                self.btnCancelSubcription?.isHidden = true
                self.btnPurchaseWeekly.isHidden = false
            }
            
            Http.stopActivityIndicator()
        }
    }
    
    func goNext () {
        print("Harish HCG-12-")
        if boolFromLaunch {
            print("Harish HCG-13-")
            if step1_VC != nil && step2_VC != nil && step3_VC != nil && step4_VC != nil {
                print("Harish HCG-14-")
                let s1 = Int(step1_VC!)
                let s2 = Int(step2_VC!)
                let s3 = Int(step3_VC!)
                let s4 = Int(step4_VC!)
                
                if s1 == 0 && s2 == 0 && s3 == 0 && s4 == 0 {
                    print("Harish HCG-15-")
                    let vc = story_Profile.viewController("PrimaryBusiness") as! PrimaryBusiness
                    self.navigationController?.pushViewController(vc, animated: true)
                } else if s2 == 1 && s4 == 1 {
                    print("Harish HCG-16-")
                    let vc = story_Tradie.viewController("MyBookings") as! MyBookings
                    self.navigationController?.pushViewController(vc, animated: true)
                } else {
                    print("Harish HCG-17-")
                    let vc = story_Profile.viewController("Profile") as! Profile
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            } else {
                print("Harish HCG-18-")
                let vc = story_Profile.viewController("Profile") as! Profile
                self.navigationController?.pushViewController(vc, animated: true)
            }
        } else if profileJSON == nil {
            print("Harish HCG-19-")
            var vc: UIViewController?
            
//            if Key_User_full_name.getUserValue() == nil {
//                print("Harish HCG-20-")
//                vc = story_Auth.viewController("EnterYourDetail")
//                self.navigationController?.pushViewController(vc!, animated: true)
//            } else if (Key_User_full_name.getUserValue() as? String)?.count == 0 {
//                print("Harish HCG-21-")
//                vc = story_Auth.viewController("EnterYourDetail")
//                self.navigationController?.pushViewController(vc!, animated: true)
//            } else {
//                print("Harish HCG-22-")
                self.checkProfile ()
//            }
        } else {
            print("Harish HCG-23-")
            if  Int(profileJSON?.step2 ?? "0") == 0 || Int(profileJSON?.step4 ?? "0") == 0 {
                print("Harish HCG-24-")
                let vc = story_Profile.viewController("Profile") as! Profile
                vc.profileJSON = profileJSON
                self.navigationController?.pushViewController(vc, animated: true)
            } else {
                print("Harish HCG-25-")
                let vc = story_Tradie.viewController("MyBookings") as! MyBookings
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
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
                        
                        if  Int(profileJSON?.step1 ?? "0") == 0 || Int(profileJSON?.step2 ?? "0") == 0 || Int(profileJSON?.step3 ?? "0") == 0 || Int(profileJSON?.step4 ?? "0") == 0 || Int(profileJSON?.step5 ?? "0") == 0 || Int(profileJSON?.data.user_submit_approval_btn ?? "0") == 0 {
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
}

//MARK: - Subscription verification

extension PaymentAtRegistration {
    func startAIPurchasing () {
        DispatchQueue.main.async {
            self.aiPurchase.superview?.isHidden = false
            self.aiPurchase.startAnimating()
            self.btnPurchaseWeekly.isEnabled = false
            
            self.updateCancelSubcriptionButton ()
        }
    }
    
    func stopAIPurchased () {
        DispatchQueue.main.async {
            self.aiPurchase.superview?.isHidden = true
            self.aiPurchase.stopAnimating()
            self.btnPurchaseWeekly.isEnabled = true
            
            self.updateCancelSubcriptionButton ()
        }
    }
    
    func purchsed () {
        DispatchQueue.main.async {
            Http.stopActivityIndicator()
            self.stopAIPurchased()
            
            print("y1 purchased")
        }
    }
    
    func notPurchsed () {
        DispatchQueue.main.async {
            Http.stopActivityIndicator()
            self.stopAIPurchased()
            
            self.setSubscriptionButtonTitle(nil)
            print("purchase now")
        }
    }
    
}

extension PaymentAtRegistration: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, TabbarCellDelegate {
    func setOnlineOfflineImage () {
        var online = Key_User_online.getUserValue()
        
        if online == nil {
            Key_User_online.setUserValue("0")
            online = "0"
        }
        
        if "\(online!)" == "1" {
            imgOnline.image = #imageLiteral(resourceName: "Group 4657-1")
        } else {
            imgOnline.image = #imageLiteral(resourceName: "Group 4659-1")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return kAppDelegate.tabItems().count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TabbarCell", for: indexPath) as! TabbarCell
        cell.indexPath = indexPath
        cell.delegate = self
        
        let dt = kAppDelegate.tabItems()[indexPath.row] as! NSMutableDictionary
        
        if dt.number("isselected").boolValue {
            cell.imgCell.image = (dt["selected"] as! UIImage)
            cell.lblTitle.textColor = UIColor.hexColor(0xEF4136)
        } else {
            cell.imgCell.image = (dt["unselected"] as! UIImage)
            cell.lblTitle.textColor = UIColor.hexColor(0x707070)
        }
        
        cell.lblTitle.text = dt["title"] as? String
        
        if kAppDelegate.tabItems().count == (indexPath.row + 1) {
            cell.lblBorder.isHidden = true
        } else {
            cell.lblBorder.isHidden = false
        }
        
        if indexPath.row == 1 || indexPath.row == 2 {
            cell.lblBorder.isHidden = true
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let hh: CGFloat = 60
        
        if indexPath.row == 2 {
            return CGSize(width: hh, height: 50)
        } else {
            return CGSize(width: (cltnTabbar.frame.size.width - hh) / CGFloat(kAppDelegate.tabItems().count - 1), height: 50)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    func tabbarClickedAt(_ indexPath: IndexPath) {
        kAppDelegate.tabbarClicked(indexPath, self.navigationController)
    }
}

extension PaymentAtRegistration: AlertDelegate {
    func alertOne() {
        
    }
    
    func alertZero() {
        kAppDelegate.logout (self)
    }
}

extension PaymentAtRegistration {
    func getDeviceUser () {
        var boolCheckDevice = false        
        if let oti = kAppDelegate.getOriginalTransactionId() {
            if oti.count > 0 {
                boolCheckDevice = true
            }
        }
        if boolCheckDevice {
            Http.startActivityIndicator()
            Http.instance().json(api_get_current_subscription, params(), "POST", aai: false, popup: true, prnt: true, nil, nil, sync: false, defaultCalling: true) { (json, para, ss, ht, data) in
                //print("114Harish json-\(json)-")
                
                if let json = json as? NSDictionary {
                
                    
                    if let data = json["data"] as? NSDictionary {
                        let ios_customer_id = data.string("ios_customer_id")
                        
                        let cancelStatus = data.string("status")
                        print(cancelStatus)
                        cancelStatusVal = "\(cancelStatus)"
                        
                        if let oti = kAppDelegate.getOriginalTransactionId() {
                            if ios_customer_id == oti {
                                self.boolDeviceUser = true
                                
                                if self.boolFromRegistration {
                                    print("Harish HCG-110-")
                                    let vc = story_Profile.viewController("Profile") as! Profile
                                    self.navigationController?.pushViewController(vc, animated: true)
                                } else {
                                    print("Harish HCG-111-")
                                    self.goNext ()
                                }
                                
                                
                            }
                        }
                        
                    }
                    
                    if let paymentSetting = json["paymentSetting"] as? Int {
                        print("paymentSetting",paymentSetting)
                        if paymentSetting == 1 {
                            paymentSettingStatus = true
                        }else{
                            paymentSettingStatus = false
                        }
                            
                    }
                    print("paymentSettingStatus : ",paymentSettingStatus)
                    
                }
                
                Http.stopActivityIndicator()
            }
        } else {
            if self.boolFromRegistration {
                print("Harish HCG-10-")
                let vc = story_Profile.viewController("Profile") as! Profile
                self.navigationController?.pushViewController(vc, animated: true)
            } else {
                print("Harish HCG-11-")
                self.goNext ()
            }
        }
    }
}

extension PaymentAtRegistration {
    func getPuchaseDataFromApple () {
        Http.startActivityIndicator()
        self.startAIPurchasing ()
        
        let date1 = Date()
        
        verifyReceipt { (result) in
            Http.stopActivityIndicator()
            self.stopAIPurchased()
            
            switch result {
            case .success(let receipt):
                //print("Verify receipt Success: \(receipt)")
                var original_transaction_id = ""
                var boolPurchased = false
                var latest_receipt_info_count = 0
                var dateExpiry: Date?
                
                if let latest_receipt_info = receipt["latest_receipt_info"] as? NSArray {
                    latest_receipt_info_count = latest_receipt_info.count
                    
                    for i in 0..<latest_receipt_info.count {
                        if let last = latest_receipt_info[i] as? NSDictionary {
                            original_transaction_id = last.string("original_transaction_id")
                            
                            kAppDelegate.setOriginalTransactionId(last.string("original_transaction_id"))
                            
                            let time = last.number("expires_date_ms").doubleValue
                            
                            let date = Date.init(timeIntervalSince1970: time/1000)
                            
                            print("expiry date1-\(date)-[\(last.number("original_transaction_id"))]")
                            print("current date-\(date1)-")
                            
                            dateExpiry = date
                            let int = date1.timeIntervalSince(date)
                            
                            if int > 0 {
                                
                            } else {
                                kAppDelegate.setPurchasedDate (time)
                                
                                boolPurchased = true
                                
                                self.sendPurchaseDataToServer(receipt as NSDictionary, last)
                                break
                            }
                        }
                        
                        if boolPurchased {
                            break
                        }
                    }
                }
                
                if boolPurchased {
                    self.goNext()
                } else if dateExpiry != nil {
                    self.setSubscriptionButtonTitle(dateExpiry!)
                } else if latest_receipt_info_count == 0 {
                    self.setSubscriptionButtonTitle(nil)
                } else {
                    self.setSubscriptionButtonTitle(nil)
                }
                
                break
            case .error(let error):
                Http.stopActivityIndicator()
                self.stopAIPurchased()
                
                self.setSubscriptionButtonTitle(nil)
                
                print("Verify receipt Failed: \(error)")
            }
        }
    }
    
    func getIAPDetails () {
        print("getIAPDetails 1")
        
        Http.startActivityIndicator()
        self.startAIPurchasing ()
        
        verifyReceipt { (result) in
            Http.stopActivityIndicator()
            self.stopAIPurchased()
            
            switch result {
            case .success(let receipt):
                //print("Verify receipt Success: \(receipt)")
                //var original_transaction_id = ""
                //var boolPurchased = false
                //var latest_receipt_info_count = 0
                ///var dateExpiry: Date?
                
                if let latest_receipt_info = receipt["latest_receipt_info"] as? NSArray {
                    //latest_receipt_info_count = latest_receipt_info.count
                    
                    for i in 0..<latest_receipt_info.count {
                        if let last = latest_receipt_info[i] as? NSDictionary {
                            let original_transaction_id = last.string("original_transaction_id")
                            print("getIAPDetails 2-[\(original_transaction_id)]-")
                            
                            kAppDelegate.setOriginalTransactionId(last.string("original_transaction_id"))
                            break
                        }
                    }
                }
                
                break
            case .error(let error):
                Http.stopActivityIndicator()
                self.stopAIPurchased()
                
                print("Verify receipt Failed: \(error)")
            }
        }
    }
}
