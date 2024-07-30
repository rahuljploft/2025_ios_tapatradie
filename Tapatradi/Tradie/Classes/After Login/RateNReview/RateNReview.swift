//
//  RateNReview.swift
//  Tradie
//
//  Created by Apple on 17/05/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import Common

protocol RateNReviewCellDelegate {
    func cellClicked (_ indexPath: IndexPath)
}

protocol RatingOnOffTVCellDelegate {
    func showRating(account: String, type: Int)  // account - google, facebook; type - 0 (off), 1(on)
}


class RateNReviewCell: UITableViewCell {
    var indexPath: IndexPath!
    var delegate: RateNReviewCellDelegate!
    
    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var ratingView: FloatRatingView!
    @IBOutlet weak var lblReview: UILabel!
    
    override func awakeFromNib() {
        imgUser.border5(imgUser.frame.size.height/2)
    }
    
    @IBAction func actionCellClicked(_ sender: Any) {
        delegate.cellClicked(indexPath)
    }
}


class RatingOnOffTVCell: UITableViewCell{
    
    @IBOutlet weak var viewGFShadow: UIView!
    @IBOutlet weak var lblRatingGoogle: UILabel!
    @IBOutlet weak var lblRatingFaceBook: UILabel!
    @IBOutlet weak var btnGoogleReviewOnOff: UIButton!
    @IBOutlet weak var btnGoogleSync: UIButton!
    @IBOutlet weak var btnFaceBookReviewOnOff: UIButton!
    @IBOutlet weak var btnFBSync: UIButton!
    
    @IBOutlet weak var stackGoogle: UIStackView!
    @IBOutlet weak var stackFaceBook: UIStackView!
    @IBOutlet weak var viewSeparator: UIView!
    @IBOutlet weak var viewGoogleFaceBookC: UIView!
    
    
    @IBOutlet weak var viewGoogleBusinessNameC: UIView!
    @IBOutlet weak var btnSaveGoogleBusinessName: UIButton!
    @IBOutlet weak var txtGoogleBusinessName: UITextField!
    @IBOutlet weak var viewGoogleBusinessHidable: UIView!
    
    
    @IBOutlet weak var lblNoListing: UILabel!
    
    weak var parentVC: RateNReview?
    var delegate: RateNReviewCellDelegate!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        viewGFShadow.addShadow(offset: CGSize(width: 0, height: 0), color: UIColor.lightGray, radius: 4, opacity: 1, cornerRadius: 5)
        
        viewGoogleBusinessNameC.setCornerRadiusWithBorder(cornerRadius: 4, clipsToBound: true, borderWidth: 1, borderColor: UIColor.lightGray.cgColor)
        
        
        
    }
    
    func initialsetUP(){
        
        if parentVC?.google == "1"{
            self.btnGoogleReviewOnOff.isSelected = true
            self.viewGoogleBusinessHidable.isHidden = false
        }else{
            self.btnGoogleReviewOnOff.isSelected = false
            self.viewGoogleBusinessHidable.isHidden = true
        }
        
        if parentVC?.facebook == "1"{
            self.btnFaceBookReviewOnOff.isSelected = true
        }else{
            self.btnFaceBookReviewOnOff.isSelected = false
        }
        
        self.lblRatingGoogle.text = self.parentVC?.googleRating
        //self.lblRatingFaceBook.text = self.parentVC?.googleRating //replace it with facebook rating
        
        
        ///Set Business name
        let googleBusinessName = self.parentVC?.userData?.data.googleBusinessName ?? ""
        if googleBusinessName == ""{
            self.txtGoogleBusinessName.text = self.parentVC?.userData?.data.businessName ?? "0"
        }else{
            self.txtGoogleBusinessName.text = googleBusinessName
        }
        
        
        
        
        updateUIOnGoogleReviewOnOff()
//        updateUIOnFaceBookReviewOnOff()
        viewSeparator.isHidden = true
    }
    
   
    
    func updateUIOnGoogleReviewOnOff(){
        
        if btnGoogleReviewOnOff.isSelected == true{
            
            self.parentVC?.google = "1"
            stackGoogle.isHidden = false
            viewGoogleFaceBookC.isHidden = false
            self.viewGoogleBusinessHidable.isHidden = false
            if btnFaceBookReviewOnOff.isSelected == false{
                viewSeparator.isHidden = true
            }else{
                viewSeparator.isHidden = false
            }
            
        }else{
            
            self.parentVC?.google = "0"
            stackGoogle.isHidden = true
            viewSeparator.isHidden = true
            self.viewGoogleBusinessHidable.isHidden = true
            
            if btnFaceBookReviewOnOff.isSelected == false{
                viewGoogleFaceBookC.isHidden = true
            }else{
                viewGoogleFaceBookC.isHidden = false
            }
    
        }
        self.parentVC?.tblRateReview.reloadData()
        
    }
    
    
    
    func updateUIOnFaceBookReviewOnOff(){
        
        if btnFaceBookReviewOnOff.isSelected == true{
            
            self.parentVC?.facebook = "1"
            stackFaceBook.isHidden = false
            viewGoogleFaceBookC.isHidden = false
            
            if btnGoogleReviewOnOff.isSelected == false{
                viewSeparator.isHidden = true
            }else{
                viewSeparator.isHidden = false
            }
            
            
        }else{
            
            self.parentVC?.facebook = "0"
            stackFaceBook.isHidden = true
            viewSeparator.isHidden = true
            
            if btnGoogleReviewOnOff.isSelected == false{
                viewGoogleFaceBookC.isHidden = true
            }else{
                viewGoogleFaceBookC.isHidden = false
            }
            
        }
        
        self.parentVC?.tblRateReview.reloadData()
        
    }
    
    
    
    @IBAction func btnGoogleReviewOnOffPressed(_ sender:UIButton){
        
        let googleBname = txtGoogleBusinessName.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        
        btnGoogleReviewOnOff.isSelected = !btnGoogleReviewOnOff.isSelected
        updateUIOnGoogleReviewOnOff()
        if btnGoogleReviewOnOff.isSelected == true{
            self.parentVC?.showSocialRating(account: "google", type: 1, googlBusinessName: googleBname) //on - 1
        }else{
            self.parentVC?.showSocialRating(account: "google", type: 0, googlBusinessName: googleBname) //off - 0
        }
        
    }
    
    
    @IBAction func btnFaceBookReviewOnOffPressed(_ sender:UIButton){
        
        let googleBname = txtGoogleBusinessName.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        
        
        btnFaceBookReviewOnOff.isSelected = !btnFaceBookReviewOnOff.isSelected
        updateUIOnFaceBookReviewOnOff()
        if btnFaceBookReviewOnOff.isSelected == true{
            self.parentVC?.showSocialRating(account: "facebook", type: 1, googlBusinessName: googleBname) //on - 1
        }else{
            self.parentVC?.showSocialRating(account: "facebook", type: 0, googlBusinessName: googleBname) //off - 0
        }
        
    }
    
    
    @IBAction func btnSaveGoogleBusinessNameTapped(_ sender: UIButton) {
        
        let googleBname = txtGoogleBusinessName.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        
        if googleBname == ""{
            AlertService.shared.showError(message: "Please enter google business name")
        }else{
            
            self.parentVC?.showSocialRating(account: "google", type: 1, googlBusinessName: googleBname, isFromSave: true)
            

        }
        
    }
    
    
    
    
}







extension RateNReview: RateNReviewCellDelegate {
    func cellClicked (_ indexPath: IndexPath) {
        let ob = self.rateReviewJSON?.data[indexPath.row]
        
        if ob?.isSelected == nil {
            ob?.isSelected = false
        }
        
        ob?.isSelected = !(ob?.isSelected)!
        
        tblRateReview.beginUpdates()
        tblRateReview.reloadRows(at: [indexPath], with: .none)
        tblRateReview.endUpdates()
    }
}

class RateNReview: UIViewController {
    
   
    
    @IBOutlet weak var lblNolisting: UILabel!
    
    @IBOutlet weak var tblRateReview: UITableView!
    
    
    var userData: ProfileJSON?
    
    var google: String = "0"
    var facebook: String = "0"
    
    var googleRating = "0"
    var faceBookRating = "0"
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        kAppDelegate.currentVC = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let insets = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
        tblRateReview.contentInset = insets
        
        self.tblRateReview.delegate = self
        self.tblRateReview.dataSource = self
        
        getRateNReview ()
        checkProfile()
    }
    
    var rateReviewJSON: RateReviewJSON?
    
    func getRateNReview () {
        let param = params()
        
        Http.instance().json(api_provider_get_review_list, param, "POST", aai: true, popup: true, prnt: true, nil, nil, sync: false, defaultCalling: false) { (json, para, str, http, data) in
            let jsonExp = json as? NSDictionary
            
            if jsonExp != nil {
                if jsonExp?.number("success").intValue == SESSIONEXPIRED {
                   kAppDelegate.sessionExpired(self)
                    
                    return
                }
            }
            
            if data != nil {
                do {
                    self.rateReviewJSON = try JSONDecoder().decode(RateReviewJSON.self, from: data!)
                } catch let error {
                    print("1Error: \(error)")
                }
            }
            
            
            self.tblRateReview.reloadData()
        }
    }
    
    
    
    
    func syncGoogleRatings () {
        
        let param = params()
        
        
        
        Http.instance().json(api_sync_GoogleRating, param, "POST", aai: true, popup: true, prnt: true, nil, nil, sync: false, defaultCalling: false) { (json, para, str, http, data) in
            let jsonExp = json as? NSDictionary
            
            if jsonExp != nil {
                if jsonExp?.number("success").intValue == SESSIONEXPIRED {
                   kAppDelegate.sessionExpired(self)
                    
                    return
                }
            }
            
            if data != nil {
//                do {
//                    self.rateReviewJSON = try JSONDecoder().decode(RateReviewJSON.self, from: data!)
                    let strMsg = jsonExp?.string("message") ?? "Ratings Successfully Synced"
                    AlertService.shared.showError(title: "", message: strMsg)
                    
//                } catch let error {
//                    print("1Error: \(error)")
//                }
            }
            
            self.tblRateReview.reloadData()
        }
    }
    
    
    
    func showSocialRating(account: String, type: Int, googlBusinessName: String, isFromSave:Bool = false){
        
        // account - google, facebook; type - 0 (off), 1(on)
        
        let param = params()
        
        param["account"] = account
        param["type"] = type
        param["business_name"] = googlBusinessName
        
        
        
        Http.instance().json(api_show_socialRating, param, "POST", aai: true, popup: true, prnt: true, nil, nil, sync: false, defaultCalling: false) { (json, para, str, http, data) in
            let jsonExp = json as? NSDictionary
            
            if jsonExp != nil {
                if jsonExp?.number("success").intValue == SESSIONEXPIRED {
                   kAppDelegate.sessionExpired(self)
                    
                    return
                }
            }
            
            if data != nil {
//                do {
//                    self.rateReviewJSON = try JSONDecoder().decode(RateReviewJSON.self, from: data!)
                
                
                let strMsg = jsonExp?.string("message") ?? ""
//                AlertService.shared.showError(title: "", message: strMsg)
                    
                let alert = UIAlertController(title: "", message: strMsg, preferredStyle: .alert)
                let action1 = UIAlertAction(title: "OK", style: .default) { (_) in
                    if isFromSave == true{
                        self.checkProfile()
                    }
                }
                alert.addAction(action1)
                self.present(alert, animated: true, completion: nil)
                
                
//                } catch let error {
//                    print("1Error: \(error)")
//                }
            }
            
            self.tblRateReview.reloadData()
        }
        
    }
    
    
    
    
    
    
    func checkProfile () {
        let param = params()
        
        Http.instance().json(api_provider_profile_steps, param, "POST", aai: true, popup: true, prnt: true, nil, nil, sync: false, defaultCalling: false) { (json, paras, str, data) in
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
                    self.userData = try JSONDecoder().decode(ProfileJSON.self, from: data!)
                    
                    //self.userData?.data.rating
                    
                    if self.userData != nil {
                       
                        self.google = self.userData?.data.google ?? "0"
                        self.facebook = self.userData?.data.facebook ?? "0"
                        self.googleRating = self.userData?.data.googleRating ?? "0"
                       
                        
                        DispatchQueue.main.asyncAfter(deadline: .now()) {
                            let cell = self.tblRateReview.cellForRow(at: IndexPath(row: 0, section: 0)) as! RatingOnOffTVCell
                            cell.initialsetUP()
                            
                        }
                        
                    }
                   
                } catch let error {
                    print("Error: \(error)")
                }
            }
        }
    }
    
    
    
    
    @objc func btnGoogleSyncPressed(_ sender:UIButton){
        syncGoogleRatings()
    }
    
    
    
    @objc func btnFBSyncPressed(_ sender:UIButton){
        
    }
    
    
}

extension RateNReview: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section == 0{
            return UITableView.automaticDimension
        }
        return tableView.estimatedRowHeight
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0{
            return 1
        }
        var count = 0
        
        if self.rateReviewJSON != nil {
            count = (self.rateReviewJSON?.data.count)!
        }
        
        //count = 10
        
//        if count == 0 {
//            lblNolisting.isHidden = false
//        } else {
//            lblNolisting.isHidden = true
//        }
        
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0{
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "RatingOnOffTVCell") as! RatingOnOffTVCell
            
            
            cell.btnGoogleSync.addTarget(self, action: #selector(btnGoogleSyncPressed(_:)), for: .touchUpInside)
            cell.btnFBSync.addTarget(self, action: #selector(btnFBSyncPressed(_:)), for: .touchUpInside)
            
            if (self.rateReviewJSON?.data.count ?? 0) > 0{
                cell.lblNoListing.isHidden = true
            }else{
                cell.lblNoListing.isHidden = false
            }
            
            cell.parentVC = self
            
            return cell
            
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "RateNReviewCell") as! RateNReviewCell
        
        cell.indexPath = indexPath
        cell.delegate = self
        
        if self.rateReviewJSON!.data.count > indexPath.row {
            
            let ob = self.rateReviewJSON?.data[indexPath.row]
            
            cell.lblName.text = ob?.fullName.capFirstLetter()
            
            if ob?.isSelected == nil {
                ob?.isSelected = false
            }
            
            if (ob?.isSelected)! {
                cell.lblReview.numberOfLines = 0
            } else {
                cell.lblReview.numberOfLines = 1
            }
            
            if let rating = ob?.rating {
                cell.ratingView.rating = Double(rating)
                print("rating:", cell.ratingView.rating)
            }
            else {
                print("rating: ", 0)
                cell.ratingView.rating = 0
            }
            
//            if cell.lblRating.text == "0.0" || cell.lblRating.text == "0" {
//                cell.lblRating.superview?.isHidden = true
//            } else {
//                cell.lblRating.superview?.isHidden = false
//            }
            
//            if ob?.latitude != nil && ob?.longitude != nil {
//                if ob?.latitude.count != 0 && ob?.longitude.count != 0 {
//                    let obbb = getAddressOrLatLong(NSNumber(value: Float((ob?.latitude)!)!), NSNumber(value: Float((ob?.longitude)!)!), nil, false)
//                    cell.lblCity.text = obbb!.city
//                }
//            }
            
            cell.lblTime.text = ""
            
            //1564661417326
            
            //let date = NSDate(timeIntervalSince1970: 1415637900)
            
            
            if ob?.createdOn != nil {
                var time = Double(ob!.createdOn) ?? 0.0
                
                if (ob?.createdOn.count)! > 10 {
                    time = time / 1000
                }
                
                if time > 0 {
                    let date = NSDate(timeIntervalSince1970: time) as Date
                    
                    cell.lblTime.text = date.getStringDate("dd MMM yyyy")
                }
            }
            
            let url = "\(Server)profile/\((ob?.createdBy)!)/\((ob?.profilePic)!)"
            
            cell.imgUser.uiimage(url, "Group 2826", true, nil)
            
            cell.lblReview.text = ob?.review
        }
        
        //cell.lblReview.text = "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum."
        
        cell.selectionStyle = .none
        return cell
    }
}

class RateReviewJSON: Codable {
    let success: Int
    let data: [RR]
}

class RR: Codable {
    let id, providerID, jobPostID, rating: Int
    let review, latitude, longitude: String
    let createdBy: Int
    let createdOn: String
    let updatedBy: Int
    let updatedOn, status, fullName, profilePic: String
    var isSelected = false
    
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
