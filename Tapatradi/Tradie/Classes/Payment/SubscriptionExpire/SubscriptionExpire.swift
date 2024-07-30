//
//  SubscriptionExpire.swift
//  Tradie
//
//  Created by mac on 29/07/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import StoreKit

class SubscriptionExpire: UIViewController {
    
    @IBOutlet weak var lblExpireMessage: UILabel!
    
    @IBOutlet var viewSubscriptionDecision: UIView!
    
    var vc: UIViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        lblExpireMessage.text = "30 Day Free Trial"
//            
//        viewChoosePlan.border5(viewChoosePlan.frame.size.height/2)
//        
//        //viewSubscriptionDecision.frame = UIScreen.main.bounds
//        //self.view.addSubview(viewSubscriptionDecision)
//        
//        verifyNow ()
//        
//        receiptValidation()
//
//        //writeTextToFile ()
//        //restorePurchases()
    }
    
    var isActive = true
    
    override func viewWillAppear(_ animated: Bool) {
        isActive = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        isActive = false
    }
    
    @IBAction func actionWeeklySubscription2 (_ sender: Any) {
        let vc = story_Payment.viewController("ChooseSubscripiton") as? ChooseSubscripiton
        vc?.boolFromMenu = false
        self.navigationController?.pushViewController(vc!, animated: false)
    }
    
    @IBAction func actionWeeklySubscription (_ sender: Any) {
        purchase ()
    }
    
    @IBOutlet weak var viewChoosePlan: UIView!
    
    var products: [SKProduct] = []
    
    @IBAction func actionRestorePurchases(_ sender: Any) {
        boolRestoreOnceMore = true
        
        restorePurchases ()
    }
    
    func pushVC (_ boolPurchased: Bool) {
        if isActive {
            isActive = false
            if boolPurchased {
                print("Harish 1 pushVC-----\(boolPurchased)")
                //let vc = kAppDelegate.navToViewController()
                //self.navigationController?.pushViewController(vc!, animated: true)
                
                //self.viewSubscriptionDecision.removeFromSuperview()
            } else {
                print("Harish 2 pushVC-----\(boolPurchased)")
                //self.viewSubscriptionDecision.removeFromSuperview()
            }
        }
        
        Http.stopActivityIndicator()
    }
    
    var boolSingalCheck = false
    
    var boolRestoreOnceMore = true
    
    @IBAction func actionTermsConditions (_ sender: Any) {
        let vc = story_Home.viewController("WebPage") as! WebPage
        vc.linkType = .iap_termsncondition
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func actionPrivacyPolicy (_ sender: Any) {
        let vc = story_Home.viewController("WebPage") as! WebPage
        vc.linkType = .iap_privacypolicy
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func writeTextToFile (_ text: String) {
        let file = "file.txt" //this is the file. we will write to and read from it
        
        //let text = "some text" //just a text
        
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            
            let fileURL = dir.appendingPathComponent(file)
            
            print("fileURL-\(fileURL)-")
            
            //writing
            do {
                try text.write(to: fileURL, atomically: false, encoding: .utf8)
            }
            catch {/* error handling here */}
            
            //reading
            do {
                let text2 = try String(contentsOf: fileURL, encoding: .utf8)
                
                let tv = UITextView(frame: CGRect(x: 0, y: 0, width: 300, height: 400))
                
                tv.text = text2
                
                self.view.addSubview(tv)
                
                
                let param = params()
                
                let ma = NSMutableArray()
                
                let md = NSMutableDictionary()
                
                md["param"] = "file"
                md["image"] = text2
                
                ma.add(md)
                
                
            }
            catch {/* error handling here */}
        }
    }
    
}

extension SubscriptionExpire {
    func restorePurchases() {
        Http.startActivityIndicator()
        
        SwiftyStoreKit.restorePurchases(atomically: true) { results in
            Http.stopActivityIndicator()
            
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
                break
                @unknown default:
                    break
                }
            }
            
            self.verifyNow ()
        }
    }
    
    func purchase() {
        Http.startActivityIndicator()
        
        SwiftyStoreKit.purchaseProduct("tradie.com.purchase.weekly", atomically: true) { result in
            Http.stopActivityIndicator()
            
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
            
            self.verifyNow ()
        }
    }
    
    func verifyNow () {
        Http.startActivityIndicator()
        
        verifyReceipt { (result) in
            Http.stopActivityIndicator()
            
            switch result {
            case .success(let receipt):
                //print("Verify receipt Success: \(receipt)")
                
                if let pending_renewal_info = receipt["pending_renewal_info"] as? NSArray {
                    print("pending_renewal_info-\(pending_renewal_info)-")
                }
                
                if let latest_receipt_info = receipt["latest_receipt_info"] as? NSArray {
                    if let last = latest_receipt_info.lastObject as? NSDictionary {
                        
                        //print("last-\(last)-")
                        
                        let time = last.number("expires_date_ms").doubleValue
                        
                        //print("time-\(time)-")
                        //date-2020-01-11 13:23:39 +0000-
                        
                        let date = Date.init(timeIntervalSince1970: time/1000)
                        let date1 = Date()
                        
                        //print("date-\(date)-")
                        
                        let int = date1.timeIntervalSince(date)
                        
                        //print("int-\(int)-")
                        
                        let pending_renewal_info = receipt["pending_renewal_info"] as? NSArray
                        
                        //self.sendPurchaseDataToServer(last, pending_renewal_info, receipt["pending_renewal_info"], receipt)
                        
                        if int > 0 {
                            print("purchase now")
                            
                            //self.viewSubscriptionDecision.removeFromSuperview()
                        } else {
                            print("purchased")
                            
                            //let vc = kAppDelegate.navToViewController()
                            //self.navigationController?.pushViewController(vc!, animated: true)
                        }
                    }
                }
            case .error(let error):
                //self.viewSubscriptionDecision.removeFromSuperview()
                print("Verify receipt Failed: \(error)")
            }
        }
    }
    
    func sendPurchaseDataToServer (_ last: NSDictionary, _ pending_renewal_info: NSArray?, _ pending_renewal_info_any: Any?, _ receiptresponce: Any?) {
        //print("last-\(last)-")
        
        let time = last.number("expires_date_ms").doubleValue
        
        let date = Date.init(timeIntervalSince1970: time/1000)
        
        let original_purchase_date_ms = last.number("original_purchase_date_ms").doubleValue
        
        let date1 = Date.init(timeIntervalSince1970: original_purchase_date_ms/1000)
        
        let expires_date = date.getStringDate("yyyy-MM-dd HH:mm:ss z")
        let original_purchase_date = date1.getStringDate("yyyy-MM-dd HH:mm:ss z")
        
        //print("expires_date-\(expires_date)-")
        //print("original_purchase_date-\(original_purchase_date)-")
        
        let json = last.toString1()
        
        //print("json-\(json)-")
        
        let param = params()
        
        print("param-\(param)-")
        
        param["expires_date"] = "0"
        param["original_purchase_date"] = "0"
        param["json"] = "0"
        
        param["pending_renewal_info"] = ""
        param["expiration_intent"] = ""
        
        var expiration_intent = ""
        
        param["pending_renewal_info_any"] = "Harish-[\(String(describing: pending_renewal_info_any))]-Harish-[\(pending_renewal_info_any)]-Harish"//.base64()
        
        if pending_renewal_info != nil {
            param["pending_renewal_info"] = pending_renewal_info
            
            for i in 0..<pending_renewal_info!.count {
                if let dt = pending_renewal_info![i] as? NSDictionary {
                    //param["expiration_intent"] = dt.string("expiration_intent")
                    
                    if expiration_intent.count == 0 {
                        expiration_intent = dt.string("expiration_intent")
                    } else {
                        expiration_intent = "\(expiration_intent),\(dt.string("expiration_intent"))"
                    }
                }
            }
        }
        
        param["expiration_intent"] = expiration_intent
        //param["expiration_intent"] = "342"
        param["expires_date"] = expires_date
        param["original_purchase_date"] = original_purchase_date
        param["json"] = json
        
        if param["uid"] == nil {
            param["uid"] = "0"
        }
        
        if param["latitude"] == nil {
            param["latitude"] = "0"
        }
        
        if param["longitude"] == nil {
            param["longitude"] = "0"
        }
        
        param["reciept_data"] = "reciept_data"
        
        //writeTextToFile("\(param)")
        
        if let receiptPath = Bundle.main.appStoreReceiptURL?.path {
            if FileManager.default.fileExists(atPath: receiptPath) {
                do {
                    let receiptData = try Data(contentsOf: Bundle.main.appStoreReceiptURL!)
                    
                    param["reciept_data"] = receiptData.base64EncodedString()
                } catch {
                    param["reciept_data"] = "try catch"
                }
            }
        }
        
        param["reciept_data"] = "catch out"
        
        param["apple_reciept_data"] = "apple_reciept_data"
        
        if receiptresponce != nil {
            param["apple_reciept_data"] = receiptresponce
        }
        
        param["apple_reciept_data"] = "apple_reciept_data"
        
        //param["reciept_data"] = "try catch"
        //param["apple_reciept_data"] = "apple_reciept_data"
        //param["pending_renewal_info_any"] = "pending_renewal_info_any"
        //param["json"] = "json"
        
        let para = params()
        para["user_id"] = param["uid"]
        para["stripe_id"] = ""
        
        para["amount"] = "4.99"
        
        para["plan_id"] = "weekly" // (weekly,yearly,daily),
        para["plan_name"] = "Weekly Subscription" // (Weekly Subscription,Yearly Subscription,Daily Plan),
        para["order_id"] = last.string("transaction_id")
        para["subscription_id"] = last.string("subscription_group_identifier")
        
        para["end_date"] = date.timeStamp() //expires_date
        para["freeday"] = "0"
        
        if last.string("is_trial_period") == "true" {
            para["is_trail"] = "1"
            para["start_date"] = date.startDate (true)
        } else {
            para["start_date"] = date.startDate (false)
            para["is_trail"] = "0"
        }
        
        para["payment_status"] = "completed" // ('pending', 'completed', 'failed')
        
        /*Http.instance().json(api_new_save_subscription_data, para, "POST", aai: false, popup: false, prnt: true, nil, nil, sync: false, defaultCalling: true) { (json, para, ss, ht, data) in
            print("1 Harish json-\(json)-")
            
            DispatchQueue.global().async {
                Http.instance().json(api_save_purchase_history, param, "POST", aai: false, popup: false, prnt: true, nil, nil, sync: false, defaultCalling: true) { (json, para, ss, ht, data) in
                    print("2 Harish json-\(json)-")
                }
            }
        }*/
    }
    
    func verifyReceipt(completion: @escaping (VerifyReceiptResult) -> Void) {
        SwiftyStoreKit.verifyReceipt(using: appleValidator, completion: completion)
    }
}

//let appleValidator = AppleReceiptValidator(service: .sandbox, sharedSecret: "0ce1f883a9904f6c8b987ed3c2e55a00")
let appleValidator = AppleReceiptValidator(service: .production, sharedSecret: "0ce1f883a9904f6c8b987ed3c2e55a00")

func receiptValidation () {
    
}

func receiptValidation1 () {
    /*var error: NSError?
    
    if let receiptPath = Bundle.main.appStoreReceiptURL?.path {
        if FileManager.default.fileExists(atPath: receiptPath) {
            do {
                let receiptData = try Data(contentsOf: Bundle.main.appStoreReceiptURL!)
                
                let receiptDictionary = ["receipt-data" : receiptData.base64EncodedString(),
                                         "password" : "0ce1f883a9904f6c8b987ed3c2e55a00"
                ]
                
                let md = NSMutableDictionary(dictionary: receiptDictionary)
                
                let requestData = try JSONSerialization.data(withJSONObject: receiptDictionary, options: JSONSerialization.WritingOptions.prettyPrinted)
                
                let storeURL = NSURL(string: "https://sandbox.itunes.apple.com/verifyReceipt")!
     
            } catch {
                
            }
        }
    }*/
    
    if let appStoreReceiptURL = Bundle.main.appStoreReceiptURL,
        FileManager.default.fileExists(atPath: appStoreReceiptURL.path) {
        
        do {
            let receiptData = try Data(contentsOf: appStoreReceiptURL, options: .alwaysMapped)
            print(receiptData)
            
            let receiptString = receiptData.base64EncodedString(options: [])
            
            let receiptDictionary = ["receipt-data" : receiptString,
                                     "password" : "0ce1f883a9904f6c8b987ed3c2e55a00"
            ]
            
            let md = NSMutableDictionary(dictionary: receiptDictionary)
            
            let requestData = try JSONSerialization.data(withJSONObject: receiptDictionary, options: JSONSerialization.WritingOptions.prettyPrinted)
            
            //https://buy.itunes.apple.com/verifyReceipt
            Http.instance().json("https://sandbox.itunes.apple.com/verifyReceipt", md, "POST", aai: false, popup: false, prnt: false, nil, nil, sync: false, defaultCalling: true) { (json, para, ss, ht, data) in
             
                print("Harish chandra ganagavane-\(json)-")
             }
            // Read receiptData
        }
        catch { print("Couldn't read receipt data with error: " + error.localizedDescription) }
    }
}

extension String {
    func base64 () -> String {
        let str = "iOS Developer Tips encoded in Base64"
        
        let utf8str = str.data(using: .utf8)//dataUsingEncoding(NSUTF8StringEncoding)
        
        if let base64Encoded = utf8str?.base64EncodedString(options: Data.Base64EncodingOptions.init(rawValue: 0)) {
            return base64Encoded
        }
        
        
        
        
        /*if let base64Encoded = utf8str?.base64EncodedStringWithOptions(NSDataBase64EncodingOptions(rawValue: 0)) {
            return base64Encoded
        }*/
        
        return "base64 convert error"
    }
}

extension Date {
    func timeStamp () -> TimeInterval {
        return self.timeIntervalSince1970 * 1000
    }
    
    func startDate (_ boolTrail: Bool) -> TimeInterval {
        var days = -1 * 7
        
        if boolTrail {
            days = -1 * kAppDelegate.purchaseTrailDays
        }
        
        let calendar = Calendar.current
        
        let sDate = calendar.date(byAdding: .day, value: days, to: self)
        
        var start_date = 0
        
        if sDate != nil {
            //start_date = sDate!.getStringDate("yyyy-MM-dd HH:mm:ss z")
            start_date = Int(sDate!.timeStamp())
        }
        
        return TimeInterval(start_date)
    }
}
