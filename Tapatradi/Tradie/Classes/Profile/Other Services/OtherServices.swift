//
//  OtherServices.swift
//  Tradie
//
//  Created by Apple on 07/05/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class OtherServices: UIViewController {
    
    var isFromRegister = false
    
    @IBOutlet weak var btn_Next: UIButton!
    @IBAction func actionBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        kAppDelegate.currentVC = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        btn_Next.backgroundColor = UIColor.systemOrange.withAlphaComponent(0.9)
        btn_Next.layer.cornerRadius = 10
        
        tfvNewService.placeHolder = "Additional Services"
        tfvNewService.messageText = "Please Complete"
        
        getMoreServices ("1")
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_ :)))
        self.view.addGestureRecognizer(tap)
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        self.view.endEditing(true)
    }
    
    var servicesJSON: ServicesJSON?
    
    @IBOutlet weak var tblServices: UITableView!
    @IBOutlet weak var tfvNewService: MaterialTextFieldView!
    
    var services = ""
    
    @IBAction func actionSubmit(_ sender: Any) {
        //services = ""
        
        print("1services-\(services)-")
        if servicesJSON != nil {
            for i in 0..<(servicesJSON?.data.count)! {
                let ob = servicesJSON?.data[i]
                
                if ob?.isSelected != nil {
                    if (ob?.isSelected)! {
                        if services.count == 0 {
                            services = "\((ob?.id)!)"
                        } else {
                            services = "\(services),\((ob?.id)!)"
                        }
                    }
                }
            }
        }
        
        print("2services-\(services)-")
        
        if services.count > 0 || tfvNewService.textField.text!.count > 0 {
            let vc = story_Profile.viewController("SelectServiceType") as! SelectServiceType
            vc.isFromRegister = self.isFromRegister
            vc.otherService = tfvNewService.textField.text!
            vc.services = services
            
            if boolcommercial || boolResidential {
                vc.boolCommercial = boolcommercial
                vc.boolResidential = boolResidential
            } else {
                vc.boolCommercial = true
                vc.boolResidential = true
            }
            
            vc.selected_services = (servicesJSON?.selectedServices)!
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            Http.alert("", "Please select atleast one service.")
        }
    }
    
    var boolResidential = false
    var boolcommercial = false
    
    var downloading: Downloading = .canDownload
    var current_page = "1"
    var pointContentOffset = CGPoint.zero
}

extension OtherServices: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        (textField.superview as? MaterialTextFieldView)?.endEditing()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        (textField.superview as? MaterialTextFieldView)?.beginEditing()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let str = textField.text! + string
        
        let superV = (textField.superview as? MaterialTextFieldView)
        
        if superV == tfvNewService {
            if str.count > 30 {
                return false
            } else if textField.text!.count <= 1 && string.count == 0 {
                (textField.superview as? MaterialTextFieldView)?.status = .nodata
                (textField.superview as? MaterialTextFieldView)?.showNoValidation()
                (textField.superview as? MaterialTextFieldView)?.lblMsg.text = "Please Complete"
            } else if textField.text!.count < 1 {
                (textField.superview as? MaterialTextFieldView)?.status = .error
                (textField.superview as? MaterialTextFieldView)?.showError()
            } else if textField.text!.count == 1 && string.count == 0 {
                (textField.superview as? MaterialTextFieldView)?.status = .error
                (textField.superview as? MaterialTextFieldView)?.showError()
            } else if str.count == 3 {
                (textField.superview as? MaterialTextFieldView)?.status = .varified
                (textField.superview as? MaterialTextFieldView)?.showNoError()
                (textField.superview as? MaterialTextFieldView)?.lblMsg.text = ""
            }
        }
        
        return true
    }
}

extension OtherServices {
    func processJSON (_ downloadData: ServicesJSON?, _ tbl: UITableView) {
        var arrTable = self.servicesJSON
        
        if downloadData != nil && downloadData?.data != nil {
            if (downloadData?.data.count)! == 0 {
                self.downloading = .noData
            }
        }
        
        if downloadData != nil && arrTable == nil {
            arrTable = downloadData
        } else if downloadData != nil && arrTable != nil {
            for i in 0..<(downloadData?.data.count)! {
                arrTable?.data.append((downloadData?.data[i])!)
            }
        }
        
        self.servicesJSON = arrTable
        
        if self.downloading != .noData {
            self.downloading = .canDownload
        }
        
        /*self.dataArray = [ServicesJSON]()
        
        if arrTable?.data != nil {
            for i in 0..<(arrTable?.data.count)! {
                self.dataArray?.append((arrTable?.data[i])!)
            }
        }*/
        
        DispatchQueue.main.async {
            tbl.reloadData()
        }
    }
    
    func getMoreServices (_ page: String) {
        pointContentOffset = tblServices.contentOffset
        
        let param = params()
        
        param["search"] = ""
        param["fixed_service"] = "0"
        param["page"] = page
        print(param)
        Http.instance().json(api_get_services_list, param, "POST", aai: false, popup: true, prnt: true, nil, nil, sync: false, defaultCalling: false) { (json, paras, str, data) in
            let jsonExp = json as? NSDictionary
            
            if jsonExp != nil {
                if jsonExp?.number("success").intValue == SESSIONEXPIRED {
                    kAppDelegate.sessionExpired(self)
                    
                    return
                }
            }
            
            var json = json as? NSDictionary
            json = json?.getMutable(nil)
            
            if json == nil {
                Http.stopActivityIndicator()
                
                return
            }
            
            if let data = json?["data"] as? NSArray {
                
                var arr = [Services]()
                
                for i in 0..<(data.count) {
                    if let dt = data[i] as? NSDictionary {
                        let assign = dt.string("assign")
                        let created_by = dt.string("created_by")
                        let created_on = dt.string("created_on")
                        let id = dt.string("id")
                        let image = dt.string("image")
                        let image_link = dt.string("image_link")
                        let name = dt.string("name")
                        let status = dt.string("status")
                        let type = dt.string("type")
                        let updated_by = dt.string("updated_by")
                        let updated_on = dt.string("updated_on")
                        
                        let obb = Services("")
                        
                        obb.id = id
                        obb.name = name
                        //let imageLink: ImageLink?
                        obb.image = name
                        obb.createdBy = created_by
                        obb.createdOn = created_on
                        obb.updatedBy = updated_by
                        obb.updatedOn = updated_on
                        //let status: Status1?
                        obb.assign = assign
                        
                        arr.append(obb)
                    }
                }
                
                let self_servicesJSON = ServicesJSON(success: "1", message: "", data: arr, selectedServices: nil)
                
                self.processJSON(self_servicesJSON, self.tblServices)
                
                self.servicesJSON?.selectedServices = json?.string("selected_services")
            }
            
            /*let s1 = (json?.toString1())!.replacingOccurrences(of: "<null>", with: "")
            
            let data = s1.data(using: String.Encoding.utf8)
            
            if data != nil {
                do {
                    self.servicesJSON = try JSONDecoder().decode(ServicesJSON.self, from: data!)
                } catch let error {
                    print("Error: \(error)")
                }
            }*/
            
            if self.servicesJSON != nil {
                if self.servicesJSON?.selectedServices != nil {
                    let arr = self.servicesJSON?.selectedServices?.components(separatedBy: ",")
                    
                    if arr != nil {
                        for i in 0..<(arr?.count)! {
                            for j in 0..<(self.servicesJSON?.data.count)! {
                                let ob = self.servicesJSON?.data[j]
                                
                                if (ob?.id)! == arr![i] {
                                    ob?.isSelected = true
                                    
                                    if (ob?.assign)!.subString("residential") {
                                        self.boolResidential = true
                                    }
                                    
                                    if (ob?.assign)!.subString("commercial") {
                                        self.boolcommercial = true
                                    }
                                    
                                    break
                                }
                            }
                        }
                    }
                }
            }
            
            self.tblServices.reloadData()
        }
    }
}

extension OtherServices: UITableViewDelegate, UITableViewDataSource, PrimaryBusinessCellDelegate {
    func cellClicked (_ indexPath: IndexPath) {
        let ob = servicesJSON?.data[indexPath.row]
        
        if ob?.id == "-99999" {
            moreClicked ()
        } else {
            if ob?.isSelected == nil {
                ob?.isSelected = false
            }
            
            ob?.isSelected = !(ob?.isSelected)!
        }
        
        tblServices.reloadRows(at: [indexPath], with: .automatic)
    }
    
    func moreClicked () {
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if servicesJSON != nil {
            return (servicesJSON?.data.count)!
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PrimaryBusinessCell") as! PrimaryBusinessCell
        cell.delegate = self
        cell.indexPath = indexPath
        
        let ob = servicesJSON?.data[indexPath.row]
        
        cell.lblCell.text = ob?.name?.capFirstLetter()
        
        if ob?.isSelected == nil {
            ob?.isSelected = false
        }
        
        if ob?.id == "-99999" {
            cell.imgCheckBox.isHidden = true
            cell.imgArrow.isHidden = false
        } else {
            cell.imgArrow.isHidden = true
            cell.imgCheckBox.isHidden = false
            
            if (ob?.isSelected)! {
                cell.imgCheckBox.image = #imageLiteral(resourceName: "Group 42191")
            } else {
                cell.imgCheckBox.image = #imageLiteral(resourceName: "Group 4219")
            }
        }
        
        pagingDecision (indexPath)
        
        return cell
    }
    
    func pagingDecision (_ indexPath: IndexPath) {
        let total_cell = totalCells ()
        
        //print("total_cell-\(indexPath.row)-\(total_cell)-\(downloading)-\(total_cell % rows)-")
        
        if (indexPath.row == (total_cell - 1)) && (tblServices.contentOffset.y > pointContentOffset.y) {
            if downloading == .canDownload {
                current_page = "\(Int(current_page)! + 1)"
                
                downloading = .downloading
                getMoreServices (current_page)
            }
        }
    }
    
    func totalCells () -> Int {
        if servicesJSON?.data == nil {
            return 0
        }
        
        return (servicesJSON?.data.count)!
    }
}
