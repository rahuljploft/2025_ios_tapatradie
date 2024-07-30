//
//  PrimaryBusiness.swift
//  Tradie
//
//  Created by Apple on 07/05/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

protocol PrimaryBusinessCellDelegate {
    func cellClicked (_ indexPath: IndexPath)
    func moreClicked ()
}

class PrimaryBusinessCell: UITableViewCell {
    override func awakeFromNib() {
        
    }
    
    @IBAction func actionMore(_ sender: Any) {
        delegate.moreClicked()
    }
    
    @IBAction func actionCellClicked(_ sender: Any) {
        delegate.cellClicked(indexPath)
    }
    
    var delegate: PrimaryBusinessCellDelegate!
    var indexPath: IndexPath!
    
    @IBOutlet weak var lblCell: UILabel!
    @IBOutlet weak var imgCheckBox: UIImageView!
    @IBOutlet weak var imgArrow: UIImageView!
}

class PrimaryBusiness: BaseVC {
    
    
    var isFromRegister = false
    
    @IBOutlet weak var headerView: HeaderView!
    
    @IBAction func actionSearchService(_ sender: Any) {
        self.view.endEditing(true)
    }
    
    @IBAction func actionSearch(_ sender: UITextField) {
        maServices = NSMutableArray()
        
        if servicesJSON != nil {
            for i in 0..<(servicesJSON?.data.count)! {
                let ob = servicesJSON?.data[i]
                
                if (sender.text?.count)! > 0 {
                    if (ob?.name?.lowercased().subString(sender.text!.lowercased()))! {
                        maServices.add(ob!)
                    }
                } else {
                    maServices.add(ob!)
                }
            }
        }
        
        if servicesMoreJSON != nil {
            for i in 0..<(servicesMoreJSON?.data.count)! {
                let ob = servicesMoreJSON?.data[i]
                
                if (sender.text?.count)! > 0 {
                    if (ob?.name?.lowercased().subString(sender.text!.lowercased()))! {
                        let ob = servicesJSON?.data[(servicesJSON?.data.count)!-1]
                        maServices.add(ob!)
                        
                        break
                    }
                }
            }
        }
        
        /*if maServices.count == 0 {
            let ob = servicesJSON?.data[(servicesJSON?.data.count)!-1]
            maServices.add(ob!)
        }*/
        
        tblServices.reloadData()
    }
    
    @IBAction func actionBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBOutlet weak var tfSearch: UITextField!
    
    @IBOutlet weak var tblServices: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        kAppDelegate.currentVC = self
        headerView.updateData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let user = UserDefaults.standard
        
        let value = user.object(forKey: getPrimaryServiceKey ())
        
        if value == nil {
            user.set("", forKey: getPrimaryServiceKey ())
            user.synchronize()
        }
                
        tfSearch.superview?.border5(4)
        tfSearch.superview?.shadow(4, -1)
        tfSearch.placeHolderColor(UIColor.hexColor(0xA4A4A4), "Search for a service")
        
        tfvNewService.placeHolder = "Additional Services"
        tfvNewService.messageText = "Optional"
        
        getServices()
        getMoreServices()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_ :)))
        self.view.addGestureRecognizer(tap)
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        self.view.endEditing(true)
    }

    var servicesJSON: ServicesJSON?
    var servicesMoreJSON: ServicesJSON?
    
    @IBOutlet weak var tfvNewService: MaterialTextFieldView!
    
    var services = ""
    
    
    @IBAction func actionLogout(_ sender: UIButton) {
        let dialogMessage = UIAlertController(title: "Confirm", message: "Are you sure you want to logout!" , preferredStyle: .alert)
        
        let ok = UIAlertAction(title: "Logout", style: .default, handler: { (action) -> Void in
            self.dismiss(animated: true) {
                kAppDelegate.logout (self)
            }
        })
        let cancel = UIAlertAction(title: "Cancel", style: .default) { (action) -> Void in
            
        }
        dialogMessage.addAction(cancel)
        dialogMessage.addAction(ok)
        self.present(dialogMessage, animated: true, completion: nil)
        
    }
    
    @IBAction func actionSubmit(_ sender: Any) {
        services = ""
        
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
        
        if services.count > 0 {
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
    
    var maServices = NSMutableArray()
    
    var boolResidential = false
    var boolcommercial = false
}

extension PrimaryBusiness: UITextFieldDelegate {
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

extension PrimaryBusiness {
    func getMoreServices () {
        let param = params()
        
        param["search"] = ""
        param["fixed_service"] = "0"
        param["page"] = "all"
        print(param)
        Http.instance().json(api_get_services_list, param, "POST", aai: false, popup: true, prnt: true, nil, nil, sync: false, defaultCalling: false) { (json, paras, str, data) in
            let jsonExp = json as? NSDictionary
            
            if jsonExp != nil {
                if jsonExp?.number("success").intValue == SESSIONEXPIRED {
                   kAppDelegate.sessionExpired(self)
                    
                    return
                }
            }
            //MARK: Check two
            var json = json as? NSDictionary
            json = json?.getMutable(nil)
            
            if json == nil {
                Http.stopActivityIndicator()
                
                return
            }
            
            var s1 = (json?.toString1())!.replacingOccurrences(of: "<null>", with: "")
            
            //MARK: Himanshu update Resolve Issues.
            s1 = s1.replacingOccurrences(of: "\n", with: "")
            
            let data = s1.data(using: String.Encoding.utf8)
            
            if data != nil {
                do {
                    self.servicesMoreJSON = try JSONDecoder().decode(ServicesJSON.self, from: data!)
                } catch let error {
                    print("Error: \(error)")
                }
            }
        }
    }
}

extension PrimaryBusiness {
    func getServices () {
        let param = params()
        
        param["search"] = ""
        param["fixed_service"] = "1"
        param["page"] = "all"
        print(param)
        Http.instance().json(api_get_services_list, param, "POST", aai: false, popup: true, prnt: true, nil, nil, sync: false, defaultCalling: false) { (json, paras, str, data) in
            let jsonExp = json as? NSDictionary
            
            if jsonExp != nil {
                if jsonExp?.number("success").intValue == SESSIONEXPIRED {
                   kAppDelegate.sessionExpired(self)
                    
                    return
                }
            }
            //MARK: Check one
            var json = json as? NSDictionary
            json = json?.getMutable(nil)
            
            if json == nil {
                Http.stopActivityIndicator()
                
                return
            }
            
            var s1 = (json?.toString1())!.replacingOccurrences(of: "<null>", with: "")
            
            //MARK: Himanshu update Resolve Issues.
            s1 = s1.replacingOccurrences(of: "\n", with: "")
            
            let data = s1.data(using: String.Encoding.utf8)
            
            if data != nil {
                do {
                    self.servicesJSON = try JSONDecoder().decode(ServicesJSON.self, from: data!)
                    
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
                        
                        let ob = Services("")
                        ob.name = "More"
                        ob.id = "-99999"
                        self.servicesJSON?.data.append(ob)
                        
                        self.maServices = NSMutableArray()
                        
                        for i in 0..<(self.servicesJSON?.data.count)! {
                            let ob = self.servicesJSON?.data[i]
                            self.maServices.add(ob)
                        }
                    }
                    
                    self.tblServices.reloadData()
                } catch let error {
                    print("Error: \(error)")
                }
            }
        }
    }
}

extension PrimaryBusiness: UITableViewDelegate, UITableViewDataSource, PrimaryBusinessCellDelegate, AlertDelegate {
    func alertZero() {
        let vc = story_Payment.viewController("ChooseSubscripiton") as? ChooseSubscripiton
        vc?.boolFromMenu = false
        self.navigationController?.pushViewController(vc!, animated: false)
    }
    
    func alertOne() {
        
    }

    func cellClicked (_ indexPath: IndexPath) {
        //let ob = servicesJSON?.data[indexPath.row]
        let ob = maServices[indexPath.row] as? Services
        
        if ob?.id == "-99999" {
            moreClicked ()
        } else {
            if ob?.isSelected == nil {
                ob?.isSelected = false
            }
            
            ob?.isSelected = !(ob?.isSelected)!
            
            tblServices.reloadRows(at: [indexPath], with: .automatic)
        }
    }
    
    func moreClicked () {
        services = ""
        
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
        
        let vc = story_Profile.viewController("OtherServices") as! OtherServices
        vc.isFromRegister = self.isFromRegister
        vc.services = services
        vc.boolcommercial = boolcommercial
        vc.boolResidential = boolResidential
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        /*if servicesJSON != nil {
            return (servicesJSON?.data.count)!
        }*/
        
        return maServices.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PrimaryBusinessCell") as! PrimaryBusinessCell
        cell.delegate = self
        cell.indexPath = indexPath
        
        //let ob = servicesJSON?.data[indexPath.row]
        
        let ob = maServices[indexPath.row] as? Services
        
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
                cell.imgCheckBox.image = UIImage(named: "check 2")
            } else {
                cell.imgCheckBox.image = #imageLiteral(resourceName: "Check Box Off")
            }
        }
        
        return cell
    }
}

struct ServicesJSON: Codable {
    let success: String
    let message: String
    var data: [Services]
    var selectedServices: String?
    
    enum CodingKeys: String, CodingKey {
        case success, message, data
        case selectedServices = "selected_services"
    }
}

class Services: Codable {
    var id: String?
    var name: String?
    var imageLink: ImageLink?
    var image: String?
    var createdBy: String?
    var createdOn: String?
    var updatedBy: String?
    var updatedOn: String?
    var status: Status1?
    var assign: String?
    var isSelected = false
    
    public init(_ str: String) {
        id = nil
        name = nil
        imageLink = nil
        image = nil
        createdBy = nil
        createdOn = nil
        updatedBy = nil
        updatedOn = nil
        status = nil
        assign = nil
    }
    
    enum CodingKeys: String, CodingKey {
        case id, name
        case imageLink = "image_link"
        case image
        case createdBy = "created_by"
        case createdOn = "created_on"
        case updatedBy = "updated_by"
        case updatedOn = "updated_on"
        case status, assign
    }
}

enum ImageLink: String, Codable {
    case services = "/services"
}

enum Status1: String, Codable {
    case active = "active"
}

// MARK: Encode/decode helpers

class JSONNull: Codable, Hashable {
    
    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
        return true
    }
    
    public var hashValue: Int {
        return 0
    }

    public init() {}
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}
