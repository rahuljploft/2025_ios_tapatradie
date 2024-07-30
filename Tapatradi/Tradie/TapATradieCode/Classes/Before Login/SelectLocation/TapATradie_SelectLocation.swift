//
//  SelectLocation.swift
//  TapATradie
//
//  Created by Apple on 20/04/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import CoreLocation

extension TapATradie_SelectLocation: TapATradie_DrawerTransitionDelegate, TapATradie_SideMenuDelegate {
    func initMenu () {
        leftMenu = TapATradie_story_Home.TapATradie_viewController("CustomerMenuViewController") as! TapATradie_CustomerMenuViewController
        leftMenu.delegate = self
        
        self.leftDrawerTransition = TapATradie_DrawerTransition(target: self, drawer: leftMenu)
        self.leftDrawerTransition.setPresentCompletion {  }
        self.leftDrawerTransition.setDismissCompletion {  }
        self.leftDrawerTransition.edgeType = .left
    }
    
    func TapATradie_menuClicked (_ vc: String) {
        if vc == Key_Menu_VC_AboutUs {
            let vc = TapATradie_story_Home.TapATradie_viewController("WebPage") as! TapATradie_WebPage
            vc.linkType = .aboutus
            self.navigationController?.pushViewController(vc, animated: true)
        } else if vc == Key_Menu_VC_TermsCondition {
            let vc = TapATradie_story_Home.TapATradie_viewController("WebPage") as! TapATradie_WebPage
            vc.linkType = .termsncondition
            self.navigationController?.pushViewController(vc, animated: true)
        } else if vc == Key_Menu_VC_PrivacyPolicy {
            let vc = TapATradie_story_Home.TapATradie_viewController("WebPage") as! TapATradie_WebPage
            vc.linkType = .privacypolicy
            self.navigationController?.pushViewController(vc, animated: true)
        } else if vc == Key_Menu_VC_Logout {
            TapATradie_kAppDelegate.TapATradie_logout (self)
        } else if vc == Key_Menu_VC_InviteFriends {
            let vc = TapATradie_story_Invite.TapATradie_viewController("InviteFriends")
            self.navigationController?.pushViewController(vc!, animated: false)
            
            
        }
        //MARK: Himanshu Update
        else if vc == Key_Menu_VC_HowItWork {
            let vc = TapATradie_story_Invite.TapATradie_viewController("HowItWork_Screen")
            self.navigationController?.pushViewController(vc!, animated: false)
        }else if vc == Key_Menu_VC_FAQ {
            let vc = TapATradie_story_Invite.TapATradie_viewController("FrequentlyAskedQuestion")
            self.navigationController?.pushViewController(vc!, animated: false)
        }
        
        
    }
    
    func logout () {
        let param = TapATradie_params()
        Http.instance().json(TapATradie_api_logout, param, "POST", aai: true, popup: true, prnt: true, nil, nil, sync: false, defaultCalling: false) { (json, paras, str, data) in
            let jsonExp = json as? NSDictionary
            
            if jsonExp != nil {
                if jsonExp?.number("success").intValue == SESSIONEXPIRED {
                   TapATradie_kAppDelegate.TapATradie_sessionExpired(self)
                    
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

class TapATradie_SelectLocation: UIViewController {
    var pushToViewController: UIViewController?
    var popToViewController: UIViewController?
    
    @IBOutlet weak var tfSearch: UITextField!
    @IBOutlet weak var viewCurrentLocation: UIView!
    
    @IBOutlet weak var lblShadow: UILabel!
    
    @IBOutlet weak var tblAddresses: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initMenu ()
        
        tfSearch.placeHolderColor(UIColor.white, "Search")
        viewCurrentLocation.shadow(1.0, 3.0)
        
        lblShadow.shadow(1.0, -3.0)
        
        getAddresses ()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        TapATradie_kAppDelegate.TapATradie_currentVC = self
    }
    
    private var leftMenu  = TapATradie_CustomerMenuViewController()
    private var leftDrawerTransition:TapATradie_DrawerTransition!
    
    @IBAction func actionMenu(_ sender: Any) {
        self.leftDrawerTransition.presentDrawerViewController(animated: true)
    }
    
    @IBAction func actionCurrentLocation(_ sender: Any) {
        let ob = TapATradie_kAppDelegate.TapATradie_staticLocation()
        
        if ob.lat != nil && ob.lng != nil {
            if ob.lat != 0.0 && ob.lng != 0.0 {
                let ob2 = getAddressOrLatLong(ob.lat! as NSNumber, ob.lng! as NSNumber, nil, false)
                
                let ob1 = TapATradie_Addresses("")
                
                ob1.locationName = "Home"
                ob1.address = ob2!.address
                ob1.latitude = "\(ob.lat!)"
                ob1.longitude = "\(ob.lng!)"
                
                ob1.city = ob2!.city!
                ob1.state = ob2!.state!
                ob1.country = ob2!.country!
                
                TapATradie_kAppDelegate.TapATradie_setUserAddress(ob1)
                PlaceApiData(ob1)
            }
        }
        Http.alert("Tap A Tradie", "Please allow app to access your location", [self, "Settings", "Cancel"])
    }
    
    var userAddress: TapATradie_UserAddress?
    
    func getAddresses () {
        Http.instance().json (TapATradie_api_user_get_address, TapATradie_params(), "POST", aai: true, popup: true, prnt: true, nil, nil, sync: false, defaultCalling: false) { (json, paras, str, data) in
            let jsonExp = json as? NSDictionary
            
            if jsonExp != nil {
                if jsonExp?.number("success").intValue == SESSIONEXPIRED {
                   TapATradie_kAppDelegate.TapATradie_sessionExpired(self)
                    return
                }
            }
            
            if data != nil {
                do {
                    self.userAddress = try JSONDecoder().decode(TapATradie_UserAddress.self, from: data!)
                    self.tblAddresses.reloadData()
                } catch let error {
                    print("Error: \(error)")
                }
            }
            
            if let json = json as? NSDictionary {
                if json.number("success").intValue == 0 {
                    Http.alert("", json.string("message"))
                }
            }
        }
    }
}

extension TapATradie_SelectLocation: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.userAddress != nil {
            return (self.userAddress?.data.count)!
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SelectLocationCell") as! TapATradie_SelectLocationCell
        let ob = self.userAddress?.data[indexPath.row]
        
        cell.lblTitle.text = ob?.locationName!.capFirstLetter()
        cell.lblAddress.text = ob?.address
        
        cell.indexPath = indexPath
        cell.delegate = self
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}

extension TapATradie_SelectLocation: UITextFieldDelegate {
    /*func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }*/
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        if textField == tfSearch {
            if (textField.text?.count)! > 0 {
                getAddresses()
                //getRestaurants("1")
            }
        }
        
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.autocapitalizationType = .sentences
        
        if textField == tfSearch {
            let place = TapATradie_story_Auth.TapATradie_viewController("PlaceApiViewController") as! TapATradie_PlaceApiViewController
            place.delegate = self
            self.present(place, animated: true, completion: nil)
        }
    }
}

extension TapATradie_SelectLocation: TapATradie_SelectLocationCellDelegate {
    func select(_ indexPath: IndexPath) {
        let ob = self.userAddress?.data[indexPath.row]
        
        let ob1 = TapATradie_Addresses("")
        
        ob1.locationName = ob?.locationName
        ob1.address = ob?.address
        ob1.latitude = ob?.latitude
        ob1.longitude = ob?.longitude
        
        ob1.city = ob!.city!
        ob1.state = ob!.state!
        ob1.country = ob!.country!
        
        TapATradie_kAppDelegate.TapATradie_setUserAddress(ob1)
        
        PlaceApiData(ob1)
    }
}

extension TapATradie_SelectLocation: TapATradie_PlanceApiDelegate {
    func PlaceApiData(_ ob: TapATradie_Addresses) {
        
        TapATradie_kAppDelegate.TapATradie_setUserAddress(ob)
        
        if ob.address != nil {
            let param = TapATradie_params()
            param["address"] = ob.address!
            param["location_name"] = "Home"
            param["latitude"] = ob.latitude!
            param["longitude"] = ob.longitude!
            
            param["city"] = ob.city!
            param["state"] = ob.state!
            param["country"] = ob.country!
            
            Http.instance().json(TapATradie_api_user_add_address, param, "POST", aai: true, popup: true, prnt: true, nil, nil, sync: false, defaultCalling: false) { (json, paras, str, data) in
                let jsonExp = json as? NSDictionary
                
                if jsonExp != nil {
                    if jsonExp?.number("success").intValue == SESSIONEXPIRED {
                       TapATradie_kAppDelegate.TapATradie_sessionExpired(self)
                    
                    return
                    }
                }
                
                if let json = json as? NSDictionary {
                    if json.number("success").intValue == 1 {
                        if self.pushToViewController != nil {
                            self.navigationController?.pushViewController(self.pushToViewController!, animated: true)
                        } else if self.popToViewController != nil {
                            self.navigationController?.popToViewController(self.popToViewController!, animated: true)
                        } else {
                            let vc = TapATradie_story_Home.TapATradie_viewController("Home") as! TapATradie_Home
                            self.navigationController?.pushViewController(vc, animated: true)
                        }
                    } else {
                        Http.alert("", json.string("message"))
                    }
                }
            }
        }
    }
}

class TapATradie_UserAddress: Codable {
    let success: Int
    let message: String
    let data: [TapATradie_Addresses]
}

class TapATradie_Addresses: Codable {
    let id: Int?
    var locationName, address, latitude, longitude: String?
    var city, country, state: String?
    
    init(_ str: String) {
        locationName = ""
        address = ""
        latitude = ""
        longitude = ""
        city = ""
        country = ""
        state = ""
        id = 0
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case locationName = "location_name"
        case address, latitude, longitude
        case city, country, state
    }
}

extension TapATradie_SelectLocation: AlertDelegate {
    func alertZero() {
        print("")
    }
    
    func alertOne() {
        print("")
    }
    
    func TapATradie_alertZero() {
        UIApplication.shared.open(URL(string:UIApplication.openSettingsURLString)!)
    }
    
    func TapATradie_alertOne() {
    }
}
