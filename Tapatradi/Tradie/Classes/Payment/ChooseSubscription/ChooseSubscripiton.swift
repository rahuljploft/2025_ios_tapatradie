//
//  ChooseSubscripiton.swift
//  Tradie
//
//  Created by mac on 26/06/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import StoreKit
var freeTrial = 0
class ChooseSubscripiton: BaseVC, UITableViewDataSource, UITableViewDelegate, UpdatePurchase, CancelSubscritpion, cancelFinalPopup, PaymentLogout {
    
    func logoutPayment() {
        kAppDelegate.logout (self)
    }
    
    
    
    
    
    func updatePurchase() {
        getSubcriptionDetailsFromServer()
    }
    
    @IBOutlet weak var tabView: TabBarView!
    @IBOutlet weak var viewCancel: UIView!
    @IBOutlet weak var tblSubscription: UITableView!
    @IBOutlet weak var btnSubmit: UIButton!
    
    @IBOutlet weak var shimerView: UIView!
       @IBOutlet weak var viewOne: UIView!
       @IBOutlet weak var viewTwo: UIView!
       @IBOutlet weak var viewThree: UIView!
       @IBOutlet weak var viewFour: UIView!
       @IBOutlet weak var viewFive: UIView!
       @IBOutlet weak var viewSix: UIView!
       @IBOutlet weak var viewSev: UIView!
       
       



    
    
    
    
    var selectedIndex = -1
    var subscriptionListModel : SubscriptionListModel?
    var delegate:UpdatePurchase!
    
    
    
    
    @IBOutlet weak var viewCancelCard: UIView!
    
    @IBOutlet weak var headerView: HeaderView!
    @IBOutlet weak var aiPurchase: UIActivityIndicatorView!
    @IBOutlet weak var lblSubscriptionTrial: UILabel!
    @IBOutlet weak var activityViewC: UIView!
    @IBOutlet weak var viewFreeAdvert: UIView!
    @IBOutlet weak var lbl_getsgo: UILabel!
    @IBOutlet weak var lblWelcome: UILabel!
    @IBOutlet weak var lblMembershipPlan: UILabel!
    @IBOutlet weak var tabBarView: TabBarView!
    @IBOutlet weak var onOffButton: OnlineOfflineButton!
    @IBOutlet weak var HeightValue: NSLayoutConstraint!
    @IBOutlet weak var btnChoosePlanFree: UIButton!
    @IBOutlet weak var btnCancelSubcription: UIButton?
    @IBOutlet weak var viewOnlineOfflineRightCross: UIView!
    @IBOutlet weak var viewOblineOfflineRightCrossInner: UIView!
    @IBOutlet weak var lblNextRenewDate: UILabel!
    
    @IBOutlet weak var cancelBtnHeight: NSLayoutConstraint!
    @IBOutlet weak var cancelPopHeight: NSLayoutConstraint!
    
    @IBOutlet weak var lbl_DEtail: UILabel!
    var planID = ""
    var countTabl = 0
    
    var isFromRegister = false
    var isFreePlan = false
    var boolDeviceUser = false
    var (iOSSubscritpion, androidSubscription, stripeSubscription) = (false, false, false)
    var subscriptionId = ""
    var endDate = ""
    var boolFromMenu = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        print("Here")
        
        
        cancelPopHeight.constant = 0
        if cancelStatusVal.contains("cancel") || cancelStatusVal == "cancel" {
            cancelBtnHeight.constant = 0
            cancelPopHeight.constant = 325
            
            lbl_DEtail.text = "You have already cancelled your Tapatradie Premium Subscription which will end on \(endDate).\n\nTill then you can access leads/jobs. When your subscription ends you will no longer access the leads/jobs and your advert will convert in Free Advert.\n\nYou can again subscribe once your current billing cycle end means after \(endDate).\n\nWe hope to welcome you back soon!"
            viewCancelCard.layer.cornerRadius = 15
            viewCancelCard.layer.shadowColor = UIColor.gray.cgColor
            viewCancelCard.layer.shadowRadius = 2
            viewCancelCard.layer.shadowOffset = .zero
            viewCancelCard.layer.shadowOpacity = 0.5
            
        }else{
            cancelBtnHeight.constant = 50
            cancelPopHeight.constant = 0
        }
        
        viewCancel.layer.cornerRadius = 25
        viewCancel.clipsToBounds = true
        tblSubscription.dataSource = self
        tblSubscription.delegate = self
        btnSubmit.layer.cornerRadius = btnSubmit.frame.height/2
        
        NotificationCenter.default.addObserver( self, selector: #selector(applicationWillEnterForeground(_:)), name: UIApplication.willEnterForegroundNotification, object: nil)
        showShimmer()
        getSubcriptionDetailsFromServer()
    }
    
    
    
    func showShimmer() {
        shimerView.isHidden = false
        viewOne.startShimmeringEffect()
        viewTwo.startShimmeringEffect()
        viewThree.startShimmeringEffect()
        viewFour.startShimmeringEffect()
        viewFive.startShimmeringEffect()
        viewSix.startShimmeringEffect()
        viewSev.startShimmeringEffect()
        
        viewOne.layer.cornerRadius = 8
        viewTwo.layer.cornerRadius = 8
        viewThree.layer.cornerRadius = 8
        viewFour.layer.cornerRadius = 8
        viewFive.layer.cornerRadius = 8
        viewSix.layer.cornerRadius = 8
        viewSev.layer.cornerRadius = 8
    }
    
    func hideShimmer() {
        shimerView.isHidden = true
        viewOne.stopShimmeringEffect()
        viewTwo.stopShimmeringEffect()
        viewThree.stopShimmeringEffect()
        viewFour.stopShimmeringEffect()
        viewFive.stopShimmeringEffect()
        viewSix.stopShimmeringEffect()
        viewSev.stopShimmeringEffect()
    }
 
 
 
 
    
    
    @objc func applicationWillEnterForeground(_ notification: NSNotification) {
        print("Enter applicationWillEnterForeground")
        //purchaseDetailsFromIAP()
        getSubcriptionDetailsFromServer()
    }
    
    func cancelStripeSubscription(){
        Http.startActivityIndicator()
        let user = UserDefaults.standard
        let token = user.object(forKey: KEY_ACCESSTOEKN) as? String
        let userId = Key_User_id.getUserValue()
        let param = [
            "device_id":"\(UIDevice.current.identifierForVendor!.uuidString)_provider",
            "device_type":"2",
            "api_key":"$2a$06$hsTL2DeUKS5pUV.YlY/CSuVesppz0ha4hZdcsB7gN8VKRQRBwKct6",
            "access_token":token!,
            "uid":userId!,
            "subscription_id":self.subscriptionId
        ] as [String:Any]
        
        Http.instance().json(api_cancel_current_subscription, self.params(), "POST", aai: true, popup: true, prnt: true, nil, nil, sync: false, defaultCalling: true) { (json, para, ss, ht, data) in
            if let json = json as? NSDictionary {
                if let success = json["success"] as? Int {
                    if success == 1 {
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AfterSubscriptionCancel_VC") as! AfterSubscriptionCancel_VC
                        vc.modalPresentationStyle = .overFullScreen
                        vc.delegate = self
                        self.present(vc, animated: false)
                    }else{
                        DispatchQueue.main.async {
                            if let msg = json["message"] as? String {
                                let alert = UIAlertController(title: "Tap A Tradie", message: "\(msg)", preferredStyle: .alert)
                                alert.addAction(UIAlertAction(title: "OK", style: .cancel))
                                self.present(alert, animated: true)
                            }
                        }
                    }
                    
                }
            }
            Http.stopActivityIndicator()
        }
    }
    
    func finalCancel() {
        DispatchQueue.main.async {
            let story = UIStoryboard(name: "Home", bundle: nil)
            let vc = story.instantiateViewController(withIdentifier: "PaymentScreenVC") as! PaymentScreenVC
            vc.modalPresentationStyle = .overFullScreen
            vc.delegate = self
            vc.delegateLogout = self
            self.present(vc, animated: false)
        }
    }
    
    @IBAction func Actino_TermsCondition(_ sender: UIButton) {
        "https://www.tapatradie.com/terms-conditions".openAsUrl()
    }
    @IBAction func Actino_PrivacyPolicy(_ sender: UIButton) {
        "https://www.tapatradie.com/privacy-policy".openAsUrl()
    }
    
    
    func params () -> NSMutableDictionary {
        let md = NSMutableDictionary()
        md["device_id"] = "\(UIDevice.current.identifierForVendor!.uuidString)_provider"
        md["device_type"] = "2"
        md["api_key"] = "$2a$06$hsTL2DeUKS5pUV.YlY/CSuVesppz0ha4hZdcsB7gN8VKRQRBwKct6"
        md["subscription_id"] = self.subscriptionId
        //md["role"] = "provider"
        let user = UserDefaults.standard
        
        if let token = user.object(forKey: KEY_ACCESSTOEKN) as? String {
            md["access_token"] = token
        }
        
        let userId = Key_User_id.getUserValue()
        
        if userId != nil {
            md["uid"] = userId!
        }
        return md
    }
    
    
    
    
    @IBAction func actionSubmit(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "CancelSubscriptionPopUp_VC") as! CancelSubscriptionPopUp_VC
        vc.delegate = self
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true)
    }
    
    func cancelSubscriptionDele() {
  
        
        if planID == "tradie.com.purchase.threemonthsplan_withoutfreetrial" || planID == "tradie.com.purchase.sixmonthsplan_withoutfreetrial" || planID == "tradie.com.purchase.oneyearplan_withoutfreetrial"  {
            DispatchQueue.main.async {
                UIApplication.shared.open(URL(string: "https://apps.apple.com/account/subscriptions")!, options: [:]) { value in
                    print(value)
                    self.getSubcriptionDetailsFromServer()
                }
            }
        }else{
            cancelStripeSubscription()
        }
    }
    
    
    
    //MARK: In App Cancel Subscription Cancel Process---------- Start
    func verifyReceipt(completion: @escaping (VerifyReceiptResult) -> Void) {
        SwiftyStoreKit.verifyReceipt(using: appleValidator, completion: completion)
    }
    
    func purchaseDetailsFromIAP () {
        let mdReceptQuery = NSMutableDictionary()
        verifyReceipt { (result) in
            switch result {
            case .success(let receipt):
                DispatchQueue.main.async {
                    print(receipt)
                    mdReceptQuery["success receipt"] = "-\(receipt)-"
                    self.verifyReceiptJsonFromServer(receipt as NSDictionary, mdReceptQuery)
                }
            case .error(let error):
                print("Verify receipt Failed: \(error)")
            }
        }
    }
    
    func verifyReceiptJsonFromServer (_ receipt: NSDictionary, _ mdQuery: NSMutableDictionary) {
        if let pending_renewal_info = receipt["pending_renewal_info"] as? NSArray {
            print("pending_renewal_info-\(pending_renewal_info.count)-")
        }
        if let latest_receipt_info = receipt["latest_receipt_info"] as? NSArray {
            for i in 0..<latest_receipt_info.count {
                if let last = latest_receipt_info[i] as? NSDictionary {
                    let time = last.number("expires_date_ms").doubleValue
                    kAppDelegate.setOriginalTransactionId(last.string("original_transaction_id"))
                    let date = Date.init(timeIntervalSince1970: time/1000)
                    let date1 = Date()
                    let int = date1.timeIntervalSince(date)
                    print("Expiry  date-[\(date)]-Current-[\(date1)]-[\(last.number("original_transaction_id"))]-[\(int)]-")
                    if int > 0 {
                        print("Empty")
                    } else {
                        self.sendPurchaseDataToServer(receipt, last)
                        break
                    }
                }
            }
        }
        Http.stopActivityIndicator()
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
            self.getSubcriptionDetailsFromServer()
        }
    }
    
    
    //MARK: In App Cancel Subscription Cancel Process---------- End
    
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countTabl
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SubscriptionListCell") as! SubscriptionListCell
        if selectedIndex == indexPath.row {
            cell.viewCard.layer.cornerRadius = 12
            cell.viewCard.layer.borderColor = UIColor.systemOrange.cgColor
            cell.viewCard.layer.borderWidth = 2
        }else{
            cell.viewCard.layer.cornerRadius = 12
            cell.viewCard.layer.shadowRadius = 2
            cell.viewCard.layer.shadowOpacity = 0.5
            cell.viewCard.layer.shadowOffset = .zero
            cell.viewCard.layer.shadowColor = UIColor.lightGray.cgColor
        }
        
        
        cell.viewImage.layer.cornerRadius = cell.viewImage.frame.height/2
        
        
        
        cell.imgLogo.image = UIImage(named: "\(indexPath.row + 1)")
        if planID == "price_1MUp7kHKYdiVnQytVz3ijwV4" || planID == "tradie.com.purchase.threemonthsplan_withoutfreetrial" ||  planID == "price_1MYT4aHKYdiVnQytWUlbfuCY"  {
            cell.lblSubscrptionTitle.text = "3 Months"
            cell.lblAmount.text = "$64.99"
            cell.lblDetail.text = "Bronze"
            cell.lbl_DEtailtxt.text = ""
            cell.hideCard.isHidden = true
        } else if planID == "price_1MUrPMHKYdiVnQytJDVpRhbx" || planID == "tradie.com.purchase.sixmonthsplan_withoutfreetrial"  {
            cell.lblSubscrptionTitle.text = "6 Months"
            cell.lblAmount.text = "$119.99"
            cell.lblDetail.text = "Silver"
            cell.lbl_DEtailtxt.text = "More cost effective than the Bronze"
            cell.hideCard.isHidden = false
        } else if planID == "price_1MUrR7HKYdiVnQytLsDWoAYO" || planID == "tradie.com.purchase.oneyearplan_withoutfreetrial"  {
            cell.lblSubscrptionTitle.text = "12 Months"
            cell.lblAmount.text = "$219.99"
            cell.lblDetail.text = "Gold"
            cell.lbl_DEtailtxt.text = "More cost effective than the Silver"
            cell.hideCard.isHidden = false
        } else if planID == "price_1MUs79HKYdiVnQytgDrcPP9I"{
            cell.lblSubscrptionTitle.text = "1 Day"
            cell.lblAmount.text = "$1"
            cell.lblDetail.text = "For One Day"
            cell.imgLogo.image = UIImage(named: "1")
            cell.lbl_DEtailtxt.text = "More cost effective than the Silver"
            cell.hideCard.isHidden = true
        }
    
        cell.lblDueDate.text = "Next renew date is \(endDate)"
        
        return cell
    }
    
  
    
    func getSubcriptionDetailsFromServer () {
        kAppDelegate.boolPurchasedFromIAP = true
        Http.instance().json(api_get_current_subscription, params(), "POST", aai: true, popup: true, prnt: true, nil, nil, sync: false, defaultCalling: true) { (json, para, ss, ht, data) in
            var boolData = false
            if let json = json as? NSDictionary {
                print("json \(json)")
                if let data = json["data"] as? NSDictionary {
                    let isFebVal = data.number("isFab")
                    print("isFeb == ",isFebVal)
                    if isFebVal == 0 {
                        isFeb = 0
                        self.view.isHidden = false
                    }else if isFebVal == 1 {
                        isFeb = 1
                        self.view.isHidden = false
//                        DispatchQueue.main.async {
//                            let story = UIStoryboard(name: "Home", bundle: nil)
//                            let vc = story.instantiateViewController(withIdentifier: "PaymentScreenVC") as! PaymentScreenVC
//                            vc.modalPresentationStyle = .overFullScreen
//                            vc.delegate = self
//                            vc.delegateLogout = self
//                            self.present(vc, animated: false)
//                        }
                    }else{
                        self.view.isHidden = false
                        isFeb = 0
                    }
                    
                    let timestampVAL = data.string("end_date")
                    let statusVAL = data.string("status")
                    if timestampVAL.count > 0 && (statusVAL != "end") {
                        let time = data.number("end_date").doubleValue
                        var date: Date = Date()
                        if timestampVAL.count == 13 {
                            date = Date.init(timeIntervalSince1970: time/1000)
                        } else {
                            date = Date.init(timeIntervalSince1970: time)
                        }
                        let date1 = Date()
                        let int = date1.timeIntervalSince(date)
                        if int > 0 {
                            subscriptionStatus = false
                            self.navigationController?.popViewController(animated: true)
                        } else {
                            subscriptionStatus = true
                        }
                    }else{
                        subscriptionStatus = false
                        self.navigationController?.popViewController(animated: true)
                    }
                    
                    
                    let cancelStatus = data.string("status")
                    print(cancelStatus)
                    cancelStatusVal = "\(cancelStatus)"
                    
                    DispatchQueue.main.async {
                        self.hideShimmer()
                        if cancelStatusVal.contains("cancel") || cancelStatusVal == "cancel" {
                            self.cancelBtnHeight.constant = 0
                            self.cancelPopHeight.constant = 325
                            self.viewCancelCard.layer.cornerRadius = 15
                            self.viewCancelCard.layer.shadowColor = UIColor.gray.cgColor
                            self.viewCancelCard.layer.shadowRadius = 2
                            self.viewCancelCard.layer.shadowOffset = .zero
                            self.viewCancelCard.layer.shadowOpacity = 0.5
                        }else{
                            self.cancelBtnHeight.constant = 50
                            self.cancelPopHeight.constant = 0
                        }
                    }
                    
                    self.tabView.isHidden = false
                    self.planID = data.string("plan_id")
                    self.subscriptionId = data.string("subscription_id")
                    let time = data.string("end_date") as? String
                    if let timeResult = (Double(time ?? "0")) {
                        let date = Date(timeIntervalSince1970: timeResult)
                        let dateFormatter = DateFormatter()
                        dateFormatter.timeStyle = DateFormatter.Style.medium //Set time style
                        dateFormatter.dateStyle = DateFormatter.Style.medium //Set date style
                        dateFormatter.timeZone = .current
                        let localDate = dateFormatter.string(from: date)
                        //self.endDate = "\(date)".components(separatedBy: "at")
                        //print(self.endDate[0])
                    }
                    let timestamp = data.string("end_date")
                    if timestamp.count > 0 {
                        let time = data.number("end_date").doubleValue
                        var date: Date = Date()
                        if timestamp.count == 13 {
                            date = Date.init(timeIntervalSince1970: time/1000)
                        } else {
                            date = Date.init(timeIntervalSince1970: time)
                        }
                        let date1 = Date()
                        print("Expiry date-[\(date)]-current-[\(date1)]")
                        
                        let dateNew = "\(date)".components(separatedBy: " ")
                        print(date)
                        var finaldate = dateNew[0]
                        print(finaldate)
                        //self.endDate =
                        
                        let newFinal = "\(finaldate)".components(separatedBy: "-")
                        print("\(newFinal[2])-\(newFinal[1])-\(newFinal[0])")
                        self.endDate = "\(newFinal[2])-\(newFinal[1])-\(newFinal[0])"
                        print(self.endDate)
                    }
                    
                    
                    DispatchQueue.main.async {
                        
                        self.lbl_DEtail.text = "You have already cancelled your Tapatradie Premium Subscription which will end on \(self.endDate).\n\nTill then you can access leads/jobs. When your subscription ends you will no longer access the leads/jobs and your advert will convert in Free Advert.\n\nYou can again subscribe once your current billing cycle end means after \(self.endDate).\n\nWe hope to welcome you back soon!"

                    }
                    
                    
                    
                    self.countTabl = 1
                    self.tblSubscription.reloadData()
                }else{
                    print("Not Purchased 2")
                    DispatchQueue.main.async {
                        self.navigationController?.popViewController(animated: true)
//                        let story = UIStoryboard(name: "Home", bundle: nil)
//                        let vc = story.instantiateViewController(withIdentifier: "PaymentScreenVC") as! PaymentScreenVC
//                        vc.modalPresentationStyle = .overFullScreen
//                        vc.delegate = self
//                        vc.delegateLogout = self
//                        self.present(vc, animated: false)
                    }
                }
                
                
                if let paymentSetting = json["paymentSetting"] as? Int {
                    print("paymentSetting",paymentSetting)
                    if paymentSetting == 1 {
                        paymentSettingStatus = true
                    }else{
                        subscriptionStatus = true
                        paymentSettingStatus = false
                    }
                        
                }
                print("paymentSettingStatus : ",paymentSettingStatus)
                
            }else{
                DispatchQueue.main.async {
                    self.hideShimmer()
                }
                
                print("Not Purchased")
            }
        }
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        // START 30 DAYS FREE TRAIL
//        // SUBSCRIBE NOW
//        // left-arrow
//        headerView.updateData()
//        setOnlineOfflineImage ()
//
//        //SARJAN Comment
//
//        let obc = kAppDelegate.boolIAPPurchased ()
//        print("obc-\(obc)-")
//        verifyNow ()
//        if kAppDelegate.boolSubscriptionExpired {
//            self.lblNextRenewDate.isHidden = true
//            self.btnPurchaseWeekly.isHidden = false
//            self.lblSubscriptionTrial.text = "30 days free trial for new sign up. After that weekly subscription of AUD $4.99 charged"
//            if obc.date == nil {
//                verifyNow ()
//            } else {
//                self.setSubscriptionButtonTitle (obc.date)
//            }
//        } else {
//            self.lblNextRenewDate.isHidden = false
//            self.btnPurchaseWeekly.isHidden = true
//            self.lblSubscriptionTrial.text = ""
//        }
//        self.updateCancelSubcriptionButton ()
//        self.lblNextRenewDate.isHidden = false
//        self.btnPurchaseWeekly.isHidden = true
//        self.lblSubscriptionTrial.text = ""
//        self.btnCancelSubcription?.isHidden = true
//
//    }

    @IBAction func actionOnlineOffline(_ sender: Any) {
//        var online = Key_User_online.getUserValue()
//        if online == nil {
//            Key_User_online.setUserValue("0")
//            online = "0"
//        }
//        if "\(online!)" == "1" {
//            actionRightOnlineOffline("")
//        } else {
//            viewOnlineOfflineRightCross.frame = self.view.bounds
//            self.view.addSubview(viewOnlineOfflineRightCross)
//        }
    }

    @IBAction func actionCancelSubcription (_ sender: Any) {
//        if self.iOSSubscritpion{
//            if let url = URL(string: "https://apps.apple.com/account/subscriptions") {
//                UIApplication.shared.open(url, options: [:], completionHandler: nil)
//            }
//        }else if self.androidSubscription{
//            if let url = URL(string: "https://play.google.com/store/account/subscriptions?sku=new_tradie_weekly&package=com.si.tradie") {
//                UIApplication.shared.open(url, options: [:], completionHandler: nil)
//            }
//        }else if self.stripeSubscription{
//            cancelStripeSubscription()
//        }
    }
    
    @IBAction func actionCrossOnlineOffline(_ sender: Any) {
        viewOnlineOfflineRightCross.removeFromSuperview()
    }
    
    
    
    
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//        if isFromRegister == true{
//            self.tabBarView.isTabBarHidden = true
//            self.tabBarView.isHidden = true
//        }else{
//            self.tabBarView.isTabBarHidden = false
//            self.tabBarView.isHidden = false
//        }
//    }
    
//    func updateCancelSubcriptionButton () {
//        DispatchQueue.main.async {
//            self.btnCancelSubcription?.isHidden = !self.btnPurchaseWeekly.isHidden
//            //self.lblNextRenewDate.isHidden = self.btnPurchaseWeekly.isHidden
//            self.btnChoosePlanFree.isHidden = self.btnPurchaseWeekly.isHidden
//            self.lbl_getsgo.isHidden = self.btnPurchaseWeekly.isHidden
//            if self.btnCancelSubcription?.isHidden == true {
//                self.HeightValue.constant = 290
//                self.lblMembershipPlan.text = "Membership"
//            }else{
//                self.HeightValue.constant = 250
//
//                self.lblMembershipPlan.text = "My Membership"
//            }
//
//            //            if kAppDelegate.boolSubscriptionExpired == false && kAppDelegate.boolPurchasedFromIAP == false {
//            //                self.btnCancelSubcription?.isHidden = true
//            //            }
//            //Comment Sarjan for test
//            //            if self.boolDeviceUser == false {
//            //                self.btnCancelSubcription?.isHidden = true
//            //                self.btnPurchaseWeekly.isHidden = true
//            //            }
//        }
//    }
    
//    func showSubscriptionPopup (_ title: String, _ msg: String) {
//        AlertView.instance.present(title, msg) { (result) in
//            if result == "actionSendReceiptToServer" {
//                let md = NSMutableDictionary()
//
//                var recpt = "receipt not available"
//
//                if let receiptFileURL = Bundle.main.appStoreReceiptURL {
//                    let receiptData = try? Data(contentsOf: receiptFileURL)
//
//                    if let recieptString = receiptData?.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0)) {
//                        recpt = recieptString
//                    }
//                }
//
//                md["receipt"] = recpt
//
//                //self.saveReceiptDataToServer (md)
//            }
//
//        }
//    }
//
//    override func viewDidDisappear(_ animated: Bool) {
//
//    }
    
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//    }
    
//    @IBAction func actionWeeklySubcription (_ sender: Any) {
//        purchase()
//    }
    
//    func purchase() {
//        Http.startActivityIndicator()
//        self.startAIPurchasing ()
//        var productId = ""
//        if freeTrial == 1 {
//            //MARK: 30 Day Free Trial
//            productId = "tradie.com.purchase.weekly"
//        }else{
//            //MARK: Without Free Trial
//            productId = "one_week_tradiw"
//        }
//        SwiftyStoreKit.purchaseProduct("\(productId)", atomically: true) { result in
//            //Http.stopActivityIndicator()
//            //self.stopAIPurchased()
//            //MARK: Himanshu (Result After Purchase)
//            print("result-\(result)-")
//            if case .success(let purchase) = result {
//                switch purchase.transaction.transactionState {
//                case .purchased:
//                    let downloads = purchase.transaction.downloads
//                    if !downloads.isEmpty {
//                        print("51HCG-\(purchase.transaction.transactionState.debugDescription): \(purchase.productId)")
//                        SwiftyStoreKit.start(downloads)
//                    } else if purchase.needsFinishTransaction {
//                        print("52HCG-\(purchase.transaction.transactionState.debugDescription): \(purchase.productId)")
//                        // Deliver content from server, then:
//                        SwiftyStoreKit.finishTransaction(purchase.transaction)
//                    } else {
//                        print("53HCG-\(purchase.transaction.transactionState.debugDescription): \(purchase.productId)")
//                    }
//                    //self.verifyNow ()
//                case .restored:
//                    let downloads = purchase.transaction.downloads
//                    if !downloads.isEmpty {
//                        print("511HCG-\(purchase.transaction.transactionState.debugDescription): \(purchase.productId)")
//                        SwiftyStoreKit.start(downloads)
//                    } else if purchase.needsFinishTransaction {
//                        print("521HCG-\(purchase.transaction.transactionState.debugDescription): \(purchase.productId)")
//                        // Deliver content from server, then:
//                        SwiftyStoreKit.finishTransaction(purchase.transaction)
//                    } else {
//                        print("531HCG-\(purchase.transaction.transactionState.debugDescription): \(purchase.productId)")
//                    }
//                    //self.verifyNow ()
//                case .failed, .purchasing, .deferred:
//                    break // do nothing
//                @unknown default:
//                    break // do nothing
//                }
//                let downloads = purchase.transaction.downloads
//                if !downloads.isEmpty {
//                    SwiftyStoreKit.start(downloads)
//                }
//                // Deliver content from server, then:
//                if purchase.needsFinishTransaction {
//                    SwiftyStoreKit.finishTransaction(purchase.transaction)
//                }
//            }
//            self.verifyNow ()
//        }
//    }
    
//    func verifyNow () {
//        Http.startActivityIndicator()
//        self.startAIPurchasing ()
//
//        let date1 = Date()
//
//        verifyReceipt { (result) in
//            Http.stopActivityIndicator()
//            self.stopAIPurchased()
//
//            switch result {
//            case .success(let receipt):
//                //print("Verify receipt Success: \(receipt)")
//
//                if let latest_receipt_info = receipt["latest_receipt_info"] as? NSArray {
//                    print(latest_receipt_info)
//                    var boolPurchased = false
//
//                    for i in 0..<latest_receipt_info.count {
//                        if let last = latest_receipt_info[i] as? NSDictionary {
//                            let time = last.number("expires_date_ms").doubleValue
//                            kAppDelegate.setOriginalTransactionId(last.string("original_transaction_id"))
//                            let date = Date.init(timeIntervalSince1970: time/1000)
//                            print("Expiry date-[\(date)]-current-[\(date1)]")
//                            let int = date1.timeIntervalSince(date)
//                            if int > 0 {
//
//                            } else {
//                                //self.setSubscriptionButtonTitle (date)
//                                kAppDelegate.setPurchasedDate (time)
//                                boolPurchased = true
//                                self.sendPurchaseDataToServer(receipt as NSDictionary, last)
//                                if kAppDelegate.allowTestingPopup() {
//                                    self.showSubscriptionPopup ("Popup 1", "-[\(date)]-[\(date1)]-[\(receipt)]-")
//                                }
//                                break
//                            }
//                        }
//
//                        if boolPurchased {
//                            break
//                        }
//                    }
//
//                    /*
//                    if boolPurchased == false {
//
//                        if let last = latest_receipt_info.lastObject as? NSDictionary {
//
//                            print("2last-\(last)-")
//
//                            //Http.alert("latest_receipt_info 2", "latest_receipt_info-[\(last)]-")
//
//                            let time = last.number("expires_date_ms").doubleValue
//
//                            kAppDelegate.setPurchasedDate (time)
//
//                            print("time-\(time)-")
//                            //date-2020-01-11 13:23:39 +0000-
//
//                            let date = Date.init(timeIntervalSince1970: time/1000)
//
//                            self.setSubscriptionButtonTitle (date)
//
//                            if kAppDelegate.allowTestingPopup() {
//                                self.showSubscriptionPopup ("Popup 2", "-[\(date)]-[\(date1)]-[\(receipt)]-")
//                            }
//                        } else {
//                            if kAppDelegate.allowTestingPopup() {
//                                self.showSubscriptionPopup ("Popup 3", "-[\(receipt)]-")
//                            }
//                        }
//                    }
//                    */
//
//
//                } else {
//
//                    if kAppDelegate.allowTestingPopup() {
//                        self.showSubscriptionPopup ("Popup 4", "-[\(receipt)]-")
//                    }
//                    DispatchQueue.main.async {
//                        self.setSubscriptionButtonTitle(nil)
//                    }
//
//                }
//
//                break
//            case .error(let error):
//                Http.stopActivityIndicator()
//                self.stopAIPurchased()
//
//                if kAppDelegate.allowTestingPopup() {
//                    self.showSubscriptionPopup ("Popup 5", "-[\(result)]-")
//                }
//
//                print("Verify receipt Failed: \(error)")
//            }
//        }
//    }
    
//    func sendPurchaseDataToServer (_ receipt: NSDictionary, _ dt: NSDictionary) {
//        /*"expires_date_pst": "2020-07-17 06:19:29 America/Los_Angeles",
//         "purchase_date": "2020-07-17 13:16:29 Etc/GMT",
//         "purchase_date_ms": "1594991789000",
//         "original_purchase_date_ms": "1594991792000",
//         "transaction_id": "1000000694482460",
//         "original_transaction_id": "1000000551707521",
//         "quantity": "1",
//         "expires_date_ms": "1594991969000",
//         "original_purchase_date_pst": "2020-07-17 06:16:32 America/Los_Angeles",
//         "product_id": "tradie.com.purchase.weekly",
//         "subscription_group_identifier": "20537905",
//         "web_order_line_item_id": "1000000054134178",
//         "expires_date": "2020-07-17 13:19:29 Etc/GMT",
//         "is_in_intro_offer_period": "false",
//         "original_purchase_date": "2020-07-17 13:16:32 Etc/GMT",
//         "purchase_date_pst": "2020-07-17 06:16:29 America/Los_Angeles",
//         "is_trial_period": "false"*/
//
//        print("receipt-[\(receipt)]-")
//
//        let notify_type = "INITIAL_SETUP"
//        let expires_date_ms = dt.number("expires_date_ms").intValue
//        let sevendays = 60 * 60 * 24 * 7
//        let param = params()
//        param["customer_id"] = dt.string("original_transaction_id")
//        kAppDelegate.setOriginalTransactionId(dt.string("original_transaction_id"))
//        param["purchase_start_date"] = expires_date_ms - sevendays
//        param["purchase_end_date"] = expires_date_ms
//        param["sevendays"] = sevendays
//        if dt.string("is_trial_period") == "false" {
//            param["is_trial"] = "0"
//        } else {
//            param["is_trial"] = "1"
//        }
//
//        param["notify_type"] = notify_type
//        param["transaction_id"] = dt.string("transaction_id")
//        param["product_id"] = dt.string("product_id")
//        param["environment"] = receipt.string("environment")
//        param["raw_data"] = "\(receipt)"
//
//        print("api_ios_purchase_membership param-[\(param)]-")
//
//        Http.instance().json(api_ios_purchase_membership, param, "POST", aai: true, popup: false, prnt: true, nil, nil, sync: false, defaultCalling: true) { (json, para, ss, ht, data) in
//            print("3Harish json-\(json)-")
//            self.getSubcriptionDetailsFromServer()
//        }
//    }
    
//    func setSubscriptionButtonTitle (_ date: Date?) {
//        if date != nil {
//            let date = date!
//
//            let date1 = Date()
//
//            print("date-\(date)-")
//
//            let int = date1.timeIntervalSince(date)
//
//            print("int-[\(int)]-")
//
//            //            self.btnPurchaseWeekly.setImage(#imageLiteral(resourceName: "left-arrow"), for: .normal)
//            self.btnPurchaseWeekly.setImage(UIImage(), for: .normal)
//
//            if int > 0 {
//                print("purchase now")
//
//                self.btnPurchaseWeekly.setTitle("SUBSCRIBE NOW", for: .normal)
//
//                //                self.btnPurchaseWeekly.setImage(#imageLiteral(resourceName: "left-arrow"), for: .normal)
//                self.lblNextRenewDate.isHidden = true
//                self.btnPurchaseWeekly.isHidden = false
//                self.lblSubscriptionTrial.text = "30 days free trial for new sign up. After that weekly subscription of AUD $4.99 charged"
//                self.viewFreeAdvert.isHidden = false
//                kAppDelegate.boolSubscriptionExpired = true
//            } else {
//                print("purchased")
//
//                kAppDelegate.boolSubscriptionExpired = false
//                kAppDelegate.setPurchased()
//                self.lblNextRenewDate.isHidden = false
//                self.btnPurchaseWeekly.isHidden = true
//                self.viewFreeAdvert.isHidden = true
//                self.lblSubscriptionTrial.text = ""
//            }
//
//            if kAppDelegate.allowTestingPopup() {
//                showSubscriptionPopup ("Popup 6", "3-pdate-[\(date)]-cdate-[\(date1)]-")
//            }
//
//            lblNextRenewDate.text = "Next renew date : \(date.getStringDate(EXPIRYDATEFORMATE))"
//        } else {
//
//            if kAppDelegate.allowTestingPopup() {
//                showSubscriptionPopup ("Popup 7", "2-[h-date-nil]-")
//            }
//
//            self.btnPurchaseWeekly.setTitle("START \(kAppDelegate.purchaseTrailDays) DAYS FREE TRAIL", for: .normal)
//
//            self.btnPurchaseWeekly.setImage(UIImage(), for: .normal)
//            self.lblNextRenewDate.isHidden = true
//            self.btnPurchaseWeekly.isHidden = false
//            self.lblSubscriptionTrial.text = "30 days free trial for new sign up. After that weekly subscription of AUD $4.99 charged"
//            self.viewFreeAdvert.isHidden = false
//        }
//
//        Http.stopActivityIndicator()
//        self.stopAIPurchased()
//
//        self.updateCancelSubcriptionButton()
//    }
    
  
    @IBAction func actionYearlySubcription(_ sender: Any) {
        
    }
    
    @IBAction func actionRestorePurchases(_ sender: Any) {
        restorePurchases()
    }
    
    func restorePurchases() {
//        Http.startActivityIndicator()
//        self.startAIPurchasing ()
//
//        SwiftyStoreKit.restorePurchases(atomically: true) { results in
//            //Http.stopActivityIndicator()
//            //self.stopAIPurchased()
//
//            for purchase in results.restoredPurchases {
//
//                switch purchase.transaction.transactionState {
//                case .purchased, .restored:
//                    let downloads = purchase.transaction.downloads
//                    if !downloads.isEmpty {
//                        print("51HCG-\(purchase.transaction.transactionState.debugDescription): \(purchase.productId)")
//                        SwiftyStoreKit.start(downloads)
//                    } else if purchase.needsFinishTransaction {
//                        print("52HCG-\(purchase.transaction.transactionState.debugDescription): \(purchase.productId)")
//                        // Deliver content from server, then:
//                        SwiftyStoreKit.finishTransaction(purchase.transaction)
//                    } else {
//                        print("53HCG-\(purchase.transaction.transactionState.debugDescription): \(purchase.productId)")
//                    }
//
//                case .failed, .purchasing, .deferred:
//                    break // do nothing
//                @unknown default:
//                    break // do nothing
//                }
//            }
//
//            self.verifyNow ()
//        }
    }
    
    @IBOutlet weak var btnPurchaseWeekly: UIButton!
    
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
        "https://www.tapatradie.com/terms-conditions".openAsUrl()
    }
    
    @IBAction func actionPrivacyPolicy(_ sender: Any) {
        "https://www.tapatradie.com/privacy-policy".openAsUrl()
    }
    
    
    @IBAction func actionChoosePlan(_ sender: UIButton) {
        
//        if btnChoosePlanFree.currentTitle == ""{
//            return
//        }
        
        if btnChoosePlanFree.tag == 5{
//            tabbarClickedAt(1)
            let vc = story_Tradie.viewController("MyBookings") as! MyBookings
            self.navigationController?.pushViewController(vc, animated: false)
            
//            return
        }else{
            //MARK: Updated By Himanshu
            let vc = story_Tradie.viewController("MyBookings") as! MyBookings
            self.navigationController?.pushViewController(vc, animated: false)
//            let vc = story_Payment.viewController("ChooseSubscripiton") as! ChooseSubscripiton
//            vc.isFromRegister = false
//            vc.isFreePlan = true
//            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        
        
    }
    
    
    @IBAction func actionRightOnlineOffline(_ sender: Any) {
//        viewOnlineOfflineRightCross.removeFromSuperview()
//
//        var online = Key_User_online.getUserValue()
//
//        if online == nil {
//            online = "0"
//            Key_User_online.setUserValue("0")
//        }
//
//        let param = params()
//
//        if "\(online!)" == "1" {
//            param["online"] = "0"
//        } else {
//            param["online"] = "1"
//        }
//
//        Http.instance().json(api_provider_online_status, param, "POST", aai: true, popup: true, prnt: false, nil, nil, sync: false, defaultCalling: false) { (json, para, str, http, data) in
//            let json = json as? NSDictionary
//
//            if json != nil {
//                if json?.number("success").intValue == 1 {
//
//                    if "\(online!)" == "1" {
//                        Key_User_online.setUserValue("0")
//                    } else {
//                        Key_User_online.setUserValue("1")
//                    }
//
//                    DispatchQueue.main.async {
//                        self.setOnlineOfflineImage ()
//                    }
//                }
//
//                //Http.alert("", json?.string("message"))
//            }
//
//            let jsonExp = json as? NSDictionary
//
//            if jsonExp != nil {
//                if jsonExp?.number("success").intValue == SESSIONEXPIRED {
//                    kAppDelegate.sessionExpired(self)
//                    return
//                }
//            }
//        }
    }
}

//MARK: - Subscription verification

//extension ChooseSubscripiton {
//    func startAIPurchasing () {
//        DispatchQueue.main.async {
//            self.aiPurchase.superview?.isHidden = false
//            self.activityViewC.isHidden = false
//            self.aiPurchase.startAnimating()
//            self.btnPurchaseWeekly.isEnabled = false
//
//            self.updateCancelSubcriptionButton ()
//        }
//    }
//
//    func stopAIPurchased () {
//        DispatchQueue.main.async {
//            self.aiPurchase.superview?.isHidden = true
//            self.activityViewC.isHidden = true
//            self.aiPurchase.stopAnimating()
//            self.btnPurchaseWeekly.isEnabled = true
//
//            self.updateCancelSubcriptionButton ()
//        }
//    }
//
//
//
//    /*
//
//    func verifyNow2 () {
//        verifyReceiptH ()
//    }
//
//    func verifyReceiptH () {
//        Http.startActivityIndicator()
//        self.startAIPurchasing ()
//
//        if let receiptFileURL = Bundle.main.appStoreReceiptURL {
//            let receiptData = try? Data(contentsOf: receiptFileURL)
//            if let recieptString = receiptData?.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0)) {
//                let jsonDict: [String: AnyObject] = ["receipt-data" : recieptString as AnyObject, "password" : IAP_Password as AnyObject]
//
//                do {
//                    let requestData = try JSONSerialization.data(withJSONObject: jsonDict, options: JSONSerialization.WritingOptions.prettyPrinted)
//                    let storeURL = URL(string: IAP_URL)!
//                    var storeRequest = URLRequest(url: storeURL)
//                    storeRequest.httpMethod = "POST"
//                    storeRequest.httpBody = requestData
//
//                    let session = URLSession(configuration: URLSessionConfiguration.default)
//                    let task = session.dataTask(with: storeRequest, completionHandler: { [weak self] (data, response, error) in
//
//                        do {
//                            let jsonResponse = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers)
//                            print("=======>",jsonResponse)
//
//                            DispatchQueue.main.async {
//                                if let dt = jsonResponse as? NSDictionary {
//                                    self!.verifyReceiptJson(dt)
//                                } else {
//                                    self!.notPurchsed()
//                                }
//                            }
//                        } catch let parseError {
//                            print(parseError)
//                            self!.notPurchsed()
//                        }
//                    })
//                    task.resume()
//                } catch let parseError {
//                    print(parseError)
//                    self.notPurchsed()
//                }
//            } else {
//                self.notPurchsed()
//            }
//        } else {
//            self.notPurchsed()
//        }
//    }
//
//    func verifyReceiptJson (_ receipt: NSDictionary) {
//        print("HHHH receipt-[\(receipt)]-")
//
//        if let latest_receipt_info = receipt["latest_receipt_info"] as? NSArray {
//            if let last = latest_receipt_info.lastObject as? NSDictionary {
//
//                kAppDelegate.setOriginalTransactionId(last.string("original_transaction_id"))
//
//                print("1last-\(last)-")
//
//                let time = last.number("expires_date_ms").doubleValue
//
//                kAppDelegate.setPurchasedDate (time)
//
//                print("time-\(time)-")
//                //date-2020-01-11 13:23:39 +0000-
//
//                let date = Date.init(timeIntervalSince1970: time/1000)
//                let date1 = Date()
//
//                //Http.alert("latest_receipt_info 2", "-[\(date)]-\n-[\(date1)]-\n-latest_receipt_info-[\(last)]-")
//
//                Http.stopActivityIndicator()
//                self.stopAIPurchased()
//
//                self.setSubscriptionButtonTitle (date)
//            } else {
//                self.notPurchsed ()
//            }
//        } else {
//            self.notPurchsed ()
//        }
//    }
//
//
//
//    func purchsed () {
//        DispatchQueue.main.async {
//            Http.stopActivityIndicator()
//            self.stopAIPurchased()
//
//            print("purchased")
//        }
//    }
//
//    func notPurchsed () {
//        DispatchQueue.main.async {
//            Http.stopActivityIndicator()
//            self.stopAIPurchased()
//
//            self.setSubscriptionButtonTitle(nil)
//            print("purchase now")
//        }
//    }
//
//    */
//
//
//}
//
////extension ChooseSubscripiton: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, TabbarCellDelegate {
////    func setOnlineOfflineImage () {
////        var online = Key_User_online.getUserValue()
////
////        if online == nil {
////            Key_User_online.setUserValue("0")
////            online = "0"
////        }
////    }
////
////    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
////        return kAppDelegate.tabItems().count
////    }
////
////    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
////
////        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TabbarCell", for: indexPath) as! TabbarCell
////        cell.indexPath = indexPath
////        cell.delegate = self
////
////        let dt = kAppDelegate.tabItems()[indexPath.row] as! NSMutableDictionary
////
////        if dt.number("isselected").boolValue {
////            cell.imgCell.image = (dt["selected"] as! UIImage)
////            cell.lblTitle.textColor = UIColor.hexColor(0xEF4136)
////        } else {
////            cell.imgCell.image = (dt["unselected"] as! UIImage)
////            cell.lblTitle.textColor = UIColor.hexColor(0x707070)
////        }
////
////        cell.lblTitle.text = dt["title"] as? String
////
////        if kAppDelegate.tabItems().count == (indexPath.row + 1) {
////            cell.lblBorder.isHidden = true
////        } else {
////            cell.lblBorder.isHidden = false
////        }
////
////        if indexPath.row == 1 || indexPath.row == 2 {
////            cell.lblBorder.isHidden = true
////        }
////
////        return cell
////    }
////
////    func collectionView(_ collectionView: UICollectionView,
////                        layout collectionViewLayout: UICollectionViewLayout,
////                        sizeForItemAt indexPath: IndexPath) -> CGSize {
////        let hh: CGFloat = 60
////
////        return CGSize(width: hh, height: 50)
////    }
////
////    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
////        return 0
////    }
////
////    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
////        return 0
////    }
////
////    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
////
////    }
////
////    func tabbarClickedAt(_ indexPath: IndexPath) {
////        kAppDelegate.tabbarClicked(indexPath, self.navigationController)
////    }
////}
//
////extension ChooseSubscripiton {
////    func getSubcriptionDetails ()
////    {
////        getSubcriptionDetailsFromServer()
////        return
////        /*
////        Http.startActivityIndicator()
////
////        Http.instance().json(api_get_current_subscription, params(), "POST", aai: false, popup: true, prnt: true, nil, nil, sync: false, defaultCalling: true) { (json, para, ss, ht, data) in
////            //print("114Harish json-\(json)-")
////
////            if let json = json as? NSDictionary {
////                if let data = json["data"] as? NSDictionary {
////
////                    let ios_customer_id = data.string("ios_customer_id")
////
////
////                    print("bbbbbbccccdd-[\(kAppDelegate.getOriginalTransactionId())]-[\(ios_customer_id)]-")
////
////                    if let oti = kAppDelegate.getOriginalTransactionId() {
////                        if ios_customer_id == oti {
////                            self.boolDeviceUser = true
////                        }
////                    }
////                }
////            }
////
////            self.updateCancelSubcriptionButton ()
////
////            Http.stopActivityIndicator()
////        }
////        */
////    }
////
////    func getSubcriptionDetailsFromServer () {
////        print("Get Subscription Detail --")
////        Http.instance().json(api_get_current_subscription, params(), "POST", aai: true, popup: true, prnt: true, nil, nil, sync: false, defaultCalling: true) { (json, para, ss, ht, data) in
////            print("114Harish json-\(json)-")
////            var boolData = false
////            if let json = json as? NSDictionary {
////                freeTrial = json["freeTrail"] as? Int ?? 0
////                print(freeTrial)
////                let sta = json["success"] as? Int
////                print(sta)
////                if sta == SESSIONEXPIRED {
////                    kAppDelegate.sessionExpired(self)
////                    return
////                }
////                if let data = json["data"] as? NSDictionary {
////                    let timestamp = data.string("end_date")
////                    let status = data.string("status")
////                    //                    DispatchQueue.main.async {
////                    if timestamp.count > 0 && (status != "end"){
////                        boolData = true
////                        let time = data.number("end_date").doubleValue
////
////                        print(time)
////                        kAppDelegate.serverCustomerId = data.string("ios_customer_id")
////                        let iOSCID = data.string("ios_customer_id")
////                        let androidCID = data.string("android_customer_id")
////                        if iOSCID != ""{
////                            self.iOSSubscritpion = true
////                        }
////                        if androidCID != ""{
////                            self.androidSubscription = true
////                        }
////                        if (iOSCID == "") && (androidCID == ""){
////                            self.stripeSubscription = true
////                        }
////                        self.subscriptionId = data.string("subscription_id")
////                        var date: Date = Date()
////                        if timestamp.count == 13 {
////                            date = Date.init(timeIntervalSince1970: time/1000)
////                        } else {
////                            date = Date.init(timeIntervalSince1970: time)
////                        }
////                        kAppDelegate.serverExpiryDate = date
////                        let date1 = Date()
////                        print("Expiry date-[\(date)]-current-[\(date1)]")
////                        let int = date1.timeIntervalSince(date)
////
////                        var showDate = "\(date)".components(separatedBy: " ")
////                        if showDate.count > 0 {
////                            print(showDate[0])
////                            self.lblNextRenewDate.text = "Next renew date : \(showDate[0])"
////                        }
////                        if int > 0 {
////                            print("x1 Not purchased----[12]-")
////                            self.btnCancelSubcription?.isHidden = true
////                            self.btnChoosePlanFree.isHidden = false
////                            self.lbl_getsgo.isHidden = false
////                            self.lblMembershipPlan.text = "Membership"
////                            self.HeightValue.constant = 290
////                            self.lblNextRenewDate.isHidden = true
////                            self.btnPurchaseWeekly.isHidden = false
////                            self.lblSubscriptionTrial.text = "30 days free trial for new sign up. After that weekly subscription of AUD $4.99 charged"
////                            self.viewFreeAdvert.isHidden = false
////                        } else {
////                            print("Purchased-----12")
////                            self.btnCancelSubcription?.isHidden = false
////                            self.btnChoosePlanFree.isHidden = true
////                            self.lbl_getsgo.isHidden = true
////                            self.lblMembershipPlan.text = "My Membership"
////                            self.HeightValue.constant = 250
////                            self.lblNextRenewDate.isHidden = false
////                            self.btnPurchaseWeekly.isHidden = true
////                            self.lblSubscriptionTrial.text = ""
////                            self.viewFreeAdvert.isHidden = true
////                            self.lblWelcome.isHidden = true
////                            self.lblMembershipPlan.isHidden = false
////                            self.tabBarView.isTabBarHidden = false
////                            self.tabBarView.isHidden = false
////                            self.onOffButton.isHidden = false
////                            self.view.setNeedsDisplay()
////                            self.view.layoutIfNeeded()
////                        }
////                    }else{
////                        self.btnCancelSubcription?.isHidden = true
////                        self.btnChoosePlanFree.isHidden = false
////                        self.lbl_getsgo.isHidden = false
////                        self.lblMembershipPlan.text = "Membership"
////                        self.HeightValue.constant = 290
////                        self.lblNextRenewDate.isHidden = true
////                        self.btnPurchaseWeekly.isHidden = false
////                        self.lblSubscriptionTrial.text = "30 days free trial for new sign up. After that weekly subscription of AUD $4.99 charged"
////                        self.viewFreeAdvert.isHidden = false
////                        //self.lblWelcome.isHidden = true
////                        //self.lblMembershipPlan.isHidden = false
////                        //self.tabBarView.isTabBarHidden = false
////                        //self.tabBarView.isHidden = false
////                        //self.onOffButton.isHidden = false
////                    }
////                    if self.boolFromLaunch == true{
////                        let vc = story_Payment.viewController("ChooseSubscripiton") as! ChooseSubscripiton
////                        vc.isFromRegister = false
////                        vc.isFreePlan = true
////                        self.navigationController?.pushViewController(vc, animated: true)
////                    }
////                    //}
////                }
////            }
////
////
////            /*
////             DispatchQueue.main.async  {
////             if boolData {
////             if kAppDelegate.isLoginUserDeviceUser() {
////             self.btnCancelSubcription?.isHidden = false
////             self.btnPurchaseWeekly.isHidden = true
////             self.lblSubscriptionTrial.text = ""
////             } else {
////             self.btnCancelSubcription?.isHidden = true
////             self.btnPurchaseWeekly.isHidden = true
////             self.lblSubscriptionTrial.text = ""
////             }
////             } else {
////             self.btnCancelSubcription?.isHidden = true
////             self.btnPurchaseWeekly.isHidden = false
////             self.lblSubscriptionTrial.text = "30 days free trial for new sign up. After that weekly subscription of AUD $4.99 charged"
////             }
////
////             self.updateCancelSubcriptionButton()
////             }
////             */
////
////            //Comment Sarjan for test
////            //            self.btnPurchaseWeekly.isHidden = true
////            //            self.btnCancelSubcription?.isHidden = true
////            Http.stopActivityIndicator()
////        }
////    }
////
////
////
////
////
////
////}
