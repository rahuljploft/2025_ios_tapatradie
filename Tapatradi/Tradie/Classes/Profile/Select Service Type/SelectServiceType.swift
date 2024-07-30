//
//  SelectServiceType.swift
//  Tradie
//
//  Created by Apple on 07/05/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class SelectServiceType: UIViewController {
    
    var otherService = ""
    var services = ""
    var selected_services = ""
    var removed = ""
    
    var isFromRegister = false
    
    
    @IBAction func actionBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        //boolResidential = true
        //boolCommercial = true
        
        selectResidential ()
        selectCommercial ()

        kAppDelegate.currentVC = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("selected_services-\(selected_services)-")
        
//        btnResidential.setTitleColor(UIColor.black, for: .normal)
        btnResidential.superview?.border(colorUnSelected, 4, 0.25)
        
//        btnCommercial.setTitleColor(UIColor.black, for: .normal)
        btnCommercial.superview?.border(colorUnSelected, 4, 0.25)
        
        let old = selected_services.components(separatedBy: ",")
        
        if old.count > 0 {
            let new = services.components(separatedBy: ",")
            
            if new.count > 0 {
                for i in 0..<old.count {
                    var count = 0
                    for j in 0..<new.count {
                        if old[i] == new[j] {
                            break
                        }
                        
                        count += 1
                    }
                    
                    if new.count == count {
                        if removed.count == 0 {
                            removed = "\(old[i])"
                        } else {
                            removed = "\(removed),\(old[i])"
                        }
                    }
                }
            }
        }
        
        print("removed-\(removed)-")
    }
    
    var boolResidential = true
    @IBOutlet weak var btnResidential: UIButton!
    @IBAction func actionResidential(_ sender: Any) {
        boolResidential = !boolResidential
        
        selectResidential ()
    }
    
    func selectResidential () {
        if boolResidential {
//            btnResidential.setTitleColor(UIColor.black, for: .normal)
            btnResidential.superview?.border(colorSelected, 4, 1)
        } else {
//            btnResidential.setTitleColor(UIColor.black, for: .normal)
            btnResidential.superview?.border(colorUnSelected, 4, 0.25)
        }
    }
    
    var boolCommercial = true
    @IBOutlet weak var btnCommercial: UIButton!
    @IBAction func actionCommercial(_ sender: Any) {
        boolCommercial = !boolCommercial
        
        selectCommercial ()
    }
    
    let colorSelected: UIColor = UIColor.hexColor(0x008000)
    let colorUnSelected: UIColor = UIColor.black
    
    func selectCommercial () {
        if boolCommercial {
//            btnCommercial.setTitleColor(UIColor.black, for: .normal)
            btnCommercial.superview?.border(colorSelected, 4, 1)
        } else {
//            btnCommercial.setTitleColor(UIColor.black, for: .normal)
            btnCommercial.superview?.border(colorUnSelected, 4, 0.25)
        }
    }
    
    @IBAction func actionGetStartted(_ sender: Any) {
        
//        if kAppDelegate.boolSubscriptionExpired {
//            Http.alert("", "Your subscription has been expired", [self, "Subscribe", "Cancel"])
//
//            return
//        }
//
        
        
        
//        let alert = UIAlertController(title: "Alert", message: "Your Subscription has been expired", preferredStyle: .alert)
//
//        let action1 = UIAlertAction(title: "Subscribe", style: .default) { (_) in
//            self.alertZero()
//        }
//
//        let action2 = UIAlertAction(title: "Skip", style: .default) { (_) in
//            self.addServices()
//        }
//
//        alert.addAction(action1)
//        alert.addAction(action2)
//        self.present(alert, animated: true, completion: nil)
        
        
        addServices()
        
        
    }
    
    
    
    func addServices()
    {
     
        
        if !boolCommercial && !boolResidential {
            Http.alert("", "Please select service type")
        } else {
            let param = params()
            
            param["services_id"] = services
            param["other"] = otherService
            param["remove_services"] = removed
            
            if boolCommercial && boolResidential {
                param["services_type"] = "residential,commercial"
            } else if boolCommercial {
                param["services_type"] = "commercial"
            } else if boolResidential {
                param["services_type"] = "residential"
            }
            
            Http.instance().json(api_provider_assign_service_to_him, param, "POST", aai: true, popup: true, prnt: true, nil, nil, sync: false, defaultCalling: false) { (json, paras, str, data) in
                let jsonExp = json as? NSDictionary
                
                if jsonExp != nil {
                    if jsonExp?.number("success").intValue == SESSIONEXPIRED {
                       kAppDelegate.sessionExpired(self)
                    return
                    }
                }
                let json = json as? NSDictionary
                if json != nil {
                    //Http.alert("", json?.string("message"))
                    //Http.alert("", "Service successfully assigned")
                    if json?.number("success").intValue == 1 {
                        let user = UserDefaults.standard
                        user.set("1", forKey: getPrimaryServiceKey ())
                        user.synchronize()
                        //MARK: InAppPurchase - (Comment Below Code and Uncomment Code Below 'print("ChooseSubscripiton")' to Show Premium for In App Screen) - Himanshu Jangid
                        let vc = story_Profile.viewController("Profile") as! Profile
                        self.navigationController?.pushViewController(vc, animated: true)
//                        let vc = story_Tradie.viewController("MyBookings")!
//                        vc.boolFromRegistration = true
//                        self.navigationController?.pushViewController(vc, animated: true)
                        print("ChooseSubscripiton")
//                        let vc = story_Payment.viewController("ChooseSubscripiton") as! ChooseSubscripiton
//                        vc.isFromRegister = self.isFromRegister
//                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                }
            }
        }
        
    }
    
    
}

extension SelectServiceType: AlertDelegate {
    func alertZero() {
        let vc = story_Payment.viewController("ChooseSubscripiton") as? ChooseSubscripiton
        vc?.boolFromMenu = false
        self.navigationController?.pushViewController(vc!, animated: false)
    }
    
    func alertOne() {
        
    }    
}
