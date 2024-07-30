//
//  SeeTradiesArround.swift
//  Tradie
//
//  Created by Apple on 20/04/19.
//  Copyright © 2019 Apple. All rights reserved.
//

class SeeTradiesArround: UIViewController {
    var pushToViewController: UIViewController?
    var popToViewController: UIViewController?
    
    @IBOutlet weak var headerView: HeaderView!
    @IBOutlet weak var anotherLocationButton: UIButton!
    
    override func viewWillAppear(_ animated: Bool) {
        kAppDelegate.currentVC = self
        
        headerView.updateData()
        
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
        let ob = kAppDelegate.staticLocation()
        
        if ob.lat != nil && ob.lng != nil {
            if ob.lat != 0.0 && ob.lng != 0.0 {
                let ob2 = getAddressOrLatLong(ob.lat! as NSNumber, ob.lng! as NSNumber, nil, false)
            
                let ob1 = Addresses("")
            
                ob1.locationName = "Home"
                ob1.address = ob2!.address
                ob1.latitude = "\(ob.lat!)"
                ob1.longitude = "\(ob.lng!)"
            
                ob1.city = ob2!.city!
                ob1.state = ob2!.state!
                ob1.country = ob2!.country!
                
                kAppDelegate.setUserAddress(ob1)
            
                PlaceApiData (ob1)
            
                kAppDelegate.sendAddressToServer ()
                self.headerView.updateData()
                self.navigationController?.popViewController(animated: true)
                
                return
            }
        }
        
        Http.alert("Tap A Tradie", "Please allow app to access your location", [self, "Settings", "Cancel"])
    }
    
    @IBAction func actionAnotherLocation(_ sender: Any) {
        let place = story_Auth.viewController("PlaceApiViewController") as! PlaceApiViewController
        place.delegate = self
        self.present(place, animated: true, completion: nil)
    }
    
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
    }
}

extension SeeTradiesArround: AlertDelegate {
    func alertZero() {
        UIApplication.shared.open(URL(string:UIApplication.openSettingsURLString)!)
    }
    
    func alertOne() {
        
    }
    
    
}

extension SeeTradiesArround: PlanceApiDelegate {
    func PlaceApiData(_ ob: Addresses) {
        kAppDelegate.setUserAddress(ob)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.headerView.updateData()
            self.navigationController?.popViewController(animated: true)
        }
    }
}

