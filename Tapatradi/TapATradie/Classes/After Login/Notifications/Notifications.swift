//
//  Help.swift
//  TapATradie
//
//  Created by Apple on 09/05/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class Notifications: UIViewController {
    var ntflModel: NTFLModel?
    
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
        let param = params()
        
        Http.instance().json(clear_notification, param, "POST", aai: true, popup: true, prnt: true, nil, nil, sync: false, defaultCalling: false) { (json, paras, str, data) in
            let jsonExp = json as? NSDictionary
            if jsonExp != nil {
                if jsonExp?.number("success").intValue == SESSIONEXPIRED {
                   kAppDelegate.sessionExpired(self)
                    
                    return
                }
            }
            self.navigationController?.popViewController(animated: true)
            //self.getNotifications ()
        }
    }
    
    
    func getNotifications () {
        let param = params()
        
        Http.instance().json(api_get_notification_list, param, "POST", aai: true, popup: true, prnt: true, nil, nil, sync: false, defaultCalling: false) { (json, paras, str, data) in
            
            let jsonExp = json as? NSDictionary
            
            if jsonExp != nil {
                if jsonExp?.number("success").intValue == SESSIONEXPIRED {
                   kAppDelegate.sessionExpired(self)
                    
                    return
                }
            }
                        
            self.ntflModel = NTFLModel.init(json as! JsonDictionay)
            
            self.tbl.reloadData()
        }
    }
}

//MARK: - TableView Delegates ans Datasource

extension Notifications: UITableViewDelegate, UITableViewDataSource {
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationsCell") as! NotificationsCell
        
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
        askAction.backgroundColor = .hexColor(0xEF4136)
        
        return UISwipeActionsConfiguration(actions: [askAction])
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let ob = self.ntflModel?.data?[indexPath.row]
        
        let action = ob?.model?.action
        
        let param = params()
        param["notification_id"] = ob?.model?.id
        
        Http.instance().json(api_read_notification, param, "POST", aai: true, popup: true, prnt: true, nil, nil, sync: false, defaultCalling: false) { (json, paras, str, data) in
            
            kAppDelegate.badgeCount(0)
            
            let jsonExp = json as? NSDictionary
            
            if jsonExp != nil {
                if jsonExp?.number("success").intValue == SESSIONEXPIRED {
                   kAppDelegate.sessionExpired(self)
                    
                    return
                }
                
                if jsonExp?.string("success") == "1" {
                    let vc = story_Tradie.viewController("MyBookings") as! MyBookings
                    
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
        
        let param = params()
        param["notification_id"] = ob?.model?.id
        
        Http.instance().json(api_delete_notification, param, "POST", aai: true, popup: true, prnt: true, nil, nil, sync: false, defaultCalling: false) { (json, paras, str, data) in
            
            kAppDelegate.badgeCount(0)
            
            let jsonExp = json as? NSDictionary
            
            if jsonExp != nil {
                if jsonExp?.number("success").intValue == SESSIONEXPIRED {
                   kAppDelegate.sessionExpired(self)
                    
                    return
                }
                
                if jsonExp?.string("success") == "1" {
                    self.getNotifications()
                }
            }
        }
    }
}
