//
//  TradieProfile.swift
//  Tradie
//
//  Created by Apple on 26/04/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import ImageScrollView

protocol TradieProfileCell1Delegate {
    func requestJob ()
}

class TradieProfileCell1: UITableViewCell {
    
    @IBOutlet weak var cnstBottom: NSLayoutConstraint!
    
    @IBOutlet weak var lblTradieTypeSingle: UILabel!
    @IBOutlet weak var viewMultipleTradieType: UIView!
    
    @IBOutlet weak var btnRequestJob: UIButton!
    
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var imgVarified: UIImageView!
    @IBOutlet weak var lblNAme: UILabel!
   // @IBOutlet weak var lblServices: UILabel!
    @IBOutlet weak var lblRating: UILabel!
    @IBOutlet weak var lblMessage: UILabel!
    
    @IBOutlet weak var ratting: FloatRatingView!
    @IBOutlet weak var viewRating2: FloatRatingView!
    
    var delegate: TradieProfileCell1Delegate?
    
    @IBAction func actionRequestJob(_ sender: Any) {
        delegate?.requestJob()
    }
    
    @IBOutlet weak var lblResidential: UILabel!
    @IBOutlet weak var lblCommercial: UILabel!
    
    override func awakeFromNib() {
        imgProfile.shadow(imgProfile.frame.size.height/2, -1)
        imgProfile.border(UIColor.white, imgProfile.frame.size.height/2, 2)
        
        lblResidential.border5(4)
        lblCommercial.border5(4)
    }
}

class TradieProfileCell2: UITableViewCell {
    @IBOutlet weak var cltnServices: UICollectionView!
    @IBOutlet weak var cltnHeight: NSLayoutConstraint!
    
    override func awakeFromNib() {
        
    }
}

class TradieProfileCell3: UITableViewCell {
    @IBOutlet weak var imgLocation: UIImageView!
    @IBOutlet weak var lblLocation: UILabel!
    
    @IBOutlet weak var imgContact: UIImageView!
    @IBOutlet weak var lblContact: UILabel!
    
    @IBOutlet weak var imgPhoneNumber: UIImageView!
    @IBOutlet weak var lblPhoneNumber: UILabel!
    
    override func awakeFromNib() {
        
    }
}

class TradieProfileCell4: UITableViewCell {
    
    @IBOutlet weak var cltnGallery: UICollectionView!
    @IBOutlet weak var cnstnHeight: NSLayoutConstraint!
    
    override func awakeFromNib() {
        
    }
}

class TradieProfileCell5: UITableViewCell {
    @IBOutlet weak var imgCell: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblCity: UILabel!
    @IBOutlet weak var lblRating: UILabel!
    @IBOutlet weak var lblOther: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    
    override func awakeFromNib() {
        imgCell.border(UIColor.white, imgCell.frame.size.height/2, 1)
    }
}

protocol TradieProfileCell6Delegate {
    func viewMore ()
}

class TradieProfileCell6: UITableViewCell {
    @IBAction func actionViewMore(_ sender: Any) {
        delegate?.viewMore()
    }
    
    @IBOutlet weak var btnViewMore: UIButton!
    @IBOutlet weak var lblViewMore: UILabel!
    
    var delegate:TradieProfileCell6Delegate?
    
    override func awakeFromNib() {
        
    }
}

class TradieProfile: UIViewController, TradieProfileCell1Delegate {
    static func viewController () -> TradieProfile {
        return "Profile".viewController("TradieProfile") as! TradieProfile
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
        
        kAppDelegate.tabbarClicked(IndexPath(row: 1, section: 0), self.navigationController)
    }
    
    var boolGoToServiceSelection = false
    var tradiesJSON: TradiesJSON?
    var tradie_type: String?
    var search = ""
    var services: Services?
    var paramSendToAll: NSMutableDictionary?
    var boolGoToRequestFarm = false
    
    func requestJob () {}
    
    func sendRequest () {}
    
    @IBAction func actionBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBOutlet weak var tblTradieProfile: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        kAppDelegate.currentVC = self
        
        getTradieProfile ()
    }
    
    var tradiesProfileJSON: TradiesProfileJSON?
    
    func getTradieProfile () {
        
        let param = params()
        
        param["provider_id"] = param["uid"] // tradies?.id
      
        //print("1param-\(param)-")
        
        //return;
                
        Http.instance().json(api_get_provider_profile, param, "POST", aai: true, popup: true, prnt: true, nil, nil, sync: false, defaultCalling: false) { (json, paras, str, data) in
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
            
            var s1 = (json?.toString1())!.replacingOccurrences(of: "<null>", with: "")
            
            //MARK: Himanshu update Resolve Issues.
            s1 = s1.replacingOccurrences(of: "\n", with: "")
            
            let data = s1.data(using: String.Encoding.utf8)
            
            if data != nil {
                do {
                    self.tradiesProfileJSON = try JSONDecoder().decode(TradiesProfileJSON.self, from: data!)
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
            
            /*let userTradieData = UserTradieData(id: "", fullName: "", email: "", mobile: "", gender: "", dob: "", country: "", city: "", professionalExperience: "", phoneNumber: "", websiteLink: "", aboutMe: "", businessName: "", licenseNumber: "", profilePic: "", latitude: "", longitude: "", status: "", access: "", lastLogin: "", registerComplete: "", online: "", verified: "1", rating: "")
            let businessData = BusinessData(id: "", uid: "", houseNo: "", street: "", pincode: "", country: "", state: "", city: "", latitude: "", longitude: "")
            let service = Service(id: "", name: "", image: "", serviceType: "")
            let gallery = Gallery(id: "", uid: "", image: "", createdOn: "")
            
            self.tradiesProfileJSON = TradiesProfileJSON(success: "", message: "", userData: userTradieData, businessData: businessData, services: [], gallery: [gallery])*/
            
            self.getTradieReviews ()
        }
    }
    
    var tradies: Tradies?
    //var tradieId = "58"
    
    var tradiesReviewJSON: TradiesReviewJSON?
    
    func getTradieReviews () {
        let param = params()
        
        param["uid"] = tradies?.id
        
        Http.instance().json(api_provider_get_review_list, param, "POST", aai: true, popup: true, prnt: true, nil, nil, sync: false, defaultCalling: false) { (json, paras, str, data) in
            let jsonExp = json as? NSDictionary
            
            if jsonExp != nil {
                if jsonExp?.number("success").intValue == SESSIONEXPIRED {
                   kAppDelegate.sessionExpired(self)
                    
                    return
                }
            }
            
            if data != nil {
                do {
                    self.tradiesReviewJSON = try JSONDecoder().decode(TradiesReviewJSON.self, from: data!)
                    
                    self.tblTradieProfile.reloadData()
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
            
            let url = "\(Server)profile/\((ob?.id)!)/\((ob?.profilePic)!)"
            
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

extension TradieProfile: ImageScrollViewDelegate {
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

struct TradiesReviewJSON: Codable {
    let success: Int
    let data: [TradiesReview]
}

struct TradiesReview: Codable {
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

extension TradieProfile: UITableViewDelegate, UITableViewDataSource, TradieProfileCell6Delegate {
    
    func viewMore () {
        boolShowMore = !boolShowMore
        
        tblTradieProfile.reloadData()
        
        print("View More")
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tradiesProfileJSON != nil {
            if indexPath.row == 1 {
                if tradiesProfileJSON?.services.count == 0 {
                    return 0
                } else {
                    return tableView.estimatedRowHeight
                }
            } else if indexPath.row == 2 {
                
                
                var count = 0
                
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
                    count += 1
                }
                    }
                }
                
                let ob1 = tradiesProfileJSON?.userData
                
                if (ob1?.phoneNumber)!.count > 0 {
                    count += 1
                }
                
                if (ob1?.mobile)!.count > 0 {
                    count += 1
                }
                
                if (ob1?.email)!.count > 0 {
                    count += 1
                }
                
                print("Harish count-\(count)-")
                
                if count == 0 {
                    return 0
                }
                
                return tableView.estimatedRowHeight
                //return 123
            } else if indexPath.row >= defaultCells {
                print("1 indexPath.row-\(indexPath.row)-")
                return tableView.estimatedRowHeight
            } else {
                print("2 indexPath.row-\(indexPath.row)-")
                return tableView.estimatedRowHeight
            }
        }
        
        return 0
    }
    
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
                
                if (self.tradiesReviewJSON?.data.count)! > 4 {
                    if boolShowMore {
                        total = defaultCells + (self.tradiesReviewJSON?.data.count)!
                    } else {
                        total = defaultCells + 4
                    }
                } else {
                    total = defaultCells + (self.tradiesReviewJSON?.data.count)!
                }
                
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
                if (self.tradiesReviewJSON?.data.count)! > 0 {
                    bool = true
                }
            }
            
            if ((total - 1) == indexPath.row) && bool {//}&& (boolShowMore == false) {
                //print("Harish index 1")
                let cell = tableView.dequeueReusableCell(withIdentifier: "TradieProfileCell6") as! TradieProfileCell6
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
                let cell = tableView.dequeueReusableCell(withIdentifier: "TradieProfileCell1") as! TradieProfileCell1
                cell.delegate = self
                
                if paramSendToAll == nil {
                    cell.btnRequestJob.isHidden = true
                    cell.cnstBottom.constant = 20
                } else {
                    cell.btnRequestJob.isHidden = false
                    cell.cnstBottom.constant = 78
                }
                
                let ob = tradiesProfileJSON?.userData
                
                let url = "\(Server)profile/\((ob?.id)!)/\((ob?.profilePic)!)"
                cell.imgProfile.uiimage(url, "Group 2826", true, nil)
                
                if Int((ob?.verified)!)! == 0 {
                    cell.imgVarified.isHidden = true
                } else {
                    cell.imgVarified.isHidden = false
                }
                
                cell.lblTradieTypeSingle.isHidden = true
                cell.viewMultipleTradieType.isHidden = true
                
                for i in 0..<(tradiesProfileJSON?.services.count)! {
                    let ob = tradiesProfileJSON?.services[i]

                    let arr = ob?.serviceType.components(separatedBy: ",")
                    
                    if arr != nil {
                        if (arr?.count)! > 1 {
                            cell.viewMultipleTradieType.isHidden = false
                        } else if (arr?.count)! == 1 {
                            cell.lblTradieTypeSingle.text = "\(arr![0])".capFirstLetter()
                            cell.lblTradieTypeSingle.isHidden = false
                        }
                    }
                    
                    break
                }
                
                cell.lblNAme.text = ob?.fullName.capFirstLetter()
                cell.lblRating.text = "\((ob?.rating)!)".showRating()
                
                if let rate = ob?.rating, rate != "" {
                    cell.ratting.rating = Double(rate) as! Double
                    cell.viewRating2.rating = Double(rate) as! Double
                }
                
                //cell.ratting.rating = Double(ob?.rating ?? 0)
                
                if (ob?.rating)!.count == 0 {
                    cell.lblRating.text = "0.0"
                }
                
                if cell.lblRating.text == "0.0" || cell.lblRating.text == "0" {
                    cell.lblRating.superview?.superview?.isHidden = true
                    cell.viewRating2.isHidden = false
                } else {
                    cell.lblRating.superview?.superview?.isHidden = false
                    cell.viewRating2.isHidden = true
                }
                
            //    cell.lblServices.text = ""
                cell.lblMessage.text = ob?.aboutMe
                
               /* if tradiesProfileJSON != nil {
                    if tradiesProfileJSON?.services != nil {
                        for i in 0..<(tradiesProfileJSON?.services.count)! {
                            let ob = tradiesProfileJSON?.services[i]
                         //   cell.lblServices.text = ob?.name.capFirstLetter()
                            break
                        }
                    }
                }*/
                //print("==========================================")
                return cell
            } else if indexPath.row == 1 {
                //print("Harish index 3")
                let cell = tableView.dequeueReusableCell(withIdentifier: "TradieProfileCell2") as! TradieProfileCell2
                cell.cltnServices.delegate = self
                cell.cltnServices.dataSource = self
                cell.cltnServices.reloadData()
                
                var count: CGFloat = 0
                
                count = CGFloat((tradiesProfileJSON?.services.count)! / 2)
                
                if ((tradiesProfileJSON?.services.count)! % 2) != 0 {
                    count += 1
                }
                
                count -= 1
                
                cell.cltnHeight.constant = 35 + (32 * count)
                //print("==========================================")
                return cell
            } else if indexPath.row == 2 {
                //print("Harish index 4")
                let cell = tableView.dequeueReusableCell(withIdentifier: "TradieProfileCell3") as! TradieProfileCell3
                
                cell.imgLocation.isHidden = true
                cell.lblLocation.isHidden = true
                
                cell.imgContact.isHidden = true
                cell.lblContact.isHidden = true
                
                cell.imgPhoneNumber.isHidden = true
                cell.lblPhoneNumber.isHidden = true
                
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
                    cell.imgLocation.isHidden = false
                    cell.lblLocation.isHidden = false
                }
                    }
                    
                    var str = "".concat(ob.houseNo, " ")
                    str = str.concat(ob.street, " ")
                    str = str.concat(ob.city, " ")
                    str = str.concat(ob.state, " ")
                    str = str.concat(ob.country, " ")
                    str = str.concat(ob.pincode, " ")
                    
                    cell.lblLocation.text = str//"\((ob.houseNo)!) \((ob.street)!) \(ob.city) \(ob.state) \(ob.country) \(ob.pincode)"
                    
                //cell.lblLocation.text = (ob.houseNo)! + " " + (ob.street)! + " " + ob!.city  + " " + ob!.state  + " " + ob!.country  + " " + ob!.pincode
                }
                
                let ob1 = tradiesProfileJSON?.userData
                cell.lblPhoneNumber.text = ob1?.phoneNumber
                
                if (ob1?.phoneNumber)!.count == 0 {
                    cell.lblPhoneNumber.text = ob1?.mobile
                }
                
                if cell.lblPhoneNumber.text!.count > 0 {
                    cell.imgPhoneNumber.isHidden = false
                    cell.lblPhoneNumber.isHidden = false
                }
                
                cell.lblContact.text = ob1?.email
                
                /*if cell.lblPhoneNumber.text!.count > 0 {
                    cell.imgContact.isHidden = false
                    cell.lblContact.isHidden = false
                }*/
                
                print("cell.lblContact.text-[\(cell.lblContact.text)]-")
                
                if cell.lblContact.text!.count > 0 {
                    cell.imgContact.isHidden = false
                    cell.lblContact.isHidden = false
                }
                //print("==========================================")
                return cell
            } else if (tradiesProfileJSON?.gallery.count)! > 0 && indexPath.row == 3 {
                //print("Harish index 5")
                let cell = tableView.dequeueReusableCell(withIdentifier: "TradieProfileCell4") as! TradieProfileCell4
                cell.cltnGallery.delegate = self
                cell.cltnGallery.dataSource = self
                cell.cltnGallery.reloadData()
                
                cell.cnstnHeight.constant = 0
                
                if tradiesProfileJSON != nil {
                    
                    let frame = cell.cltnGallery.frame
                    
                    let size = (frame.size.width - 8) / 3
                    
                    if (tradiesProfileJSON?.gallery.count)! > 6 {
                        cell.cnstnHeight.constant = 32 + (size * CGFloat(2))
                    } else if (tradiesProfileJSON?.gallery.count)! <= 3 {
                        cell.cnstnHeight.constant = 32 + (size * CGFloat(1))
                    } else if (tradiesProfileJSON?.gallery.count)! > 3 {
                        cell.cnstnHeight.constant = 32 + (size * CGFloat(2))
                    }
                }
                //print("==========================================")
                return cell
            } else if ((tradiesProfileJSON?.gallery.count)! == 0 && indexPath.row == 3) || (indexPath.row > 3) {
                //print("Harish index 6")
                let totalReview = tradiesReviewJSON?.data.count
                
                let indexGot = total - totalReview! - 1
                
                let index = indexPath.row - indexGot
                
                //print("index-\(index)-\(total)-\(totalReview)-\(indexPath.row)-\(indexGot)-")
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "TradieProfileCell5") as! TradieProfileCell5
                
                let ob = self.tradiesReviewJSON?.data[index]
                
                let url = "\(Server)profile/\((ob?.createdBy)!)/\((ob?.profilePic)!)"
                cell.imgCell.uiimage(url, "Group 2826", true, nil)
                
                cell.lblName.text = ob?.fullName.capFirstLetter()
                cell.lblRating.text = "\((ob?.rating)!)".showRating()
                cell.lblOther.text = ob?.review
                
                if cell.lblRating.text == "0.0" || cell.lblRating.text == "0" {
                    cell.lblRating.superview?.isHidden = true
                } else {
                    cell.lblRating.superview?.isHidden = false
                }
                
                if ob?.createdOn != nil {
                    var time = Double(ob!.createdOn)!
                    
                    if (ob?.createdOn.count)! > 10 {
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

extension TradieProfile: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.tag == 0 {
            if tradiesProfileJSON != nil {
                if (tradiesProfileJSON?.gallery.count)! > 6 {
                    return 6
                } else if (tradiesProfileJSON?.gallery.count)! <= 3 {
                    return (tradiesProfileJSON?.gallery.count)!
                } else if (tradiesProfileJSON?.gallery.count)! > 3 {
                    return (tradiesProfileJSON?.gallery.count)!
                }
            }
        } else {
            if tradiesProfileJSON != nil {
                return (tradiesProfileJSON?.services.count)!
            }
        }
        
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView.tag == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GalleryCell", for: indexPath) as! GalleryCell
            
            cell.lblCount.text = ""
            cell.imgGallery.border5(4)
            
            let ob = tradiesProfileJSON?.gallery[indexPath.row]
            
            if indexPath.row == 5 && (tradiesProfileJSON?.gallery.count)! == 6 {
                let url = "\(Server)gallery/\((ob?.uid)!)/\((ob?.image)!)"
                cell.imgGallery.uiimage(url, "Group 2826", true, nil)
            } else if indexPath.row == 5 && (tradiesProfileJSON?.gallery.count)! > 6 {
                let url = "\(Server)gallery/\((ob?.uid)!)/\((ob?.image)!)"
                cell.imgGallery.uiimage(url, "Group 2826", true, nil)
                
                cell.lblCount.text = "+ \((tradiesProfileJSON?.gallery.count)! - 5) images"
            } else {
                let url = "\(Server)gallery/\((ob?.uid)!)/\((ob?.image)!)"
                cell.imgGallery.uiimage(url, "Group 2826", true, nil)
            }
            
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ServiceCell", for: indexPath) as! ServiceCell
            cell.contentView.backgroundColor = UIColor.blue
            
            let ob = tradiesProfileJSON?.services[indexPath.row]
            
            let url = "\(Server)services/\((ob?.image)!)"
            cell.imgCell.uiimage(url, "Group 4302", true, nil)
            
            cell.lblServiceName.text = ob?.name.capFirstLetter()
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView.tag == 0 {
            let frame = collectionView.frame
            
            let size = (frame.size.width - 8) / 3
            return CGSize(width: size, height: size)
        } else {
            return CGSize(width: self.view.frame.size.width / 2, height: 32)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView.tag == 0 {
            return 4
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("indexPath-\(indexPath)-")
        
        if (tradiesProfileJSON?.gallery.count ?? 0) > indexPath.row{
            
            
            let ob = tradiesProfileJSON?.gallery[indexPath.row]
            
            let url = "\(Server)gallery/\((ob?.uid)!)/\((ob?.image)!)"
            
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
}

class GalleryCell: UICollectionViewCell {
    @IBOutlet weak var imgGallery: UIImageView!
    @IBOutlet weak var lblCount: UILabel!
}

class ServiceCell: UICollectionViewCell {
    @IBOutlet weak var lblServiceName: UILabel!
    @IBOutlet weak var imgCell: UIImageView!
}

struct TradiesProfileJSON: Codable {
    let success: String
    let message: String
    let userData: UserTradieData
    let businessData: BusinessData?
    let services: [Service]
    let gallery: [Gallery]
    
    enum CodingKeys: String, CodingKey {
        case success, message
        case userData = "user_data"
        case businessData = "business_data"
        case services, gallery
    }
}

struct BusinessData: Codable {
    let id, uid: String?
    let houseNo, street, pincode, country: String?
    let state, city, latitude, longitude: String?
    
    enum CodingKeys: String, CodingKey {
        case id, uid
        case houseNo = "house_no"
        case street, pincode, country, state, city, latitude, longitude
    }
}

struct Gallery: Codable {
    let id, uid: String
    let image, createdOn: String
    
    enum CodingKeys: String, CodingKey {
        case id, uid, image
        case createdOn = "created_on"
    }
}

struct Service: Codable {
    let id: String
    let name, image, serviceType: String
    
    enum CodingKeys: String, CodingKey {
        case id, name, image
        case serviceType = "service_type"
    }
}

struct UserTradieData: Codable {
    let id: String
    let fullName, email, mobile, gender: String
    let dob, country, city, professionalExperience: String
    let phoneNumber: String
    let websiteLink: String
    let aboutMe, businessName, licenseNumber, profilePic: String
    let latitude, longitude, status, access: String
    let lastLogin: String
    let registerComplete, online, verified: String
    let rating: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case fullName = "full_name"
        case email, mobile, gender, dob, country, city
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
    }
}

struct TradiesJSON: Codable {
    let success: Int
    let message: String
    let data: [Tradies]
}

class Tradies: Codable {
    var id: Int
    var fullName, latitude, longitude, profilePic: String
    var online, verified: Int
    var serviceName: String
    var serviceId: String
    var rating, distance: Double?
    
    enum CodingKeys: String, CodingKey {
        case id
        case serviceId = "service_id"
        case fullName = "full_name"
        case latitude, longitude
        case profilePic = "profile_pic"
        case online, verified
        case serviceName = "service_name"
        case rating, distance
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
        rating = 0
        distance = 0
    }
}
