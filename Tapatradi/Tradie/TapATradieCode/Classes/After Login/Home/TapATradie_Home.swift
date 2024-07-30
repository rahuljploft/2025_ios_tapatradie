//
//  Home.swift
//  TapATradie
//
//  Created by Apple on 22/04/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import Crashlytics

//MARK: Delegate CollectionView Cell
protocol TapATradie_TabbarCellDelegate {
    func tabbarClickedAt(_ indexPath: IndexPath)
}

//MARK: CollectionView Cell
class TapATradie_TabbarCell : UICollectionViewCell {
    @IBOutlet weak var imgCell: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblBorder: UILabel!
    
    var indexPath: IndexPath!
    var delegate: TapATradie_TabbarCellDelegate!
    
    @IBAction func actionCell(_ sender: Any) {
        delegate.tabbarClickedAt(indexPath)
    }
}


//MARK: Delegate CollectionView Cell (Home)
protocol TapATradie_HomeCellDelegate {
    func cellClicked (_ indexPath: IndexPath)
}

//MARK: CollectionView Cell (Home)
class TapATradie_HomeCell : UICollectionViewCell {
    @IBOutlet weak var viewBackground: UIView!
    @IBOutlet weak var imgCell: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblMoreServices: UILabel!
    @IBOutlet weak var lblShimmer: UILabel!
    
    var delegate: TapATradie_HomeCellDelegate!
    var indexPath: IndexPath!
    
    override func awakeFromNib() {
        //lblShimmer.border5(16)
        lblShimmer.border5(3)
    }
    
    @IBAction func actionClicked(_ sender: Any) {
        delegate.cellClicked(indexPath)
    }
}

//MARK: ViewController
class TapATradie_Home: UIViewController {
    
    @IBOutlet weak var cltnView: UICollectionView!
    
    var arrShimmer: [String] = []
    var servicesJSON: TapATradie_ServicesJSON?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        TapATradie_ArgAppUpdater.getSingleton().showUpdateWithConfirmation()
        TapATradie_kAppDelegate.TapATradie_subscribeToFirebase (true)
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_ :)))
        self.view.addGestureRecognizer(tap)
        tap.cancelsTouchesInView = false
        TapATradie_SocketIOManager.shared.login()
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        self.view.endEditing(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        TapATradie_kAppDelegate.TapATradie_currentVC = self
        getServices ()
    }
    
    func getServices () {
        arrShimmer = ["", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""]
        self.cltnView.reloadData()
        let param = TapATradie_params()
        param["search"] = ""
        param["fixed_service"] = "1"
        param["page"] = "all"
        
        Http.instance().json(TapATradie_api_get_services_list, param, "POST", aai: false, popup: true, prnt: true, nil, nil, sync: false, defaultCalling: false) { (json, paras, str, data) in
            let jsonExp = json as? NSDictionary
            if jsonExp != nil {
                if jsonExp?.number("success").intValue == SESSIONEXPIRED {
                    TapATradie_kAppDelegate.TapATradie_sessionExpired(self)
                    return
                }
            }
            
            if data != nil {
                do {
                    self.servicesJSON = try JSONDecoder().decode(TapATradie_ServicesJSON.self, from: data!)
                    if self.servicesJSON != nil {
                        let ob = TapATradie_Services("")
                        ob.name = "More"
                        ob.id = -99999
                        self.servicesJSON?.data.append(ob)
                    }
                    self.arrShimmer = []
                    self.cltnView.reloadData()
                } catch let error {
                    print("Error: \(error)")
                }
            }
        }
    }
    
    
}


extension TapATradie_Home: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, TapATradie_HomeCellDelegate {
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "\(TrendingTradieListHeader.self)", for: indexPath)
            //let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "", for: indexPath)
            return header
        default:
            fatalError("Invalid element type")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if arrShimmer.count > 0 {
            return arrShimmer.count
        }
        if servicesJSON != nil {
            return (servicesJSON?.data.count)!
        }
        return 0
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCell", for: indexPath) as! TapATradie_HomeCell
        
        if arrShimmer.count > 0 {
            cell.lblShimmer.superview?.isHidden = false
            cell.lblShimmer.isHidden = false
            cell.lblShimmer.startShimmeringEffect()
            return cell
        } else {
            cell.lblShimmer.superview?.isHidden = true
            cell.lblShimmer.isHidden = true
            cell.lblShimmer.stopShimmeringEffect ()
        }
        cell.delegate = self
        cell.indexPath = indexPath
        cell.viewBackground.border(UIColor.TapATradie_hexColor(0xEC9422), 0, 1)
        let ob = servicesJSON?.data[indexPath.row]
        cell.lblTitle.text = ob?.name?.capFirstLetter()
        if (ob?.name)! != "More" {
            let url = "\(TapATradie_Server)\((ob?.imageLink)!)/\((ob?.image)!)"
            cell.imgCell.downloadUIImage(url) { (image, bool) in
                DispatchQueue.main.async {
                    if image != nil {
                        cell.imgCell.image = image
                    } else {
                        cell.imgCell.image = UIImage(named: "Group 4302")
                    }
                }
            }
        } else {
            cell.imgCell.image = #imageLiteral(resourceName: "Group 4652")
        }
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = (self.view.frame.size.width - 20) / 4
        //if size < 124 {
        //return CGSize(width: size, height: 124)
        //} else {
        return CGSize(width: size, height: size)
        //}
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func cellClicked(_ indexPath: IndexPath) {
        let ob = servicesJSON?.data[indexPath.row]
        if ob?.id != -99999 {
            redirectToTradieMap(ob: ob)
            //            let vc = story_Home.viewController("RequestTradie") as! RequestTradie
            //            vc.services = ob
            //            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            let vc = TapATradie_story_Home.TapATradie_viewController("UserServices") as! TapATradie_UserServices
            vc.fixed_service = "0"
            vc.services = ob
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
    func redirectToTradieMap(ob: TapATradie_Services?){
        let vc = TapATradie_story_Tradie.TapATradie_viewController("TradiesMap") as! TapATradie_TradiesMap
        vc.search_type = "services"
        vc.tradies = nil
        //        vc.tradiesJSON = self.tradiesJSON
        vc.services = ob
        //        vc.search = search
        //        vc.tradie_type = tradie_type
        vc.paramSendToAll = nil//params()
        vc.boolGoToRequestFarm = true//true//boolGoToRequestFarm
        vc.boolGoToServiceSelection = false//boolGoToServiceSelection
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    
}

struct TapATradie_ServicesJSON: Codable {
    let success: Int
    let message: String
    var data: [TapATradie_Services]
    let selectedServices: TapATradie_JSONNull?
    
    enum CodingKeys: String, CodingKey {
        case success, message, data
        case selectedServices = "selected_services"
    }
}

class TapATradie_Services: Codable {
    var id: Int?
    var name: String?
    let imageLink: TapATradie_ImageLink?
    let image: String?
    let createdBy: Int?
    let createdOn: String?
    let updatedBy: Int?
    let updatedOn: String?
    let status: TapATradie_Status1?
    let assign: TapATradie_JSONNull?
    
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

enum TapATradie_ImageLink: String, Codable {
    case services = "/services"
}

enum TapATradie_Status1: String, Codable {
    case active = "active"
}

// MARK: Encode/decode helpers

class TapATradie_JSONNull: Codable, Hashable {
    
    public static func == (lhs: TapATradie_JSONNull, rhs: TapATradie_JSONNull) -> Bool {
        return true
    }
    
    public var hashValue: Int {
        return 0
    }
    
    public init() {}
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(TapATradie_JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}
