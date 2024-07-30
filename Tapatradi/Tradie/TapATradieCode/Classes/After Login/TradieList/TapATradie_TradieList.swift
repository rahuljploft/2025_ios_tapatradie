//
//  TradieList.swift
//  TapATradie
//
//  Created by Apple on 24/04/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import ImageScrollView
import Common

protocol TapATradie_TradieListCellDelegate {
    func requestAt (_ indexPath: IndexPath)
    func cellClicked (_ indexPath: IndexPath)
    func cellSelected (_ indexPath: IndexPath, _ btn: UIButton)
    func cellViewProfile (_ indexPath: IndexPath)
}

class TapATradie_TradieListCell: UITableViewCell {
    

    
    @IBOutlet weak var lblGoogleRating: UILabel!
    @IBOutlet weak var lblFaceBookRating: UILabel!
    
    @IBOutlet weak var stackGoogle: UIStackView!
    @IBOutlet weak var stackFaceBook: UIStackView!
    
    
    
    @IBOutlet weak var lblShimmer: UILabel!
    @IBOutlet weak var btnCellSelected: GradientButton!
    
    @IBAction func actionCellSelected(_ sender: Any) {
        delegate.cellSelected(indexPath, btnCellSelected)
    }
    
    var indexPath: IndexPath!
    var delegate: TapATradie_TradieListCellDelegate!
    
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var imgCell: UIImageView!
    @IBOutlet weak var imgVerified: UIImageView!
    @IBOutlet weak var imgTitle: UILabel!
    @IBOutlet weak var imgSubTitle: UILabel!
    @IBOutlet weak var subtitleViewC: UIView!
    
    @IBOutlet var starImages: [UIImageView]!
    
    @IBOutlet weak var imgOnline: UIImageView!
    @IBOutlet weak var lblOnline: UILabel!
    
    @IBOutlet weak var viewFGContainer: UIView!
    
    
    override func awakeFromNib() {
        imgCell.border5(imgCell.frame.size.height/2)
        lblShimmer.border5(6)
        
        viewFGContainer.setCornerRadiusWithBorder(cornerRadius: 4,
                                                  clipsToBound: true,
                                                  borderWidth: 1,
                                                  borderColor: UIColor(named: "#C9C9C9")?.cgColor)
        
    }
    
    
}

extension TapATradie_TradieList: TapATradie_TradieListCellDelegate {
    
    func cellSelected(_ indexPath: IndexPath, _ btn: UIButton) {
        let ob = tableArray?[indexPath.row]
        
//        if ob?.subscribedStatus != "active" || ob?.subscribedStatus != "trialing"{
//            AlertService.shared.showError(message: "You can not send request Becauase  this tradie not Member")
//            return
//        }
        
        
        if ob?.id != nil {
            if self.arrSelectedTradies.contains(ob!.id) {
                if let index = arrSelectedTradies.firstIndex(of: ob!.id) {
                    self.arrSelectedTradies.remove(at: index)
                }
            } else {
                self.arrSelectedTradies.append(ob!.id)
            }
        }
        
        let cell = tblTradies.dequeueReusableCell(withIdentifier: "TradieListCell", for: indexPath) as! TapATradie_TradieListCell
        
        let cardView = cell.cardView
        cardView?.layer.backgroundColor = UIColor.clear.cgColor
        cardView?.layer.borderColor = UIColor.TapATradie_hexColor(0xDFDFDF).cgColor
        cardView?.layer.borderWidth = 1
        cardView?.layer.cornerRadius = 6
        
        cell.btnCellSelected.setImage(UIImage(), for: .normal)
        cell.btnCellSelected.setTitle("Select", for: .normal)
        cell.btnCellSelected.setTitleColor(UIColor.white, for: .normal)
        cell.btnCellSelected.showGradient = true
        
//        cell.imgSubTitle.layer.borderWidth = 1
//        cell.imgSubTitle.layer.borderColor = UIColor.hexColor(0xDFDFDF).cgColor
//        cell.imgSubTitle.layer.backgroundColor = UIColor.white.cgColor
        
        cell.subtitleViewC.layer.borderWidth = 1
        cell.subtitleViewC.layer.borderColor = UIColor.TapATradie_hexColor(0xDFDFDF).cgColor
        cell.subtitleViewC.layer.backgroundColor = UIColor.white.cgColor
        cell.subtitleViewC.layer.cornerRadius = 4
        
        
        if self.arrSelectedTradies.contains(ob!.id) {
            cardView?.layer.backgroundColor = UIColor.TapATradie_hexColor(0xFFF9F1).cgColor
            cardView?.layer.borderWidth = 0
            cardView?.setNeedsDisplay()
            cell.btnCellSelected.setTitle("Deselect", for: .normal)
            cell.btnCellSelected.showGradient = false
            cell.btnCellSelected.backgroundColor = UIColor.TapATradie_hexColor(0xC4C4C4)
//            cell.imgSubTitle.layer.borderWidth = 0
//            cell.imgSubTitle.layer.borderColor = UIColor.clear.cgColor
            
//            cell.subtitleViewC.layer.borderWidth = 0
//            cell.subtitleViewC.layer.borderColor = UIColor.clear.cgColor
            
        }
        
        tblTradies.beginUpdates()
        tblTradies.reloadRows(at: [indexPath], with: .automatic)
        tblTradies.endUpdates()
    }
    
    func cellClicked (_ indexPath: IndexPath) {
        if tableArray == nil {
            return
        }
        
        let ob = tableArray![indexPath.row]
                
        zoomImage (indexPath)
    }
    
    func cellViewProfile (_ indexPath: IndexPath) {
        //let ob = tradiesJSON?.data[indexPath.row]
        
        if tableArray == nil {
            return
        }
        
        let ob = tableArray![indexPath.row]
        
        let vc = TapATradie_story_Tradie.TapATradie_viewController("TradieProfile") as! TapATradie_TradieProfile
        
        vc.tradies = ob
        vc.tradiesJSON = self.tradiesJSON
        vc.services = services
        vc.search = search
        vc.tradie_type = tradie_type
        vc.paramSendToAll = paramSendToAll
        vc.boolGoToRequestFarm = boolGoToRequestFarm
        vc.boolGoToServiceSelection = boolGoToServiceSelection
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func requestAt (_ indexPath: IndexPath) {
        if tableArray == nil {
            return
        }
        
        let ob = tableArray![indexPath.row]
        
        if boolGoToRequestFarm {
            if ob.serviceId.count > 0 {
                let arr = ob.serviceId.components(separatedBy: ",")
                
                if arr.count > 0 {
                    let int = Int(arr[0])
                    
                    if int != nil {
                        services = TapATradie_Services("")
                        services?.id = int!
                    }
                }
            }
        }
        
        if paramSendToAll != nil && services != nil {
            paramSendToAll!["tradie_id"] = ob.id
            
            sendRequest ()
        } else if services != nil {
            let vc = TapATradie_story_Home.TapATradie_viewController("RequestTradie") as! TapATradie_RequestTradie
            vc.services = services
            vc.tradies = ob
            vc.search_type = search_type
            vc.search = search
            vc.arrSelectedTradies = self.arrSelectedTradies
            
            if tableArray?.count != nil {
                vc.tradieCount = tableArray!.count
            }
            
            //vc.forServiceCalled = self.forServiceCalled (ob)
            
            self.navigationController?.pushViewController(vc, animated: true)
        } else if boolGoToServiceSelection {
            let vc = TapATradie_story_Home.TapATradie_viewController("UserServices") as! TapATradie_UserServices
            vc.search = search
            vc.tradies = ob
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            paramSendToAll!["tradie_id"] = ob.id
            
            sendRequest ()
        }
    }
    
    func forServiceCalled (_ ob: TapATradie_Tradies) -> String? {
            let arr = ob.serviceName.components(separatedBy: ",")
            
            if arr != nil {
                if arr.count > 1 {
                    print("Harish Both")
                    
                    return "both"
                } else if arr.count == 1 {
                    //cell.lblTradieTypeSingle.text = "\(arr![0])".capFirstLetter()
                    //cell.lblTradieTypeSingle.isHidden = false
                    
                    //Residential
                    
                    print("Harish 1-[\("\(arr[0])".capFirstLetter())]-")
                    
                    return "\(arr[0])".capFirstLetter()
                }
            }
            
        
        
        return nil
    }
}

extension UIButton {
    func TapATradie_selectedFilter (_ bool: Bool) {
        if bool {
            self.setTitleColor(UIColor.TapATradie_hexColor(0xF7941D), for: .normal)
            self.layer.borderColor = UIColor.TapATradie_hexColor(0xF7941D).cgColor
        } else {
            self.setTitleColor(UIColor.TapATradie_hexColor(0x707070), for: .normal)
            self.layer.borderColor = UIColor.TapATradie_hexColor(0x000000).withAlphaComponent(0.2).cgColor
        }
    }
}

enum TapATradie_Filter {
    case none
    case lowtohigh
    case hightolow
}

class TapATradie_TradieList: UIViewController {
    
    @IBAction func actionSend (_ sender: Any) {
        if tableArray == nil {
            return
        }
        
        if arrSelectedTradies.count == 0 {
            //Toast.toast("Please select tradie")
            actionSendToAll("")
        } else {
            actionSendToAll("")
        }
    }
    
    @IBAction func actionSelectAll (_ sender: Any) {
        if tableArray == nil {
            return
        }
        self.arrSelectedTradies = []
        for i in 0..<tableArray!.count {
            let ob = tableArray?[i]
            if ob?.id != nil {
//                if ob?.subscribedStatus == "active"{
                    self.arrSelectedTradies.append(ob!.id)
//                }
            }
        }
        tblTradies.reloadData()
    }
    
    @IBAction func actionSelectAll_New (_ sender: Any) {
        
        //MARK: Himanshu Update
        if tableArray == nil {
            return
        }
        self.arrSelectedTradies = []
        for i in 0..<tableArray!.count {
            let ob = tableArray?[i]
            if ob?.id != nil {
//                if ob?.subscribedStatus == "active"{
                    self.arrSelectedTradies.append(ob!.id)
//                }
            }
        }
        
        //tblTradies.reloadData()
        
        if tableArray == nil {
            return
        }
        
        if arrSelectedTradies.count == 0 {
            Toast.toast("Please select tradie")
        } else {
            actionSendToAll("")
        }
        
    }
    
    @IBOutlet var btnSelectAll: UIButton!
    @IBOutlet var btnSelectAll_new: UIButton!
    
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
    
    override func viewDidLoad() {
        
        btnSelectAll_new.layer.cornerRadius = 4
        
        tblTradies.delegate = self
        tblTradies.dataSource = self
    }
    
    @IBAction func actionRemovePopup(_ sender: Any) {
        viewPopUp.removeFromSuperview()
        
        TapATradie_kAppDelegate.TapATradie_tabbarClicked(IndexPath(row: 1, section: 0), self.navigationController)
    }
    
    var filter: TapATradie_Filter! = TapATradie_Filter.none
    
    func selectedFilter () {
        btnFilterLowToHigh.setTitleColor(UIColor.TapATradie_hexColor(0x707070), for: .normal)
        btnFilterLowToHigh.layer.borderColor = UIColor.TapATradie_hexColor(0x000000).withAlphaComponent(0.2).cgColor
        
        btnFilterHighToLow.setTitleColor(UIColor.TapATradie_hexColor(0x707070), for: .normal)
        btnFilterHighToLow.layer.borderColor = UIColor.TapATradie_hexColor(0x000000).withAlphaComponent(0.2).cgColor
        
        if filter == TapATradie_Filter.lowtohigh {
            btnFilterLowToHigh.setTitleColor(UIColor.TapATradie_hexColor(0xF7941D), for: .normal)
            btnFilterLowToHigh.layer.borderColor = UIColor.TapATradie_hexColor(0xF7941D).cgColor
        } else if filter == TapATradie_Filter.hightolow {
            btnFilterHighToLow.setTitleColor(UIColor.TapATradie_hexColor(0xF7941D), for: .normal)
            btnFilterHighToLow.layer.borderColor = UIColor.TapATradie_hexColor(0xF7941D).cgColor
        }
    }
    
    @IBAction func actionRemoveFilters(_ sender: Any) {
        viewFilters.removeFromSuperview()
    }
    
    func clearFunction () {
        filter = TapATradie_Filter.none
        
        selectedFilter ()
    }
    
    @IBAction func actionOpenFilters(_ sender: Any) {
        //clearFunction ()
        
        viewFilters.frame = self.view.bounds
        self.view.addSubview(viewFilters)
    }
    
    @IBOutlet var viewFilters: UIView!
    
    @IBOutlet weak var btnFilterLowToHigh: UIButton!
    @IBOutlet weak var btnFilterHighToLow: UIButton!
    
    @IBAction func actionLowToHigh(_ sender: Any) {
        filter = TapATradie_Filter.lowtohigh
        
        selectedFilter ()
    }
    
    @IBAction func actionHighToLow(_ sender: Any) {
        filter = TapATradie_Filter.hightolow
        
        selectedFilter ()
    }
    
    @IBAction func actionApply(_ sender: Any) {
        viewFilters.removeFromSuperview()
        
        getTradies ()
        
        arrangeTableArray ()
    }
    
    @IBAction func actionClearAll(_ sender: Any) {
        clearFunction ()
        
        arrangeTableArray ()
        
        viewFilters.removeFromSuperview()
    }
    
    @IBOutlet weak var tblTradies: UITableView!
    
    @IBAction func actionBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        TapATradie_kAppDelegate.TapATradie_currentVC = self
        
        if services != nil {
            getTradies ()
        } else if tradiesJSON != nil {
            arrangeTableArray ()
        }
        
        selectedFilter()
    }
    
    @IBAction func actionMap(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
//        let vc = story_Tradie.viewController("TradiesMap") as! TradiesMap
//        vc.search_type = search_type
//        vc.tradies = nil
//        vc.tradiesJSON = self.tradiesJSON
//        vc.services = services
//        vc.search = search
//        vc.tradie_type = tradie_type
//        vc.paramSendToAll = paramSendToAll
//        vc.boolGoToRequestFarm = boolGoToRequestFarm
//        vc.boolGoToServiceSelection = boolGoToServiceSelection
        
//        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    var services: TapATradie_Services?
    
    var paramSendToAll: NSMutableDictionary?
    
    func getServiceType () {
        var idsOnlyResidential = ""
        var idsOnlyCommercial = ""
        var idsResidentialCommercial = ""
        
        for i in 0..<tableArray!.count {
            let ob = tableArray![i]
            
            if ob.serviceName.count > 0 {
                let arr = ob.serviceName.components(separatedBy: ",")
                
                print("arr-[\(arr)]-")
                
                if arr.count > 0 {
                    let int = Int(arr[0])
                    
                    if int != nil {
                        /*if ids.count == 0 {
                            ids = "\(int!)"
                        } else {
                            ids = "\(ids),\(int!)"
                        }*/
                    }
                }
            }
        }
    }
    
    @IBAction func actionSendToAll(_ sender: Any) {
        var ids = ""
        
        //getServiceType ()
        
        if boolGoToRequestFarm {
            if tableArray == nil {
                return
            }
            
            services = TapATradie_Services("")
            
            for i in 0..<tableArray!.count {
                let ob = tableArray![i]
                
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
            
            services = TapATradie_Services("")
        }
        
        if paramSendToAll == nil && services != nil {
            let vc = TapATradie_story_Home.TapATradie_viewController("RequestTradie") as! TapATradie_RequestTradie
            vc.services = services
            
            if tableArray?.count != nil {
                vc.tradieCount = tableArray!.count
            }
            
            vc.arrSelectedTradies = self.arrSelectedTradies
            
            print("self.arrSelectedTradies.-[\(self.arrSelectedTradies)]-[\(tableArray)]-")
            
            if boolGoToRequestFarm {
                vc.tradies = nil
                vc.serviceIDS = ids
                vc.services = nil
            }
            
            vc.search_type = search_type
            vc.boolSendToAll = true
            
            vc.arrSelectedTradies = self.arrSelectedTradies
            vc.search = search
            self.navigationController?.pushViewController(vc, animated: true)
        } else if boolGoToServiceSelection {
            let vc = TapATradie_story_Home.TapATradie_viewController("UserServices") as! TapATradie_UserServices
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            sendRequest ()
        }
    }
    
    var search_type = ""
    
    func sendRequest () {
        paramSendToAll! ["search"] = search
        
        paramSendToAll?.TapATradie_addStaticLocation()
        
        if TapATradie_kAppDelegate.TapATradie_obAddresses != nil {
            if TapATradie_kAppDelegate.TapATradie_obAddresses?.latitude != nil && TapATradie_kAppDelegate.TapATradie_obAddresses?.longitude != nil {
                paramSendToAll!["latitude"] = (TapATradie_kAppDelegate.TapATradie_obAddresses?.latitude)!
                paramSendToAll!["longitude"] = (TapATradie_kAppDelegate.TapATradie_obAddresses?.longitude)!
                
                paramSendToAll!["city"] = (TapATradie_kAppDelegate.TapATradie_obAddresses?.city)!
                paramSendToAll!["state"] = (TapATradie_kAppDelegate.TapATradie_obAddresses?.state)!
                paramSendToAll!["country"] = (TapATradie_kAppDelegate.TapATradie_obAddresses?.country)!
            }
        }
        
        paramSendToAll?.TapATradie_addSearchType()
        
        if arrSelectedTradies.count == tableArray!.count {
            paramSendToAll! ["tradie_id"] = "0"
        } else {          
            if arrSelectedTradies.count > 0 {
                let arr = NSArray (array: arrSelectedTradies)
                paramSendToAll! ["tradie_id"] = arr.componentsJoined(by: ",")
            }
        }
        
        /*vc.arrSelectedTradies = self.arrSelectedTradies
        
        if tableArray?.count != nil {
            vc.tradieCount = tableArray!.count
        }*/
        
        Http.instance().json(TapATradie_api_user_job_request_to_tradie, paramSendToAll, "POST", aai: true, popup: true, prnt: true, nil, nil, sync: false, defaultCalling: false) { (json, paras, str, data) in
            let jsonExp = json as? NSDictionary
            
            if jsonExp != nil {
                if jsonExp?.number("success").intValue == SESSIONEXPIRED {
                    TapATradie_kAppDelegate.TapATradie_sessionExpired(self)
                    
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
    
    var boolGoToServiceSelection = false
    var boolGoToRequestFarm = false
    
    var tradiesJSON: TapATradie_TradiesJSON?
    
    var tradie_type: String?
    
    var search = ""
    
    var arrShimmer: [String] = []
    
    func getTradies () {
        arrShimmer = ["", "", "", "", "", "", "", "", "", "", "", "", ""]
        self.tblTradies.reloadData()
        
        let param = TapATradie_params()
        
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
        
        if filter == TapATradie_Filter.lowtohigh {
            param["sort_by"] = "low_to_high"
        } else if filter == TapATradie_Filter.hightolow {
            param["sort_by"] = "high_to_low"
        }
        
        param["search_type"] = ""
        
        if TapATradie_kAppDelegate.TapATradie_obAddresses != nil {
            if TapATradie_kAppDelegate.TapATradie_obAddresses?.latitude != nil && TapATradie_kAppDelegate.TapATradie_obAddresses?.longitude != nil {
                param["latitude"] = (TapATradie_kAppDelegate.TapATradie_obAddresses?.latitude)!
                param["longitude"] = (TapATradie_kAppDelegate.TapATradie_obAddresses?.longitude)!
                param["city"] = (TapATradie_kAppDelegate.TapATradie_obAddresses?.city)!
                param["state"] = (TapATradie_kAppDelegate.TapATradie_obAddresses?.state)!
                param["country"] = (TapATradie_kAppDelegate.TapATradie_obAddresses?.country)!
            }
        }
        
        Http.instance().json(TapATradie_api_user_tradie_search, param, "POST", aai: false, popup: true, prnt: true, nil, nil, sync: false, defaultCalling: false) { (json, paras, str, data) in
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
                    
                } else {
                    Http.alert("", json?.string("message"))
                }
            }
            
            if data != nil {
                do {
                    self.tradiesJSON = try JSONDecoder().decode(TapATradie_TradiesJSON.self, from: data!)
                    
                    self.tableArray = [TapATradie_Tradies]()
                    
                    if self.tradiesJSON != nil {
                        for i in 0..<(self.tradiesJSON?.data.count)! {
                            let ob = self.tradiesJSON?.data[i]
                            ob?.rating = ob?.rating ?? "0"
                            self.tableArray?.append(ob!)
                        }
                    }
                                        
                    self.arrangeTableArray ()
                } catch let error {
                    print("Error: \(error)")
                }
            }
        }
    }
    
    var tableArray: [TapATradie_Tradies]?
    
    //MARK: - Image Zoom

    @IBOutlet var viewImageZoom: UIView!

    @IBAction func actionRemoveImageZoom(_ sender: Any) {
        viewImageZoom.removeFromSuperview()
    }
    
    @IBAction func actionZoomImage(_ sender: Any) {
        //zoomImage ()

        //viewImageZoom.frame = self.view.bounds
        //self.view.addSubview(viewImageZoom)
    }
    
    func zoomImage (_ indexPath: IndexPath) {
        let ob = tableArray![indexPath.row]
        
        let url = "\(TapATradie_Server)profile/\(ob.id)/\(ob.profilePic)"
        
        let imgUser = UIImageView()
        
        imgUser.downloadUIImage(url) { (image, bool) in
            if image != nil {
                self.zoomUIImage(image!)
            } else {
                Toast.toast("Picture not available")
            }
        }
    }
      
    func zoomUIImage (_ image: UIImage) {
        DispatchQueue.main.async {
            self.viewImageZoom.frame = self.view.bounds
        
            self.view.addSubview(self.viewImageZoom)
        
            self.imageScrollView.setup()
            self.imageScrollView.imageScrollViewDelegate = self
            self.imageScrollView.imageContentMode = .aspectFit
            self.imageScrollView.initialOffset = .center
            self.imageScrollView.display(image: image)
        }
    }
    
    @IBOutlet weak var imageScrollView: ImageScrollView!
}

extension TapATradie_TradieList: ImageScrollViewDelegate {
    func imageScrollViewDidChangeOrientation(imageScrollView: ImageScrollView) {
        //print("Did change orientation")
    }
    
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        //print("scrollViewDidEndZooming at scale \(scale)")
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //print("scrollViewDidScroll at offset \(scrollView.contentOffset)")
    }
}

extension TapATradie_TradieList: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        cellViewProfile(indexPath)
    }
    
    func arrangeTableArray () {
        if filter == TapATradie_Filter.none {
            tableArray = [TapATradie_Tradies]()
            
            var tableArrayOnline = [TapATradie_Tradies]()
            var tableArrayOffline = [TapATradie_Tradies]()
            
            if self.tradiesJSON != nil {
                for i in 0..<(self.tradiesJSON?.data.count)! {
                    let ob = self.tradiesJSON?.data[i]
                    ob?.rating = ob?.rating ?? "0"
                    if (ob?.online)! == 1 {
                        if (self.tableArray?.count)! == 0 {
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
        } else {
            tableArray = tradiesJSON!.data
        }
        
        //tableArray = tradiesJSON!.data
        
//        if tableArray?.count ?? 0 < 1 {
//            view4SendToAll.isHidden = true
//        }
        
        //self.arrShimmer = []
        //self.tblTradies.reloadData()
        
        DispatchQueue.global().async {
            sleep(2)
            
            DispatchQueue.main.async {
                self.arrShimmer = []
                self.tblTradies.reloadData()
                
                if (self.tableArray?.count)! > 0 {
                    self.tblTradies.scrollToRow(at: IndexPath(row: 0, section: 0), at: .none, animated: true)
                }
            }
        }
    }
    
    func bubbleSort(_ ar: [TapATradie_Tradies]) -> [TapATradie_Tradies] {
        var ar = ar
        
        for i in stride(from: (ar.count-1), through: 0, by: -1) {
            for j in stride(from: 1, through: i, by: 1) {
                if filter == TapATradie_Filter.lowtohigh {
                    if Int(ar[j-1].rating!)! > Int(ar[j].rating!)! {
                        let obj1 = ar[j-1]
                        let obj = ar[j]
                        
                        ar.remove(at: j-1)
                        ar.insert(obj, at: j-1)
                        ar.remove(at: j)
                        ar.insert(obj1, at: j)
                    }
                } else if filter == TapATradie_Filter.hightolow {
                    if Int(ar[j-1].rating!)! < Int(ar[j].rating!)! {
                        let obj1 = ar[j-1]
                        let obj = ar[j]
                        
                        ar.remove(at: j-1)
                        ar.insert(obj, at: j-1)
                        ar.remove(at: j)
                        ar.insert(obj1, at: j)
                    }
                }
            }
        }
        
        return ar
    }
    
    func getValue (_ double: Double?) -> Double {
        if double == nil {
            return 0.0
        } else {
            return double!
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //getServiceType ()
        
        if arrShimmer.count > 0 {
            return arrShimmer.count
        }
        
        if tableArray != nil {
            return (tableArray?.count)!
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let c1 = arrShimmer.count
                
        if c1 > 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TradieListCell") as! TapATradie_TradieListCell
            
            //print("MyBookingsCell-\(c1)-\(indexPath.row)-")
            
            cell.lblShimmer.superview?.isHidden = false
            cell.lblShimmer.isHidden = false
            
            cell.lblShimmer.startShimmeringEffect()
               
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TradieListCell") as! TapATradie_TradieListCell
        
        cell.lblShimmer.superview?.isHidden = true
        cell.lblShimmer.isHidden = true
        
        cell.lblShimmer.stopShimmeringEffect ()
        
        let ob = tableArray?[indexPath.row]
        
        let cardView = cell.cardView
        cardView?.layer.backgroundColor = UIColor.clear.cgColor
        cardView?.layer.borderColor = UIColor.TapATradie_hexColor(0xDFDFDF).cgColor
        cardView?.layer.borderWidth = 1
        cardView?.layer.cornerRadius = 6
        
//        if ob?.subscribedStatus != "active"{
//            cell.btnCellSelected.isHidden = true
//        }else{
//            cell.btnCellSelected.isHidden = false
//        }
        
        cell.btnCellSelected.setTitle("Select", for: .normal)
        cell.btnCellSelected.setTitleColor(UIColor.white, for: .normal)
        cell.btnCellSelected.showGradient = true
        
//        cell.imgSubTitle.layer.borderWidth = 1
//        cell.imgSubTitle.layer.borderColor = UIColor.hexColor(0xDFDFDF).cgColor
//        cell.imgSubTitle.layer.backgroundColor = UIColor.white.cgColor
        
        cell.subtitleViewC.layer.borderWidth = 1
        cell.subtitleViewC.layer.borderColor = UIColor.TapATradie_hexColor(0xDFDFDF).cgColor
        cell.subtitleViewC.layer.backgroundColor = UIColor.white.cgColor
        cell.subtitleViewC.layer.cornerRadius = 4
        
        if ob?.id != nil {
            if self.arrSelectedTradies.contains(ob!.id) {
                cardView?.layer.backgroundColor = UIColor.TapATradie_hexColor(0xFFF9F1).cgColor
                cardView?.layer.borderWidth = 0
                cell.btnCellSelected.setTitle("Deselect", for: .normal)
                cell.btnCellSelected.backgroundColor = UIColor.TapATradie_hexColor(0xC4C4C4)
                cell.btnCellSelected.showGradient = false
//                cell.imgSubTitle.layer.borderWidth = 0
//                cell.imgSubTitle.layer.borderColor = UIColor.clear.cgColor
                
//                cell.subtitleViewC.layer.borderWidth = 0
//                cell.subtitleViewC.layer.borderColor = UIColor.clear.cgColor
            }
        }
        
        cell.indexPath = indexPath
        cell.delegate = self
        
        cell.imgTitle.text = ob?.fullName.uppercased()
        
        cell.imgSubTitle.text = ob?.serviceName.replacingOccurrences(of: ",", with: ", ")
        
        let arr = ob?.serviceName.components(separatedBy: ",")
        
        if arr != nil {
            if arr!.count > 0 {
                cell.imgSubTitle.text = arr![0].capFirstLetter()
            }
        }
        
        if ob?.verified == 1 {
            cell.imgVerified.isHidden = false
        } else {
            cell.imgVerified.isHidden = true
        }
        
        if ob?.online == 1 {
            cell.imgOnline.image = #imageLiteral(resourceName: "Online")
            cell.lblOnline.text = "Online"
        } else {
            cell.imgOnline.image = #imageLiteral(resourceName: "Offline")
            cell.lblOnline.text = "Offline"
        }
        
        
        //show google facebook rating
        
        if (ob?.google ?? "0") == "1"{
            cell.stackGoogle.isHidden = false
            cell.viewFGContainer.isHidden = false
        }else{
            cell.viewFGContainer.isHidden = true
            cell.stackGoogle.isHidden = true
        }
        
        cell.lblGoogleRating.text = ob?.googleRating ?? ""
        
        
        let starCount = Int(Double(ob?.rating ?? "0") ?? 0)
        for i in 0..<starCount {
            cell.starImages[i].isHidden = false
        }
        
        let url = "\(TapATradie_Server)profile/\((ob?.id)!)/\((ob?.profilePic)!)"

        cell.imgCell.sd_setImage(with: url.TapATradie_url) { (img, err, ty, ul) in
            if img == nil {
                cell.imgCell.image = UIImage(named: "Group 2826")
            } else {
                
            }
        }
        return cell
    }
}

struct TapATradie_TradiesJSON: Codable {
    let success: Int
    let message: String
    let data: [TapATradie_Tradies]
}

class TapATradie_Tradies: Codable {
    var id: Int
    var fullName, latitude, longitude, profilePic: String
    var google: String?
    var googleRating: String?
    var online, verified: Int
    var serviceName: String
    var serviceId: String
    var rating: String?
    var distance: Double?
    var subscribedStatus: String? //active or end or open
    
    
    enum CodingKeys: String, CodingKey {
        case id
        case serviceId = "service_id"
        case fullName = "full_name"
        case latitude, longitude
        case profilePic = "profile_pic"
        case online, verified
        case serviceName = "service_name"
        case subscribedStatus = "subscStatus"
        case rating
        case distance
        case google, googleRating
    }
    
    init() {
        id = 0
        fullName = ""
        latitude = ""
        longitude = ""
        profilePic = ""
        online = 0
        verified = 0
        serviceName = ""
        serviceId = ""
        rating = "0"
        distance = 0
        subscribedStatus = ""
        google = ""
        googleRating = ""
    }
}

extension String {
    
    func TapATradie_showRating1 () -> String {
        if self.count > 0 {
            if let flo = Float(self) {
                return String(format: "%0.1f", arguments: [flo])
            }
        } else if self.count == 0 {
            return "0"
        }
        
        return self
    }
    
    func TapATradie_showPrice1 () -> String {
        if self.count > 0 {
            if let flo = Float(self) {
                return String(format: "%0.2f", arguments: [flo])
            }
        }
        
        return self
    }
    
    func TapATradie_checkApprox (_ dict: NSDictionary?) -> String {
        if dict == nil {
            return self
        }
        
        if dict?.number("approx").intValue == 1 {
            return self + " (approx.)"
        } else {
            return self
        }
    }
    
}
