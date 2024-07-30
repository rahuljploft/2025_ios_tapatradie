//
//  CustomerMenuViewController.swift
//  i Tuppers
//
//  Created by Apple on 06/03/18.
//  Copyright © 2018 OZONESOFT Solutions. All rights reserved.
//

import UIKit
import Common

@objc protocol TapATradie_SideMenuDelegate{
    @objc optional func TapATradie_menuClicked (_ vc: String)
}

//let Key_Menu_VC_AboutUs = "Key_Menu_VC_AboutUs"
//let Key_Menu_VC_TermsCondition = "Key_Menu_VC_TermsCondition"
//let Key_Menu_VC_PrivacyPolicy = "Key_Menu_VC_PrivacyPolicy"
//let Key_Menu_VC_Logout = "Key_Menu_VC_Logout"
//let Key_Menu_VC_InviteFriends = "Key_Menu_VC_InviteFriends"
//let Key_Menu_VC_Support = "Key_Menu_VC_Support"

//MARK: Himanshu Update (How It Work)
//let Key_Menu_VC_HowItWork = "Key_Menu_VC_HowItWork"
//let Key_Menu_VC_FAQ = "Key_Menu_VC_FrequentlyAskQuestion"

class TapATradie_CustomerMenuViewController: UIViewController,TapATradie_FloatRatingViewDelegate {
    
    open var viewMenu: UIView!
    var delegate: TapATradie_SideMenuDelegate?
    
    @IBOutlet weak var imgProfilePicture: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imgProfilePicture.border(UIColor.white, imgProfilePicture.frame.height/2, 1)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        TapATradie_kAppDelegate.TapATradie_currentVC = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        lblName.text = (TapATradie_Key_User_full_name.TapATradie_getUserValue() as? String)?.capFirstLetter()
        
        let url = "\(TapATradie_Server)profile/\(TapATradie_Key_User_id.TapATradie_getUserValue() as! Int)/\(TapATradie_Key_User_profile_pic.TapATradie_getUserValue() as! String)"
        
        //print("url-\(url)-")
        
        imgProfilePicture.image = #imageLiteral(resourceName: "Group 2826")
        imgProfilePicture.downloadUIImage(url) { (image, bool) in
            if image != nil {
                DispatchQueue.main.async {
                    self.imgProfilePicture.image = image
                }
            }
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBAction func actionAboutUs(_ sender: Any) {
        "https://www.tapatradie.com/about-us".openAsUrl()
    }
    
    @IBAction func actionTermCondition(_ sender: Any) {
        "https://www.tapatradie.com/terms-conditions".openAsUrl()
    }
    
    @IBAction func actionPrivacyPolicy(_ sender: Any) {
        "https://www.tapatradie.com/privacy-policy".openAsUrl()
    }
    
    @IBAction func actionInviteFriends(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        delegate?.TapATradie_menuClicked!(Key_Menu_VC_InviteFriends)
    }
    
    @IBAction func howItWorks_touchUpInside(_ sender: UIButton) {
        //"https://www.tapatradie.com/how-it-works".openAsUrl()
        self.dismiss(animated: true, completion: nil)
        delegate?.TapATradie_menuClicked!(Key_Menu_VC_HowItWork)
    }
    
    @IBAction func faq_touchUpInside(_ sender: UIButton) {
        //"https://www.tapatradie.com/faq".openAsUrl()
        self.dismiss(animated: true, completion: nil)
        delegate?.TapATradie_menuClicked!(Key_Menu_VC_FAQ)
    }
    
    
    @IBAction func becomeATradie(_ sender: UIButton) {
        guard let url = URL(string: "https://apps.apple.com/us/app/tradie/id1473400813") else { return }
        UIApplication.shared.open(url)
        delegate?.TapATradie_menuClicked!(Key_Menu_VC_FAQ)
    }
    
    
    @IBAction func btnSupportTapped(_ sender: UIButton) {
        
//        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SupportVC") as! SupportVC
//        self.navigationController?.push(viewController: vc, animated: true)
        self.dismiss(animated: true, completion: nil)
        delegate?.TapATradie_menuClicked!(Key_Menu_VC_Support)
    }
    
    
    @IBAction func actionLogout(_ sender: Any) {
        let dialogMessage = UIAlertController(title: "Confirm", message: "Are you sure you want to logout!" , preferredStyle: .alert)
        
        let ok = UIAlertAction(title: "Logout", style: .default, handler: { (action) -> Void in
            self.dismiss(animated: true, completion: nil)
            self.delegate?.TapATradie_menuClicked!(Key_Menu_VC_Logout)
        })
        
        // Create Cancel button with action handlder
        let cancel = UIAlertAction(title: "Cancel", style: .default) { (action) -> Void in
            
        }
        
        dialogMessage.addAction(cancel)
        dialogMessage.addAction(ok)
        
        // Present dialog message to user
        self.present(dialogMessage, animated: true, completion: nil)
    }
    
}
