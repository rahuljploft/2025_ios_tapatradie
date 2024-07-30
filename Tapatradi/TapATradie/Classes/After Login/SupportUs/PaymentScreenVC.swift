//
//  PaymentScreenVC.swift
//  Tradie
//
//  Created by Admin on 11/01/23.
//

import UIKit

protocol UpdatePurchase {
    func updatePurchase()
}

protocol PaymentLogout {
    func logoutPayment()
}

class PaymentScreenVC: UIViewController, UITableViewDataSource, UITableViewDelegate, sussessfullPayment, SelectedPaymentOption, UpdateData {

    @IBOutlet weak var shimerView: UIView!
    @IBOutlet weak var viewOne: UIView!
    @IBOutlet weak var viewTwo: UIView!
    @IBOutlet weak var viewThree: UIView!
    @IBOutlet weak var viewFour: UIView!
    @IBOutlet weak var viewFive: UIView!
    @IBOutlet weak var viewSix: UIView!
    @IBOutlet weak var viewSev: UIView!
    
    
    @IBOutlet weak var scrlView: UIScrollView!
    @IBOutlet weak var viewLogout: UIView!
    @IBOutlet weak var viewActivityIndicator: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    //@IBOutlet weak var tabheight: NSLayoutConstraint!
    @IBOutlet weak var tabView: TabBarView!
    @IBOutlet weak var tblHeight: NSLayoutConstraint!
    @IBOutlet weak var viewSubmit: UIView!
    @IBOutlet weak var tblSubscription: UITableView!
    @IBOutlet weak var btnSubmit: UIButton!
    var selectedIndex = -1
    var subscriptionListModel : SubscriptionListModel?
    var delegate:UpdatePurchase!
    var delegateLogout:PaymentLogout!
    var multiplePaymentOption = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("PaymentScreenVC")
        
        viewLogout.clipsToBounds = true
        viewLogout.layer.cornerRadius = 25
        
        viewActivityIndicator.layer.cornerRadius = 8
        viewActivityIndicator.isHidden = true
        
        tabView.selectedItem = 3
        viewSubmit.layer.cornerRadius = 25
        viewSubmit.clipsToBounds = true
        tblSubscription.dataSource = self
        tblSubscription.delegate = self
        btnSubmit.layer.cornerRadius = btnSubmit.frame.height/2
        showShimmer()
        getSubscriptinoList()
        //tblHeight.constant = 125
        tblSubscription.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        tblSubscription.removeObserver(self, forKeyPath: "contentSize")
        super.viewWillDisappear(true)
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if(keyPath == "contentSize"){
            if let newvalue = change?[.newKey]
            {
                let newsize  = newvalue as! CGSize
                print(newsize,newsize.height)
                tblHeight.constant = newsize.height + 125 + 70
            }
        }
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
    
    
    func updateData() {
        
        if subscriptionListModel?.showStripe == 0 {
            if selectedIndex < 0 {
                let alert = UIAlertController(title: "Tap A Tradie", message: "Please select plan first", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel))
                self.present(alert, animated: true)
            }else{
                if selectedIndex == 0 {
                    let vc = story_Tradie.viewController("MyBookings") as! MyBookings
                    self.navigationController?.pushViewController(vc, animated: false)
                }else if selectedIndex == 1 {
                    purchase(productID: "tradie.com.purchase.threemonthsplan_withoutfreetrial")
                } else if selectedIndex == 2 {
                    purchase(productID: "tradie.com.purchase.sixmonthsplan_withoutfreetrial")
                } else if selectedIndex == 3 {
                    purchase(productID: "tradie.com.purchase.oneyearplan_withoutfreetrial")
                }
            }
        }else{
            if selectedIndex < 0 {
                let alert = UIAlertController(title: "Tap A Tradie", message: "Please select plan first", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel))
                self.present(alert, animated: true)
            }else{
                if selectedIndex == 0 {
                    let vc = story_Tradie.viewController("MyBookings") as! MyBookings
                    self.navigationController?.pushViewController(vc, animated: false)
                }else{
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "CardSelectionPopUp_VC") as! CardSelectionPopUp_VC
                    vc.delegate = self
                    self.present(vc, animated: true)
                }
            }
        }
    }
    
    
    
    
    func successPayment() {
        DispatchQueue.main.async {
            self.dismiss(animated: true) {
                if isFeb == 1 {
                    let vc = story_Payment.viewController("ChooseSubscripiton") as? ChooseSubscripiton
                    self.navigationController?.pushViewController(vc!, animated: false)
                }else{
                    let vc = story_Payment.viewController("ChooseSubscripiton") as? ChooseSubscripiton
                    self.navigationController?.pushViewController(vc!, animated: false)
                }
            }
        }
    }
    
    
    @IBAction func actionLogout(_ sender: UIButton) {
        
        let dialogMessage = UIAlertController(title: "Confirm", message: "Are you sure you want to logout!" , preferredStyle: .alert)
        
        let ok = UIAlertAction(title: "Logout", style: .default, handler: { (action) -> Void in
            self.dismiss(animated: true) {
                self.delegateLogout.logoutPayment()
            }
        })
        let cancel = UIAlertAction(title: "Cancel", style: .default) { (action) -> Void in
            
        }
        dialogMessage.addAction(cancel)
        dialogMessage.addAction(ok)
        self.present(dialogMessage, animated: true, completion: nil)
        
    }
    
    
    @IBAction func actionSubmit(_ sender: UIButton) {
        
        if subscriptionListModel?.showStripe == 0 {
            if selectedIndex < 0 {
                let alert = UIAlertController(title: "Tap A Tradie", message: "Please select plan first", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel))
                self.present(alert, animated: true)
            }else{
                if selectedIndex == 0 {
                    let vc = story_Tradie.viewController("MyBookings") as! MyBookings
                    self.navigationController?.pushViewController(vc, animated: false)
                }else if selectedIndex == 1 {
                    purchase(productID: "tradie.com.purchase.threemonthsplan_withoutfreetrial")
                } else if selectedIndex == 2 {
                    purchase(productID: "tradie.com.purchase.sixmonthsplan_withoutfreetrial")
                } else if selectedIndex == 3 {
                    purchase(productID: "tradie.com.purchase.oneyearplan_withoutfreetrial")
                }
            }
        }else{
            if selectedIndex < 0 {
                let alert = UIAlertController(title: "Tap A Tradie", message: "Please select plan first", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel))
                self.present(alert, animated: true)
            }else{
                if selectedIndex == 0 {
                    let vc = story_Tradie.viewController("MyBookings") as! MyBookings
                    self.navigationController?.pushViewController(vc, animated: false)
                }else{
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "CardSelectionPopUp_VC") as! CardSelectionPopUp_VC
                    vc.delegate = self
                    self.present(vc, animated: true)
                }
            }
        }
    }
    
    func selectPaymentMethod(peymentMethod: PaymentOption) {
        
        if peymentMethod == .inapp {
            if selectedIndex == 0 {
                purchase(productID: "tradie.com.purchase.threemonthsplan_withoutfreetrial")
            } else if selectedIndex == 1 {
                purchase(productID: "tradie.com.purchase.sixmonthsplan_withoutfreetrial")
            } else if selectedIndex == 2 {
                purchase(productID: "tradie.com.purchase.oneyearplan_withoutfreetrial")
            }
        }else if peymentMethod == .stripe {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "CardDetailScreenVC") as! CardDetailScreenVC
            vc.modalPresentationStyle = .overFullScreen
            vc.delegateNew = self
            vc.planeID = "\(subscriptionListModel?.subscription[selectedIndex].planID ?? "")"
            vc.amount = "\(subscriptionListModel?.subscription[selectedIndex].amount?.value ?? "")"
            self.present(vc, animated: true)
        }
    }
    
    @IBAction func Actino_TermsCondition(_ sender: UIButton) {
        "https://www.tapatradie.com/terms-conditions".openAsUrl()
    }
    @IBAction func Actino_PrivacyPolicy(_ sender: UIButton) {
        "https://www.tapatradie.com/privacy-policy".openAsUrl()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("\(subscriptionListModel?.subscription.count ?? 0)")
        return subscriptionListModel?.subscription.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SubscriptionListCell") as! SubscriptionListCell
        if selectedIndex == indexPath.row {
            print("Selcted Index \(selectedIndex) = \(indexPath.row)")
            cell.viewCard.layer.cornerRadius = 12
            cell.viewCard.layer.borderColor = UIColor.systemOrange.cgColor
            cell.viewCard.layer.borderWidth = 2
        }else{
            print("Unselected Index \(selectedIndex) = \(indexPath.row)")
            cell.viewCard.layer.cornerRadius = 12
            cell.viewCard.layer.shadowRadius = 2
            cell.viewCard.layer.shadowOpacity = 0.5
            cell.viewCard.layer.shadowOffset = .zero
            cell.viewCard.layer.shadowColor = UIColor.lightGray.cgColor
            cell.viewCard.layer.borderColor = UIColor.clear.cgColor
            cell.viewCard.layer.borderWidth = 0
        }
        cell.selectionStyle = .none
        cell.viewImage.layer.cornerRadius = cell.viewImage.frame.height/2
        cell.lblSubscrptionTitle.text = "\(subscriptionListModel?.subscription[indexPath.row].name ?? "")"
        
        cell.lblDetail.text = "\(subscriptionListModel?.subscription[indexPath.row].description ?? "")"
        if indexPath.row == 0 {
            cell.lblAmount.isHidden = true
            cell.lblAmount.text = "$\(subscriptionListModel?.subscription[indexPath.row].amount?.value ?? "")"
            cell.lbl_Detail.text = "Advertise your business for free."
            cell.lbl_Detail2.text = "Full profile including work images and profile pictures."
            cell.imgLogo.image = UIImage(named: "freemium")
        }else{
            cell.lblAmount.isHidden = false
            cell.lblAmount.text = "$\(subscriptionListModel?.subscription[indexPath.row].amount?.value ?? "")"
            cell.lbl_Detail.text = "Full access to all features."
            cell.lbl_Detail2.text = "Receive quality leads directly from customers, 24/7, within a 100km radius."
            cell.imgLogo.image = UIImage(named: "\(indexPath.row)")
        }
        if  indexPath.row == 4 {
            cell.imgLogo.image = UIImage(named: "\(1)")
        }
        cell.btn_OpenFremium.tag = indexPath.row
        cell.btn_OpenFremium.addTarget(self, action: #selector(openPopUp(_ :)), for: .touchUpInside)
        return cell
    }
    
    @objc func openPopUp(_ sender : UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "FremiumPopUP_VC") as! FremiumPopUP_VC
        vc.delegate = self
        if sender.tag == 0 {
            vc.continueVal = true
            selectedIndex = 0
            vc.SubscriptionImage = "freemium"
            vc.Title = "Free Advert"
            vc.first = "Full profile including work images and profile pictures."
            vc.second = "Your phone number."
            vc.third = "To accept leads, you must subscribe to our Gold, Silver or Bronze option"
            vc.four = "Your email address."
            vc.five = "Notifications when live leads are posted in your area."
            vc.six = ""
            vc.seven = ""

        }else if sender.tag == 1 {
            selectedIndex = 1
            vc.SubscriptionImage = "1"
            vc.Title = "Bronze"
            vc.first = "Receive quality leads directly from customers, 24/7, within a 100km radius"
            vc.second = "Leads direct from customers"
            vc.third = "Directory Listing"
            vc.four = "Photo Gallery"
            vc.five = "Full access to all features"
            vc.six = "Email and app notifications on leads instantly"
            vc.seven = ""
            
        }else if sender.tag == 2 {
            selectedIndex = 2
            vc.SubscriptionImage = "2"
            vc.Title = "Silver"
            vc.first = "Receive quality leads directly from customers, 24/7, within a 100km radius"
            vc.second = "Leads direct from customers"
            vc.third = "Directory Listing"
            vc.four = "Photo Gallery"
            vc.five = "Full access to all features"
            vc.six = "Email and app notifications on leads instantly"
            vc.seven = "More cost effective than the Bronze"
            vc.eight = ""
            
        }else if sender.tag == 3 {
            selectedIndex = 3
            vc.SubscriptionImage = "3"
            vc.Title = "Gold"
            vc.first = "Receive quality leads directly from customers, 24/7, within a 100km radius"
            vc.second = "Leads direct from customers"
            vc.third = "Directory Listing"
            vc.four = "Photo Gallery"
            vc.five = "Full access to all features"
            vc.six = "Email and app notifications on leads instantly"
            vc.seven = "More cost effective than the Silver"
            vc.eight = ""
            
        }
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true)
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        DispatchQueue.main.async {
            self.tblSubscription.reloadData()
        }
        let bottomOffset = CGPoint(x: 0, y: scrlView.contentSize.height - scrlView.bounds.height + scrlView.contentInset.bottom)
        scrlView.setContentOffset(bottomOffset, animated: true)
    }
    
    
    func purchase(productID:String) {
        DispatchQueue.main.async {
            self.view.isUserInteractionEnabled = false
            self.viewActivityIndicator.isHidden = false
            self.activityIndicator.startAnimating()
        }
        
        
        let productId = productID
        SwiftyStoreKit.purchaseProduct("\(productId)", atomically: true) { result in
            print("result-\(result)-")
            if case .success(let purchase) = result {
                Http.stopActivityIndicator()
                switch purchase.transaction.transactionState {
                case .purchased:
                    let downloads = purchase.transaction.downloads
                    if !downloads.isEmpty {
                        print("51HCG-\(purchase.transaction.transactionState.debugDescription): \(purchase.productId)")
                        SwiftyStoreKit.start(downloads)
                    } else if purchase.needsFinishTransaction {
                        print("52HCG-\(purchase.transaction.transactionState.debugDescription): \(purchase.productId)")
                        SwiftyStoreKit.finishTransaction(purchase.transaction)
                    } else {
                        print("53HCG-\(purchase.transaction.transactionState.debugDescription): \(purchase.productId)")
                    }
                    //self.getSubcriptionDetailsFromServer()
                    self.purchaseDetailsFromIAP()
                    
                    //self.verifyReceipt()
                    
                    //let customerId = purchase
                    let transactionId = "\(purchase.transaction.transactionIdentifier ?? "")"
                    let productId = "\(purchase.productId)"
                    let rawData = "\(result)"
                    //self.sendPurchaseDataToServer(customer_id: transactionId, transaction_id: transactionId, product_id: productId, raw_data: rawData)
                    
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
                    //self.getSubcriptionDetailsFromServer()
                    self.purchaseDetailsFromIAP()
                    //let customerId = purchase
                    let transactionId = "\(purchase.transaction.transactionIdentifier ?? "")"
                    let productId = "\(purchase.productId)"
                    let rawData = "\(result)"
                    //self.sendPurchaseDataToServer(customer_id: transactionId, transaction_id: transactionId, product_id: productId, raw_data: rawData)
                case .failed, .purchasing, .deferred:
                    print("Cancel Payment")
                    break
                @unknown default:
                    break
                }
                let downloads = purchase.transaction.downloads
                if !downloads.isEmpty {
                    SwiftyStoreKit.start(downloads)
                }
                if purchase.needsFinishTransaction {
                    SwiftyStoreKit.finishTransaction(purchase.transaction)
                }
            }
            
            switch result {
            case .success(let receipt):
                DispatchQueue.main.async {
                    //self.view.isUserInteractionEnabled = true
                    //self.viewActivityIndicator.isHidden = true
                    //self.activityIndicator.stopAnimating()
                }
                print("Receipt verification Success: \(receipt)")
            case .error(let error):
                DispatchQueue.main.async {
                    self.view.isUserInteractionEnabled = true
                    self.viewActivityIndicator.isHidden = true
                    self.activityIndicator.stopAnimating()
                }
                print("Receipt verification failed: \(error)")
                //self.getSubcriptionDetailsFromServer()
            }
        }
    }
    
    
    
    
    func verifyReceipt() {
        SwiftyStoreKit.verifyReceipt(using: appleValidator, completion: { result in
            self.verifyReceipt(result: result)
            if case .error(let error) = result {
                if case .noReceiptData = error {
                    self.refreshReceipt()
                }
            }
        })
    }
    
    func refreshReceipt() {
           SwiftyStoreKit.fetchReceipt(forceRefresh: true, completion: { result in
               print("Start refreshing the receipt...")
           })
       }
    
    func verifyReceipt(result: VerifyReceiptResult) {
           switch result {
           case .success(let receipt):
               print("Verify Receipt: \(receipt)")
           case .error(let error):
               switch error {
               case .noRemoteData: return print("No receipt founded. Try again")
               default: return print("Error Verify Receipt: \(error)")
               }
           }
       }
    
    
    func verifyReceipt(completion: @escaping (VerifyReceiptResult) -> Void) {
        SwiftyStoreKit.verifyReceipt(using: appleValidator, completion: completion)
    }
    
    func purchaseDetailsFromIAP () {
        
        DispatchQueue.main.async {
            self.view.isUserInteractionEnabled = false
            self.viewActivityIndicator.isHidden = false
            self.activityIndicator.startAnimating()
        }
        
        let mdReceptQuery = NSMutableDictionary()
        verifyReceipt { (result) in
            print("Result -- ",result)
            switch result {
            case .success(let receipt):
                DispatchQueue.main.async {
                    mdReceptQuery["success receipt"] = "-\(receipt)-"
                    print(receipt)
                    self.verifyReceiptJsonFromServer(receipt as NSDictionary, mdReceptQuery)
                }
            case .error(let error):
                
                DispatchQueue.main.async {
                    self.view.isUserInteractionEnabled = true
                    self.viewActivityIndicator.isHidden = true
                    self.activityIndicator.stopAnimating()
                }
                
                print("Verify receipt Failed: \(error)")
                let alert = UIAlertController(title: "Tap A Tradie", message: "Fail to purchase subscription. Please try again.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "try Again", style: .default,handler: {_ in
                    //self.purchaseDetailsFromIAP ()
                }))
                self.present(alert, animated: true)
            }
        }
    }
    
    func verifyReceiptJsonFromServer (_ receipt: NSDictionary, _ mdQuery: NSMutableDictionary) {
        if let pending_renewal_info = receipt["pending_renewal_info"] as? NSArray {
            print("pending_renewal_info-\(pending_renewal_info.count)-")
        }
        
        print(receipt["latest_receipt_info"] as? NSArray)
        
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
                        
                        DispatchQueue.main.async {
                            self.view.isUserInteractionEnabled = true
                            self.viewActivityIndicator.isHidden = true
                            self.activityIndicator.stopAnimating()
                        }
                        
                        print("Empty")
                        let alert = UIAlertController(title: "Tap A Tradie", message: "Fail to purchase subscription. Please try again.", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .cancel))
                        self.present(alert, animated: true)
                    } else {
                        self.sendPurchaseDataToServer(receipt, last)
                        break
                    }
                }
            }
        }
        
    }
    
//    func sendPurchaseDataToServer (customer_id: String,transaction_id: String,product_id: String,raw_data: String) {
//        let param = params()
//        param["customer_id"] = customer_id
//        param["transaction_id"] = transaction_id
//        param["product_id"] = product_id
//        param["raw_data"] = raw_data
//        print("transaction_id",transaction_id)
//        print("product_id",product_id)
//        print("raw_data",raw_data)
//        print(param)
//
//        Http.instance().json(api_ios_purchase_membership, param, "POST", aai: true, popup: false, prnt: true, nil, nil, sync: false, defaultCalling: true) { (json, para, ss, ht, data) in
//            print("3Harish json-\(json)-")
//            self.getSubcriptionDetailsFromServer()
//        }
//    }
    
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
            
            DispatchQueue.main.async {
                self.view.isUserInteractionEnabled = true
                self.viewActivityIndicator.isHidden = true
                self.activityIndicator.stopAnimating()
                
                self.dismiss(animated: true) {
                    if isFeb == 1 {
                        let vc = story_Tradie.viewController("MyBookings") as! MyBookings
                                            self.navigationController?.pushViewController(vc, animated: false)
                    }else{
                        let vc = story_Tradie.viewController("MyBookings") as! MyBookings
                        self.navigationController?.pushViewController(vc, animated: false)
                    }
                }
            }
            
            //self.getSubcriptionDetailsFromServer ()
        }
    }
    
    
    
    func getSubcriptionDetailsFromServer () {
        kAppDelegate.boolPurchasedFromIAP = true
        Http.instance().json(api_get_current_subscription, params(), "POST", aai: true, popup: true, prnt: true, nil, nil, sync: false, defaultCalling: true) { (json, para, ss, ht, data) in
            if let json = json as? NSDictionary {
                print("json \(json)")
                
                
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
                
                
                
                DispatchQueue.main.async {
                    self.view.isUserInteractionEnabled = true
                    self.viewActivityIndicator.isHidden = true
                    self.activityIndicator.stopAnimating()
                }
                
                if let data = json["data"] as? NSDictionary {
                    let timestamp = data.string("end_date")
                    let status = data.string("status")
                    let cancelStatus = data.string("status")
                    print(cancelStatus)
                    cancelStatusVal = "\(cancelStatus)"
                    
                    if timestamp.count > 0 && (status != "end") {
                        self.successPayment()
                    }
                }
            }
        }
    }
    
    
    func getSubscriptinoList() {
        let usernew = UserDefaults.standard
        let token = "\(usernew.object(forKey: KEY_ACCESSTOEKN) ?? "")"
        let userID = Key_User_id.getUserValue() ?? ""
        let params : [String:String] = [
            "access_token": "\(token)",
            "device_id": "\(UIDevice.current.identifierForVendor!.uuidString)_provider",
            "api_key": "$2a$06$hsTL2DeUKS5pUV.YlY/CSuVesppz0ha4hZdcsB7gN8VKRQRBwKct6",
            "device_type": "2",
            "uid": "\(userID)"
        ]
        print(params)
        let url = URL(string: "\(get_subscription_list)")
        
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        request.timeoutInterval = 180
        request.addValue("application/json", forHTTPHeaderField: "Accept")
   
        let postString = PaymentScreenVC.getPostString(params: params)
        request.httpBody = postString.data(using: .utf8)
        print("-URL-",url)
        print("-Param-",params)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let dataVal = data {
                let json = try! JSONSerialization.jsonObject(with: dataVal, options: [])
                print("Response :- \(json)")
                let jsonDict = json as? NSDictionary
                let status = (jsonDict?["success"] as? Int) ?? 0
                if status == 1 {
                    self.subscriptionListModel = try! JSONDecoder().decode(SubscriptionListModel.self, from: dataVal)
                    DispatchQueue.main.async {
                        self.hideShimmer()
                        self.tblSubscription.reloadData()
                    }
                }
            }else{
                DispatchQueue.main.async {
                    self.hideShimmer()
                }
                print(error)
            }
        }
        task.resume()
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




struct SubscriptionListModel: Codable {
    let message: String
    let subscription: [Subscription]
    let success: Int
    let showStripe: Int?
}

// MARK: - Subscription
struct Subscription: Codable {
    let amount: DynamicObject?
    let description: String
    let id: Int
    let name, planID, status, type: String

    enum CodingKeys: String, CodingKey {
        case amount
        case description, id, name
        case planID = "plan_id"
        case status, type
    }
}




enum DynamicObject: Codable {
    
    case double(Double)
    case string(String)
    case int(Int)
    case jsonNul(JSONNull)

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let x = try? container.decode(Double.self) {
            self = .double(x)
            return
        }
        if let x = try? container.decode(String.self) {
            self = .string(x)
            return
        }
        if let x = try? container.decode(Int.self) {
            self = .int(x)
            return
        }
        if let x = try? container.decode(JSONNull.self) {
            self = .jsonNul(x)
            return
        }
        throw DecodingError.typeMismatch(DynamicObject.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for Amount"))
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .double(let x):
            try container.encode(x)
        case .string(let x):
            try container.encode(x)
        case .int(let x):
            try container.encode(x)
        case .jsonNul(_):
            try container.encodeNil()
        }
    }
    
    var value: String {
        switch self {
        case .double(let value):
            return "\(value)"
        case .string(let value):
            return value
        case .int(let value):
            return "\(value)"
        case .jsonNul(_):
            return "null"
        }
    }
}
