//
//  TradiesMap.swift
//  TapATradie
//
//  Created by Apple on 27/04/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import MapKit
import Common

class TradiesMap: UIViewController {
    
    @IBOutlet weak var btnSendToAll_Two: UIButton!
    @IBOutlet weak var btn_Background: UIImageView!
    @IBOutlet weak var btnSendToAll: UIButton!
    @IBOutlet weak var viewFGContainer: UIView!
    @IBOutlet weak var lblGRating: UILabel!
    @IBOutlet weak var lblFRating: UILabel!
    
    @IBOutlet weak var View_NoDataFound: UIView!
    @IBOutlet weak var stackGoogle: UIStackView!
    @IBOutlet weak var stackFaceBook: UIStackView!
    @IBOutlet weak var imgNoData: UIImageView!
    
    var boolGoToRequestFarm = false

    var arrSelectedTradies: Array<Int> = Array()
    
    
    
    func addPopUp (_ boolSuccess: Bool, _ msg: String) {
        if boolSuccess {
            imgPopup.image = #imageLiteral(resourceName: "Group 4654-3")
            lblPopupTitle.text = "Thankyou!"
            lblPopupMessage.text = "Your request is successfully submitted."
        } else {
            imgPopup.image = #imageLiteral(resourceName: "Group 4655-1")
            lblPopupTitle.text = "Error"
            lblPopupMessage.text = msg//"Something went wrong."
        }
        
        imgPopup.superview?.border5(16)
        
        viewPopUp.frame = self.view.bounds
        self.view.addSubview(viewPopUp)
    }
    
    @IBOutlet var viewPopUp: UIView!
    
    @IBOutlet weak var imgPopup: UIImageView!
    @IBOutlet weak var lblPopupTitle: UILabel!
    @IBOutlet weak var lblPopupMessage: UILabel!
    
    @IBAction func actionRemovePopup(_ sender: Any) {
        viewPopUp.removeFromSuperview()
 
        kAppDelegate.tabbarClicked(IndexPath(row: 1, section: 0), self.navigationController)
    }
    
    var tradiesJSON: TradiesJSON?
    
    
    
    
//    var boolGoToServiceSelection = false
//    var boolGoToRequestFarm = false
    
//    var tradiesJSON: TradiesJSON?
    
//    var tradie_type: String?
//
//    var search = ""
    
    var arrShimmer: [String] = []
    
    func getTradies () {
        arrShimmer = ["", "", "", "", "", "", "", "", "", "", "", "", ""]
//        self.tblTradies.reloadData()
        //MARK: Check Here
        let param = params()
        
        param["service_id"] = ""
        param["tradie_type"] = ""

        param["search"] = search
        
        if services?.id != nil {
            param["service_id"] = services?.id
        }

        if tradie_type != nil {
            param["tradie_type"] = tradie_type!
        }
        
        param["page"] = "all"
        
//        if filter == Filter.lowtohigh {
//            param["sort_by"] = "low_to_high"
//        } else if filter == Filter.hightolow {
//            param["sort_by"] = "high_to_low"
//        }
        
        param["search_type"] = ""
        
        //MARK: Updated By Himanshu
        print(kAppDelegate.obAddresses?.latitude)
        let latitude = "\(param["latitude"] ?? "")"
        let longitude = "\(param["longitude"] ?? "")"
        if latitude == "" && longitude == "" {
            if kAppDelegate.obAddresses != nil {
                if kAppDelegate.obAddresses?.latitude != nil && kAppDelegate.obAddresses?.longitude != nil {
                    param["latitude"] = (kAppDelegate.obAddresses?.latitude ?? "")
                    param["longitude"] = (kAppDelegate.obAddresses?.longitude ?? "")
                    
                    param["city"] = (kAppDelegate.obAddresses?.city  ?? "")
                    param["state"] = (kAppDelegate.obAddresses?.state  ?? "")
                    param["country"] = (kAppDelegate.obAddresses?.country  ?? "")
                }
            }
        }else{
            kAppDelegate.obAddresses?.latitude = "\(param["latitude"] ?? "")"
            kAppDelegate.obAddresses?.longitude = "\(param["longitude"] ?? "")"
            kAppDelegate.obAddresses?.city = "\(param["city"] ?? "")"
            kAppDelegate.obAddresses?.state = "\(param["state"] ?? "")"
            kAppDelegate.obAddresses?.country = "\(param["country"] ?? "")"
        }

        
        Http.instance().json(api_user_tradie_search, param, "POST", aai: false, popup: true, prnt: true, nil, nil, sync: false, defaultCalling: false) { (json, paras, str, data) in
            let jsonExp = json as? NSDictionary
            
            if jsonExp != nil {
                if jsonExp?.number("success").intValue == SESSIONEXPIRED {
                   kAppDelegate.sessionExpired(self)
                    
                    return
                }
            }
            
            let json = json as? NSDictionary
            
            if json != nil {
                if json?.number("success").intValue == 1 {
                    
                } else {
                    Http.alert("", json?.string("message"))
                }
            }
            
            if data != nil {
                do {
                    self.tradiesJSON = try JSONDecoder().decode(TradiesJSON.self, from: data!)
                    self.showPins ()
//                    self.tableArray = [Tradies]()
//                    if self.tradiesJSON != nil {
//                        for i in 0..<(self.tradiesJSON?.data.count)! {
//                            let ob = self.tradiesJSON?.data[i]
//                            ob?.rating = ob?.rating ?? "0"
//                            self.tableArray?.append(ob!)
//                        }
//                    }
//
//                    self.arrangeTableArray ()
                } catch let error {
                    print("Error: \(error)")
                }
            }
        }
    }
    
    
    
    @IBAction func actionSideMenu(_ sender: Any) {
//        self.navigationController?.popViewController(animated: false)
        
//        let vc = story_Home.viewController("TradieList") as! TradieList
////        vc.paramSendToAll = param
////        param["search_type"] = ""
////
////        vc.tradie_type = param["tradie_type"] as? String
//        vc.services = services
//        vc.tradiesJSON = self.tradiesJSON
//        vc.search = search
//        vc.boolGoToServiceSelection = boolGoToServiceSelection//false
//        self.navigationController?.pushViewController(vc, animated: true)
        
        print("\(tradiesJSON!.data.count)")
        if tradiesJSON!.data.count != 0 {
            
            let vc = story_Home.viewController("TradieList") as! TradieList
    //        vc.paramSendToAll = param
    //        param["search_type"] = ""
    //
    //        vc.tradie_type = param["tradie_type"] as? String
            vc.services = services
            vc.tradiesJSON = self.tradiesJSON
            vc.search = search
            vc.boolGoToServiceSelection = boolGoToServiceSelection//false
            vc.boolGoToRequestFarm = boolGoToRequestFarm//true
            vc.search_type = search_type
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
        

    }
    
    @IBAction func actionBack(_ sender: Any) {
        let arr = self.navigationController?.viewControllers
        
        var bool = false
        
        /*if arr != nil {
            for i in 0..<arr!.count {
                if i == 1 {
                    let vc = arr![i]
                    bool = true
                    self.navigationController?.popToViewController(vc, animated: true)
                    break
                }
            }
        }*/
        
        if bool == false {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBOutlet weak var mapTradie: MKMapView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        View_NoDataFound.isHidden = true
        
        btnSendToAll_Two.layer.cornerRadius = 4
        
        btn_Background.layer.cornerRadius = 4
        cnstBottom.constant = 0
        
        userDetailSetup ()
        
        viewFGContainer.setCornerRadiusWithBorder(cornerRadius: 4,
                                                  clipsToBound: true,
                                                  borderWidth: 1,
                                                  borderColor: UIColor(named: "#C9C9C9")?.cgColor)
        
        //SocketIOManager.shared.sendRequestForLocation(tradiesJSON)
        
        //MARK: For MAP ISSUES
        if services != nil {
            getTradies ()
        } else if tradiesJSON != nil {
            arrangeTableArray()
            showPins ()
        }
        
    }
    
    
    
    @IBOutlet weak var viewSideMenu: UIView!
    
    override func viewWillAppear(_ animated: Bool) {
        kAppDelegate.currentVC = self
        
        viewSideMenu.border5(viewSideMenu.frame.size.height/2)
        
////        getTradies()
//        showPins ()
        
//        if services != nil {
//            getTradies ()
//        } else if tradiesJSON != nil {
//            arrangeTableArray()
//            showPins ()
//        }
        
    }
    
    var tableArray: [Tradies]?
    
    func arrangeTableArray () {
        
            tableArray = [Tradies]()
            
            var tableArrayOnline = [Tradies]()
            var tableArrayOffline = [Tradies]()
            
            if self.tradiesJSON != nil {
                for i in 0..<(self.tradiesJSON?.data.count ?? 0) {
                    let ob = self.tradiesJSON?.data[i]
                    ob?.rating = ob?.rating ?? "0"
                    if (ob?.online ?? 0) == 1 {
                        if (self.tableArray?.count ?? 0) == 0 {
                            self.tableArray?.append(ob!)
                        } else {
                            self.tableArray?.insert(ob!, at: 0)
                        }
                        
                        tableArrayOnline.append(ob!)
                    } else {
                        tableArrayOffline.append(ob!)
                        
                        self.tableArray?.append(ob!)
                    }
                }
                
                //print("tableArrayOffline.count-\(tableArrayOnline.count)-\(tableArrayOffline.count)-")
                
                for i in 0..<tableArrayOffline.count {
                    let ob = tableArrayOffline[i]
                    tableArrayOnline.append(ob)
                }
                
                tableArray = tableArrayOnline
                
                //print("tableArray.count-\(tableArray!.count)-")
            }
        
        

    }
    
    
    
    func showPins () {
        btnSendToAll.isHidden = false
        View_NoDataFound.isHidden = true
        ////btnSendToAll_Two.isHidden = false
        mapTradie.delegate = self
        self.mapTradie.removeAnnotations(self.mapTradie.annotations)
        
        if tradiesJSON != nil {
            for i in 0..<(tradiesJSON?.data.count ?? 0) {
                let ob = tradiesJSON?.data[i]
                
                let latitude = Double((ob?.latitude ?? "0.0"))
                let longitude = Double((ob?.longitude ?? "0.0"))
                
                if latitude != 0.0 && longitude != 0.0 {
                    if ob?.id != nil && ob?.fullName != nil {
                        let dd = Tradies()
                        
                        dd.id = ob?.id ?? 0
                        dd.fullName = ob?.fullName ?? ""
                        dd.latitude = ob?.latitude ?? ""
                        dd.longitude = ob?.longitude ?? ""
                        dd.profilePic = ob?.profilePic ?? ""
                        dd.online = ob?.online ?? 0
                        dd.verified = ob?.verified ?? 0
                        dd.serviceName = ob?.serviceName ?? ""
                        dd.serviceId = ob?.serviceId ?? ""
                        dd.rating = ob?.rating ?? ""
                        dd.distance = ob?.distance ?? 0
                        dd.subscribedStatus = ob?.subscribedStatus ?? ""
                        dd.googleRating = ob?.googleRating ?? ""
                        dd.google = ob?.google ?? ""
                        
                        let loc = CLLocationCoordinate2D(latitude: latitude!, longitude: longitude!)
                        let artwork = MyAnnotation(title: dd.fullName.capFirstLetter(), coordinate: loc, isDriver:true, id:"")
                        artwork.tradies = dd
                        self.mapTradie.addAnnotation(artwork)
                    }
                }
            }
            
            if (tradiesJSON?.data.count)! == 0 {
                //btnSendToAll_Two.isHidden = true
                View_NoDataFound.isHidden = false
                btnSendToAll.isHidden = true
            } else {
                View_NoDataFound.isHidden = true
                //btnSendToAll_Two.isHidden = false
                btnSendToAll.isHidden = false
            }
            
            self.mapTradie.showAnnotations(self.mapTradie.annotations, animated: true)
        } else {
            View_NoDataFound.isHidden = false
            //btnSendToAll_Two.isHidden = true
            btnSendToAll.isHidden = true
        }
    }
    
    func zoomMap () {
        let ob = kAppDelegate.getUserAddress()
        
        if ob != nil {
            let obc = kAppDelegate.staticLocation()
            
            if let lat = obc.lat, let lng = obc.lng {
                let loc = CLLocation(latitude: lat, longitude: lng)
                self.mapTradie.region = MKCoordinateRegion(center: loc.coordinate, latitudinalMeters: 10000.0, longitudinalMeters: 10000.0)
            }
        }
    }
    
    var boolGoToServiceSelection = false
    //var tradiesJSON: TradiesJSON?
    var tradie_type: String?
    var search = ""
    var services: Services?
    var paramSendToAll: NSMutableDictionary?
    
    /****************************/
    

    @IBOutlet weak var viewUserDetail: UIView!
    
    @IBOutlet weak var cnstBottom: NSLayoutConstraint! // 87
    
    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var imgVerified: UIImageView!
    
    @IBOutlet weak var imgOnline: UIImageView!
    @IBOutlet weak var lblOffline: UILabel!
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblServiceName: UILabel!
    
    @IBOutlet weak var lblRating: UILabel!
    
    @IBOutlet weak var btnRequest: UIButton!
    
    @IBAction func actionRequest(_ sender: Any) {
        print("Action Request")
        if boolGoToRequestFarm == true {
            if tradies?.serviceId != nil {
                if tradies!.serviceId.count > 0 {
                    let arr = tradies!.serviceId.components(separatedBy: ",")
                    
                    if arr.count > 0 {
                        let int = Int(arr[0])
                        
                        if int != nil {
                        
//                            if tradies?.subscribedStatus != "active" || tradies?.subscribedStatus != "trialing"{
//                                AlertService.shared.showError(message: "You can not send request Becauase  this tradie not Member")
//                                return
//                            }
                            
                            services = Services("")
                            services?.id = int!
                            
                            boolGoToServiceSelection = false
                            
                            let vc = story_Home.viewController("RequestTradie") as! RequestTradie
                            vc.services = services
                            vc.tradies = tradies
                            vc.search = search
                            vc.services = services
                            vc.search_type = search_type
                            self.navigationController?.pushViewController(vc, animated: true)
                            
                            return
                        }
                    }
                }
            }
        }
        
//        if boolGoToServiceSelection {
//            let vc = story_Home.viewController("UserServices") as! UserServices
//            self.navigationController?.pushViewController(vc, animated: true)
//        } else {
//            paramSendToAll!["tradie_id"] = tradies?.id
//
//            if tradies?.subscribedStatus != "active"{
//                AlertService.shared.showError(message: "Currently This Tradie status is not active")
//                return
//            }
//
//            sendRequest()
//        }
    }
    
    func sendRequest () {
        
        paramSendToAll! ["search"] = search
        paramSendToAll?.addStaticLocation()
        
        if kAppDelegate.obAddresses != nil {
            if kAppDelegate.obAddresses?.latitude != nil && kAppDelegate.obAddresses?.longitude != nil {
                paramSendToAll!["latitude"] = (kAppDelegate.obAddresses?.latitude)!
                paramSendToAll!["longitude"] = (kAppDelegate.obAddresses?.longitude)!
                
                paramSendToAll!["city"] = (kAppDelegate.obAddresses?.city)!
                paramSendToAll!["state"] = (kAppDelegate.obAddresses?.state)!
                paramSendToAll!["country"] = (kAppDelegate.obAddresses?.country)!
            }
        }
        
        paramSendToAll?.addSearchType()
        
        Http.instance().json(api_user_job_request_to_tradie, paramSendToAll, "POST", aai: true, popup: true, prnt: true, nil, nil, sync: false, defaultCalling: false) { (json, paras, str, data) in
            let jsonExp = json as? NSDictionary
            
            if jsonExp != nil {
                if jsonExp?.number("success").intValue == SESSIONEXPIRED {
                   kAppDelegate.sessionExpired(self)
                    
                    return
                }
            }
            
            let json = json as? NSDictionary
            
            if json != nil {
                if json != nil {
                    if json?.number("success").intValue == 1 {
                        self.addPopUp(true, "")
                    } else if json?.number("success").intValue == 0 {
                        self.addPopUp(false, json!.string("message"))
                    }
                }
            }
        }
    }
    
    @IBAction func actionGoToTradieProfile(_ sender: Any) {
        let vc = story_Tradie.viewController("TradieProfile") as! TradieProfile
        
        vc.tradies = tradies
        vc.tradiesJSON = self.tradiesJSON
        vc.services = services
        vc.search = search
        vc.tradie_type = tradie_type
        vc.paramSendToAll = paramSendToAll
        vc.boolGoToServiceSelection = boolGoToServiceSelection
        vc.boolGoToRequestFarm = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func userDetailSetup () {
        imgUser.border5(imgUser.frame.size.height/2)
        btnRequest.border(btnRequest.titleLabel?.textColor, 4, 1)
        lblRating.superview?.border5(2)
    }
    
    var tradies: Tradies?
    
    func setUser (_ ob: Tradies?) {
        cnstBottom.constant = 87
        viewUserDetail.isHidden = false
        
        tradies = ob
        
        lblName.text = ob?.fullName.capFirstLetter()
        lblServiceName.text = ob?.serviceName.replacingOccurrences(of: ",", with: ", ")
        
        let arr = ob?.serviceName.components(separatedBy: ",")
        
        if arr != nil {
            if (arr?.count)! > 0 {
                lblServiceName.text = arr![0].capFirstLetter()
            }
        }
        
        if ob?.verified == 1 {
            imgVerified.image = #imageLiteral(resourceName: "Group 4413")
            imgVerified.isHidden = false
        } else {
            imgVerified.image = #imageLiteral(resourceName: "Group 4413")
            imgVerified.isHidden = true
        }
        
        if ob?.online == 1 {
            imgOnline.image = #imageLiteral(resourceName: "Ellipse 180")
            lblOffline.text = "Online"
        } else {
            imgOnline.image = #imageLiteral(resourceName: "Ellipse 1801")
            lblOffline.text = "Offline"
        }
        
        if ob?.rating == nil {
            lblRating.text = "0.0"
        } else {
            lblRating.text = "\((ob?.rating)!)".showRating()
        }
        
        if lblRating.text == "0.0" || lblRating.text == "0" {
            lblRating.superview?.isHidden = true
        } else {
            lblRating.superview?.isHidden = false
        }
        
        //Show Google FaceBook Rating
        
        if (ob?.google ?? "0") == "1"{
            viewFGContainer.isHidden = false
            stackGoogle.isHidden = false
        }else{
            viewFGContainer.isHidden = true
            stackGoogle.isHidden = true
        }
        lblGRating.text = ob?.googleRating ?? ""
        
        let url = "\(Server)profile/\((ob?.id)!)/\((ob?.profilePic)!)"
        imgUser.uiimage(url, "Group 2826", true, nil)
    }
    
    var search_type = ""
    
    @IBAction func actionSendToAll(_ sender: Any) {
        var ids = ""
//        boolGoToRequestFarm = false
        if boolGoToRequestFarm {
            if tradiesJSON?.data == nil {
                return
            }
            
            services = Services("")
            self.arrSelectedTradies = []
            
            for i in 0..<tradiesJSON!.data.count {
                let ob = tradiesJSON!.data[i]
                
//                if ob.subscribedStatus == "active"{
                    self.arrSelectedTradies.append(ob.id)
//                }
                
                
                if ob.serviceId.count > 0 {
                    let arr = ob.serviceId.components(separatedBy: ",")
                    
                    if arr.count > 0 {
                        let int = Int(arr[0])
                        
                        if int != nil {
                            if ids.count == 0 {
                                ids = "\(int!)"
                            } else {
                                ids = "\(ids),\(int!)"
                            }
                        }
                    }
                }
            }
            
            
            services = Services("")
        }
        
        if paramSendToAll == nil && services != nil {
            
//            if self.arrSelectedTradies.count == 0{
//                AlertService.shared.showError(message: "Currently No Tradie have active status")
//                return
//            }
                
            let vc = story_Home.viewController("RequestTradie") as! RequestTradie
            vc.tradieCount = arrSelectedTradies.count
            vc.arrSelectedTradies = self.arrSelectedTradies
            
            vc.services = services
//            vc.tradies = tradies
            
            if boolGoToRequestFarm {
                vc.tradies = nil
                vc.serviceIDS = ids
                vc.services = nil
            }
            
            
            vc.services = services
//          vc.tradies = tradies
            
            if boolGoToRequestFarm {
                vc.tradies = nil
                vc.serviceIDS = ids
                vc.services = nil
            }
            
            
            vc.search_type = search_type
            
            vc.boolSendToAll = true
            vc.search = search
            self.navigationController?.pushViewController(vc, animated: true)
        } else if boolGoToServiceSelection {
            let vc = story_Home.viewController("UserServices") as! UserServices
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            sendRequest ()
        }
    }
}

class AnnotationView: MKAnnotationView {
    var tradies: Tradies?
}

extension TradiesMap: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if !(annotation is MyAnnotation) {
            return nil
        }
        let annotationIdentifier = "AnnotationIdentifier"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationIdentifier) as? AnnotationView
        if annotationView == nil {
            annotationView = AnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
            annotationView!.canShowCallout = false
            if let ann = annotation as? MyAnnotation {
                let tred = ann.tradies
                annotationView?.tradies = tred
                let latitude = Double((tred?.latitude)!)!
                let longitude = Double((tred?.longitude)!)!
                let loc = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                let nnn = MyAnnotation(title: tred!.fullName, coordinate: loc, isDriver: true, id: "")
                annotationView!.annotation = nnn
            }
        } else {
            annotationView!.annotation = annotation
        }
        var pinImage = UIImage(named: "mappin")
        if annotationView?.tradies?.serviceName != nil {
            if (annotationView?.tradies?.serviceName)!.count > 0 {
                pinImage = getMapPin((annotationView?.tradies?.serviceName)!)
            }
        }
        annotationView!.image = pinImage
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        var ob: Tradies?
        print("view-\(view)-")
        if let cc = view as? PinAnnotationView {
            ob = cc.tradies
        } else if let cc = view as? AnnotationView {
            ob = cc.tradies
        }
        print("ob-\(ob?.fullName)-\n=========================")
        if ob != nil {
            setUser(ob)
        }
    }
}

class PinAnnotationView: MKPinAnnotationView {
    var tradies: Tradies?
}

func getMapPin (_ serviceName: String) -> UIImage {
    if serviceName.lowercased().subString("electrician".lowercased()) {
        return #imageLiteral(resourceName: "electrician")
    } else if serviceName.lowercased().subString("plumber".lowercased()) {
        return #imageLiteral(resourceName: "plumber")
    } else if serviceName.lowercased().subString("carpenter".lowercased()) {
        return #imageLiteral(resourceName: "carpenter")
    } else if serviceName.lowercased().subString("tiler".lowercased()) {
        return #imageLiteral(resourceName: "tiler")
    } else if serviceName.lowercased().subString("painter".lowercased()) {
        return #imageLiteral(resourceName: "painter")
    } else if serviceName.lowercased().subString("plasterer".lowercased()) {
        return #imageLiteral(resourceName: "plasterer")
    } else if serviceName.lowercased().subString("landscaper".lowercased()) {
        return #imageLiteral(resourceName: "landscraper")
    } else if serviceName.lowercased().subString("labourer".lowercased()) {
        return #imageLiteral(resourceName: "labourer")
    } else if serviceName.lowercased().subString("bricklayer".lowercased()) {
        return #imageLiteral(resourceName: "bricklayer")
    } else if serviceName.lowercased().subString("lawn".lowercased()) {
        return #imageLiteral(resourceName: "lawn moving")
    }
    
    return UIImage(named: "mappin")!
}
