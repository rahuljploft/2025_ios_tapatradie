//
//  Profile.swift
//  Tradie
//
//  Created by Apple on 08/05/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import ImageScrollView
import DynamicBlurView

protocol ProfileCellDelegate {
    func cellClicked (_ indexPath: IndexPath)
}


let userDefaultsPro = UserDefaults.standard


class ProfileCell: UITableViewCell {
    var indexPath: IndexPath!
    var delegate: ProfileCellDelegate!
    
    @IBOutlet weak var imgRight: UIImageView!
    @IBOutlet weak var lblCount: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBAction func actionCellClicked(_ sender: Any) {
        delegate.cellClicked (indexPath)
    }
}

extension Profile: ProfileCellDelegate, AlertDelegate {
    
    func alertOne() {
        print("")
    }
    
    func alertZero() {
        let vc = story_Payment.viewController("ChooseSubscripiton") as? ChooseSubscripiton
        vc?.boolFromMenu = false
        self.navigationController?.pushViewController(vc!, animated: false)
    }
    
    
    
    func cellClicked (_ indexPath: IndexPath) {
        if indexPath.row == 0 {
            let vc = story_Profile.viewController("IdentityVerification") as! IdentityVerification
            self.navigationController?.pushViewController(vc, animated: true)
        } else if indexPath.row == 1 {
            let vc = story_Profile.viewController("BusinessDetail") as! BusinessDetail
            self.navigationController?.pushViewController(vc, animated: true)
        } else if indexPath.row == 2 {
            let vc = story_Profile.viewController("UploadPhotos") as! UploadPhotos
            self.navigationController?.pushViewController(vc, animated: true)
        } else if indexPath.row == 3 {
            let vc = story_Profile.viewController("PrimaryBusiness") as! PrimaryBusiness
            self.navigationController?.pushViewController(vc, animated: true)
        } else if indexPath.row == 4 {
            //let vc = story_Profile.viewController("PrimaryBusiness") as! PrimaryBusiness
            //self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension Profile {
    
    func logoutPayment() {
        kAppDelegate.logout (self)
    }
    
    
    func getSubcriptionDetailsFromServer_New() {
        Http.instance().json(api_get_current_subscription, params(), "POST", aai: true, popup: true, prnt: true, nil, nil, sync: false, defaultCalling: true) { (json, para, ss, ht, data) in
            var boolData = false
            //self.viewTab.isHidden = false
            self.view.isUserInteractionEnabled = true
            if let json = json as? NSDictionary {
                print("json \(json)")
                

                
                
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
                    let status = data.string("status")
                    if timestamp.count > 0 && (status != "end") {
                        subscriptionStatus = true
                    }else{
                        subscriptionStatus = false
                        print("Not Purchased 2")
                        DispatchQueue.main.async {
//                            let story = UIStoryboard(name: "Home", bundle: nil)
//                            let vc = story.instantiateViewController(withIdentifier: "PaymentScreenVC") as! PaymentScreenVC
//                            vc.modalPresentationStyle = .overFullScreen
//                            vc.delegate = self
//                            vc.delegateLogout = self
//                            self.present(vc, animated: false)
                        }
                    }
                }else{
                    print("Not Purchased 2")
                    subscriptionStatus = false
                    DispatchQueue.main.async {
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
                        paymentSettingStatus = false
                        subscriptionStatus = true
                    }
                        
                }
                print("paymentSettingStatus : ",paymentSettingStatus)
                
                
                
            }else{
                subscriptionStatus = false
                print("Not Purchased")
            }
        }
    }
    
    
    
    
    func getSubcriptionDetailsFromServer() {
        let user = UserDefaults.standard
        let step1 = user.object(forKey: Key_step1) as? String
        let step2 = user.object(forKey: Key_step2) as? String
        let step3 = user.object(forKey: Key_step3) as? String
        let step4 = user.object(forKey: Key_step4) as? String
        let step5 = user.object(forKey: Key_step5) as? String
        let usersubmitapprovalbtn = user.object(forKey: user_submit_approval_btn) as? String
        let profilePic = Key_User_profile_pic.getUserValue() as! String
        if step1 != nil {
            self.step1 = Int(step1!)!
        }
        
        if step2 != nil {
            self.step2 = Int(step2!)!
        }
        
        if step3 != nil {
            self.step3 = Int(step3!)!
        }
        
        if step4 != nil {
            self.step4 = Int(step4!)!
        }
        
        if step5 != nil {
            self.step5 = Int(step5!)!
        }
        
        if usersubmitapprovalbtn != nil {
            self.usersubmitapprovalbtn = Int(usersubmitapprovalbtn!)!
        }
        Http.instance().json(api_get_current_subscription, params(), "POST", aai: true, popup: true, prnt: true, nil, nil, sync: false, defaultCalling: true) { (json, para, ss, ht, data) in
            var boolData = false
            //self.viewTab.isHidden = false
            //self.view.isUserInteractionEnabled = true
            if let json = json as? NSDictionary {
                print("json \(json)")
                

                
                
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
                    let status = data.string("status")
                    if timestamp.count > 0 && (status != "end") {
                        subscriptionStatus = true
                    }else{
                        subscriptionStatus = false
                        if self.step1 != 0 && self.step2 != 0 && self.step3 != 0 && self.step4 != 0 && profilePic.count != 0 && self.usersubmitapprovalbtn != 0 {
                            print("Not Purchased 2")
                            DispatchQueue.main.async {
//                                let story = UIStoryboard(name: "Home", bundle: nil)
//                                let vc = story.instantiateViewController(withIdentifier: "PaymentScreenVC") as! PaymentScreenVC
//                                vc.modalPresentationStyle = .overFullScreen
//                                vc.delegate = self
//                                vc.delegateLogout = self
//                                self.present(vc, animated: false)
                            }
                        }
                        
                    }
                }else{
                    print("Not Purchased 2")
                    subscriptionStatus = false
                    DispatchQueue.main.async {
                        if self.step1 != 0 && self.step2 != 0 && self.step3 != 0 && self.step4 != 0 && profilePic.count != 0 && self.usersubmitapprovalbtn != 0 {
//                            let story = UIStoryboard(name: "Home", bundle: nil)
//                            let vc = story.instantiateViewController(withIdentifier: "PaymentScreenVC") as! PaymentScreenVC
//                            vc.modalPresentationStyle = .overFullScreen
//                            vc.delegate = self
//                            vc.delegateLogout = self
//                            self.present(vc, animated: false)
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
                
                
            }else{
                print("Not Purchased")
            }
        }
    }
}

class Profile: BaseVC, DeleteAccount, UpdatePurchase, PaymentLogout {
    func updatePurchase() {
        print("Update Membership")
        getSubcriptionDetailsFromServer ()
    }
    
    func deleteAccountSuccess() {
        kAppDelegate.logout (self)
    }
    
    
    
    @IBOutlet weak var viewOfflineButton: OnlineOfflineButton!
    
    
    @IBOutlet weak var viewTab: TabBarView!
    
    
    
    @IBAction func actionCrossOnlineOffline(_ sender: Any) {
        //        viewOnlineOfflineRightCross.removeFromSuperview()
    }
    
    @IBAction func actionRightOnlineOffline(_ sender: Any) {
        //        viewOnlineOfflineRightCross.removeFromSuperview()
        
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
            let jsonExp = json as? NSDictionary
            
            if jsonExp != nil {
                if jsonExp?.number("success").intValue == SESSIONEXPIRED {
                    kAppDelegate.sessionExpired(self)
                    
                    return
                }
            }
            
            let json = json as? NSDictionary
            
            if json != nil {
                if json?.number("success").intValue == 1 {
                    
                    if "\(online!)" == "1" {
                        Key_User_online.setUserValue("0")
                    } else {
                        Key_User_online.setUserValue("1")
                    }
                    
                    DispatchQueue.main.async {
                        //                        self.setOnlineOfflineImage ()
                    }
                    
                    //                    self.setAddress ()
                }
                
                //Http.alert("", json?.string("message"))
            }
        }
    }
    
    
    @IBOutlet weak var viewShowMsg: UIView!
    @IBOutlet weak var headerHeight: NSLayoutConstraint!
    @IBOutlet weak var headerView: HeaderView!
    @IBOutlet weak var viewDeleteButton: UIView!
    @IBOutlet weak var switchNotifi: UISwitch!
    @IBOutlet weak var viewNotificationSound: UIView!
    @IBOutlet weak var btnViewProfile:UIButton!
   
    
    @IBAction func switchNotification(_ sender: UISwitch) {
        //sender.isOn
        
        if sender.isOn {
            print("isOn")
            self.switchNotifi.thumbTintColor = UIColor.white
        }else{
            print("isOff")
            self.switchNotifi.thumbTintColor = UIColor.systemRed
        }
        
        let userID = Key_User_id.getUserValue() ?? ""
        let usernew = UserDefaults.standard
        let token = "\(usernew.object(forKey: KEY_ACCESSTOEKN) ?? "")"

        
        let params : [String:String] = [
            "userId":"\(userID)",
            "type":":update",
            "access_token": "\(token)",
            "api_key": "$2a$06$hsTL2DeUKS5pUV.YlY/CSuVesppz0ha4hZdcsB7gN8VKRQRBwKct6",
            "device_type": "2",
            "device_id": "\(UIDevice.current.identifierForVendor!.uuidString)_provider",
        ]
        
        print(params)
        changeNotificationSettings(params: params)
    }
    
    func changeNotificationSettings(params:[String:Any]?) {
        let url = URL(string: "\(notificationsetting)")
        print(url)
        print(params)
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        request.timeoutInterval = 180
        
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        if let paramVal = params {
            let postString = DeletePopUpVC.getPostString(params: paramVal)
            request.httpBody = postString.data(using: .utf8)
        }
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let dataVal = data {
                let json = try! JSONSerialization.jsonObject(with: dataVal, options: [])
                print("Response :- \(json)")
                let jsonDict = json as? NSDictionary
                let status = (jsonDict?["success"] as? Int) ?? 0
                if status == 1 {
                    DispatchQueue.main.async {
                        let data = jsonDict?["data"] as? NSDictionary
                        if let notificationSetting = data?["notification_setting"] as? Int {
                            if notificationSetting == 1 {
                                self.switchNotifi.setOn(true, animated: true)
                                self.switchNotifi.thumbTintColor = UIColor.white
                            }else{
                                self.switchNotifi.setOn(false, animated: true)
                                self.switchNotifi.thumbTintColor = UIColor.systemRed
                            }
                        }
                    }
                }
            }else{
                print(error)
            }
        }
        task.resume()
    }
    
    
    var profileJSON: ProfileJSON?
    
    
    @IBOutlet weak var shimerProfileImage: UIView!
    @IBOutlet weak var shimerHelloName: UIView!
    @IBOutlet weak var shimerStart: UIView!
    @IBOutlet weak var shimerIdentity: UIView!
    @IBOutlet weak var shimerBusinessDetail: UIView!
    @IBOutlet weak var shimerUploadPhotos: UIView!
    @IBOutlet weak var shimerShimerAdiotionl: UIView!
    
    
    
    @IBOutlet weak var tblProfile: UITableView!
    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblMessage: UILabel!
    
    private var leftMenu  = CustomerMenuViewController()
    private var leftDrawerTransition:DrawerTransition!
    
    var step1 = 0
    var step2 = 0
    var step3 = 0
    var step4 = 0
    var step5 = 0
    var usersubmitapprovalbtn = 0
    
    @IBOutlet weak var btnCamera: UIButton!
    @IBOutlet weak var btnChange: UIButton!
    @IBOutlet weak var viewRating: FloatRatingView!
    //@IBOutlet weak var profileHeight: NSLayoutConstraint!
    
    @IBOutlet weak var viewHidePayment: UIView!
    @IBOutlet weak var middelSpace: NSLayoutConstraint!
    @IBOutlet weak var viewc: UIView!
    @IBOutlet weak var viewPro: UIView!
    @IBOutlet weak var cellHeightManage: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewNotificationSound.layer.cornerRadius = 12
        viewNotificationSound.layer.borderWidth = 1
        viewNotificationSound.layer.borderColor = UIColor.gray.cgColor
        viewTab.isHidden = true
        viewDeleteButton.layer.cornerRadius = 12
        viewDeleteButton.layer.borderWidth = 1
        viewDeleteButton.layer.borderColor = UIColor.gray.cgColor
        let userID = Key_User_id.getUserValue() ?? ""
        let usernew = UserDefaults.standard
        let token = "\(usernew.object(forKey: KEY_ACCESSTOEKN) ?? "")"
        let params : [String:String] = [
            "userId":"\(userID)",
            "type":"get",
            "access_token": "\(token)",
            "api_key": "$2a$06$hsTL2DeUKS5pUV.YlY/CSuVesppz0ha4hZdcsB7gN8VKRQRBwKct6",
            "device_type": "2",
            "device_id": "\(UIDevice.current.identifierForVendor!.uuidString)_provider",
        ]
        print(params)
        changeNotificationSettings(params: params)
        view.isUserInteractionEnabled = true
        
        
        viewTab.isHidden = true
        lblName.text = ""
        lblMessage.isHidden = true
        
        let user = UserDefaults.standard
        user.set("1", forKey: getPrimaryServiceKey ())
        user.synchronize()
        
        imgUser.superview!.border(UIColor.white, imgUser.frame.size.height/2, 0)
        
        let obc = kAppDelegate.boolIAPPurchased ()
        
        if obc.purchased == false {
            verifyNow ()
        }
        
        viewc.setCornerRadiusWithBorder(cornerRadius: 6, clipsToBound: true, borderWidth: 1, borderColor: UIColor(named: "#000000 - 10")?.cgColor)
        viewc.addShadow(offset: CGSize(width: 0, height: 4), color: .lightGray, radius: 4, opacity: 0.25, cornerRadius: 6)
        //viewPro.setCornerRadiusWithBorder(cornerRadius: 6, clipsToBound: true)
        
    }
    
    
    @IBAction func actinoDeleteAccount(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "DeletePopUpVC") as! DeletePopUpVC
        vc.modalPresentationStyle = .overFullScreen
        vc.delegate = self
        self.present(vc, animated: true)
    }
    
    func checkProfileReloadTable () {
        if let name = Key_User_full_name.getUserValue() as? String {
            if name == "" {
                lblName.text = "Hello"
            }else{
                lblName.text = "Hello, \(name.capFirstLetter())"
            }
        }
        
        //lblName.text = (Key_User_full_name.getUserValue() as? String)?.capFirstLetter()
        
        let rating = Key_User_rating.getUserValue()
        
        if rating != nil {
            if let rat = rating as? String {
                var rrr: Double = 0
                
                if rat.count > 0 {
                    rrr = Double(rat)!
                }
                
                viewRating.rating = rrr
            } else if let rat = rating as? Double {
                viewRating.rating = rat
            }
        }
        
        initMenu ()
        
        let profilePic = Key_User_profile_pic.getUserValue() as! String
        if profilePic.count > 0 {
            let url = "\(Server)profile/\(Key_User_id.getUserValue()!)/\(Key_User_profile_pic.getUserValue() as! String)"
            print("profilePic url-\(url)-")
            imgUser.uiimage(url, "Group 2826", true, nil)
        } else {
            imgUser.image = UIImage(named: "Group 2826")
        }
        
        btnChange.isHidden = true
        btnCamera.isHidden = false
        
        
        if let verified = Key_User_verified.getUserValue() as? String {
            if verified == "0" || verified == "" {
                //lblMessage.text = "You are few step away from completing your profile"
            } else {
                //lblMessage.text = "Your Profile Successfully Approved"
            }
        }
        
        let user = UserDefaults.standard
        let step1 = user.object(forKey: Key_step1) as? String
        let step2 = user.object(forKey: Key_step2) as? String
        let step3 = user.object(forKey: Key_step3) as? String
        let step4 = user.object(forKey: Key_step4) as? String
        let step5 = user.object(forKey: Key_step5) as? String
        let usersubmitapprovalbtn = user.object(forKey: user_submit_approval_btn) as? String
        
        
        
        
        if step1 != nil {
            self.step1 = Int(step1!)!
        }
        
        if step2 != nil {
            self.step2 = Int(step2!)!
        }
        
        if step3 != nil {
            self.step3 = Int(step3!)!
        }
        
        if step4 != nil {
            self.step4 = Int(step4!)!
        }
        
        if step5 != nil {
            self.step5 = Int(step5!)!
        }
        
        if usersubmitapprovalbtn != nil {
            self.usersubmitapprovalbtn = Int(usersubmitapprovalbtn!)!
        }
        
        
        
        print(self.step1)
        print(self.step2)
        print(self.step3)
        print(self.step4)
        print(self.step5)
        print("self.usersubmitapprovalbtn",self.usersubmitapprovalbtn)
        print("profilePic.count",profilePic.count)
        print("profilePic",profilePic)
        
        self.stopShimer()
        
        if self.step1 == 0 || self.step2 == 0 || self.step3 == 0 || self.step4 == 0 || profilePic.count == 0 || self.usersubmitapprovalbtn == 0 {
            viewTab.isHidden = true
            viewOfflineButton.isHidden = true
            headerView.isHidden = true
            headerHeight.constant = 0
            viewDeleteButton.isHidden = true
            viewNotificationSound.isHidden = true
            btnViewProfile.isHidden = true
            btnSubmit.isHidden = false
            btnLogoutShow.isHidden = false
            viewShowMsg.isHidden = false
            viewRating.isHidden = true
            lblMessage.isHidden = false
            lblMessage.text = "You are few step away from completing your profile"
            
            userDefaultsPro.set(false, forKey: "submitDone")
            
            let profilePic = Key_User_profile_pic.getUserValue() as! String
            print(profilePic)
            if profilePic.count == 0 {
                self.btnSubmit.setTitle("Upload your profile picture", for: .normal)
            }else if self.step1 == 0 {
                self.btnSubmit.setTitle("Update identity verification & about me", for: .normal)
            }else if self.step2 == 0 {
                self.btnSubmit.setTitle("Update business details", for: .normal)
            }else if self.step3 == 0 {
                self.btnSubmit.setTitle("Upload photos of your work", for: .normal)
            }else if self.step4 == 0 {
                self.btnSubmit.setTitle("Additional service information", for: .normal)
            }else if self.usersubmitapprovalbtn == 0 {
                self.btnSubmit.setTitle("Submit", for: .normal)
            }
        }else{
            //            viewRating.isHidden = false
            //            viewShowMsg.isHidden = true
            //            viewTab.isHidden = false
            //            viewOfflineButton.isHidden = false
            //            headerHeight.constant = 80
            //            headerView.isHidden = false
            //            viewDeleteButton.isHidden = false
            //            viewNotificationSound.isHidden = false
            //            btnViewProfile.isHidden = false
            //            btnSubmit.isHidden = true
            //            btnLogoutShow.isHidden = true
            
            lblMessage.text = "Your Profile Successfully Approved"
            viewRating.isHidden = false
            viewShowMsg.isHidden = true
            viewTab.isHidden = false
            viewOfflineButton.isHidden = false
            headerHeight.constant = 80
            headerView.isHidden = false
            viewDeleteButton.isHidden = false
            viewNotificationSound.isHidden = false
            btnViewProfile.isHidden = false
            btnSubmit.isHidden = true
            btnLogoutShow.isHidden = true
            lblMessage.isHidden = false
        }
        
        if self.step1 == 1 && self.step2 == 1 && self.step3 == 1 && self.step4 == 1 {
            
        } else {
            
        }
        
        let val = user.object(forKey: "\(key_submit_for_approval)_\(Key_User_id.getUserValue()!)")
        tblProfile.reloadData()
        navigateToEnterInfo ()
    }
    
    func navigateToEnterInfo () {
        let user = UserDefaults.standard
        let step1 = user.object(forKey: Key_step1) as? String
        let step2 = user.object(forKey: Key_step2) as? String
        let step3 = user.object(forKey: Key_step3) as? String
        let step4 = user.object(forKey: Key_step4) as? String
        //if step1 != nil && step2 != nil && step3 != nil && step4 != nil {
//            let s1 = Int(step1!)
//            let s2 = Int(step2!)
//            let s3 = Int(step3!)
//            let s4 = Int(step4!)
//
//            var vc: UIViewController?
//
////            if s1 == 0 && s2 == 0 && s3 == 0 && s4 == 0 {
////                vc = story_Profile.viewController("PrimaryBusiness") as! PrimaryBusiness
////            }
////            if vc != nil {
////                self.navigationController?.pushViewController(vc!, animated: true)
////            }
//        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        viewTab.isHidden = true
        viewOfflineButton.isHidden = true
        headerView.isHidden = true
        headerHeight.constant = 0
        viewDeleteButton.isHidden = true
        viewNotificationSound.isHidden = true
        btnViewProfile.isHidden = true
        btnSubmit.isHidden = true
        btnLogoutShow.isHidden = true
        viewShowMsg.isHidden = true
        viewRating.isHidden = true
        lblMessage.isHidden = true
        lblMessage.text = ""
                
        DispatchQueue.main.asyncAfter(deadline: .now()+15) {
            Http.stopActivityIndicator()
        }
                
        self.viewTab.isHidden = true
        kAppDelegate.currentVC = self
        headerView.updateData()
        checkProfile ()
        kAppDelegate.subscribeToFirebase(true)
        getSubcriptionDetailsFromServer ()
    }
    
    
    var userData: ProfileJSON?
    
    
    func showShimer() {
        DispatchQueue.main.async {
            self.viewHidePayment.isHidden = false
            self.shimerProfileImage.layer.cornerRadius = self.shimerProfileImage.frame.height/2
            self.shimerHelloName.layer.cornerRadius = 8
            self.shimerStart.layer.cornerRadius = 8
            self.shimerIdentity.layer.cornerRadius = 8
            self.shimerBusinessDetail.layer.cornerRadius = 8
            self.shimerUploadPhotos.layer.cornerRadius = 8
            self.shimerShimerAdiotionl.layer.cornerRadius = 8
            
            self.shimerProfileImage.startShimmeringEffect()
            self.shimerHelloName.startShimmeringEffect()
            self.shimerStart.startShimmeringEffect()
            self.shimerIdentity.startShimmeringEffect()
            self.shimerBusinessDetail.startShimmeringEffect()
            self.shimerUploadPhotos.startShimmeringEffect()
            self.shimerShimerAdiotionl.startShimmeringEffect()
        }
    }
    
    
    func stopShimer() {
        DispatchQueue.main.async {
            self.viewHidePayment.isHidden = true
            
            self.shimerProfileImage.stopShimmeringEffect()
            self.shimerHelloName.stopShimmeringEffect()
            self.shimerStart.stopShimmeringEffect()
            self.shimerIdentity.stopShimmeringEffect()
            self.shimerBusinessDetail.stopShimmeringEffect()
            self.shimerUploadPhotos.stopShimmeringEffect()
            self.shimerShimerAdiotionl.stopShimmeringEffect()
        }
    }
    
    
    
    func checkProfile () {
        showShimer()
        let param = params()
        Http.instance().json(api_provider_profile_steps, param, "POST", aai: true, popup: true, prnt: true, nil, nil, sync: false, defaultCalling: false) { (json, paras, str, data) in
            let jsonExp = json as? NSDictionary
            
            if jsonExp != nil {
                if jsonExp?.number("success").intValue == SESSIONEXPIRED {
                    kAppDelegate.sessionExpired(self)
                    return
                }
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
                    self.userData = try JSONDecoder().decode(ProfileJSON.self, from: data!)
                    if self.userData != nil {
                        let user = UserDefaults.standard
                        if self.userData?.data.rating != nil {
                            user.set(self.userData?.data.rating, forKey: Key_User_rating)
                        }
                        user.set(self.userData?.step1, forKey: Key_step1)
                        user.set(self.userData?.step2, forKey: Key_step2)
                        user.set(self.userData?.step3, forKey: Key_step3)
                        user.set(self.userData?.step4, forKey: Key_step4)
                        user.set(self.userData?.step5, forKey: Key_step5)
                        user.synchronize()
                    }

                    self.goNext ()
                } catch let error {
                    print("Error: \(error)")
                }
            }
        }
    }
    
    func goNext () {
        if self.userData == nil {
            return
        }
        
        let userData = self.userData!
        let user = UserDefaults.standard
        
        user.set(userData.data.aboutMe, forKey: Key_User_about_me)
        user.set(userData.data.access, forKey: Key_User_access)
        user.set(userData.data.businessName, forKey: Key_User_business_name)
        user.set(userData.data.city, forKey: Key_User_city)
        user.set(userData.data.country, forKey: Key_User_country)
        user.set(userData.data.dob, forKey: Key_User_dob)
        user.set(userData.data.email, forKey: Key_User_email)
        user.set(userData.data.fullName, forKey: Key_User_full_name)
        user.set(userData.data.gender, forKey: Key_User_gender)
        user.set(Int(userData.data.id), forKey: Key_User_id)
        user.set(userData.data.lastLogin, forKey: Key_User_last_login)
        user.set(userData.data.latitude, forKey: Key_User_latitude)
        user.set(userData.data.licenseNumber, forKey: Key_User_license_number)
        user.set(userData.data.longitude, forKey: Key_User_longitude)
        user.set(userData.data.mobile, forKey: Key_User_mobile)
        user.set(userData.data.online, forKey: Key_User_online)
        user.set(userData.data.mobile, forKey: Key_User_phone_number)
        user.set(userData.data.professionalExperience, forKey: Key_User_professional_experience)
        user.set(userData.data.profilePic, forKey: Key_User_profile_pic)
        user.set(userData.data.registerComplete, forKey: Key_User_register_complete)
        user.set(userData.data.verified, forKey: Key_User_verified)
        user.set(userData.data.websiteLink, forKey: Key_User_website_link)
        user.set(userData.data.status, forKey: Key_User_status)
        user.synchronize()
        
        self.checkProfileReloadTable ()
    }
    
    
    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet weak var btnLogoutShow: UIButton!
    
    let key_submit_for_approval = "key_submit_for_approval"
    
    let user = UserDefaults.standard
    
    
    func callAfterSucessOfSubmit(){
        
        btnSubmit.superview?.isHidden = true
        user.set("", forKey: "\(key_submit_for_approval)_\(Key_User_id.getUserValue()!)")
        user.synchronize()
        
        btnSubmit.isHidden = true
        btnLogoutShow.isHidden = true
        
        submitForApprovalSave("tradie_\(Key_User_id.getUserValue()!)")
        
        let vc = story_Tradie.viewController("MyBookings") as! MyBookings
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @IBAction func actionLogoutVal(_ sender: UIButton) {
        let dialogMessage = UIAlertController(title: "Confirm", message: "Are you sure you want to logout!" , preferredStyle: .alert)
        let ok = UIAlertAction(title: "Logout", style: .default, handler: { (action) -> Void in
            kAppDelegate.logout (self)
        })
        let cancel = UIAlertAction(title: "Cancel", style: .default) { (action) -> Void in
        }
        dialogMessage.addAction(cancel)
        dialogMessage.addAction(ok)
        self.present(dialogMessage, animated: true, completion: nil)
        
    }
   
    
    @IBAction func actionSubmitForApproval(_ sender: Any) {
        
        let profilePic = Key_User_profile_pic.getUserValue() as! String
        
        if self.step1 == 1 && self.step2 == 1 && self.step3 == 1 && self.step4 == 1 && profilePic.count != 0 {
            userDefaultsPro.set(true, forKey: "submitDone")
            let param = params()
            param["submit_for_approval"] = "1"
            Http.instance().json(api_submit_for_approval, param, "POST", aai: true, popup: true, prnt: true, nil, nil, sync: false, defaultCalling: false) { (json, para, str, http, data) in
                weak var _self = self
                let jsonExp = json as? NSDictionary
                
                if jsonExp != nil {
                    if jsonExp?.number("success").intValue == SESSIONEXPIRED {
                        kAppDelegate.sessionExpired(self)
                        return
                    }
                }
                let json = json as? NSDictionary
                if json != nil {
                    if json?.number("success").intValue == 1 {
                        _self?.callAfterSucessOfSubmit()
//                        if self.subscriptionStatus == true {
//
//                        }else{
//                            let user = UserDefaults.standard
//                            user.set("1", forKey: user_submit_approval_btn)
//                            self.checkProfileReloadTable ()
//                            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
//                                self.getSubcriptionDetailsFromServer_New()
//                            }
//                        }
                    }else{
                        Http.alert("", json?.string("message"))
                    }
                }
            }
        } else {
            if profilePic.count == 0 {
                self.picturePicker ()
            }else if self.step1 == 0 {
                let vc = story_Profile.viewController("IdentityVerification") as! IdentityVerification
                self.navigationController?.pushViewController(vc, animated: true)
            } else if self.step2 == 0 {
                let vc = story_Profile.viewController("BusinessDetail") as! BusinessDetail
                self.navigationController?.pushViewController(vc, animated: true)
            } else if self.step3 == 0 {
                let vc = story_Profile.viewController("UploadPhotos") as! UploadPhotos
                self.navigationController?.pushViewController(vc, animated: true)
            } else if self.step4 == 0 {
                let vc = story_Profile.viewController("PrimaryBusiness") as! PrimaryBusiness
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    @IBAction func actionPickProfilePicture(_ sender: Any) {
        //        if kAppDelegate.boolSubscriptionExpired {
        //            Http.alert("", "Your subscription has been expired", [self, "Subscribe", "Cancel"])
        //
        //            return
        //        }
        
        picturePicker ()
    }
    
    @IBAction func actionViewProfile(_ sender: Any) {
        let vc = TradieProfile.viewController()
        vc.push(self)
    }
    
    //MARK: - Image Zoom
    
    @IBOutlet var viewImageZoom: UIView!
    
    @IBAction func actionRemoveImageZoom(_ sender: Any) {
        viewImageZoom.removeFromSuperview()
    }
    
    @IBAction func actionZoomImage(_ sender: Any) {
        zoomImage ()
    }
    
    func zoomImage () {
        let url = "\(Server)profile/\(Key_User_id.getUserValue()!)/\(Key_User_profile_pic.getUserValue() as! String)"
        
        imgUser.downloadUIImage(url) { (image, bool) in
            if image != nil {
                self.zoomUIImage(image!)
            } else {
                Toast.toast("Picture not available")
            }
        }
    }
    
    func zoomUIImage (_ image: UIImage) {
        DispatchQueue.main.async {
            self.viewImageZoom.frame = self.view.bounds
            
            self.view.addSubview(self.viewImageZoom)
            
            self.imageScrollView.setup()
            self.imageScrollView.imageScrollViewDelegate = self
            self.imageScrollView.imageContentMode = .aspectFit
            self.imageScrollView.initialOffset = .center
            self.imageScrollView.display(image: image)
        }
    }
    
    @IBOutlet weak var imageScrollView: ImageScrollView!
}

extension Profile: ImageScrollViewDelegate {
    func imageScrollViewDidChangeOrientation(imageScrollView: ImageScrollView) {
        //print("Did change orientation")
    }
    
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        //print("scrollViewDidEndZooming at scale \(scale)")
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //print("scrollViewDidScroll at offset \(scrollView.contentOffset)")
    }
}

extension Profile: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileCell") as! ProfileCell
        
        cell.indexPath = indexPath
        cell.delegate = self
        
        cell.lblCount.text = "\(indexPath.row + 1)"
        
        
        
        if indexPath.row == 0 {
            cell.lblTitle.text = "Identify Verification & About me"
        } else if indexPath.row == 1 {
            cell.lblTitle.text = "Business detail"
        } else if indexPath.row == 2 {
            cell.lblTitle.text = "Upload photos of your work"
        } else if indexPath.row == 3 {
            cell.lblTitle.text = "Additional service information"
        } else if indexPath.row == 4 {
            cell.lblTitle.text = "Add your service location"
        }
        
        cell.imgRight.isHidden = true
        cell.lblCount.superview?.isHidden = true
        
        if indexPath.row == 0 {
            if step1 == 0 {
                print("Index 0 Hide")
                cell.lblCount.superview?.isHidden = false
            } else {
                print("Index 0 Show")
                cell.imgRight.isHidden = false
            }
        } else if indexPath.row == 1 {
            if step2 == 0 {
                print("Index 1 Hide")
                cell.lblCount.superview?.isHidden = false
            } else {
                print("Index 1 Show")
                cell.imgRight.isHidden = false
            }
        } else if indexPath.row == 2 {
            if step3 == 0 {
                print("Index 2 Hide")
                cell.lblCount.superview?.isHidden = false
            } else {
                print("Index 2 Show")
                cell.imgRight.isHidden = false
            }
        } else if indexPath.row == 3 {
            if step4 == 0 {
                print("Index 3 Hide")
                cell.lblCount.superview?.isHidden = false
            } else {
                print("Index 3 Show")
                cell.imgRight.isHidden = false
            }
        } else if indexPath.row == 4 {
            if step5 == 0 {
                cell.lblCount.superview?.isHidden = false
            } else {
                cell.imgRight.isHidden = false
            }
        }
        
        return cell
    }
}

extension Profile: DrawerTransitionDelegate, SideMenuDelegate {
    func initMenu () {
        leftMenu = story_Home.viewController("CustomerMenuViewController") as! CustomerMenuViewController
        leftMenu.delegate = self
        
        self.leftDrawerTransition = DrawerTransition(target: self, drawer: leftMenu)
        self.leftDrawerTransition.setPresentCompletion {  }
        self.leftDrawerTransition.setDismissCompletion {  }
        self.leftDrawerTransition.edgeType = .left
    }
    
    func menuClicked (_ vc: String) {
        if vc == Key_Menu_VC_RateReview {
            let vc = story_Tradie.viewController("RateNReview") as! RateNReview
            self.navigationController?.pushViewController(vc, animated: true)
        } else if vc == Key_Menu_VC_AboutUs {
            let vc = story_Home.viewController("WebPage") as! WebPage
            vc.linkType = .aboutus
            self.navigationController?.pushViewController(vc, animated: true)
        } else if vc == Key_Menu_VC_TermsCondition {
            let vc = story_Home.viewController("WebPage") as! WebPage
            vc.linkType = .termsncondition
            self.navigationController?.pushViewController(vc, animated: true)
        } else if vc == Key_Menu_VC_PrivacyPolicy {
            let vc = story_Home.viewController("WebPage") as! WebPage
            vc.linkType = .privacypolicy
            self.navigationController?.pushViewController(vc, animated: true)
        } else if vc == Key_Menu_VC_Logout {
            kAppDelegate.logout (self)
        } else if vc == Key_Menu_VC_Payment {
            let vc = story_Home.viewController("Help")
            //let vc = story_Payment.viewController("ChooseSubscripiton")
            self.navigationController?.pushViewController(vc!, animated: false)
        } else if vc == Key_Menu_VC_InviteFriends {
            let vc = story_Payment.viewController("InviteFriends")
            self.navigationController?.pushViewController(vc!, animated: false)
        }else if vc == Key_Menu_VC_Support {
            let vc = story_Home.viewController("SupportVC")
            self.navigationController?.pushViewController(vc!, animated: false)
        }else if vc == Key_Menu_VC_HowItWork {
            
            let vc = story_Payment.viewController("FrequentlyAskedQuestion")
            self.navigationController?.pushViewController(vc!, animated: false)
        }else if vc == Key_Menu_VC_FAQ {
            let vc = story_Payment.viewController("HowItWork_Screen")
            self.navigationController?.pushViewController(vc!, animated: false)
        }
    }
    
    func logout () {
        let param = params()
        Http.instance().json(api_logout, param, "POST", aai: true, popup: true, prnt: true, nil, nil, sync: false, defaultCalling: false) { (json, paras, str, data) in
            let jsonExp = json as? NSDictionary
            
            if jsonExp != nil {
                if jsonExp?.number("success").intValue == SESSIONEXPIRED {
                    kAppDelegate.sessionExpired(self)
                    return
                }
            }
            
            let json = json as? NSDictionary
            
            if json != nil {
                if json?.number("success").intValue == 1 {
                    UIApplication.shared.applicationIconBadgeNumber = 0
                }
                Http.alert("", json?.string("message"))
            }
        }
    }
}

extension Profile: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func picturePicker () {
        let myalert = UIAlertController(title: "Choose option", message: "", preferredStyle: UIAlertController.Style.actionSheet)
        
        myalert.addAction(UIAlertAction(title: "Camera", style: .default) { (action:UIAlertAction!) in
            self.openCamera()
        })
        
        myalert.addAction(UIAlertAction(title: "Gallery", style: .default) { (action:UIAlertAction!) in
            self.openGallary()
        })
        
        myalert.addAction(UIAlertAction(title: "Cancel", style: .cancel) { (action:UIAlertAction!) in
            
        })
        
        self.present(myalert, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        print("IMage UPloaded")
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.uploadProfilePicture(pickedImage)
        } else if let pickedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            self.uploadProfilePicture(pickedImage)
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.isNavigationBarHidden = false
        self.dismiss(animated: true, completion: nil)
    }
    
    func openCamera() {
        let imagePicker = UIImagePickerController()
        
        imagePicker.delegate = self
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera)) {
            
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        } else {
            let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func openGallary() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        imagePicker.allowsEditing = false
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func uploadProfilePicture (_ image1: UIImage) {
        let param = params()
        
        let image = NSMutableArray()
        let md = NSMutableDictionary()
        md["image"] = image1
        md["param"] = "image"
        print("---",md)
        image.add(md)
        
        Http.instance().json(api_upload_profile_picture, param, "POST", aai: true, popup: true, prnt: true, nil, image, sync: false, defaultCalling: false) { (json, para, str, http, data) in
            let jsonExp = json as? NSDictionary
            
            if jsonExp != nil {
                if jsonExp?.number("success").intValue == SESSIONEXPIRED {
                    kAppDelegate.sessionExpired(self)
                    return
                }
            }
            let json = json as? NSDictionary
            if json != nil {
                if json?.number("success").intValue == 1 {
                    self.imgUser.image = image1
                    self.btnCamera.isHidden = true
                    self.btnChange.isHidden = false
                    Key_User_profile_pic.setUserValue((json?.string("data"))!)
                    self.checkProfileReloadTable ()
                }
                Http.alert("", json?.string("message"))
            }
        }
    }
}

extension Profile: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, TabbarCellDelegate {
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
        
        return CGSize(width: hh, height: 50)
        
        //return CGSize(width: cltnTabbar.frame.size.width / CGFloat(kAppDelegate.tabItems().count), height: 58)
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
extension String {
    func concat (_ add: String?, _ with: String = ",") -> String {
        if add == nil {
            return self
        }
        
        if add!.count == 0 {
            return self
        }
        
        var str = self
        
        if str.count == 0 {
            str = add!
        } else {
            str = "\(str)\(with)\(add!)"
        }
        
        return str
    }
}

extension Profile {
    func verifyReceipt(completion: @escaping (VerifyReceiptResult) -> Void) {
        SwiftyStoreKit.verifyReceipt(using: appleValidator, completion: completion)
    }
    
    func verifyNow () {
        //Http.startActivityIndicator()
        
        verifyReceipt { (result) in
            Http.stopActivityIndicator()
            
            switch result {
            case .success(let receipt):
                //print("Verify receipt Success: \(receipt)")
                
                if let pending_renewal_info = receipt["pending_renewal_info"] as? NSArray {
                    //print("pending_renewal_info-\(pending_renewal_info)-")
                }
                
                if let latest_receipt_info = receipt["latest_receipt_info"] as? NSArray {
                    if let last = latest_receipt_info.lastObject as? NSDictionary {
                        
                        //print("last-\(last)-")
                        
                        let time = last.number("expires_date_ms").doubleValue
                        
                        kAppDelegate.setPurchasedDate (time)
                        
                        //print("time-\(time)-")
                        //date-2020-01-11 13:23:39 +0000-
                        
                        let date = Date.init(timeIntervalSince1970: time/1000)
                        let date1 = Date()
                        
                        //print("date-\(date)-")
                        
                        let int = date1.timeIntervalSince(date)
                        
                        //print("int-[\(int)]-")
                        
                        let pending_renewal_info = receipt["pending_renewal_info"] as? NSArray
                        
                        //self.sendPurchaseDataToServer(last, pending_renewal_info, receipt["pending_renewal_info"], receipt)
                        
                        if int > 0 {
                            kAppDelegate.boolSubscriptionExpired = true
                            
                            print("purchase now")
                        } else {
                            kAppDelegate.boolSubscriptionExpired = false
                            kAppDelegate.setPurchased()
                            
                            print("purchased")
                        }
                    }
                } else {
                    kAppDelegate.boolSubscriptionExpired = true
                }
            case .error(let error):
                //self.viewSubscriptionDecision.removeFromSuperview()
                print("Verify receipt Failed: \(error)")
                
                kAppDelegate.boolSubscriptionExpired = true
            }
        }
    }
    
    func sendPurchaseDataToServer (_ last: NSDictionary, _ pending_renewal_info: NSArray?, _ pending_renewal_info_any: Any?, _ receiptresponce: Any?) {
        print("last-\(last)-")
        
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
        
        print("para-\(para)-")
        
        /*Http.instance().json(api_new_save_subscription_data, para, "POST", aai: false, popup: false, prnt: true, nil, nil, sync: false, defaultCalling: true) { (json, para, ss, ht, data) in
         print("1Harish json-\(json)-")
         
         DispatchQueue.global().async {
         Http.instance().json(api_save_purchase_history, param, "POST", aai: false, popup: false, prnt: true, nil, nil, sync: false, defaultCalling: true) { (json, para, ss, ht, data) in
         //print("2Harish json-\(json)-")
         }
         }
         }*/
    }
}







class BlurredLabel: UILabel {

    func blur(_ blurRadius: Double = 2.5) {
        let blurredImage = getBlurryImage(blurRadius)
        let blurredImageView = UIImageView(image: blurredImage)
        blurredImageView.translatesAutoresizingMaskIntoConstraints = false
        blurredImageView.tag = 100
        blurredImageView.contentMode = .center
        blurredImageView.backgroundColor = .white
        addSubview(blurredImageView)
        NSLayoutConstraint.activate([
            blurredImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            blurredImageView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }

    func unblur() {
        subviews.forEach { subview in
            if subview.tag == 100 {
                subview.removeFromSuperview()
            }
        }
    }

    private func getBlurryImage(_ blurRadius: Double = 2.5) -> UIImage? {
        UIGraphicsBeginImageContext(bounds.size)
        layer.render(in: UIGraphicsGetCurrentContext()!)
        guard let image = UIGraphicsGetImageFromCurrentImageContext(),
            let blurFilter = CIFilter(name: "CIGaussianBlur") else {
            UIGraphicsEndImageContext()
            return nil
        }
        UIGraphicsEndImageContext()

        blurFilter.setDefaults()

        blurFilter.setValue(CIImage(image: image), forKey: kCIInputImageKey)
        blurFilter.setValue(blurRadius, forKey: kCIInputRadiusKey)

        var convertedImage: UIImage?
        let context = CIContext(options: nil)
        if let blurOutputImage = blurFilter.outputImage,
            let cgImage = context.createCGImage(blurOutputImage, from: blurOutputImage.extent) {
            convertedImage = UIImage(cgImage: cgImage)
        }

        return convertedImage
    }
}
