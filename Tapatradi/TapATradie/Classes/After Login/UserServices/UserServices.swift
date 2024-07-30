//
//  Home.swift
//  TapATradie
//
//  Created by Apple on 22/04/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class UserServices: UIViewController {    
    var tradies: Tradies?
    
    var current_page = "1"
    
    @IBOutlet weak var cltnView: UICollectionView!
    @IBOutlet weak var txtfld4Search: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        txtfld4Search.placeHolderColor(UIColor.hexColor(0x707070), "Search for a Tradie")
        
        txtfld4Search.superview?.border5(3)
        txtfld4Search.superview?.shadow()
    }
    
    var search = ""
    
    override func viewWillAppear(_ animated: Bool) {
        kAppDelegate.currentVC = self
        
        getServices ("1")
    }
    
    @IBAction func btn4Search(_ sender: Any) {
//        if (txtfld4Search.text?.count)! > 0 {
            getTradies()
//        } else {
//            Http.alert("", "Enter service/tradie name")
//        }
        
        self.view.endEditing(true)
    }
    
    var fixed_service = "1"
    
    func getServices (_ page: String) {
        let param = params()
        
        current_page = page
        
        param["search"] = ""
        param["fixed_service"] = fixed_service
        
        if self.fixed_service == "1" {
            param["page"] = "all"
        } else {
            param["page"] = page
        }
        
        Http.instance().json(api_get_services_list, param, "POST", aai: true, popup: true, prnt: true, nil, nil, sync: false, defaultCalling: false) { (json, paras, str, data) in
            
            let jsonExp = json as? NSDictionary
            
            if jsonExp != nil {
                if jsonExp?.number("success").intValue == SESSIONEXPIRED {
                   kAppDelegate.sessionExpired(self)
                    
                    return
                }
            }
            
            if data != nil {
                do {
                    let self_servicesJSON = try JSONDecoder().decode(ServicesJSON.self, from: data!)
                    
                    if self_servicesJSON != nil {
                        if self.fixed_service == "1" {
                            self.servicesJSON = self_servicesJSON
                            
                            let ob = Services("")
                            ob.name = "More"
                            ob.id = -99999
                            self.servicesJSON?.data.append(ob)
                            
                            self.createTableArray ()
                        } else {
                            self.processJSON(self_servicesJSON)
                        }
                    }
                } catch let error {
                    print("Error: \(error)")
                    
                    self.downloading = .noData
                }
            } else {
                self.downloading = .noData
            }
        }
    }
    
    var servicesJSON: ServicesJSON?
    
    var services: Services?
    var downloading: Downloading = .canDownload
    
    func getTradies () {
        let param = params()
        param["search"] = txtfld4Search.text
        param["tradie_type"] = ""
        param["service_id"] = ""
        param["sort_by"] = ""
        param["page"] = "all"
         param["fixed_service"] = fixed_service//"0"
        
        Http.instance().json(api_get_services_list, param, "POST", aai: true, popup: true, prnt: true, nil, nil, sync: false, defaultCalling: false) { (json, paras, str, data) in
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
                    self.servicesJSON = try JSONDecoder().decode(ServicesJSON.self, from: data!)
                    
                    self.createTableArray ()
                } catch let error {
                    print("Error: \(error)")
                }
            }
        }
    }
    
    //Services
    
    var arrTable = [Services]()
    var arrDict = [[String:[Services]]]()
    
    func createTableArray () {
        arrTable = [Services]()
        arrDict = [[String:[Services]]]()
        
        if self.servicesJSON?.data != nil {
            arrTable = self.servicesJSON!.data
            
            var firstCharacter:String = ""
            
            var arryService = [Services]()
            
            for serviceData in self.servicesJSON!.data{
                
                let localFirstCharacter = serviceData.name?.first?.description ?? ""
                
                if firstCharacter == ""{
                    firstCharacter = localFirstCharacter
                }
                
                
                if localFirstCharacter == firstCharacter{
                    arryService.append(serviceData)
                }else{
                    arrDict.append([firstCharacter:arryService])
                    firstCharacter = localFirstCharacter
                    arryService.removeAll()
                    arryService.append(serviceData)
                }
                
            }
            
            arrDict.append([firstCharacter:arryService])
        }
        
        self.cltnView.reloadData()
        
    }
    
    @IBAction func actionSearch (_ textField: UITextField) {
        /*
        arrTable = [Services]()
        
        if self.servicesJSON?.data != nil {
            if textField.text!.count > 0 {
                for i in 0..<self.servicesJSON!.data.count {
                    let ob = self.servicesJSON!.data[i]
                    
                    if ob.name != nil {
                        let a1 = (ob.name?.lowercased())!
                        let a2 = (textField.text?.lowercased())!
                        
                        if a1.subInSensetive(a2) {
                            print("textField.text-\(a1)-\(a2)-")
                            arrTable.append(ob)
                        }
                    }
                }
            } else {
                arrTable = self.servicesJSON!.data
            }
        }
        
        print("arrTable-\(arrTable.count)-")
        */
       
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.getTradies()
        }
        
        
    }
}

extension UserServices: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, HomeCellDelegate, UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.arrDict.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let dict = self.arrDict[section]
        let arry = dict[dict.keys.first ?? ""]?.count
//        return dict[""].count
//        return arrTable.count
        return arry ?? 0
    }
    
    func processJSON (_ servicesJSON: ServicesJSON?) {
        if servicesJSON != nil && servicesJSON?.data != nil {
            if (servicesJSON?.data.count ?? 0) == 0 {
                self.downloading = .noData
            }
        }
        
        if servicesJSON != nil && self.servicesJSON == nil {
            self.servicesJSON = servicesJSON
        } else if servicesJSON != nil && self.servicesJSON != nil {
            for i in 0..<(servicesJSON?.data.count ?? 0) {
                self.servicesJSON?.data.append((servicesJSON?.data[i])!)
            }
        }
        
        if self.downloading != .noData {
            self.downloading = .canDownload
        }
        self.createTableArray ()
    }
    
    /*
    func processPaging (_ indexPath: IndexPath) {
        if txtfld4Search.text!.count == 0 {
            var total_cell = 0
            
            if servicesJSON?.data != nil {
                total_cell = servicesJSON!.data.count
            }
            
            let rows = 15
            
            //print("total_cell-\(indexPath.row)-\(total_cell)-\(downloading)-\(total_cell % rows)-")
            
            if indexPath.row == (total_cell - 1) {
                if downloading == .canDownload {
                    
                    let current_page = Int(self.current_page)! + 1
                    
                    downloading = .downloading
                    getServices ("\(current_page)")
                }
            }
        }
    }
    */
    
    
    
    func processPaging (_ indexPath: IndexPath) {
        if txtfld4Search.text!.count == 0 {
//            var total_cell = 0
//
//            if servicesJSON?.data != nil {
//                total_cell = servicesJSON!.data.count
//            }
//
//            let rows = 15
            
            //print("total_cell-\(indexPath.row)-\(total_cell)-\(downloading)-\(total_cell % rows)-")
            
            let serviceDict = self.arrDict[indexPath.section]
            let arrService = serviceDict[serviceDict.keys.first ?? ""] ?? [Services("")]
            
            
            if (indexPath.section == (self.arrDict.count-1)) && (indexPath.row == (arrService.count - 1)) {
                
                if downloading == .canDownload {
                    
                    let current_page = Int(self.current_page)! + 1
                    
                    downloading = .downloading
                    getServices ("\(current_page)")
                }
            }
            
        }
    }
    
    
   
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if fixed_service == "0" {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "USCell", for: indexPath) as! USCell
            
            //cell.imgCell.image = #imageLiteral(resourceName: "Group 4652")
            //cell.imgCell.isHidden = true
            //cell.lblTitle.text = ""
            
            //let ob = servicesJSON?.data[indexPath.row]
            
            
            /*
            let ob = arrTable[indexPath.row]
            
            cell.lblCell.text = ob.name?.capFirstLetter()
            cell.delegate = self
            cell.indexPath = indexPath
            
            processPaging (indexPath)
            */
            
            let serviceDict = self.arrDict[indexPath.section]
            let arrService = serviceDict[serviceDict.keys.first ?? ""] ?? [Services("")]
            
            
            let ob = arrService[indexPath.row]
            
            cell.lblCell.text = ob.name?.capFirstLetter()
            cell.delegate = self
            cell.indexPath = indexPath
            
            processPaging (indexPath)
            
            return cell
            
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCell", for: indexPath) as! HomeCell
            cell.delegate = self
            cell.indexPath = indexPath
            cell.viewBackground.border5(3)
            cell.viewBackground.shadow(3, -1)
            
            //let ob = servicesJSON?.data[indexPath.row]
            
           
            
            let ob = arrTable[indexPath.row]
            
            cell.lblTitle.text = ob.name?.capFirstLetter()
            cell.lblMoreServices.text = ""
            
            cell.imgCell.isHidden = false
            if (ob.name)! != "More" {
                let url = "\(Server)\((ob.imageLink)!)/\((ob.image)!)"
                
                cell.imgCell.uiimage(url, "Group 4302", true, nil)
            } else {
                cell.imgCell.image = #imageLiteral(resourceName: "Group 4652")
            }
            
            processPaging (indexPath)
            
            
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        if fixed_service == "0" {
            return CGSize(width: self.view.frame.size.width, height: 25)
        } else {
            let size = (self.view.frame.size.width - 2) / 3
            
            return CGSize(width: size, height: size)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        switch kind{
            
        case UICollectionView.elementKindSectionHeader:
            
            let headerView = cltnView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "UserServiceHeaderCV", for: indexPath) as! UserServiceHeaderCV
            let dic = self.arrDict[indexPath.section].keys
            headerView.lblHead.text = dic.first
            return headerView
            
        default:
            //assert(false, "Unexpected element kind")
            fatalError("Unexpected element kind")
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: self.cltnView.frame.width, height: 100.0)
    }
    
    
    
    
    
    
    
    
    
    func cellClicked(_ indexPath: IndexPath) {
        //let ob = servicesJSON?.data[indexPath.row]
//        let ob = arrTable[indexPath.row] as? Services
        
        let serviceDict = self.arrDict[indexPath.section]
        let arrService = serviceDict[serviceDict.keys.first ?? ""]
        
        
        let ob = arrService?[indexPath.row]
        
        
        print("ob-\(ob?.id)-")
        
        if ob?.id != -99999 {
            if fixed_service == "1" {
                let vc = story_Home.viewController("TradieList") as? TradieList
                
                vc?.search = search
                vc?.services = ob
                vc?.tradie_type = nil
                vc?.paramSendToAll = nil
                vc?.boolGoToServiceSelection = true
                self.navigationController?.pushViewController(vc!, animated: true)
            } else if fixed_service == "0" {
                
                let vc = story_Tradie.viewController("TradiesMap") as! TradiesMap
                vc.search_type = ""
                vc.tradies = nil
        //        vc.tradiesJSON = self.tradiesJSON
                vc.services = ob
                vc.search = search
                vc.tradie_type = nil//tradie_type
                vc.paramSendToAll = nil//paramSendToAll
                
                //MARK: Himanshu Update
                //vc.boolGoToRequestFarm = false//boolGoToRequestFarm
                vc.boolGoToRequestFarm = true//boolGoToRequestFarm
                vc.boolGoToServiceSelection = false//boolGoToServiceSelection
                
                self.navigationController?.pushViewController(vc, animated: false)
                
                
//                let vc = story_Home.viewController("RequestTradie") as! RequestTradie
//                vc.services = ob
//                vc.tradies = tradies
//                vc.search = search
//                self.navigationController?.pushViewController(vc, animated: true)
            }
        } else {
            let vc = story_Home.viewController("UserServices") as! UserServices
            vc.fixed_service = "0"
            vc.search = search
            vc.services = ob
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

class USCell: UICollectionViewCell {
    
    @IBOutlet weak var lblCell: UILabel!
    
    var delegate: HomeCellDelegate!
    var indexPath: IndexPath!
    
    @IBAction func actionClicked(_ sender: Any) {
        delegate.cellClicked(indexPath)
    }
    
    override func awakeFromNib() {
        //lblCell.superview?.border(.hexColor(0xF7941D), 4, 2)
    }
}
