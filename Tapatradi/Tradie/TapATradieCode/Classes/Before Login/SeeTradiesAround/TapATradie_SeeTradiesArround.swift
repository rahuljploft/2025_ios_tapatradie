//
//  SeeTradiesArround.swift
//  TapATradie
//
//  Created by Apple on 20/04/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import Common

class TapATradie_SeeTradiesArround: UIViewController {
    var pushToViewController: UIViewController?
    var popToViewController: UIViewController?
    
    @IBOutlet weak var anotherLocationButton: UIButton!
    @IBOutlet weak var headerView: HeaderView!
    
    
    override func viewWillAppear(_ animated: Bool) {
        TapATradie_kAppDelegate.TapATradie_currentVC = self
        
        guard let viewControllers = self.navigationController?.viewControllers else { return }
        anotherLocationButton.isHidden = viewControllers.count <= 1
    }
    
    @IBAction func actionBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
            
                PlaceApiData (ob1)
            
                return
            }
        }
        
        Http.alert("Tap A Tradie", "Please allow app to access your location", [self, "Settings", "Cancel"])
        
    }
    
    @IBAction func actionAnotherLocation(_ sender: Any) {
        let place = TapATradie_story_Auth.TapATradie_viewController("PlaceApiViewController") as! TapATradie_PlaceApiViewController
        place.delegate = self
        self.present(place, animated: true, completion: nil)
    }
}

extension TapATradie_SeeTradiesArround: AlertDelegate {
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

extension TapATradie_SeeTradiesArround: TapATradie_PlanceApiDelegate {
    func PlaceApiData(_ ob: TapATradie_Addresses) {
        
        //kAppDelegate.setUserAddress(ob)
        
        
        let ob1 = TapATradie_Addresses("")
        ob1.locationName = "Home"
        ob1.address = ob.address
        ob1.latitude = "\(ob.latitude ?? "")"
        ob1.longitude = "\(ob.longitude ?? "")"
        
        ob1.city = ob.city!
        ob1.state = ob.state!
        ob1.country = ob.country!
        print(ob1.address)
        print(ob1.latitude)
        print(ob1.longitude)
        print(ob1.city)
        print(ob1.state)
        print(ob1.country)
        
        if (ob1.country ?? "") == "" {
            currentStateNew(lat: (ob1.latitude ?? ""), lng: (ob1.longitude ?? ""))
        }else{
            TapATradie_kAppDelegate.TapATradie_setUserAddress(ob1)
            
            if ob.address != nil {
                let param = TapATradie_params()
                param["address"] = ob.address!
                param["location_name"] = "Home"
                param["latitude"] = ob.latitude!
                param["longitude"] = ob.longitude!
                
                param["city"] = ob.city!
                param["state"] = ob.state!
                param["country"] = ob.country!
                print(param)
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
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                if self.pushToViewController != nil {
                                    self.navigationController?.pushViewController(self.pushToViewController!, animated: true)
                                } else if self.popToViewController != nil {
                                    self.navigationController?.popToViewController(self.popToViewController!, animated: true)
                                } else {
                                    let vc = TapATradie_story_Home.TapATradie_viewController("Home") as! TapATradie_Home
                                    self.navigationController?.pushViewController(vc, animated: true)
                                }
                            }
                        } else {
                            Http.alert("", json.string("message"))
                        }
                    }
                }
            }
        }
        
        
        

    }
    
    func currentStateNew(lat:String,lng:String) {
        let urlStr = "https://maps.googleapis.com/maps/api/geocode/json?latlng=\(lat),\(lng)&sensor=true&key=AIzaSyAKBtULxvzVH8VHh5kdWxYrmVlzQ6RgUC8"
        if let url = URL(string: urlStr) {
            print(url)
            
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.timeoutInterval = 180
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            
            let tsk = URLSession.shared.dataTask(with: request) { data, response, error in
                print(response)
                if let dataVal = data {
                    let addressComponentModel = try! JSONDecoder().decode(TapATradie_GETCountryState.self, from: dataVal)
                    print(addressComponentModel)
                    
                    var state = ""
                    var city = ""
                    var country = ""
                    var address = ""
                    
                    
                    
                    if (addressComponentModel.results.count ) > 0 {
                        let addressComponentCount = addressComponentModel.results[0].addressComponents.count
                        for i in 0..<addressComponentCount {
                            let type = addressComponentModel.results[0].addressComponents[i].types
                            print(type)
                            
                            if (type.contains("administrative_area_level_1") ) {
                                state = addressComponentModel.results[0].addressComponents[i].longName
                            }
                            
                            if (type.contains("country") ) {
                                country = addressComponentModel.results[0].addressComponents[i].longName
                            }
                            
                            if (type.contains("administrative_area_level_3") ) {
                                city = addressComponentModel.results[0].addressComponents[i].longName
                            }
                            
                        }
                        address = addressComponentModel.results[0].formattedAddress
                        
                        
                        print(address)
                        print(lat)
                        print(lng)
                        print(city)
                        print(state)
                        print(country)
                        
                        let ob1 = TapATradie_Addresses("")
                        ob1.locationName = "Home"
                        ob1.address = address
                        ob1.latitude = "\(lat)"
                        ob1.longitude = "\(lng)"
                        
                        ob1.city = city
                        ob1.state = state
                        ob1.country = country
                        
                        TapATradie_kAppDelegate.TapATradie_setUserAddress(ob1)
                        self.PlaceApiDataNew_After(ob1)
                    }
                }
            }
            
          
            tsk.resume()
        }
    }

    
    
    func PlaceApiDataNew_After(_ ob: TapATradie_Addresses) {
        
        let ob1 = TapATradie_Addresses("")
        ob1.locationName = "Home"
        ob1.address = ob.address
        ob1.latitude = "\(ob.latitude ?? "")"
        ob1.longitude = "\(ob.longitude ?? "")"
        
        ob1.city = ob.city!
        ob1.state = ob.state!
        ob1.country = ob.country!
        print(ob1.address)
        print(ob1.latitude)
        print(ob1.longitude)
        print(ob1.city)
        print(ob1.state)
        print(ob1.country)
        
        if (ob1.country ?? "") == "" {
            currentStateNew(lat: (ob1.latitude ?? ""), lng: (ob1.longitude ?? ""))
        }else{
            TapATradie_kAppDelegate.TapATradie_setUserAddress(ob1)
            
            if ob.address != nil {
                let param = TapATradie_params()
                param["address"] = ob.address!
                param["location_name"] = "Home"
                param["latitude"] = ob.latitude!
                param["longitude"] = ob.longitude!
                
                param["city"] = ob.city!
                param["state"] = ob.state!
                param["country"] = ob.country!
                print(param)
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
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                if self.pushToViewController != nil {
                                    self.navigationController?.pushViewController(self.pushToViewController!, animated: true)
                                } else if self.popToViewController != nil {
                                    self.navigationController?.popToViewController(self.popToViewController!, animated: true)
                                } else {
                                    let vc = TapATradie_story_Home.TapATradie_viewController("Home") as! TapATradie_Home
                                    self.navigationController?.pushViewController(vc, animated: true)
                                }
                            }
                        } else {
                            Http.alert("", json.string("message"))
                        }
                    }
                }
            }
        }
        
        
        

    }
    
    
}






struct TapATradie_GETCountryState: Codable {
    let results: [TapATradie_ResultNEW]
    let status: String

    enum CodingKeys: String, CodingKey {
        case results, status
    }
}


// MARK: - Result
struct TapATradie_ResultNEW: Codable {
    let addressComponents: [TapATradie_AddressComponentNEW]
    let formattedAddress: String
    
    enum CodingKeys: String, CodingKey {
        case addressComponents = "address_components"
        case formattedAddress = "formatted_address"
    
    }
}

// MARK: - AddressComponent
struct TapATradie_AddressComponentNEW: Codable {
    let longName, shortName: String
    let types: [String]

    enum CodingKeys: String, CodingKey {
        case longName = "long_name"
        case shortName = "short_name"
        case types
    }
}

