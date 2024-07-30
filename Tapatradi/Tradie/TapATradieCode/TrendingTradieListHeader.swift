//
//  TrendingTradieListHeader.swift
//  TapATradie
//
//  Created by Aman Maharjan on 15/10/2021.
//

import Foundation
import UIKit

class TrendingTradieListHeader: UICollectionReusableView {
    
    @IBOutlet weak var tfSearchForTradie: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        tfSearchForTradie.superview?.border5(4)
        tfSearchForTradie.superview?.shadow()
        tfSearchForTradie.text = ""
        tfSearchForTradie.delegate = self
    }
    
    @IBAction func actionSearch(_ sender: Any) {
        if (tfSearchForTradie.text?.count ?? 0) > 0 {
            getTradies ()
        } else {
            Http.alert("", "Enter service/tradie name")
        }
        tfSearchForTradie.endEditing(true)
    }
    
    var tradiesJSON: TapATradie_TradiesJSON?
    
    func getTradies () {
        let param = params()
        param["search"] = tfSearchForTradie.text
        param["tradie_type"] = ""
        param["service_id"] = ""
        param["sort_by"] = ""
        param["page"] = "all"
        param["search_type"] = "services"
        
        Http.instance().json(TapATradie_api_user_tradie_search, param, "POST", aai: true, popup: true, prnt: true, nil, nil, sync: false, defaultCalling: false) { (json, paras, str, data) in
            let jsonExp = json as? NSDictionary
            
            if jsonExp != nil {
                if jsonExp?.number("success").intValue == SESSIONEXPIRED {
                    kAppDelegate.sessionExpired(self.parentViewController!)
                    return
                }
            }
            
            let json = json as? NSDictionary
            
            if json != nil {
                if json?.number("success").intValue == 1 {
                    
                } else {
                    if json?.string("message").count == 0 {
                        Http.alert("", "Invalid search.")
                    } else {
                        Http.alert("", json?.string("message"))
                    }
                }
            }
            
            if data != nil {
                do {
                    self.tradiesJSON = try JSONDecoder().decode(TapATradie_TradiesJSON.self, from: data!)
                    
                    if self.tradiesJSON != nil {
                        
//                        let vc = story_Home.viewController("TradieList") as? TradieList
//                        vc?.tradiesJSON = self.tradiesJSON
//                        vc?.services = nil
//                        vc?.search = self.tfSearchForTradie.text!
//                        vc?.tradie_type = nil
//                        vc?.paramSendToAll = nil
//                        vc?.boolGoToRequestFarm = true
//                        vc?.boolGoToServiceSelection = true
//                        vc?.search_type = "services"
//                        self.parentViewController?.navigationController?.pushViewController(vc!, animated: true)
                        
                        let vc = story_Tradie.viewController("TradiesMap") as! TapATradie_TradiesMap
                        
                        vc.search_type = "services"
                        vc.tradies = nil
                        vc.tradiesJSON = self.tradiesJSON
                        vc.services = nil
                        vc.search = self.tfSearchForTradie.text ?? ""//search
                        vc.tradie_type = nil//tradie_type
                        vc.paramSendToAll = nil//paramSendToAll
                        vc.boolGoToRequestFarm = true//boolGoToRequestFarm
                        vc.boolGoToServiceSelection = true//boolGoToServiceSelection
                        self.parentViewController?.navigationController?.pushViewController(vc, animated: false)
                    }
                } catch let error {
                    print("Error: \(error)")
                }
            }
        }
    }
    
}

extension TrendingTradieListHeader: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if (textField.text?.count ?? 0) > 0 { getTradies() }
        
        textField.resignFirstResponder()
        return true
    }
    
}
