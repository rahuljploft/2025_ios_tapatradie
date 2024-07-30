//
//  HeaderView.swift
//  TapATradie
//
//  Created by Aman Maharjan on 16/10/2021.
//

import Foundation
import UIKit
import Common

@IBDesignable class HeaderView: UIView {
    
    let nibName = "\(HeaderView.self)"
    
    @IBOutlet weak var viewNotification: UIView!
    @IBOutlet var view: UIView!
    @IBOutlet weak var hamburgerMenuButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var addressButton: UIButton!
    @IBOutlet weak var notificationButton: UIButton!
    @IBOutlet weak var notificationCountLabel: UILabel!
    
    @IBInspectable var showBack: Bool = false {
        didSet {
            hamburgerMenuButton.isHidden = showBack
            backButton.isHidden = !showBack
        }
    }
    
    @IBInspectable var addressEnabled: Bool = true {
        didSet {
            addressButton.isEnabled = addressEnabled
        }
    }
    
    private var leftMenu  = CustomerMenuViewController()
    private var leftDrawerTransition:DrawerTransition!
    
    private var TapATradie_leftMenu  = TapATradie_CustomerMenuViewController()
    private var TapATradie_leftDrawerTransition:TapATradie_DrawerTransition!
    
    override var intrinsicContentSize: CGSize {
        print("safe area top inset: ", safeAreaInsets.top)
        return CGSize(width: self.frame.width, height: 45 + UIApplication.shared.safeAreaInsets.top)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        if Config.shared.appRole == "provider" {
            view = loadViewFromNib(nibName: nibName, frame: self.bounds)
            self.addSubview(view)
            initButtons()
            initNotification()
        }else{
            view = loadViewFromNib(nibName: nibName, frame: self.bounds)
            self.addSubview(view)
            
            TapATradie_initButtons()
            TapATradie_initNotification()
            TapATradie_setAddress()
            TapATradie_setNotificationCount()
        }
    }
    
    override func awakeFromNib() {
        if Config.shared.appRole == "provider" {
            initMenu()
            initDrawerTransition()
            updateData()
        }else{
            TapATradie_initMenu()
            TapATradie_initDrawerTransition()
        }
    }
    
    private func initButtons() {
        hamburgerMenuButton.setTitle("", for: .normal)
        addressButton.setTitle("", for: .normal)
        notificationButton.setTitle("", for: .normal)
    }
    
    private func initNotification() {
        notificationCountLabel.superview?.border5(notificationCountLabel.superview!.frame.size.height / 2)
    }
    
    func updateData() {
        if Config.shared.appRole == "provider" {
            getBusinessData ()
            getAddressFromServer ()
            setNotificationCount()
        }
    }
    
    var businessDetailJSON: BusinessDetailJSON?
    
    func getBusinessData () {
        let param = params()
        
        Http.instance().json(api_provider_get_business_detail, param, "POST", aai: false, popup: true, prnt: false, nil, nil, sync: false, defaultCalling: false) { (json, paras, str, data) in
            
            let jsonExp = json as? NSDictionary
            
            if jsonExp != nil {
                if jsonExp?.number("success").intValue == SESSIONEXPIRED {
                    //kAppDelegate.sessionExpired(self.parentViewController!)
                    //kAppDelegate.generateAccessToken()
                    kAppDelegate.logout(self.parentViewController!)
                    return
                }
            }
            
            if data != nil {
                do {
                    self.businessDetailJSON = try JSONDecoder().decode(BusinessDetailJSON.self, from: data!)
                    self.setBusinessAddress()
                } catch let error {
                    print("Error: \(error)")
                }
            }
        }
    }
    
    func setBusinessAddress () {
        if businessDetailJSON?.businessData != nil {
            let address = "\(businessDetailJSON?.businessData?.houseNo ?? "") \(businessDetailJSON?.businessData?.street ?? "") \(businessDetailJSON?.businessData?.city ?? "") \(businessDetailJSON?.businessData?.state ?? "") \(businessDetailJSON?.businessData?.country ?? "") \(businessDetailJSON?.businessData?.pincode ?? "")"
            
            print("address-\(address)-")
            let addd = getAddressOrLatLong(nil, nil, address, false)
            let ob1 = Addresses("")
            ob1.locationName = "Home"
            ob1.address = address
            ob1.city = businessDetailJSON?.businessData?.city
            ob1.country = businessDetailJSON?.businessData?.country
            ob1.state = businessDetailJSON?.businessData?.state
            
            if addd != nil {
                if addd?.lat != nil && addd?.long != nil {
                    ob1.latitude = "\((addd?.lat)!)"
                    ob1.longitude = "\((addd?.long)!)"
                }
            }
            
            kAppDelegate.setUserAddressBusiness(ob1)
        }
    }
    
    private func setAddress() {
        guard let userAddress = kAppDelegate.getUserAddress() else { return }
        addressButton.setTitle(userAddress.address, for: .normal)
        
        var online = Key_User_online.getUserValue()
        
        if online == nil {
            Key_User_online.setUserValue("0")
            online = "0"
        }
        
        if "\(online!)" == "1" {
            let ob = kAppDelegate.getUserAddress()
            
            if ob != nil {
                addressButton.setTitle(ob?.address, for: .normal)
            } else {
                addressButton.setTitle("Please select address", for: .normal)
                kAppDelegate.setLocationCurrentAddress ()
                setLocationCurrentAddress ()
            }
        } else {
            let ob = kAppDelegate.getUserAddressBusiness()
            if ob != nil {
                addressButton.setTitle(ob?.address, for: .normal)
            }
        }
    }
    
    func setLocationCurrentAddress () {
        var online = Key_User_online.getUserValue()
        
        if online == nil {
            Key_User_online.setUserValue("0")
            online = "0"
        }
        
        if "\(online!)" == "1" {
            let ob = kAppDelegate.getUserAddress()
            
            if ob != nil {
                addressButton.setTitle(ob?.address, for: .normal)
            }
        }
    }
    
    private func setNotificationCount() {
        self.notificationCountLabel.superview?.isHidden = true
        getNotificationCount { [weak self] count in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self.notificationCountLabel.superview?.isHidden = count == 0
                self.notificationCountLabel.text = String(count)
            }
            
        }
    }
    
    private func getNotificationCount(completion: @escaping (Int) -> Void) {
        let param = params()
        
        Http.instance().json(api_get_unread_notification_count, param, "POST", aai: false, popup: false, prnt: true, nil, nil, sync: false, defaultCalling: false) { (json, paras, str, data) in
            
            let jsonExp = json as? NSDictionary
            
            if jsonExp != nil {
                if jsonExp?.number("success").intValue == SESSIONEXPIRED {
                    //kAppDelegate.sessionExpired(self.parentViewController!)
                    
                    completion(0)
                    return
                }
            }
            
            let json = json as? NSDictionary
            
            if json != nil {
                if json?.number("success").intValue == 1 {
                    let badge_count = json?.number("badge_count").intValue
                    
                    if badge_count != nil {
                        kAppDelegate.badgeCount(badge_count!)
                    }
                    
                    guard let notificationCount = json?.number("notification_count").intValue else {
                        completion(0)
                        return
                    }
                    completion(notificationCount)
                    return
                }
            }
            
            completion(0)
        }
    }
    
    private func initMenu() {
        self.leftMenu = story_Home.viewController("CustomerMenuViewController") as! CustomerMenuViewController
        self.leftMenu.delegate = self
    }
    
    private func initDrawerTransition() {
        self.leftDrawerTransition = DrawerTransition(target: self.parentViewController!, drawer: leftMenu)
        self.leftDrawerTransition.setPresentCompletion {  }
        self.leftDrawerTransition.setDismissCompletion {  }
        self.leftDrawerTransition.edgeType = .left
    }
    
    @IBAction func hamburgerMenuButton_touchUpInside(_ sender: UIButton) {
        if Config.shared.appRole == "provider" {
            self.leftDrawerTransition.presentDrawerViewController(animated: true)
        }else{
            self.TapATradie_leftDrawerTransition.presentDrawerViewController(animated: true)
        }
    }
    
    @IBAction func backButton_touchUpInside(_ sender: UIButton) {
        if Config.shared.appRole == "provider" {
            self.parentViewController?.navigationController?.popViewController(animated: true)
        }else{
            self.parentViewController?.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func address_touchUpInside(_ sender: UIButton) {
        if Config.shared.appRole == "provider" {
            var online = Key_User_online.getUserValue()
            if online == nil {
                Key_User_online.setUserValue("0")
                online = "0"
            }
            let vc = story_Auth.viewController("SeeTradiesArround") as! SeeTradiesArround
            self.parentViewController?.navigationController?.pushViewController(vc, animated: true)
        }else{
            let vc = TapATradie_story_Auth.TapATradie_viewController("SeeTradiesArround") as! TapATradie_SeeTradiesArround
            self.parentViewController?.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func notificationButton_touchUpInside(_ sender: UIButton) {
        if Config.shared.appRole == "provider" {
            let vc = story_Home.viewController("Notifications") as! Notifications
            self.parentViewController?.navigationController?.pushViewController(vc, animated: true)
        }else{
            let vc = TapATradie_story_Home.TapATradie_viewController("Notifications") as! TapATradie_Notifications
            self.parentViewController?.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension HeaderView: SideMenuDelegate {
    
    func menuClicked (_ vc: String) {
        if vc == Key_Menu_VC_RateReview {
            let vc = story_Tradie.viewController("RateNReview") as! RateNReview
            self.parentViewController?.navigationController?.pushViewController(vc, animated: true)
        } else if vc == Key_Menu_VC_AboutUs {
            let vc = story_Home.viewController("WebPage") as! WebPage
            vc.linkType = .aboutus
            self.parentViewController?.navigationController?.pushViewController(vc, animated: true)
        } else if vc == Key_Menu_VC_TermsCondition {
            let vc = story_Home.viewController("WebPage") as! WebPage
            vc.linkType = .termsncondition
            self.parentViewController?.navigationController?.pushViewController(vc, animated: true)
        } else if vc == Key_Menu_VC_PrivacyPolicy {
            let vc = story_Home.viewController("WebPage") as! WebPage
            vc.linkType = .privacypolicy
            self.parentViewController?.navigationController?.pushViewController(vc, animated: true)
        } else if vc == Key_Menu_VC_Logout {
            kAppDelegate.logout (self.parentViewController!)
        } else if vc == Key_Menu_VC_Payment {
            
            print("Help Called--")
            let vc = story_Home.viewController("Help")
            //let vc = story_Payment.viewController("ChooseSubscripiton")
            self.parentViewController?.navigationController?.pushViewController(vc!, animated: false)
        } else if vc == Key_Menu_VC_InviteFriends {
            let vc = story_Payment.viewController("InviteFriends")
            self.parentViewController?.navigationController?.pushViewController(vc!, animated: false)
        }else if vc == Key_Menu_VC_Support {
            let vc = story_Home.viewController("SupportVC")
            self.parentViewController?.navigationController?.pushViewController(vc!, animated: false)
        }else if vc == Key_Menu_VC_HowItWork {
            let vc = story_Payment.viewController("HowItWork_Screen")
            self.parentViewController?.navigationController?.pushViewController(vc!, animated: false)
        }else if vc == Key_Menu_VC_FAQ {
            let vc = story_Payment.viewController("FrequentlyAskedQuestion")
            self.parentViewController?.navigationController?.pushViewController(vc!, animated: false)
        }
        
        
        
    }
    
    func getAddressFromServer () {
        let param = params()
        Http.instance().json(api_tradie_online_address, param, "POST", aai: false, popup: false, prnt: true, nil, nil, sync: false, defaultCalling: true) { (json, para, ss, ht, data) in
            //print("3111 Harish json-\(json)-")
            
            if let json = json as? NSDictionary {
                if let data = json["data"] as? NSArray {
                    for i in 0..<data.count {
                        if let dt = data[i] as? NSDictionary {
                            
                            let latitude = dt.string("latitude")
                            let longitude = dt.string("longitude")
                            let online_address = dt.string("online_address")
                            
                            
                            
                            let ob = Addresses("")
                            ob.address = online_address
                            ob.latitude = latitude
                            ob.longitude = longitude
                            
                            if online_address == "" || online_address == "undefined" || latitude == "" || longitude == ""{
                                kAppDelegate.setLocationCurrentAddress ()
                                self.setAddress ()
                            }else{
                                kAppDelegate.setUserAddress(ob)
                                
                                self.setAddress ()
                            }
                            
                            
                            break
                        }
                    }
                }
            }
        }
    }
    
}



extension HeaderView: TapATradie_SideMenuDelegate {
    
    func TapATradie_menuClicked (_ vc: String) {
        if vc == Key_Menu_VC_AboutUs {
            let vc = TapATradie_story_Home.TapATradie_viewController("WebPage") as! TapATradie_WebPage
            vc.linkType = .aboutus
            self.parentViewController?.navigationController?.pushViewController(vc, animated: true)
        } else if vc == Key_Menu_VC_TermsCondition {
            let vc = TapATradie_story_Home.TapATradie_viewController("WebPage") as! TapATradie_WebPage
            vc.linkType = .termsncondition
            self.parentViewController?.navigationController?.pushViewController(vc, animated: true)
        } else if vc == Key_Menu_VC_PrivacyPolicy {
            let vc = TapATradie_story_Home.TapATradie_viewController("WebPage") as! TapATradie_WebPage
            vc.linkType = .privacypolicy
            self.parentViewController?.navigationController?.pushViewController(vc, animated: true)
        } else if vc == Key_Menu_VC_Logout {
            TapATradie_kAppDelegate.TapATradie_logout (self.parentViewController!)
        }else if vc == Key_Menu_VC_InviteFriends {
            let vc = TapATradie_story_Invite.TapATradie_viewController("InviteFriends")
            self.parentViewController?.navigationController?.pushViewController(vc!, animated: false)
        }else if vc == Key_Menu_VC_Support {
            let vc = TapATradie_story_Home.TapATradie_viewController("SupportVC")
            self.parentViewController?.navigationController?.pushViewController(vc!, animated: false)
        }else if vc == Key_Menu_VC_HowItWork {
            let vc = TapATradie_story_Invite.TapATradie_viewController("HowItWork_Screen")
            self.parentViewController?.navigationController?.pushViewController(vc!, animated: false)
        }else if vc == Key_Menu_VC_FAQ {
            let vc = TapATradie_story_Invite.TapATradie_viewController("FrequentlyAskedQuestion")
            self.parentViewController?.navigationController?.pushViewController(vc!, animated: false)
        }
    }
    
    private func TapATradie_initButtons() {
        hamburgerMenuButton.setTitle("", for: .normal)
        addressButton.setTitle("", for: .normal)
        notificationButton.setTitle("", for: .normal)
    }
    
    private func TapATradie_initNotification() {
        notificationCountLabel.superview?.border5(notificationCountLabel.superview!.frame.size.height / 2)
    }
    
    private func TapATradie_setAddress() {
        guard let userAddress = TapATradie_kAppDelegate.TapATradie_getUserAddress() else { return }
        addressButton.setTitle(userAddress.address, for: .normal)
    }
    
    private func TapATradie_setNotificationCount() {
        self.notificationCountLabel.superview?.isHidden = true
        TapATradie_getNotificationCount { [weak self] count in
            guard let self = self else { return }
            self.notificationCountLabel.superview?.isHidden = count == 0
            self.notificationCountLabel.text = String(count)
        }
    }
    
    private func TapATradie_getNotificationCount(completion: @escaping (Int) -> Void) {
        let param = TapATradie_params()
        
        Http.instance().json(TapATradie_api_get_unread_notification_count, param, "POST", aai: false, popup: false, prnt: true, nil, nil, sync: false, defaultCalling: false) { (json, paras, str, data) in
            
            let jsonExp = json as? NSDictionary
            
            if jsonExp != nil {
                if jsonExp?.number("success").intValue == SESSIONEXPIRED {
                    TapATradie_kAppDelegate.TapATradie_sessionExpired(self.parentViewController!)
                    completion(0)
                    return
                }
            }
            
            let json = json as? NSDictionary
            
            if json != nil {
                if json?.number("success").intValue == 1 {
                    let badge_count = json?.number("badge_count").intValue
                    
                    if badge_count != nil {
                        TapATradie_kAppDelegate.TapATradie_badgeCount(badge_count!)
                    }
                    
                    guard let notificationCount = json?.number("notification_count").intValue else {
                        completion(0)
                        return
                    }
                    completion(notificationCount)
                    return
                }
            }
            
            completion(0)
        }
    }
    
    private func TapATradie_initMenu() {
        self.TapATradie_leftMenu = TapATradie_story_Home.TapATradie_viewController("CustomerMenuViewController") as! TapATradie_CustomerMenuViewController
        self.TapATradie_leftMenu.delegate = self
    }
    
    private func TapATradie_initDrawerTransition() {
        self.TapATradie_leftDrawerTransition = TapATradie_DrawerTransition(target: self.parentViewController!, drawer: TapATradie_leftMenu)
        self.TapATradie_leftDrawerTransition.setPresentCompletion {  }
        self.TapATradie_leftDrawerTransition.setDismissCompletion {  }
        self.TapATradie_leftDrawerTransition.edgeType = .left
    }
    
}
