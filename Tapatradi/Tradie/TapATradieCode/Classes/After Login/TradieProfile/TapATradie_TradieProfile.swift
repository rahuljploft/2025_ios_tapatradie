//
//  TradieProfile.swift
//  TapATradie
//
//  Created by Apple on 26/04/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import ImageScrollView

protocol TapATradie_TradieProfileCell1Delegate {
    func requestJob ()
}

class TapATradie_TradieProfileCell1: UITableViewCell {
    
}

class TapATradie_TradieProfileCell2: UITableViewCell {
    
    
    override func awakeFromNib() {
        
    }
}

class TapATradie_TradieProfileCell3: UITableViewCell {

    
    override func awakeFromNib() {
        
    }
}

class TapATradie_TradieProfileCell4: UITableViewCell {
    
    
}

class TapATradie_TradieProfileCell5: UITableViewCell {
    @IBOutlet weak var imgCell: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblCity: UILabel!
//    @IBOutlet weak var lblRating: UILabel!
    @IBOutlet weak var lblOther: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    
    override func awakeFromNib() {
        imgCell.border(UIColor.white, imgCell.frame.size.height/2, 1)
    }
}

protocol TapATradie_TradieProfileCell6Delegate {
    func viewMore ()
}

class TapATradie_TradieProfileCell6: UITableViewCell {
    @IBAction func actionViewMore(_ sender: Any) {
        delegate?.viewMore()
    }
    
    @IBOutlet weak var btnViewMore: UIButton!
    @IBOutlet weak var lblViewMore: UILabel!
    
    var delegate:TapATradie_TradieProfileCell6Delegate?
    
    override func awakeFromNib() {
        
    }
}

class TapATradie_TradieProfile: UIViewController, TapATradie_TradieProfileCell1Delegate {
    
    @IBOutlet weak var lblTradieTypeSingle: UILabel!
    @IBOutlet weak var viewMultipleTradieType: UIView!
    
    @IBOutlet weak var btnRequestJob: UIButton!
    
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var imgVarified: UIImageView!
    @IBOutlet weak var lblNAme: UILabel!
    @IBOutlet weak var lblMessage: UILabel!
    
    @IBOutlet weak var viewRating2: TapATradie_FloatRatingView!
    
    @IBOutlet weak var lblGoogleRatings: UILabel!
    @IBOutlet weak var lblFBRatings: UILabel!
    
    @IBOutlet weak var stackGoogleRatings: UIStackView!
    @IBOutlet weak var stackFaceBookRatings: UIStackView!
    
    @IBOutlet weak var View_Location: UIView!
    @IBOutlet weak var View_Phone: UIStackView!
    @IBOutlet weak var View_Contact: UIStackView!
    var hideDetailStatus = true
    
    var delegate: TapATradie_TradieProfileCell1Delegate?
    
    @IBAction func actionRequestJob(_ sender: Any) {
        requestJob()
    }
    
    @IBOutlet weak var lblResidential: UILabel!
    @IBOutlet weak var lblCommercial: UILabel!
    
    @IBOutlet weak var imgLocation: UIImageView!
    @IBOutlet weak var imgPhoneNumber: UIImageView!
    @IBOutlet weak var imgContact: UIImageView!
    
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var lblPhoneNumber: UILabel!
    @IBOutlet weak var lblContact: UILabel!
    
    @IBOutlet weak var cltnServices: UICollectionView!
    @IBOutlet weak var cltnHeight: NSLayoutConstraint!
    
    @IBOutlet weak var cltnGallery: UICollectionView!
    @IBOutlet weak var cnstnHeight: NSLayoutConstraint!
    
    func configureDetails() {
        if let ob = tradiesProfileJSON?.businessData {
            if ob.houseNo != nil ||
                ob.street != nil ||
                ob.city != nil ||
                ob.state != nil ||
                ob.country != nil ||
                ob.pincode != nil {
                
                
                if (ob.houseNo)!.count > 0 ||
                    (ob.street)!.count > 0 ||
                    (ob.city)!.count > 0 ||
                    (ob.state)!.count > 0 ||
                    (ob.country)!.count > 0 ||
                    (ob.pincode)!.count > 0 {
                    imgLocation.isHidden = false
                    lblLocation.isHidden = false
                }
            }
            
            var str = "".TapATradie_concat(ob.houseNo, " ")
            str = str.TapATradie_concat(ob.street, " ")
            str = str.TapATradie_concat(ob.city, " ")
            str = str.TapATradie_concat(ob.state, " ")
            str = str.TapATradie_concat(ob.country, " ")
            str = str.TapATradie_concat(ob.pincode, " ")
            print(str)
            lblLocation.text = str
            //lblLocation.text = "45 dfcx Youcftg Hy Gh Andorra 65555 45 dfcx Youcftg Hy Gh Andorra 65555 45 dfcx Youcftg Hy Gh Andorra 65555 45 dfcx Youcftg Hy Gh Andorra 65555 45 dfcx Youcftg Hy Gh Andorra 65555 45 dfcx Youcftg Hy Gh Andorra 65555 "
        }
        
        let ob1 = tradiesProfileJSON?.userData
        lblPhoneNumber.text = "\(ob1?.country_code ?? "") \(ob1?.phoneNumber ?? "")"
        
        //MARK: updated By Himanshu
        let phonenumber = ob1?.phoneNumber ?? ""
        if phonenumber.count == 0 {
            lblPhoneNumber.text = "\(ob1?.country_code ?? "") \(ob1?.mobile ?? "")"
        }
        
        let phonenumber2 = lblPhoneNumber.text ?? ""
        if phonenumber2.count > 0 {
            imgPhoneNumber.isHidden = false
            lblPhoneNumber.isHidden = false
        }
        print(ob1?.email)
        lblContact.text = ob1?.email
        
        let contact = lblContact.text ?? ""
        if contact.count > 0 {
            imgContact.isHidden = false
            lblContact.isHidden = false
        }
        
        btnRequestJob.isHidden = false
        
        let ob = tradiesProfileJSON?.userData
        
        
        let id = ob?.id ?? ""
        let profilePic = ob?.profilePic ?? ""
        let url = "\(TapATradie_Server)profile/\(id)/\(profilePic)"
        imgProfile.uiimage(url, "Group 2826", true, nil)
        
        let verified = Int(ob?.verified ?? "0") ?? 0
        if verified == 0 {
            imgVarified.isHidden = true
        } else {
            imgVarified.isHidden = false
        }
        
        lblTradieTypeSingle.isHidden = true
        viewMultipleTradieType.isHidden = true
        let servicesCount = tradiesProfileJSON?.services.count ?? 0
        for i in 0..<servicesCount {
            let ob = tradiesProfileJSON?.services[i]
            
            let arr = ob?.serviceType.components(separatedBy: ",")
            
            if arr != nil {
                let arrCount = arr?.count ?? 0
                if arrCount > 1 {
                    viewMultipleTradieType.isHidden = false
                } else if arrCount == 1 {
                    lblTradieTypeSingle.text = "\(arr![0])".capFirstLetter()
                    lblTradieTypeSingle.isHidden = false
                }
            }
            
            break
        }
        
        lblNAme.text = ob?.fullName.uppercased()
        
        if let rate = ob?.rating, rate != "" {
            viewRating2.rating = Double(rate) ?? 0.0
        }
        lblMessage.isHidden = false
        lblMessage.text = ob?.aboutMe ?? ""
    }
    
    func configureServices() {
        var count = 0
        count = ((tradiesProfileJSON?.services.count ?? 0) / 3)
        if ((tradiesProfileJSON?.services.count ?? 0) % 3) != 0 { count += 1 }

        cltnHeight.constant = CGFloat(42 * count) + 10

        cltnServices.reloadData()
    }
    
    func configureGallery() {
        if tradiesProfileJSON != nil {
            var count = 0
            count = ((tradiesProfileJSON?.gallery.count ?? 0) / 3)
            if ((tradiesProfileJSON?.gallery.count ?? 0) % 3) != 0 { count += 1 }

            let size = (cltnGallery.frame.size.width - 30) / 3
            if(count > 0) { cnstnHeight.constant = size * CGFloat(count) + 10 }
        }
        cltnGallery.isHidden = false
        cltnGallery.reloadData()
    }
    
    var boolShowMore = false
    
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
        
        TapATradie_kAppDelegate.TapATradie_tabbarClicked(IndexPath(row: 1, section: 0), self.navigationController)
    }
    
    var boolGoToServiceSelection = false
    var tradiesJSON: TapATradie_TradiesJSON?
    var tradie_type: String?
    var search = ""
    var services: TapATradie_Services?
    var paramSendToAll: NSMutableDictionary?
    var boolGoToRequestFarm = false
    
    func requestJob () {
        if boolGoToRequestFarm == true {
            if tradies?.serviceId != nil {
                if tradies!.serviceId.count > 0 {
                    let arr = tradies!.serviceId.components(separatedBy: ",")
                    
                    if arr.count > 0 {
                        let int = Int(arr[0])
                        
                        if int != nil {
                            services = TapATradie_Services("")
                            services?.id = int!
                            
                            boolGoToServiceSelection = false
                            
                            let vc = TapATradie_story_Home.TapATradie_viewController("RequestTradie") as! TapATradie_RequestTradie
                            vc.services = services
                            vc.tradies = tradies
                            vc.search = search
                            vc.services = services
                            
                            vc.forServiceCalled = self.forServiceCalled ()
                            
                            self.navigationController?.pushViewController(vc, animated: true)
                            
                            return
                        }
                    }
                }
            }
        }
        
        if boolGoToServiceSelection {
            let vc = TapATradie_story_Home.TapATradie_viewController("UserServices") as! TapATradie_UserServices
            vc.search = search
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            if paramSendToAll == nil {
                paramSendToAll = TapATradie_params()
            }
            
            if tradies?.id != nil && paramSendToAll != nil {
                paramSendToAll!["tradie_id"] = tradies?.id
                sendRequest ()
            }
        }
    }
    
    
    
    @IBAction func Action_HideShowDetail(_ sender: Any) {
        if hideDetailStatus == true {
            print("Show")
            hideDetailStatus = false
            if lblLocation.text == "" {
                View_Location.isHidden = true
            }else{
                View_Location.isHidden = false
            }
            if lblPhoneNumber.text == "" {
                View_Phone.isHidden = true
            }else{
                View_Phone.isHidden = false
            }
            if lblContact.text == "" {
                View_Contact.isHidden = true
            }else{
                View_Contact.isHidden = false
            }
        }else{
            print("Hide")
            hideDetailStatus = true
            View_Location.isHidden = true
            View_Phone.isHidden = true
            View_Contact.isHidden = true
        }
        
        
    }
    
    
    func forServiceCalled () -> String? {
        for i in 0..<(tradiesProfileJSON?.services.count ?? 0) {
            let ob = tradiesProfileJSON?.services[i]
            
            let arr = ob?.serviceType.components(separatedBy: ",")
            
            if arr != nil {
                if (arr?.count)! > 1 {
                    //cell.viewMultipleTradieType.isHidden = false
                    print("Harish Both")
                    
                    return "both"
                } else if (arr?.count)! == 1 {
                    //cell.lblTradieTypeSingle.text = "\(arr![0])".capFirstLetter()
                    //cell.lblTradieTypeSingle.isHidden = false
                    
                    //Residential
                    
                    print("Harish 1-[\("\(arr![0])".capFirstLetter())]-")
                    
                    return "\(arr![0])".capFirstLetter()
                }
            }
            
            break
        }
        
        return nil
    }
    
    func sendRequest () {
        paramSendToAll?.TapATradie_addStaticLocation()
        
        if TapATradie_kAppDelegate.TapATradie_obAddresses != nil {
            if TapATradie_kAppDelegate.TapATradie_obAddresses?.latitude != nil && TapATradie_kAppDelegate.TapATradie_obAddresses?.longitude != nil {
                paramSendToAll!["latitude"] = (TapATradie_kAppDelegate.TapATradie_obAddresses?.latitude ?? "")
                paramSendToAll!["longitude"] = (TapATradie_kAppDelegate.TapATradie_obAddresses?.longitude ?? "")
                
                paramSendToAll!["city"] = (TapATradie_kAppDelegate.TapATradie_obAddresses?.city ?? "")
                paramSendToAll!["state"] = (TapATradie_kAppDelegate.TapATradie_obAddresses?.state ?? "")
                paramSendToAll!["country"] = (TapATradie_kAppDelegate.TapATradie_obAddresses?.country ?? "")
            }
        }
        
        paramSendToAll?.TapATradie_addSearchType()
        
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
                let json = json as? NSDictionary
                
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
    
    @IBOutlet weak var tblTradieProfile: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imgProfile.shadow(imgProfile.frame.size.height/2, -1)
        imgProfile.border(UIColor.white, imgProfile.frame.size.height/2, 2)
        
        imgVarified.isHidden = true
        
        lblNAme.text = ""
        
        lblLocation.isHidden = true
        lblContact.isHidden = true
        lblPhoneNumber.isHidden = true
        
        lblLocation.text = ""
        lblPhoneNumber.text = ""
        lblContact.text = ""
        
        cltnServices.delegate = self
        cltnServices.dataSource = self
        
        lblMessage.isHidden = true
        
        cltnGallery.delegate = self
        cltnGallery.dataSource = self
        cltnGallery.isHidden = true
//        cnstnHeight.constant = 0
        
        hideDetailStatus = true
        View_Location.isHidden = true
        View_Phone.isHidden = true
        View_Contact.isHidden = true
    }

    override func viewWillAppear(_ animated: Bool) {
        TapATradie_kAppDelegate.TapATradie_currentVC = self
        
        getTradieProfile ()
        
        hideDetailStatus = true
        View_Location.isHidden = true
        View_Phone.isHidden = true
        View_Contact.isHidden = true
    }
    
    var tradiesProfileJSON: TapATradie_TradiesProfileJSON?
    
    func getTradieProfile () {
        let param = TapATradie_params()
        
        param["provider_id"] = tradies?.id
      
        Http.instance().json(TapATradie_api_get_provider_profile, param, "POST", aai: true, popup: true, prnt: true, nil, nil, sync: false, defaultCalling: false) { (json, paras, str, data) in
            let jsonExp = json as? NSDictionary
            print(jsonExp)
            if jsonExp != nil {
                if jsonExp?.number("success").intValue == SESSIONEXPIRED {
                   TapATradie_kAppDelegate.TapATradie_sessionExpired(self)
                    return
                }
            }
            
            var json = json as? NSDictionary
            json = json?.getMutable(nil)
            
            if json == nil {
                Http.stopActivityIndicator()
                return
            }
            
            var s1 = (json?.toString1())!.replacingOccurrences(of: "<null>", with: "")
            
            //MARK: Himanshu update Resolve Issues.
            s1 = s1.replacingOccurrences(of: "\n", with: "")
            print(s1)
            let data = s1.data(using: String.Encoding.utf8)
            print(data)
            if data != nil {
                do {
                    self.tradiesProfileJSON = try? JSONDecoder().decode(TapATradie_TradiesProfileJSON.self, from: data!)
                    print("tradiesProfileJSON", self.tradiesProfileJSON)
                    if self.tradiesProfileJSON?.userData?.google == "1"{
                        self.stackGoogleRatings.isHidden = false
                        self.lblGoogleRatings.text = self.tradiesProfileJSON?.userData?.googleRating
                    }else{
                        self.stackGoogleRatings.isHidden = true
                    }
                } catch let error {
                    print("2Error: \(error)")
                }
            }
            
            /*if data != nil {
                do {
                    self.tradiesProfileJSON = try JSONDecoder().decode(TradiesProfileJSON.self, from: data!)
                } catch let error {
                    print("Error: \(error)")
                }
            }*/
            
            self.getTradieReviews ()
        }
    }
    
    var tradies: TapATradie_Tradies?
    //var tradieId = "58"
    
    var tradiesReviewJSON: TapATradie_TradiesReviewJSON?
    
    func getTradieReviews () {
        let param = TapATradie_params()
        
        param["uid"] = tradies?.id
        
        Http.instance().json(TapATradie_api_provider_get_review_list, param, "POST", aai: true, popup: true, prnt: true, nil, nil, sync: false, defaultCalling: false) { (json, paras, str, data) in
            let jsonExp = json as? NSDictionary
            
            if jsonExp != nil {
                if jsonExp?.number("success").intValue == SESSIONEXPIRED {
                   TapATradie_kAppDelegate.TapATradie_sessionExpired(self)
                    return
                }
            }
            
            if data != nil {
                do {
                    self.tradiesReviewJSON = try JSONDecoder().decode(TapATradie_TradiesReviewJSON.self, from: data!)
                    
                    self.tblTradieProfile.reloadData()
                    self.configureDetails()
                    self.configureServices()
                    self.configureGallery()
                } catch let error {
                    print("Error: \(error)")
                }
            }
        }
    }
    
    var defaultCells = 2
    
    //MARK: - Image Zoom

    @IBOutlet var viewImageZoom: UIView!

    @IBAction func actionRemoveImageZoom(_ sender: Any) {
        viewImageZoom.removeFromSuperview()
    }
    
    @IBAction func actionZoomImage(_ sender: Any) {
        
        let ob = tradiesProfileJSON?.userData
        
        let url = "\(TapATradie_Server)profile/\((ob?.id ?? ""))/\((ob?.profilePic ?? ""))"
        
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

extension TapATradie_TradieProfile: ImageScrollViewDelegate {
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

struct TapATradie_TradiesReviewJSON: Codable {
    let success: Int
    let data: [TapATradie_TradiesReview]
}

struct TapATradie_TradiesReview: Codable {
    let id, providerID, jobPostID, rating: Int
    let review, latitude, longitude: String
    let createdBy: Int
    let createdOn: String
    let updatedBy: Int
    let updatedOn, status, fullName, profilePic: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case providerID = "provider_id"
        case jobPostID = "job_post_id"
        case rating, review, latitude, longitude
        case createdBy = "created_by"
        case createdOn = "created_on"
        case updatedBy = "updated_by"
        case updatedOn = "updated_on"
        case status
        case fullName = "full_name"
        case profilePic = "profile_pic"
    }
}

extension TapATradie_TradieProfile: UITableViewDelegate, UITableViewDataSource, TapATradie_TradieProfileCell6Delegate {
    
    
    
    func viewMore () {
        boolShowMore = !boolShowMore
        
        tblTradieProfile.reloadData()
        
        print("View More")
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        if tradiesProfileJSON != nil {
//            if indexPath.row == 1 {
//                if tradiesProfileJSON?.services.count == 0 {
//                    return 0
//                } else {
//                    return tableView.estimatedRowHeight
//                }
//            } else if indexPath.row == 2 {
//
//
//                var count = 0
//
//                if let ob = tradiesProfileJSON?.businessData {
//
//                    if ob.houseNo != nil ||
//                    ob.street != nil ||
//                    ob.city != nil ||
//                    ob.state != nil ||
//                    ob.country != nil ||
//                    ob.pincode != nil {
//                        if (ob.houseNo)!.count > 0 ||
//                    (ob.street)!.count > 0 ||
//                    (ob.city)!.count > 0 ||
//                    (ob.state)!.count > 0 ||
//                    (ob.country)!.count > 0 ||
//                    (ob.pincode)!.count > 0 {
//                    count += 1
//                }
//                    }
//                }
//
//                let ob1 = tradiesProfileJSON?.userData
//
//                if (ob1?.phoneNumber)!.count > 0 {
//                    count += 1
//                }
//
//                if (ob1?.mobile)!.count > 0 {
//                    count += 1
//                }
//
//                if (ob1?.email)!.count > 0 {
//                    count += 1
//                }
//
//                print("Harish count-\(count)-")
//
//                if count == 0 {
//                    return 0
//                }
//
//                return tableView.estimatedRowHeight
//                //return 123
//            } else if indexPath.row >= defaultCells {
//                print("1 indexPath.row-\(indexPath.row)-")
//                return tableView.estimatedRowHeight
//            } else {
//                print("2 indexPath.row-\(indexPath.row)-")
//                return tableView.estimatedRowHeight
//            }
//        }
//
//        return 0
//    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return totalCells ()
        
        /*var total = 0
        
        if tradiesProfileJSON != nil {
            
            if self.tradiesReviewJSON != nil {
                total = defaultCells + (self.tradiesReviewJSON?.data.count)!
                
                if (self.tradiesReviewJSON?.data.count)! > 0 {
                    total += 1
                }
            } else {
                total = defaultCells
            }
            
            if (tradiesProfileJSON?.gallery.count)! > 0 {
                total += 1
            }
            
            if (tradiesProfileJSON?.services.count)! > 0 {
                total += 1
            }
        }
        
        print("total-\(total)-")
        
        return total*/
    }
    
    func totalCells () -> Int {
        var total = 0
        
        if tradiesProfileJSON != nil {
            
            if self.tradiesReviewJSON != nil {
                //total = defaultCells + (self.tradiesReviewJSON?.data.count)!
                
                if (self.tradiesReviewJSON?.data.count ?? 0) > 4 {
                    if boolShowMore {
                        total = defaultCells + (self.tradiesReviewJSON?.data.count ?? 0)
                    } else {
                        total = defaultCells + 4
                    }
                } else {
                    total = defaultCells + (self.tradiesReviewJSON?.data.count ?? 0)
                }
                
                if (self.tradiesReviewJSON?.data.count ?? 0) > 0 {
                    total += 1
                }
            } else {
                total = defaultCells
            }
            
            if (tradiesProfileJSON?.gallery.count ?? 0) > 0 {
                total += 1
            }
            
            if (tradiesProfileJSON?.services.count ?? 0) > 0 {
                total += 1
            }
        }
        
        /*if boolShowMore {
            total -= 1
        }*/
        
        return total
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //print("indexPath-\(indexPath.row)-")
        
        if tradiesProfileJSON != nil {
            let total = totalCells ()
            
            var bool = false
            
            if self.tradiesReviewJSON != nil {
                if (self.tradiesReviewJSON?.data.count ?? 0) > 0 {
                    bool = true
                }
            }
            
            if ((total - 1) == indexPath.row) && bool {//}&& (boolShowMore == false) {
                //print("Harish index 1")
                let cell = tableView.dequeueReusableCell(withIdentifier: "TradieProfileCell6") as! TapATradie_TradieProfileCell6
                cell.delegate = self
                
                if boolShowMore {
                    cell.lblViewMore.text = "View less"
                    //cell.lblViewMore.isHidden = true
                    //cell.btnViewMore.isHidden = true
                } else {
                    cell.lblViewMore.text = "View more"
                    //cell.lblViewMore.isHidden = false
                    //cell.btnViewMore.isHidden = false
                }
                
                print("==========================================")
                return cell
            } else if indexPath.row == 0 {
                //print("Harish index 2")
                let cell = tableView.dequeueReusableCell(withIdentifier: "TradieProfileCell1") as! TapATradie_TradieProfileCell1
                return cell
            } else if indexPath.row == 1 {
                //print("Harish index 3")
                let cell = tableView.dequeueReusableCell(withIdentifier: "TradieProfileCell2") as! TapATradie_TradieProfileCell2
                return cell
            } else if indexPath.row == 2 {
                //print("Harish index 4")
                let cell = tableView.dequeueReusableCell(withIdentifier: "TradieProfileCell3") as! TapATradie_TradieProfileCell3
                
                
                
                //print("==========================================")
                return cell
            } else if (tradiesProfileJSON?.gallery.count ?? 0) > 0 && indexPath.row == 3 {
                //print("Harish index 5")
                let cell = tableView.dequeueReusableCell(withIdentifier: "TradieProfileCell4") as! TapATradie_TradieProfileCell4
                
                return cell
            } else if ((tradiesProfileJSON?.gallery.count ?? 0) == 0 && indexPath.row == 3) || (indexPath.row > 3) {
                //print("Harish index 6")
                let totalReview = tradiesReviewJSON?.data.count
                
                let indexGot = total - totalReview! - 1
                
                let index = indexPath.row - indexGot
                
                //print("index-\(index)-\(total)-\(totalReview)-\(indexPath.row)-\(indexGot)-")
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "TradieProfileCell5") as! TapATradie_TradieProfileCell5
                
                guard index > 0 else { return cell }
                let ob = self.tradiesReviewJSON?.data[index]
                
                let url = "\(TapATradie_Server)profile/\((ob?.createdBy ?? 0))/\((ob?.profilePic ?? ""))"
                cell.imgCell.uiimage(url, "Group 2826", true, nil)
                
                cell.lblName.text = ob?.fullName.capFirstLetter()
//                cell.lblRating.text = "\((ob?.rating)!)".showRating()
                cell.lblOther.text = ob?.review
                
//                if cell.lblRating.text == "0.0" || cell.lblRating.text == "0" {
//                    cell.lblRating.superview?.isHidden = true
//                } else {
//                    cell.lblRating.superview?.isHidden = false
//                }
                
                if ob?.createdOn != nil {
                    var time = Double(ob?.createdOn ?? "") ?? 0.0
                    
                    if (ob?.createdOn.count ?? 0) > 10 {
                        time = time / 1000
                    }
                    
                    if time > 0 {
                        let date = NSDate(timeIntervalSince1970: time) as Date
                        cell.lblDate.text = date.getStringDate("dd MMM yyyy")
                    }
                }
                
                let obb = tradiesProfileJSON?.userData
                cell.lblCity.text = obb?.city//""//"Banglore india"
                
                //print("==========================================")
                return cell
            }
        }
        
        //print("Harish index -------\(indexPath.row)-")
        //print("==========================================")
        return UITableViewCell()
    }
}

extension TapATradie_TradieProfile: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.tag == 0 {
            return tradiesProfileJSON?.gallery.count ?? 0
        } else {
            if tradiesProfileJSON != nil {
                return tradiesProfileJSON?.services.count ?? 0
            }
        }
        
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView.tag == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GalleryCell", for: indexPath) as! TapATradie_GalleryCell
            let ob = tradiesProfileJSON?.gallery[indexPath.row]
            let url = "\(TapATradie_Server)gallery/\((ob?.uid ?? ""))/\((ob?.image ?? ""))"
            cell.imgGallery.uiimage(url, "Group 2826", true, nil)
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ServiceCell", for: indexPath) as! TapATradie_ServiceCell
            
            let ob = tradiesProfileJSON?.services[indexPath.row]
            
            let url = "\(TapATradie_Server)services/\((ob?.image)!)"
            cell.imgCell.uiimage(url, "Group 4302", true, nil)
            
            cell.lblServiceName.text = ob?.name.capFirstLetter()
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView.tag == 0 {
            let size = (collectionView.frame.size.width - 50) / 3
            return CGSize(width: size, height: size)
        } else {
            return CGSize(width: (collectionView.frame.size.width - 50) / 3, height: 32)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView.tag == 0 {
            return 10
        } else {
            return 10
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard collectionView == cltnGallery else { return }

        let ob = tradiesProfileJSON?.gallery[indexPath.row]

        let url = "\(TapATradie_Server)gallery/\((ob?.uid ?? ""))/\((ob?.image ?? ""))"

        let imgUser = UIImageView()

        imgUser.downloadUIImage(url) { (image, bool) in
            if image != nil {
                self.zoomUIImage(image!)
            } else {
                Toast.toast("Picture not available")
            }
        }
    }
}

class TapATradie_GalleryCell: UICollectionViewCell {
    @IBOutlet weak var imgGallery: UIImageView!
}

class TapATradie_ServiceCell: UICollectionViewCell {
    @IBOutlet weak var lblServiceName: UILabel!
    @IBOutlet weak var imgCell: UIImageView!
}

struct TapATradie_TradiesProfileJSON: Codable {
    let success: String
    let message: String
    let userData: TapATradie_UserTradieData?
    let businessData: TapATradie_BusinessData?
    let services: [TapATradie_Service]
    let gallery: [TapATradie_Gallery]
    
    enum CodingKeys: String, CodingKey {
        case success, message
        case userData = "user_data"
        case businessData = "business_data"
        case services, gallery
    }
}

struct TapATradie_BusinessData: Codable {
    let id, uid: String?
    let houseNo, street, pincode, country: String?
    let state, city, latitude, longitude: String?
    
    enum CodingKeys: String, CodingKey {
        case id, uid
        case houseNo = "house_no"
        case street, pincode, country, state, city, latitude, longitude
    }
}

struct TapATradie_Gallery: Codable {
    let id, uid: String
    let image, createdOn: String
    
    enum CodingKeys: String, CodingKey {
        case id, uid, image
        case createdOn = "created_on"
    }
}

struct TapATradie_Service: Codable {
    let id: String
    let name, image, serviceType: String
    
    enum CodingKeys: String, CodingKey {
        case id, name, image
        case serviceType = "service_type"
    }
}

struct TapATradie_UserTradieData: Codable {
    let id: String
    let fullName, email, mobile, country_code, gender: String
    let dob, country, city, professionalExperience: String
    let phoneNumber: String
    let websiteLink: String
    let aboutMe, businessName, licenseNumber, profilePic: String
    let latitude, longitude, status, access: String
    let lastLogin: String
    let registerComplete, online, verified: String
    let rating: String
    let google: String
    let googleRating: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case fullName = "full_name"
        case email, mobile, gender, dob, country_code, country, city
        case professionalExperience = "professional_experience"
        case phoneNumber = "phone_number"
        case websiteLink = "website_link"
        case aboutMe = "about_me"
        case businessName = "business_name"
        case licenseNumber = "license_number"
        case profilePic = "profile_pic"
        case latitude, longitude, status, access
        case lastLogin = "last_login"
        case registerComplete = "register_complete"
        case online, verified, rating
        case google, googleRating
    }
}
