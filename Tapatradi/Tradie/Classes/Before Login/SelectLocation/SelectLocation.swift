//
//  SelectLocation.swift
//  Tradie
//
//  Created by Apple on 20/04/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import CoreLocation

extension SelectLocation: DrawerTransitionDelegate, SideMenuDelegate {
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
            
            let vc = story_Payment.viewController("HowItWork_Screen")
            self.navigationController?.pushViewController(vc!, animated: false)
        }else if vc == Key_Menu_VC_FAQ {
            let vc = story_Payment.viewController("FrequentlyAskedQuestion")
            self.navigationController?.pushViewController(vc!, animated: false)
        }
    }
    
    func logout () {
        let param = params()
        Http.instance().json(api_logout, param, "POST", aai: true, popup: true, prnt: true, nil, nil, sync: false, defaultCalling: false) { (json, paras, str, data) in
            let json = json as? NSDictionary
            
            if json != nil {
                if json?.number("success").intValue == 1 {
                    UIApplication.shared.applicationIconBadgeNumber = 0
                }
                
                Http.alert("", json?.string("message"))
            }
            
            let jsonExp = json as? NSDictionary
            
            if jsonExp != nil {
                if jsonExp?.number("success").intValue == SESSIONEXPIRED {
                   kAppDelegate.sessionExpired(self)
                    return
                }
            }
        }
    }
}

class SelectLocation: UIViewController {
    var pushToViewController: UIViewController?
    var popToViewController: UIViewController?
    
    @IBOutlet weak var tfSearch: UITextField!
    @IBOutlet weak var viewCurrentLocation: UIView!
    
    @IBOutlet weak var lblShadow: UILabel!
    
    @IBOutlet weak var tblAddresses: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        kAppDelegate.currentVC = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initMenu ()
        
        tfSearch.placeHolderColor(UIColor.white, "Search")
        viewCurrentLocation.shadow(1.0, 3.0)
        
        lblShadow.shadow(1.0, -3.0)
        
        //getAddresses ()
    }
    
    private var leftMenu  = CustomerMenuViewController()
    private var leftDrawerTransition:DrawerTransition!
    
    @IBAction func actionMenu(_ sender: Any) {
        self.leftDrawerTransition.presentDrawerViewController(animated: true)
    }
    
    @IBAction func actionCurrentLocation(_ sender: Any) {
        let ob = kAppDelegate.staticLocation()
        
        if ob.lat != nil && ob.lng != nil {
        if ob.lat != 0.0 && ob.lng != 0.0 {
            kAppDelegate.boolShowChangeProviderStatus = true
            
            let ob2 = getAddressOrLatLong(ob.lat! as NSNumber, ob.lng! as NSNumber, nil, false)
            
            let ob1 = Addresses("")
            
            ob1.locationName = "Home"
            ob1.address = ob2!.address
            ob1.latitude = "\(ob.lat!)"
            ob1.longitude = "\(ob.lng!)"
            
            if let city = ob2?.city {
                ob1.city = city
            }
            
            if let state = ob2?.state {
                ob1.state = state
            }
            
            if let country = ob2?.country {
                ob1.country = country
            }
            
            kAppDelegate.setUserAddress(ob1)
            
            pop ()
            return
        }
        }
        
        Http.alert("Tap A Tradie", "Please allow app to access your location", [self, "Settings", "Cancel"])
    }
    
    var userAddress: UserAddress?
    
    func getAddresses () {
        Http.instance().json (api_provider_get_address, params(), "POST", aai: true, popup: true, prnt: true, nil, nil, sync: false, defaultCalling: false) { (json, paras, str, data) in
            let jsonExp = json as? NSDictionary
            if jsonExp != nil {
                if jsonExp?.number("success").intValue == SESSIONEXPIRED {
                   kAppDelegate.sessionExpired(self)
                    return
                }
            }
            
            if data != nil {
                do {
                    self.userAddress = try JSONDecoder().decode(UserAddress.self, from: data!)
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

extension SelectLocation: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.userAddress != nil {
            return (self.userAddress?.data.count)!
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SelectLocationCell") as! SelectLocationCell
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

extension SelectLocation: UITextFieldDelegate {
    /*func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }*/
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        if textField == tfSearch {
            if (textField.text?.count)! > 0 {
                //getAddresses()
                //getRestaurants("1")
            }
        }
        
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.autocapitalizationType = .sentences
        
        if textField == tfSearch {
            let place = story_Auth.viewController("PlaceApiViewController") as! PlaceApiViewController
            place.delegate = self
            self.present(place, animated: true, completion: nil)
        }
    }
}

extension SelectLocation: SelectLocationCellDelegate {
    func select(_ indexPath: IndexPath) {
        let ob = self.userAddress?.data[indexPath.row]
        
        let ob1 = Addresses("")
        
        ob1.locationName = ob?.locationName
        ob1.address = ob?.address
        ob1.latitude = ob?.latitude
        ob1.longitude = ob?.longitude
        
        ob1.city = ob?.city
        ob1.state = ob?.state
        ob1.country = ob?.country
        
        kAppDelegate.setUserAddress(ob1)
        
        pop ()
    }
}

extension SelectLocation: PlanceApiDelegate {
    func pop () {
        kAppDelegate.boolShowChangeProviderStatus = true
        
        let arr = self.navigationController?.viewControllers
        
        if arr != nil {
            for i in 0..<arr!.count {
                if let vc = arr?[(arr?.count)! - 1 - i] {
                    if i == 0 {
                        if vc is SelectLocation {
                            let vcc = arr![(arr?.count)! - 2]
                            if vcc is SeeTradiesArround {
                                let vccc = arr![(arr?.count)! - 3]
                            
                                self.navigationController?.popToViewController(vccc, animated: true)
                            }
                            
                            return
                        }
                    }
                }
            }
        }
        
        kAppDelegate.tabbarClicked(IndexPath(row: 1, section: 0), self.navigationController)
    }
    
    func PlaceApiData(_ ob: Addresses) {
        kAppDelegate.setUserAddress(ob)
        DispatchQueue.global().async {
            sleep(1)
            DispatchQueue.main.async {
                self.pop ()
            }
        }
        return
    }
}

class UserAddress: Codable {
    let success: Int
    let message: String
    let data: [Addresses]
}

class Addresses: Codable {
    let id: Int?
    var locationName, address, latitude, longitude: String?
    var city: String?
    var state: String?
    var country: String?
    
    init(_ str: String) {
        locationName = ""
        address = ""
        latitude = ""
        longitude = ""
        id = 0
        city = ""
        state = ""
        country = ""
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case locationName = "location_name"
        case address, latitude, longitude
        case city, state, country
    }
}

extension SelectLocation: AlertDelegate {
    func alertZero() {
        UIApplication.shared.open(URL(string:UIApplication.openSettingsURLString)!)
    }
    
    func alertOne() {
        
    }
    
    
}
