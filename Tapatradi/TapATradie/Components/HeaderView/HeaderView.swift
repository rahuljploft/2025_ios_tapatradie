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
        view = loadViewFromNib(nibName: nibName, frame: self.bounds)
        self.addSubview(view)
        
        initButtons()
        initNotification()
        setAddress()
        setNotificationCount()
    }
    
    override func awakeFromNib() {
        initMenu()
        initDrawerTransition()
    }
    
    private func initButtons() {
        hamburgerMenuButton.setTitle("", for: .normal)
        addressButton.setTitle("", for: .normal)
        notificationButton.setTitle("", for: .normal)
    }
    
    private func initNotification() {
        notificationCountLabel.superview?.border5(notificationCountLabel.superview!.frame.size.height / 2)
    }
    
    private func setAddress() {
        guard let userAddress = kAppDelegate.getUserAddress() else { return }
        addressButton.setTitle(userAddress.address, for: .normal)
    }
    
    private func setNotificationCount() {
        self.notificationCountLabel.superview?.isHidden = true
        getNotificationCount { [weak self] count in
            guard let self = self else { return }
            self.notificationCountLabel.superview?.isHidden = count == 0
            self.notificationCountLabel.text = String(count)
        }
    }
    
    private func getNotificationCount(completion: @escaping (Int) -> Void) {
        let param = params()
        
        Http.instance().json(api_get_unread_notification_count, param, "POST", aai: false, popup: false, prnt: true, nil, nil, sync: false, defaultCalling: false) { (json, paras, str, data) in
            
            let jsonExp = json as? NSDictionary
            
            if jsonExp != nil {
                if jsonExp?.number("success").intValue == SESSIONEXPIRED {
                    kAppDelegate.sessionExpired(self.parentViewController!)
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
        self.leftDrawerTransition.presentDrawerViewController(animated: true)
    }
    
    @IBAction func backButton_touchUpInside(_ sender: UIButton) {
        self.parentViewController?.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func address_touchUpInside(_ sender: UIButton) {
        let vc = story_Auth.viewController("SeeTradiesArround") as! SeeTradiesArround
        self.parentViewController?.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func notificationButton_touchUpInside(_ sender: UIButton) {
        let vc = story_Home.viewController("Notifications") as! Notifications
        self.parentViewController?.navigationController?.pushViewController(vc, animated: true)
    }
}

extension HeaderView: SideMenuDelegate {
    
    func menuClicked (_ vc: String) {
        if vc == Key_Menu_VC_AboutUs {
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
        }else if vc == Key_Menu_VC_InviteFriends {
            let vc = story_Invite.viewController("InviteFriends")
            self.parentViewController?.navigationController?.pushViewController(vc!, animated: false)
        }else if vc == Key_Menu_VC_Support {
            let vc = story_Home.viewController("SupportVC")
            self.parentViewController?.navigationController?.pushViewController(vc!, animated: false)
        }else if vc == Key_Menu_VC_HowItWork {
            let vc = story_Invite.viewController("HowItWork_Screen")
            self.parentViewController?.navigationController?.pushViewController(vc!, animated: false)
        }else if vc == Key_Menu_VC_FAQ {
            let vc = story_Invite.viewController("FrequentlyAskedQuestion")
            self.parentViewController?.navigationController?.pushViewController(vc!, animated: false)
        }
    }
    
}
