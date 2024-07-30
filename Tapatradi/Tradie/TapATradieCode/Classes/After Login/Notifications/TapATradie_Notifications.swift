//
//  Help.swift
//  TapATradie
//
//  Created by Apple on 09/05/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class TapATradie_Notifications: UIViewController {
    var ntflModel: TapATradie_NTFLModel?
    
    @IBOutlet weak var tbl: UITableView!
    @IBOutlet weak var viewNonotification: UIView!
    @IBOutlet weak var header: HeaderView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        header.viewNotification.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        header.viewNotification.isHidden = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getNotifications ()
    }
    
    @IBAction func actionClearNotification(_ sender: UIButton) {
        clearNotification()
    }
    
    func clearNotification() {
        let param = TapATradie_params()
        
        Http.instance().json(TapATradie_clear_notification, param, "POST", aai: true, popup: true, prnt: true, nil, nil, sync: false, defaultCalling: false) { (json, paras, str, data) in
            let jsonExp = json as? NSDictionary
            if jsonExp != nil {
                if jsonExp?.number("success").intValue == SESSIONEXPIRED {
                   TapATradie_kAppDelegate.TapATradie_sessionExpired(self)
                    
                    return
                }
            }
            self.navigationController?.popViewController(animated: true)
            //self.getNotifications ()
        }
    }
    
    
    func getNotifications () {
        let param = TapATradie_params()
        
        Http.instance().json(TapATradie_api_get_notification_list, param, "POST", aai: true, popup: true, prnt: true, nil, nil, sync: false, defaultCalling: false) { (json, paras, str, data) in
            
            let jsonExp = json as? NSDictionary
            
            if jsonExp != nil {
                if jsonExp?.number("success").intValue == SESSIONEXPIRED {
                   TapATradie_kAppDelegate.TapATradie_sessionExpired(self)
                    
                    return
                }
            }
                        
            self.ntflModel = TapATradie_NTFLModel.init(json as! TapATradie_JsonDictionay)
            
            self.tbl.reloadData()
        }
    }
}

//MARK: - TableView Delegates ans Datasource

extension TapATradie_Notifications: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.ntflModel?.data != nil {
            if (self.ntflModel?.data?.count ?? 0) > 0 {
                viewNonotification.isHidden = true
            }
            return (self.ntflModel?.data?.count)!
        }
        viewNonotification.isHidden = false
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationsCell") as! TapATradie_NotificationsCell
        
        let ob = self.ntflModel?.data?[indexPath.row]
        
        cell.lblTitle.text = ob?.title
//        cell.lblTitle.textColor = ob?.titleColor
        
        cell.lblDesc.text = ob?.desc
        
        cell.imgRead.isHidden = ob!.hideReadImage
        
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
      
        let askAction = UIContextualAction(style: .normal, title: nil) { action, view, complete in
            self.deleteCell (indexPath)
            
            complete(true)
        }

        askAction.image = #imageLiteral(resourceName: "Group 3091")
        askAction.backgroundColor = .TapATradie_hexColor(0xEF4136)
        
        return UISwipeActionsConfiguration(actions: [askAction])
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let ob = self.ntflModel?.data?[indexPath.row]
        
        let action = ob?.model?.action
        
        let param = TapATradie_params()
        param["notification_id"] = ob?.model?.id
        
        Http.instance().json(TapATradie_api_read_notification, param, "POST", aai: true, popup: true, prnt: true, nil, nil, sync: false, defaultCalling: false) { (json, paras, str, data) in
            
            TapATradie_kAppDelegate.TapATradie_badgeCount(0)
            
            let jsonExp = json as? NSDictionary
            
            if jsonExp != nil {
                if jsonExp?.number("success").intValue == SESSIONEXPIRED {
                   TapATradie_kAppDelegate.TapATradie_sessionExpired(self)
                    
                    return
                }
                
                if jsonExp?.string("success") == "1" {
                    let vc = TapATradie_story_Tradie.TapATradie_viewController("MyBookings") as! TapATradie_MyBookings
                    
                    if action == "reject" || action == "completed" {
                        vc.boolCurrent = false
                    } else {
                        vc.boolCurrent = true
                    }
                    
                    self.navigationController?.pushViewController(vc, animated: false)
                }
            }
        }
    }
    
    func deleteCell (_ indexPath: IndexPath) {
        let ob = self.ntflModel?.data?[indexPath.row]
        
        let param = TapATradie_params()
        param["notification_id"] = ob?.model?.id
        
        Http.instance().json(TapATradie_api_delete_notification, param, "POST", aai: true, popup: true, prnt: true, nil, nil, sync: false, defaultCalling: false) { (json, paras, str, data) in
            
            TapATradie_kAppDelegate.TapATradie_badgeCount(0)
            
            let jsonExp = json as? NSDictionary
            
            if jsonExp != nil {
                if jsonExp?.number("success").intValue == SESSIONEXPIRED {
                   TapATradie_kAppDelegate.TapATradie_sessionExpired(self)
                    
                    return
                }
                
                if jsonExp?.string("success") == "1" {
                    self.getNotifications()
                }
            }
        }
    }
}
