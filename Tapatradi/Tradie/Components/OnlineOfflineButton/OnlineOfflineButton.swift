//
//  OnlineOfflineButton.swift
//  Tradie
//
//  Created by Aman Maharjan on 29/10/2021.
//

import Foundation
import UIKit

@IBDesignable class OnlineOfflineButton: UIView {
    
    let nibName = "\(OnlineOfflineButton.self)"
    
    @IBOutlet var view: UIView!
    @IBOutlet weak var imgOnline: UIImageView!
    
    override var intrinsicContentSize: CGSize {
        let size = 58
        return CGSize(width: size, height: size)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
        setOnlineOfflineImage ()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
        setOnlineOfflineImage ()
    }
    
    private func commonInit() {
        view = loadViewFromNib(nibName: nibName, frame: self.bounds)
        self.addSubview(view)
        setOnlineOfflineImage ()
    }
    
    @IBAction func actionOnlineOffline(_ sender: Any) {
        var online = Key_User_online.getUserValue()
        
        if online == nil {
            Key_User_online.setUserValue("0")
            online = "0"
        }
        
//        if "\(online!)" == "1" {
            actionRightOnlineOffline("")
//        }
//        else {
//            viewOnlineOfflineRightCross.frame = self.view.bounds
//            self.view.addSubview(viewOnlineOfflineRightCross)
//        }
    }
    
    @IBAction func actionRightOnlineOffline(_ sender: Any) {
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
        
        print(param)
        
        Http.instance().json(api_provider_online_status, param, "POST", aai: true, popup: true, prnt: false, nil, nil, sync: false, defaultCalling: false) { (json, para, str, http, data) in
            let json = json as? NSDictionary
            print(json)
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
            }
            
            let jsonExp = json as? NSDictionary
            
            if jsonExp != nil {
                if jsonExp?.number("success").intValue == SESSIONEXPIRED {
                    kAppDelegate.sessionExpired(self.parentViewController!)
                    
                    return
                }
            }
        }
    }
    
    func setOnlineOfflineImage () {
        var online = Key_User_online.getUserValue()
        
        if online == nil {
            Key_User_online.setUserValue("0")
            online = "0"
        }
        
        if "\(online!)" == "1" {
            imgOnline.image = #imageLiteral(resourceName: "Online Button")
        } else {
            imgOnline.image = #imageLiteral(resourceName: "Offline Button")
        }
        
        //setAddress ()
    }
    
}
