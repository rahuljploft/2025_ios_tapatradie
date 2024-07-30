//
//  MyBookings.swift
//  Tradie
//
//  Created by Apple on 27/04/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import ImageScrollView
import StoreKit
import Common
import AVFoundation
import AVKit
import SDWebImage

protocol MyBookingsCellDelegate {
    func cellDelete(_ indexPath: IndexPath)
    func cellCall(_ indexPath: IndexPath)
    func cellChat(_ indexPath: IndexPath)
    func cellRight(_ indexPath: IndexPath)
    func cellMapPin(_ indexPath: IndexPath)
    func cellCross(_ indexPath: IndexPath)
    func cellConfirm(_ indexPath: IndexPath)
    func cellDispute(_ indexPath: IndexPath)
    func cellRateTo(_ indexPath: IndexPath)
    func cellCellClicked(_ indexPath: IndexPath)
    func cellListAllTradie(_ indexPath: IndexPath)
    func taskDone(_ indexPath: IndexPath)
    func cellDeleteHistory (_ indexPath: IndexPath)
    func cellZoomImage (_ indexPath: IndexPath)
    func subscriptionPOP()
}

extension MyBookings: AlertDelegate {
    func alertZero () {
        if boolSubscriptionExpiredAlert {
            actionSubscriptionExpired("")
        } else {
            acceptReject("delete", deleteIndexPath)
        }
    }
    
    func alertOne () {}
    
    func cellClicked (_ indexPath: IndexPath) {
        //let ob = getData(indexPath).jobPost//bookings?.jobPost[indexPath.row]
    }
    
    func deleteClicked (_ indexPath: IndexPath) {
        /*
         let ob = getData(indexPath)
         
         if (ob.bookings?.jobPost.count)! == 1 {
         deleteIndexPath = indexPath
         self.boolSubscriptionExpiredAlert = false
         Http.alert ("", "If you delete this tradie, so job will be automatically deleted.", [self, "Yes", "No"])
         } else {
         acceptReject ("delete", indexPath)
         }
         */
    }
    
    func rightClicked (_ indexPath: IndexPath) {
        acceptReject("accept", indexPath)
    }
    
    func crossClicked (_ indexPath: IndexPath) {
        acceptReject("reject", indexPath)
    }
    
    func acceptReject (_ type: String, _ indexPath: IndexPath) {
        /*let ob = getData(indexPath).jobPost//bookings?.jobPost[indexPath.row]
         
         let param = params()
         param["action"] = type
         
         param["pid"] = ob?.providerID
         param["job_id"] = ob?.jobPostID
         param["type"] = ob?.type
         
         Http.instance().json(api_user_job_action, param, "POST", aai: true, popup: true, prnt: true, nil, nil, sync: false, defaultCalling: false) { (json, para, str, http, data) in
         let json = json as? NSDictionary
         self.boolSubscriptionExpiredAlert = false
         if json != nil {
         if json?.number("success").intValue == 1 {
         self.getListing()
         self.boolSubscriptionExpiredAlert = false
         if type == "reject" {
         Http.alert("", "Job successfully rejected.")
         } else if type == "delete" {
         Http.alert("", "Job successfully deleted.")
         } else if type == "accept" {
         Http.alert("", "Job successfully accepted.")
         }
         } else {
         Http.alert("", json?.string("message"))
         }
         }
         }*/
    }
}

extension MyBookings: MyBookingsCellDelegate {
    func cellDeleteHistory (_ indexPath: IndexPath) {

        btnOkDeleteHistory.tag = indexPath.row
        
        addDeleteHistoryView ()
    }
    
    func cellDeleteHistoryFromOk (_ indexPath: IndexPath) {
        let ob = leadsJSON?.data[indexPath.row]
        
        let param = params()
        
        param["job_id"] = ob?.id
        param["type"] = "tradie"
        param["action"] = "deleted"
        
        //api_delete_history changed api to api_provider_job_action
        Http.instance().json(api_provider_job_action, param, "POST", aai: true, popup: true, prnt: true, nil, nil, sync: false, defaultCalling: false) { (json, para, str, http, data) in
            
            let json = json as? NSDictionary
            
            if json != nil {
                if json?.number("success").intValue == 1 {
                    self.actionHistoryBookings("")
                }
                
                Toast.toast(json!.string("message"))
            }
        }
    }
    
    func taskDone(_ indexPath: IndexPath) {
        //        if iapCheck () == false {
        //            return
        //        }
        
        indexPathTaskDone = indexPath
        
        addTaskDoneAlert ()
        //callAction("completed", indexPath)
    }
    
    func cellDispute(_ indexPath: IndexPath) {
        //        if iapCheck () == false {
        //            return
        //        }
    }
    
    func cellRateTo(_ indexPath: IndexPath) {
        //        if iapCheck () == false {
        //            return
        //        }
    }
    
    func cellListAllTradie(_ indexPath: IndexPath) {
        //        if iapCheck () == false {
        //            return
        //        }
    }
    
    func cellCellClicked(_ indexPath: IndexPath) {
        //        if iapCheck () == false {
        //            return
        //        }
        
        for i in 0..<(leadsJSON?.data.count)! {
            let ob = leadsJSON?.data[i]
            
            if i == indexPath.row {
                ob?.isSelected = !(ob?.isSelected)!
            } else {
                if (ob?.isSelected)! {
                    DispatchQueue.global().async {
                        DispatchQueue.main.async {
                            self.tblMyBookings.reloadRows(at: [IndexPath(row: i, section: 0)], with: UITableView.RowAnimation.automatic)
                        }
                    }
                }
                
                ob?.isSelected = false
            }
        }
        
        tblMyBookings.reloadRows(at: [indexPath], with: UITableView.RowAnimation.none)
        //tblMyBookings.reloadData()
    }
    
    func cellDelete(_ indexPath: IndexPath) {
        //        if iapCheck () == false {
        //            return
        //        }
        
        callAction("delete", indexPath)
    }
    
    func cellCall(_ indexPath: IndexPath) {
        let ob = leadsJSON?.data[indexPath.row]
        if ob?.mobile != nil {
            if let url = URL(string: "tel://\((ob?.mobile)!)") {
                
                if UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                } else {
                    self.boolSubscriptionExpiredAlert = false
                    Http.alert("", "Phone call not available.")
                }
            }
        }
    }
    
    func cellChat(_ indexPath: IndexPath) {
        let ob = leadsJSON?.data[indexPath.row]
        var userID = ""
        var providerId = ""
        var jobId = ""
        
        var fullName = ""
        var profilePic = ""
        
        
        if ob?.uid != nil {
            userID = "\((ob?.uid)!)"
        }
        if ob?.providerID != nil {
            providerId = "\((ob?.providerID)!)"
        }
        if ob?.id != nil {
            jobId = "\((ob?.id)!)"
        }
        
        if ob?.fullName != nil {
            fullName = "\((ob?.fullName)!)"
        }
        
        if ob?.profilePic != nil {
            profilePic = "\((ob?.profilePic)!)"
        }
        
        print(ob?.id)
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "MyChatScreen_VC") as! MyChatScreen_VC
        vc.userID = userID
        vc.providerId = providerId
        vc.jobId = jobId
        vc.profileURl = profilePic
        vc.name = fullName
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
    
    func cellRight(_ indexPath: IndexPath) {
        callAction("accept", indexPath)
    }
    
    func subscriptionPOP() {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SubscPopUP_VC") as! SubscPopUP_VC
        vc.modalPresentationStyle = .overFullScreen
        vc.parentVC = self
        self.present(vc, animated: true)
    }
    
    func navigatetoPremium() {
        //let vc = story_Payment.viewController("ChooseSubscripiton")
        let vc = story_Home.viewController("PaymentScreenVC")
        self.navigationController?.pushViewController(vc!, animated: false)
    }
    
    func cellMapPin(_ indexPath: IndexPath) {
        DispatchQueue.main.async {
            let vc = story_Tradie.viewController("TrackTradie") as! TrackTradie
            vc.leads = self.leadsJSON?.data[indexPath.row]
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    func cellCross(_ indexPath: IndexPath) {
        //        if iapCheck () == false {
        //            return
        //        }
        
        callAction("reject", indexPath)
    }
    
    func cellConfirm(_ indexPath: IndexPath) {
        //        if iapCheck () == false {
        //            return
        //        }
        
        boolCurrent = false
        callAction("completed", indexPath)
    }
    
    func callAction (_ type: String,_ indexPath: IndexPath) {
        //        if iapCheck () == false {
        //            return
        //        }
        
        let ob = leadsJSON?.data[indexPath.row]
        
        let param = params()
        param["action"] = type//"completed"
        //accept / reject/ completed
        
        param["job_id"] = ob?.id
        param["type"] = ob?.type
        
        Http.instance().json(api_provider_job_action_new, param, "POST", aai: true, popup: true, prnt: true, nil, nil, sync: false, defaultCalling: false) { (json, para, str, http, data) in
            let json = json as? NSDictionary
            
            if json != nil {
                if json?.number("success").intValue == 1 {
                    self.boolSubscriptionExpiredAlert = false
                    
                    if type == "completed" {
                        Http.alert("", "Job successfully confirmed.")
                    } else if type == "reject" {
                        Http.alert("", "Job successfully rejected.")
                    } else if type == "delete" {
                        Http.alert("", "Job successfully deleted.")
                    } else if type == "accept" {
                        Http.alert("", "The client is aware you accepted their job and they will hopefully be in touch soon.")
                    }
                    
                    if self.boolCurrent {
                        self.actionCurrentBookings("")
                    } else {
                        self.actionHistoryBookings("")
                    }
                } else if json?.number("success").intValue == SESSIONEXPIRED {
                    kAppDelegate.sessionExpired(self)
                    
                    return
                } else {
                    self.boolSubscriptionExpiredAlert = false
                    
                    Http.alert("", json?.string("message"))
                }
            }
        }
    }
    
    func iapCheck () -> Bool {
        //        return true
        print("boolApplePuchase boolServerPuchase-[\(boolApplePuchase)]-[\(boolServerPuchase)]-[\(boolDeviceUser)]-")
        
        if boolApplePuchase || boolServerPuchase {
            boolSubscriptionExpiredAlert = false
            return true
        }
        
        let alertController = UIAlertController(title: "", message: "Hey! It looks like you are a free member. In order to respond to this job and future leads kindly subscribe and become a premium member.", preferredStyle: .alert)
        
        
        
        let action1 = UIAlertAction(title: "Subscribe Now", style: .cancel) { (action) in
            let vc = story_Payment.viewController("ChooseSubscripiton") as? ChooseSubscripiton
            vc?.boolFromMenu = false
            vc?.boolDeviceUser = self.boolDeviceUser
            self.navigationController?.pushViewController(vc!, animated: false)
        }
        
        let action2 = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        
        alertController.addAction(action2)
        alertController.addAction(action1)
        
        //self.present(alertController, animated: true, completion: nil)
        
        
        
        
        //        if boolDeviceUser {
        //            Http.alert("", "Your subscription has been expired", [self, "Subscribe", "Cancel"])
        //        } else {
        //            Http.alert("", "You have subscribed with some other mobile number. Please login with the same mobile number to use this feature.")
        //        }
        
        boolSubscriptionExpiredAlert = true
        return false
    }
    
    func cellZoomImage (_ indexPath: IndexPath) {
        zoomImage (indexPath)
    }
}


protocol onPhotoClick {
    func openImage(images_Upload:[images],index: Int)
    func openVideo(images_Upload:[images],index: Int)
}


class MyBookingsCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(images_Upload.count)
        return images_Upload.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoCollection", for: indexPath) as! photoCollection
        let type = images_Upload[indexPath.row].type ?? ""
        if type == "image" {
            print("img Url",images_Upload[indexPath.row].image_url ?? "")
            cell.AlphaView.backgroundColor = UIColor.black.withAlphaComponent(0.2)
            cell.Img_PlayPause.isHidden = true
            if let url = URL(string: images_Upload[indexPath.row].image_url ?? "") {
                cell.Img_Photo.sd_setImage(with: url)
                cell.Img_Photo.sd_imageIndicator = SDWebImageActivityIndicator.gray
            }
        }else{
            cell.AlphaView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
            cell.Img_PlayPause.isHidden = false
            cell.Img_Photo.image = UIImage(named: "requesticon")
        }
        
        cell.AlphaView.layer.cornerRadius = 4
        let frm = photoCollection.frame.width
        cell.heightVal.constant = frm/3.3
        cell.widthVal.constant = frm/3.3
        cell.View_Card.layer.cornerRadius = 4
        cell.View_Card.layer.shadowRadius = 1
        cell.View_Card.layer.shadowOffset = .zero
        cell.View_Card.layer.shadowOpacity = 0.5
        cell.View_Card.layer.shadowColor = UIColor.gray.cgColor
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let type = images_Upload[indexPath.row].type ?? ""
        let urlStr = images_Upload[indexPath.row].image_url ?? ""
        if type == "image" {
            delegateNew.openImage(images_Upload: images_Upload,index: indexPath.row)
        }else{
            delegateNew.openVideo(images_Upload: images_Upload,index: indexPath.row)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let frm = photoCollection.frame.width
        return CGSize(width: frm/3.2, height: frm/3.2)
    }
    
    @IBOutlet weak var photoCollection: UICollectionView!
    @IBOutlet weak var PhotoHeight: NSLayoutConstraint!
    @IBOutlet weak var View_Collection: UIView!
    
    var images_Upload = [images]()
    var delegateNew:onPhotoClick!
    
    
    func dele() {
        self.photoCollection.delegate = self
        self.photoCollection.dataSource = self
    }
    
    
    @IBOutlet weak var containerView: CustomView!
    @IBOutlet weak var lblShimmer: UILabel!
    @IBOutlet weak var viewDeleteHistory: UIView!
    @IBOutlet weak var btnDeleteHistory: UIButton!
    @IBOutlet weak var lblJobTitle: UILabel!
    @IBOutlet weak var view2: UIView!
    @IBOutlet weak var view1: UIView!
    @IBOutlet weak var view3: UIView!
    //@IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblServiceTypeTitle2: UILabel!
    @IBOutlet weak var lblServiceType2: UILabel!
    @IBOutlet weak var lblServiceTypeTitle: UILabel!
    @IBOutlet weak var lblServiceType: UILabel!
    @IBOutlet weak var lblDetailTitle: UILabel!
    @IBOutlet weak var lblDetail: BlurredLabel!
    @IBOutlet weak var statusBackgroundView: CustomView!
    //@IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var statusLabelLeadingConstraint: NSLayoutConstraint!
    //@IBOutlet weak var lblName: UILabel!
    //@IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var imgUser: UIImageView!
    
    @IBOutlet weak var lblStatus: BlurredLabel!
    @IBOutlet weak var lblName: BlurredLabel!
    @IBOutlet weak var lblTime: BlurredLabel!
    @IBOutlet weak var lblAddress: BlurredLabel!
    
    
    var indexPath: IndexPath!
    var delegate: MyBookingsCellDelegate!
    
    override func awakeFromNib() {
        imgUser.border5(imgUser.frame.size.height/2)
        lblShimmer.superview?.border(UIColor.hexColor(0xD6D5D8), 3, 1)
    }
    
    func hideAllButtons () {
        btnDelete.isHidden = true
        btnChat.isHidden = true
        btnCall.isHidden = true
        btnRight.isHidden = true
        btnMapPin.isHidden = true
        btnCross.isHidden = true
    }
    
    @IBAction func actionCellClicked(_ sender: Any) {
        if subscriptionStatus == true {
            delegate.cellCellClicked(indexPath)
        }
    }
    
    @IBAction func actionDeleteHistory(_ sender: Any) {
        delegate.cellDeleteHistory (indexPath)
    }
    
    @IBAction func actionZoomImage(_ sender: Any) {
        if subscriptionStatus == true {
            delegate.cellZoomImage (indexPath)
        }
    }
    
    func addAddress (_ address: String, _ lat: NSNumber?, _ long: NSNumber?, handler: @escaping (String) -> Swift.Void) {
        DispatchQueue.global().async {
            let obbb = getAddressOrLatLong(lat, long, address, false)
            var str = ""
            if obbb?.city != nil {
                str = (obbb?.city)!
            }
            if obbb?.pincode != nil {
                if str.count == 0 {
                    str = (obbb?.pincode)!
                } else {
                    str = str + " " + (obbb?.pincode)!
                }
            }
            DispatchQueue.main.async {
                handler(str)
            }
        }
    }
    
    
    @IBOutlet weak var btnDelete: UIButton!
    @IBAction func actionDelete(_ sender: Any) {
        delegate.cellDelete(indexPath)
    }
    
    @IBOutlet weak var videChatCount: UIView!
    @IBOutlet weak var lblChatCount: UILabel!
    
    @IBOutlet weak var btnChat: UIButton!
    @IBOutlet weak var btnCall: UIButton!
    @IBAction func actionCall(_ sender: Any) {
        
        if subscriptionStatus == true {
            delegate.cellCall(indexPath)
        }else{
            delegate.subscriptionPOP()
        }
    }
    
    @IBAction func actionChat(_ sender: Any) {
        
        if subscriptionStatus == true {
            delegate.cellChat(indexPath)
        }else{
            delegate.subscriptionPOP()
        }
        
    }
    
    @IBOutlet weak var btnRight: UIButton!
    @IBAction func actionRight(_ sender: Any) {
        if subscriptionStatus == true {
            delegate.cellRight(indexPath)
        }else{
            delegate.subscriptionPOP()
        }
    }
    
    
    @IBOutlet weak var btnMapPin: UIButton!
    @IBAction func actionMapPin(_ sender: Any) {
        
        if subscriptionStatus == true {
            delegate.cellMapPin(indexPath)
        }else{
            delegate.subscriptionPOP()
        }
        
        
    }
    
    @IBOutlet weak var btnCross: UIButton!
    @IBAction func actionCross(_ sender: Any) {
        if subscriptionStatus == true {
            delegate.cellCross(indexPath)
        }else{
            delegate.subscriptionPOP()
        }
    }
    
    @IBOutlet weak var viewTaskDone: UIView!
    @IBOutlet weak var imgRightTaskDone: UIImageView!
    @IBOutlet weak var lblTaskDone: UILabel!
    
    @IBOutlet weak var btnTaskDone: UIButton!
    @IBAction func actionTaskDone(_ sender: Any) {
        
        if subscriptionStatus == true {
            delegate.taskDone(indexPath)
        }else{
            delegate.subscriptionPOP()
        }
        
    }
    
    func taskNotSelected () {
        viewTaskDone.border(UIColor.hexColor(0xA6A6A6), 4, 1)
        lblTaskDone.textColor = UIColor.hexColor(0x828282)
        imgRightTaskDone.image = #imageLiteral(resourceName: "Group 4346")
    }
    
    func taskSelected () {
        
        viewTaskDone.border(UIColor.hexColor(0x43AC1E), 4, 1)
        lblTaskDone.textColor = UIColor.hexColor(0x43AC1E)
        imgRightTaskDone.image = #imageLiteral(resourceName: "Group 43461")
    }
}

class photoCollection: UICollectionViewCell {
    @IBOutlet weak var Img_PlayPause: UIImageView!
    @IBOutlet weak var AlphaView: UIView!
    @IBOutlet weak var widthVal: NSLayoutConstraint!
    @IBOutlet weak var heightVal: NSLayoutConstraint!
    @IBOutlet weak var View_Card: UIView!
    @IBOutlet weak var Img_Photo: UIImageView!
}

class MyBookings: BaseVC , onPhotoClick, UpdatePurchase, PaymentLogout {
    func logoutPayment() {
        kAppDelegate.logout (self)
    }
    
    
    func updatePurchase() {
        getSubcriptionDetailsFromServer ()
    }
    
    
    func openImage(images_Upload: [images],index: Int) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "image_Video_Show") as! image_Video_Show
        vc.images_Upload = images_Upload
        vc.currentIndex = index
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    func openVideo(images_Upload: [images],index: Int) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "image_Video_Show") as! image_Video_Show
        vc.images_Upload = images_Upload
        vc.currentIndex = index
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    var boolApplePuchase = false
    var boolServerPuchase = false
    var boolDeviceUser = false
    var purchasedDeviceType = ""
    var boolSubscriptionExpiredAlert = false
    
    @IBOutlet weak var viewTab: TabBarView!
    @IBOutlet weak var headerView: HeaderView!
    @IBOutlet weak var tabBar: TabBarView!
    
    @IBOutlet weak var imgNolisting: UIImageView!
    @IBOutlet weak var lblNolisting: UILabel!
    
    @IBOutlet weak var viewOnlineOfflineRightCross: UIView!
    @IBOutlet weak var viewOblineOfflineRightCrossInner: UIView!
    @IBOutlet weak var consHtSubs: NSLayoutConstraint!
    
    @IBAction func actionOnlineOffline(_ sender: Any) {
        var online = Key_User_online.getUserValue()
        
        if online == nil {
            Key_User_online.setUserValue("0")
            online = "0"
        }
        
        if "\(online!)" == "1" {
            actionRightOnlineOffline("")
        } else {
            viewOnlineOfflineRightCross.frame = self.view.bounds
            self.view.addSubview(viewOnlineOfflineRightCross)
        }
    }
    
    @IBAction func actionCrossOnlineOffline(_ sender: Any) {
        viewOnlineOfflineRightCross.removeFromSuperview()
    }
    
    func callOnlineAPI () {
        if kAppDelegate.boolCallOnline == false {
            kAppDelegate.boolCallOnline = true
            var online = Key_User_online.getUserValue() as? String
            if online == nil {
                online = "0"
                Key_User_online.setUserValue("0")
            }
            if online == "0" {
                actionRightOnlineOffline ("")
            }
        }
    }
    
    @IBAction func actionRightOnlineOffline(_ sender: Any) {
        viewOnlineOfflineRightCross.removeFromSuperview()
        
        var online = Key_User_online.getUserValue()
        
        if online == nil {
            online = "0"
            Key_User_online.setUserValue("0")
        }
        
        let param = params()
        
        if "\(online!)" == "1" {
            param["online"] = "0"
        } else {
            param["online"] = "1"
        }
        
        Http.instance().json(api_provider_online_status, param, "POST", aai: true, popup: true, prnt: false, nil, nil, sync: false, defaultCalling: false) { (json, para, str, http, data) in
            let json = json as? NSDictionary
            if json != nil {
                if json?.number("success").intValue == 1 {
                    if "\(online!)" == "1" {
                        Key_User_online.setUserValue("0")
                    } else {
                        Key_User_online.setUserValue("1")
                    }
                }
                self.boolSubscriptionExpiredAlert = false
            }
            let jsonExp = json as? NSDictionary
            if jsonExp != nil {
                if jsonExp?.number("success").intValue == SESSIONEXPIRED {
                    kAppDelegate.sessionExpired(self)
                    return
                }
            }
        }
    }
    
    //    func setOnlineOfflineImage () {
    //        var online = Key_User_online.getUserValue()
    //
    //        if online == nil {
    //            Key_User_online.setUserValue("0")
    //            online = "0"
    //        }
    //
    //        if "\(online!)" == "1" {
    //            imgOnline.image = #imageLiteral(resourceName: "Group 4657-1")
    //        } else {
    //            imgOnline.image = #imageLiteral(resourceName: "Group 4659-1")
    //        }
    //
    //        setAddress ()
    //    }
    
    var deleteIndexPath: IndexPath!
    
    @IBOutlet var viewRaiseADispute: UIView!
    @IBOutlet weak var viewRaiseADisputeInner: UIView!
    
    @IBAction func actionRemoveViewRaiseDispute(_ sender: Any) {
        viewRaiseADispute.removeFromSuperview()
    }
    
    var indexPathRaiseADispute: IndexPath!
    var current_page = "1"
    
    @IBAction func actionSubmitRaiseDispute(_ sender: Any) {
        if tvRaiseDispute.text.count == 0 {
            self.boolSubscriptionExpiredAlert = false
            
            Http.alert("", "Please write your reason.")
        } else {
            self.viewRaiseADispute.removeFromSuperview()
            
            let ob = leadsJSON?.data[0]
            //let ob = leadsJSON?.data[indexPathRaiseADispute.row]
            
            let param = params()
            //param["job_id"] = ob?.jobPost[0].jobPostID
            param["resion"] = tvRaiseDispute.text
            
            Http.instance().json(api_provider_raise_dispute, param, "POST", aai: true, popup: true, prnt: false, nil, nil, sync: false, defaultCalling: false) { (json, para, str, http, data) in
                let json = json as? NSDictionary
                
                if json != nil {
                    if json?.number("success").intValue == 1 {
                        self.getSubcriptionDetailsFromServer ()
                        self.getListing("1")
                    }
                    self.boolSubscriptionExpiredAlert = false
                    Http.alert("", json?.string("message"))
                }
                
                let jsonExp = json as? NSDictionary
                
                if jsonExp != nil {
                    if jsonExp?.number("success").intValue == SESSIONEXPIRED {
                        kAppDelegate.sessionExpired(self)
                        return
                    }
                }
            }
        }
    }
    
    @IBOutlet weak var tvRaiseDispute: UITextView!
    @IBOutlet weak var lblPlaceHolderRaiseDispute: UILabel!
    
    func openRaiseADisputeView () {
        viewRaiseADisputeInner.border5(16)
        //indexPathRaiseADispute
        
        tvRaiseDispute.border(UIColor.hexColor(0xe8e8e8), 4, 1)
        viewRaiseADispute.frame = self.view.bounds
        self.view.addSubview(viewRaiseADispute)
    }
    
    @IBOutlet weak var tblMyBookings: UITableView!
    
    private var leftMenu  = CustomerMenuViewController()
    private var leftDrawerTransition:DrawerTransition!
    
    @IBAction func actionManu(_ sender: Any) {
        self.leftDrawerTransition.presentDrawerViewController(animated: true)
    }
    
    @IBAction func actionAddress(_ sender: Any) {
        var online = Key_User_online.getUserValue()
        
        if online == nil {
            Key_User_online.setUserValue("0")
            online = "0"
        }
        
        //if "\(online!)" == "1" {
        let vc = story_Auth.viewController("SeeTradiesArround") as! SeeTradiesArround
        self.navigationController?.pushViewController(vc, animated: true)
        //}
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if boolCurrent {
            lblNolisting.text = "New leads will appear here direct from customers"
        }else{
            lblNolisting.text = "No history found"
        }
        
        ArgAppUpdater.getSingleton().showUpdateWithConfirmation()
        viewOblineOfflineRightCrossInner.border5(16)
        initMenu ()
        SocketIOManager.shared.login()
        callOnlineAPI ()
        lblExpiry.text = "START \(kAppDelegate.purchaseTrailDays) DAYS FREE TRAIL"
        btnSubscriptionExpired.superview?.border5((btnSubscriptionExpired.superview?.frame.size.height)!/2)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.getSubcriptionDetailsFromServer ()
        
        kAppDelegate.subscribeToFirebase(true)
        kAppDelegate.boolSubscriptionExpired = false
        kAppDelegate.setPurchased()
        self.viewSubscriptionExpired.isHidden = true
        self.consHtSubs.constant = 0
        kAppDelegate.currentVC = self
        headerView.updateData()
        if boolCurrent {
            tabBar.selectedItem = 1
            actionCurrentBookings ("")
        } else {
            tabBar.selectedItem = 2
            actionHistoryBookings("")
        }
        if kAppDelegate.boolShowChangeProviderStatus {
            let ob1 = kAppDelegate.getUserAddress()
            if ob1 != nil {
                kAppDelegate.boolShowChangeProviderStatus = false
                Toast.toast("Change provider status.")
            }
        }
        getNotificationCount ()
    }
    
    var businessDetailJSON: BusinessDetailJSON?
    
    func getBusinessData () {
        let param = params()
        Http.instance().json(api_provider_get_business_detail, param, "POST", aai: false, popup: true, prnt: false, nil, nil, sync: false, defaultCalling: false) { (json, paras, str, data) in
            let jsonExp = json as? NSDictionary
            if jsonExp != nil {
                if jsonExp?.number("success").intValue == SESSIONEXPIRED {
                    kAppDelegate.sessionExpired(self)
                    return
                }
            }
            if data != nil {
                do {
                    self.businessDetailJSON = try JSONDecoder().decode(BusinessDetailJSON.self, from: data!)
                    self.setBusinessAddress()
                } catch let error {
                    print("Error: \(error)")
                }
            }
        }
    }
    
    func setBusinessAddress () {
        if businessDetailJSON?.businessData != nil {
            let address = "\(businessDetailJSON?.businessData?.houseNo ?? "") \(businessDetailJSON?.businessData?.street ?? "") \(businessDetailJSON?.businessData?.city ?? "") \(businessDetailJSON?.businessData?.state ?? "") \(businessDetailJSON?.businessData?.country ?? "") \(businessDetailJSON?.businessData?.pincode ?? "")"
            
            print("address-\(address)-")
            
            let addd = getAddressOrLatLong(nil, nil, address, false)
            
            let ob1 = Addresses("")
            
            ob1.locationName = "Home"
            ob1.address = address
            
            ob1.city = businessDetailJSON?.businessData?.city
            ob1.country = businessDetailJSON?.businessData?.country
            ob1.state = businessDetailJSON?.businessData?.state
            
            if addd != nil {
                if addd?.lat != nil && addd?.long != nil {
                    ob1.latitude = "\((addd?.lat)!)"
                    ob1.longitude = "\((addd?.long)!)"
                }
            }
            
            kAppDelegate.setUserAddressBusiness(ob1)
        }
    }
    
    func setAddress () {
        var online = Key_User_online.getUserValue()
        
        if online == nil {
            Key_User_online.setUserValue("0")
            online = "0"
        }
        
        if "\(online!)" == "1" {
            let ob = kAppDelegate.getUserAddress()
            
            if ob != nil {
                //                lblAddress.text = ob?.address
            } else {
                //                lblAddress.text = "Please select address"
                
                kAppDelegate.setLocationCurrentAddress ()
                
                setLocationCurrentAddress ()
            }
        } else {
            let ob = kAppDelegate.getUserAddressBusiness()
            
            if ob != nil {
                //                lblAddress.text = ob?.address
            }
        }
    }
    
    func setLocationCurrentAddress () {
        var online = Key_User_online.getUserValue()
        
        if online == nil {
            Key_User_online.setUserValue("0")
            online = "0"
        }
        
        if "\(online!)" == "1" {
            let ob = kAppDelegate.getUserAddress()
            
            if ob != nil {
                //                lblAddress.text = ob?.address
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //setAddress ()
        if boolCurrent {
            kAppDelegate.setSelectedTabbar(1)
        } else {
            kAppDelegate.setSelectedTabbar(3)
        }
        getSubcriptionDetailsFromServer()
    }
    
    func showSubscriptionPopup (_ title: String, _ msg: String) {
        AlertView.instance.present(title, msg) { (result) in
            if result == "actionSendReceiptToServer" {
                let md = NSMutableDictionary()
                
                var recpt = "receipt not available"
                
                if let receiptFileURL = Bundle.main.appStoreReceiptURL {
                    let receiptData = try? Data(contentsOf: receiptFileURL)
                    
                    if let recieptString = receiptData?.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0)) {
                        recpt = recieptString
                    }
                }
                
                md["receipt"] = recpt
                
                self.saveReceiptDataToServer (md)
            }
        }
    }
    
    var boolCurrent = true
    
    @IBAction func actionCurrentBookings(_ sender: Any) {
        boolCurrent = true
        print("Call One")
        getSubcriptionDetailsFromServer ()
        DispatchQueue.main.asyncAfter(deadline: .now()+1) {
            self.getListing("1")
        }
    }
    
    @IBAction func actionHistoryBookings(_ sender: Any) {
        boolCurrent = false
        getSubcriptionDetailsFromServer ()
        DispatchQueue.main.asyncAfter(deadline: .now()+1) {
            self.getListing("1")
        }
    }
    
    var arrShimmer: [String] = []
    
    func getListing (_ page: String) {
        if page == "1" {
            arrShimmer = ["", "", "", "", "", "", "", "", "", "", "", "", ""]
            self.tblMyBookings.reloadData()
            self.leadsJSON = nil
        }
        //MARK: Check Here ---
        current_page = page
        kAppDelegate.sendAddressToServer ()
        let param = params()
        self.leadsJSON?.data.removeAll()
        if boolCurrent {
            lblNolisting.text = "New leads will appear here direct from customers"
        }else{
            lblNolisting.text = "No history found"
        }
        
        if boolCurrent {
            param["lead_type"] = "new"
        } else {
            param["lead_type"] = "history"
        }
        param["page"] = page
        //MARK: Check Here ---
        Http.instance().json(api_provider_leads, param, "POST", aai: false, popup: true, prnt: false, nil, nil, sync: false, defaultCalling: false) { (json, para, str, http, data) in
            let jsonExp = json as? NSDictionary
            print(jsonExp)
            if jsonExp != nil {
                if let chatshowStatus = jsonExp?.string("chatshow") {
                    print(chatshowStatus)
                    chatshowValue = chatshowStatus
                }
                if jsonExp?.number("success").intValue == SESSIONEXPIRED {
                    kAppDelegate.sessionExpired(self)
                    return
                }
            }
            if data != nil {
                do {
                    let self_leadsJSON = try JSONDecoder().decode(LeadsJSON.self, from: data!)
                    print(self_leadsJSON)
                    if self_leadsJSON != nil && self_leadsJSON.data != nil {
                        if (self_leadsJSON.data.count) == 0 {
                            self.downloading = .noData
                        }
                    }
                    if self_leadsJSON != nil && self.leadsJSON == nil {
                        self.leadsJSON = self_leadsJSON
                        self.leadsJSON = LeadsJSON(success: self_leadsJSON.success, data: [])
                        for i in 0..<(self_leadsJSON.data.count) {
                            let obb = self_leadsJSON.data[i]
                            if obb.status != "deleted" {
                                self.leadsJSON?.data.append((self_leadsJSON.data[i]))
                            }
                        }
                    } else if self_leadsJSON != nil && self.leadsJSON != nil {
                        /*for i in 0..<(self_leadsJSON.data.count) {
                         self.leadsJSON?.data.append((self_leadsJSON.data[i]))
                         }*/
                        print(self_leadsJSON.data.count)
                        for i in 0..<(self_leadsJSON.data.count) {
                            let obb = self_leadsJSON.data[i]
                            if obb.status != "deleted" {
                                self.leadsJSON?.data.append((self_leadsJSON.data[i]))
                            }
                        }
                    }
                    if self.downloading != .noData {
                        self.downloading = .canDownload
                    }
                    self.arrShimmer = []
                    self.tblMyBookings.reloadData()
                } catch let error {
                    print("1Error: \(error)")
                }
            }
        }
    }
    
    var leadsJSON: LeadsJSON?
    
    //MARK: - Task Done popup start
    
    @IBOutlet var viewTaskDoneAlert: UIView!
    @IBOutlet var viewInnerTaskDoneAlert: UIView!
    
    func addTaskDoneAlert () {
        viewInnerTaskDoneAlert.border5(16)
        
        viewTaskDoneAlert.frame = UIScreen.main.bounds
        self.view.addSubview(viewTaskDoneAlert)
    }
    
    var indexPathTaskDone: IndexPath!
    
    @IBAction func actionAlertDoneTask(_ sender: Any) {
        viewTaskDoneAlert.removeFromSuperview()
        
        callAction("completed", indexPathTaskDone)
    }
    
    @IBAction func actionAlertDoneTaskCancel(_ sender: Any) {
        viewTaskDoneAlert.removeFromSuperview()
    }
    
    //MARK: - Task Done popup end
    
    var downloading: Downloading = .canDownload
    
    //MARK: - Delete History
    
    func addDeleteHistoryView () {
        btnOkDeleteHistory.superview?.border5(16)
        
        viewDeleteHistory.frame = UIScreen.main.bounds
        self.view.addSubview(viewDeleteHistory)
    }
    
    @IBOutlet var viewDeleteHistory: UIView!
    @IBOutlet weak var btnOkDeleteHistory: UIButton!
    
    @IBAction func actionCancelDeleteHistory(_ sender: Any) {
        viewDeleteHistory.removeFromSuperview()
    }
    
    @IBAction func actionOkDeleteHistory(_ sender: Any) {
        viewDeleteHistory.removeFromSuperview()
        
        cellDeleteHistoryFromOk(IndexPath(row: btnOkDeleteHistory.tag, section: 0))
    }
    
    @IBOutlet var viewSubscriptionExpired: UIView!
    @IBOutlet var btnSubscriptionExpired: UIButton!
    
    @IBOutlet weak var lblExpiry: UILabel!
    
    @IBAction func actionSubscriptionExpired (_ sender: Any) {
        let vc = story_Payment.viewController("ChooseSubscripiton") as? ChooseSubscripiton
        vc?.boolFromMenu = false
        vc?.boolDeviceUser = boolDeviceUser
        self.navigationController?.pushViewController(vc!, animated: false)
    }
    
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
        let ob = leadsJSON?.data[indexPath.row]
        
        if ob?.uid == nil {
            return
        }
        
        let url = "\(Server)profile/\((ob?.uid)!)/\((ob?.profilePic)!)"
        
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
    
    //MARK: - Notification count
    
    func getNotificationCount () {
        //        self.lblNotificationCount.superview?.isHidden = true
        
        let param = params()
        
        Http.instance().json(api_get_unread_notification_count, param, "POST", aai: false, popup: false, prnt: false, nil, nil, sync: false, defaultCalling: false) { (json, paras, str, data) in
            
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
                    let badge_count = json?.number("badge_count").intValue
                    
                    if badge_count != nil {
                        kAppDelegate.badgeCount(badge_count!)
                    }
                    
                    let notification_count = json?.number("notification_count").intValue
                    
                    if notification_count != nil {
                        if notification_count! > 0 {
                            //                            self.lblNotificationCount.superview?.isHidden = false
                            //                            self.lblNotificationCount.text = json?.string("notification_count")
                        }
                    }
                    
                }
            }
        }
    }
    
    @IBAction func actionNotificationList (_ sender: Any) {
        let vc = story_Home.viewController("Notifications") as! Notifications
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

//MARK: - Subcription detail from server

extension MyBookings: ImageScrollViewDelegate {
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

extension MyBookings: DrawerTransitionDelegate, SideMenuDelegate {
    
    func initMenu () {
        leftMenu = story_Home.viewController("CustomerMenuViewController") as! CustomerMenuViewController
        leftMenu.delegate = self
        self.leftDrawerTransition = DrawerTransition(target: self, drawer: leftMenu)
        self.leftDrawerTransition.setPresentCompletion {  }
        self.leftDrawerTransition.setDismissCompletion {  }
        self.leftDrawerTransition.edgeType = .left
    }
    
    func menuClicked (_ vc: String) {
        if vc == Key_Menu_VC_RateReview {
            let vc = story_Tradie.viewController("RateNReview") as! RateNReview
            self.navigationController?.pushViewController(vc, animated: true)
        } else if vc == Key_Menu_VC_AboutUs {
            let vc = story_Home.viewController("WebPage") as! WebPage
            vc.linkType = .aboutus
            self.navigationController?.pushViewController(vc, animated: true)
        } else if vc == Key_Menu_VC_TermsCondition {
            let vc = story_Home.viewController("WebPage") as! WebPage
            vc.linkType = .termsncondition
            self.navigationController?.pushViewController(vc, animated: true)
        } else if vc == Key_Menu_VC_PrivacyPolicy {
            let vc = story_Home.viewController("WebPage") as! WebPage
            vc.linkType = .privacypolicy
            self.navigationController?.pushViewController(vc, animated: true)
        } else if vc == Key_Menu_VC_Logout {
            kAppDelegate.logout (self)
        } else if vc == Key_Menu_VC_Payment {
            let vc = story_Home.viewController("Help")
            //let vc = story_Payment.viewController("ChooseSubscripiton")
            self.navigationController?.pushViewController(vc!, animated: false)
        } else if vc == Key_Menu_VC_InviteFriends {
            let vc = story_Payment.viewController("InviteFriends")
            self.navigationController?.pushViewController(vc!, animated: false)
        }else if vc == Key_Menu_VC_Support {
            let vc = story_Home.viewController("SupportVC")
            self.navigationController?.pushViewController(vc!, animated: false)
        }else if vc == Key_Menu_VC_HowItWork {
            
            let vc = story_Payment.viewController("HowItWork_Screen")
            self.navigationController?.pushViewController(vc!, animated: false)
        }else if vc == Key_Menu_VC_FAQ {
            let vc = story_Payment.viewController("FrequentlyAskedQuestion")
            self.navigationController?.pushViewController(vc!, animated: false)
        }
    }
}

extension MyBookings: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if arrShimmer.count > 0 {
            return 128
        }
        
        return UITableView.automaticDimension//tblMyBookings.estimatedRowHeight
        
        let obb = leadsJSON?.data[indexPath.row]
        
        if obb?.isSelected == nil {
            obb?.isSelected = false
        }
        
        if obb?.isSelected == false {
            let type = getType (obb!)
            
            switch type {
            case .waittouseraccept:
                //cell.lblStatus.text = "pending".uppercased()
                //cell.btnDelete.isHidden = true
                return 185
                break
            case .needtoacceptreject:
                //cell.lblStatus.text = "pending".uppercased()
                //cell.btnRight.isHidden = false
                //cell.btnCross.isHidden = false
                return 185
                break
            case .acceptedbyboth_confirm:
                //cell.lblStatus.text = "confirmed".uppercased()
                //cell.btnMapPin.isHidden = false
                //cell.btnCall.isHidden = false
                return 185
                break
            case .waitcompletebyuser:
                //cell.lblStatus.text = "confirmed".uppercased()
                //cell.btnMapPin.isHidden = false
                //cell.btnCall.isHidden = false
                return 185
                break
            case .userrejected:
                //cell.lblStatus.text = "rejected".uppercased()
                break
            case .rejectedbyme:
                //cell.lblStatus.text = "rejected".uppercased()
                break
            case .jobcompleted:
                //cell.lblStatus.text = "completed".uppercased()
                break
            case .desputed:
                //cell.lblStatus.text = "desputed".uppercased()
                break
            default:
                break
            }
        } else {
            return tblMyBookings.estimatedRowHeight
        }
        
        return 160
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if arrShimmer.count > 0 {
            lblNolisting.isHidden = true
            imgNolisting.isHidden = lblNolisting.isHidden
            return arrShimmer.count
        }
        
        var count = 0
        
        if leadsJSON?.data != nil {
            count = (leadsJSON?.data.count)!
        }
        
        if count == 0 {
            lblNolisting.isHidden = false
        } else {
            lblNolisting.isHidden = true
        }
        
        imgNolisting.isHidden = lblNolisting.isHidden
        
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //MARK: Check Data Here
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyBookingsCell") as! MyBookingsCell
        
        cell.videChatCount.layer.cornerRadius = cell.videChatCount.frame.height/2
            
        //cell.lblChatCount.text = ""
        
        if arrShimmer.count > 0 {
            cell.lblShimmer.superview?.isHidden = false
            cell.lblShimmer.isHidden = false
            cell.containerView.isHidden = true
            cell.lblShimmer.startShimmeringEffect()
            return cell
        } else {
            cell.lblShimmer.superview?.isHidden = true
            cell.lblShimmer.isHidden = true
            cell.containerView.isHidden = false
            cell.lblShimmer.stopShimmeringEffect ()
        }
        
        print("For Check")
        
        print("Image Count:",leadsJSON?.data[indexPath.row].images.count ?? 0)
        if subscriptionStatus == true {
            if (leadsJSON?.data[indexPath.row].images.count ?? 0) > 3 {
                    cell.PhotoHeight.constant = 260
            }else if (leadsJSON?.data[indexPath.row].images.count ?? 0) == 0 {
                cell.PhotoHeight.constant = 0
            }else{
                cell.PhotoHeight.constant = 150
            }
        }else{
            cell.PhotoHeight.constant = 0
        }
       
        
        
        cell.btnMapPin.isHidden = true
        cell.btnChat.isHidden = true
        cell.videChatCount.isHidden = true
        cell.btnCall.isHidden = true
        cell.btnCross.isHidden = true
        cell.btnRight.isHidden = true
        cell.btnDelete.isHidden = true
        
        cell.btnRight.clipsToBounds = true
        cell.btnRight.layer.cornerRadius = 5
        
        cell.btnCross.clipsToBounds = true
        cell.btnCross.layer.cornerRadius = 5
        
        
        let obb = leadsJSON?.data[indexPath.row]
        
        print("UUUUUUUUUUUUU)))))))))))______________",obb?.unreadmessage)
        if obb?.unreadmessage != nil {
            print(obb?.unreadmessage)
            cell.lblChatCount.text = "\(obb?.unreadmessage ?? 0)"
        }
        
        if obb?.isSelected == nil {
            obb?.isSelected = false
        }
        cell.delegateNew = self
        cell.lblJobTitle.text = obb?.title
        cell.dele()
        
        //MARK: - Is Slected Condition Change
        if subscriptionStatus == true {
            cell.lblDetail.isHidden = false
            cell.lblDetailTitle.isHidden = false
            cell.lblServiceTypeTitle.isHidden = false
            cell.lblServiceType.isHidden = false
            cell.lblServiceTypeTitle2.isHidden = false
            cell.lblServiceType2.isHidden = false
            cell.lblServiceType.text = "NA"
            if obb?.serviceName != nil {
                if obb!.serviceName.count > 0 {
                    cell.lblServiceType.text = obb?.serviceName.capFirstLetter()
                }
            }
            cell.lblServiceType2.text = "NA"
            if obb?.tradieType != nil {
                if obb!.tradieType.count > 0 {
                    cell.lblServiceType2.text = obb?.tradieType.capFirstLetter()
                }
            }
            print(leadsJSON?.data[indexPath.row].images ?? [])
            cell.images_Upload = leadsJSON?.data[indexPath.row].images ?? []
            cell.View_Collection.isHidden = false
            cell.photoCollection.reloadData()
            cell.view2.isHidden = false
        }else{
            cell.lblDetail.isHidden = false
            cell.lblDetailTitle.isHidden = false
            cell.lblServiceTypeTitle.isHidden = false
            cell.lblServiceType.isHidden = false
            cell.lblServiceTypeTitle2.isHidden = false
            cell.lblServiceType2.isHidden = false
            cell.lblServiceType.text = "NA"
            if obb?.serviceName != nil {
                if obb!.serviceName.count > 0 {
                    cell.lblServiceType.text = obb?.serviceName.capFirstLetter()
                }
            }
            cell.lblServiceType2.text = "NA"
            if obb?.tradieType != nil {
                if obb!.tradieType.count > 0 {
                    cell.lblServiceType2.text = obb?.tradieType.capFirstLetter()
                }
            }
            print(leadsJSON?.data[indexPath.row].images ?? [])
            cell.images_Upload = leadsJSON?.data[indexPath.row].images ?? []
            cell.View_Collection.isHidden = false
            cell.photoCollection.reloadData()
            cell.view2.isHidden = false
        }
        
//        if (obb?.isSelected)! {
//
//
//            if subscriptionStatus == true {
//                cell.lblDetail.isHidden = false
//                cell.lblDetailTitle.isHidden = false
//                cell.lblServiceTypeTitle.isHidden = false
//                cell.lblServiceType.isHidden = false
//                cell.lblServiceTypeTitle2.isHidden = false
//                cell.lblServiceType2.isHidden = false
//                cell.lblServiceType.text = "NA"
//                if obb?.serviceName != nil {
//                    if obb!.serviceName.count > 0 {
//                        cell.lblServiceType.text = obb?.serviceName.capFirstLetter()
//                    }
//                }
//                cell.lblServiceType2.text = "NA"
//                if obb?.tradieType != nil {
//                    if obb!.tradieType.count > 0 {
//                        cell.lblServiceType2.text = obb?.tradieType.capFirstLetter()
//                    }
//                }
//                print(leadsJSON?.data[indexPath.row].images ?? [])
//                cell.images_Upload = leadsJSON?.data[indexPath.row].images ?? []
//                cell.View_Collection.isHidden = false
//                cell.photoCollection.reloadData()
//                cell.view2.isHidden = false
//            }else{
//                cell.lblDetail.isHidden = false
//                cell.lblDetailTitle.isHidden = false
//                cell.lblServiceTypeTitle.isHidden = false
//                cell.lblServiceType.isHidden = false
//                cell.lblServiceTypeTitle2.isHidden = false
//                cell.lblServiceType2.isHidden = false
//                cell.lblServiceType.text = "NA"
//                if obb?.serviceName != nil {
//                    if obb!.serviceName.count > 0 {
//                        cell.lblServiceType.text = obb?.serviceName.capFirstLetter()
//                    }
//                }
//                cell.lblServiceType2.text = "NA"
//                if obb?.tradieType != nil {
//                    if obb!.tradieType.count > 0 {
//                        cell.lblServiceType2.text = obb?.tradieType.capFirstLetter()
//                    }
//                }
//                print(leadsJSON?.data[indexPath.row].images ?? [])
//                cell.images_Upload = leadsJSON?.data[indexPath.row].images ?? []
//                cell.View_Collection.isHidden = false
//                cell.photoCollection.reloadData()
//                cell.view2.isHidden = false
//            }
//        } else {
//            if subscriptionStatus == true {
//                cell.View_Collection.isHidden = true
//                cell.view2.isHidden = true
//                cell.lblDetail.isHidden = true
//                cell.lblDetailTitle.isHidden = true
//                cell.lblServiceTypeTitle.isHidden = true
//                cell.lblServiceType.isHidden = true
//
//                cell.lblServiceTypeTitle2.isHidden = true
//                cell.lblServiceType2.isHidden = true
//            }else{
//                cell.View_Collection.isHidden = false
//                cell.view2.isHidden = false
//                cell.lblDetail.isHidden = false
//                cell.lblDetailTitle.isHidden = false
//                cell.lblServiceTypeTitle.isHidden = false
//                cell.lblServiceType.isHidden = false
//                cell.lblServiceTypeTitle2.isHidden = false
//                cell.lblServiceType2.isHidden = false
//            }
//        }
        
        if (obb?.isSelected)! {
            cell.lblDetail.text = obb?.detail
        } else {
            cell.lblDetail.text = ""
        }
        
        cell.lblDetail.text = obb?.detail
        
        cell.indexPath = indexPath
        cell.delegate = self
        
        let ob = obb
        print(obb)
        cell.lblName.text = ob?.fullName?.capFirstLetter()
        cell.lblStatus.text = ob?.userStatus?.uppercased()
        cell.lblTime.text = ""
        
        if (obb?.date.count)! > 0 && (obb?.time.count)! > 0 {
            let arr = obb?.date.components(separatedBy: "T")
            
            if arr != nil {
                if arr!.count == 2 {
                    let newDate = "\(arr![0]) \((obb?.time)!)"
                    
                    let dd = newDate.converDate("yyyy-MM-dd HH:mm:ss", "dd")
                    let hh = newDate.converDate("yyyy-MM-dd HH:mm:ss", "hh:mm a")
                    let mmm = newDate.converDate("yyyy-MM-dd HH:mm:ss", "MMM, yyyy")
                    
                    cell.lblTime.text = "\(get12HourTime(hh)) on \(dd)th \(mmm)"
                }
            }
        }
        
        cell.lblAddress.text = "N/A"
        
        if (ob?.userStatus)! == "pending" || (ob?.providerStatus)! == "pending" {
            if ob?.latitude != nil && ob?.longitude != nil {
                if ob?.latitude.count != 0 && ob?.longitude.count != 0 {
                    cell.addAddress((ob?.address)!, NSNumber(value: Float((ob?.latitude)!)!), NSNumber(value: Float((ob?.longitude)!)!)) { (str) in
                        print("pending")
                        //cell.lblAddress.text = ob?.address//str
                        cell.lblAddress.text = "\(ob?.city ?? ""), \(ob?.state ?? ""), \(ob?.country ?? ""), \(ob?.postcode ?? "")"
                    }
                }
            } else {
                cell.addAddress((ob?.address)!, nil, nil) { (str) in
                    cell.lblAddress.text = ob?.address//str
                }
            }
        } else {
            cell.lblAddress.text = ob?.address
        }
        
        if let uid = ob?.uid, let imageName = ob?.profilePic {
            let url = "\(Server)profile/\(uid)/\(imageName)"
            if subscriptionStatus == true {
                
                cell.imgUser.uiimage(url, "Group 2826", true, nil)
            }else{
                if let urlValue = URL(string: url) {
                    cell.imgUser.downloadAndDisplayImage(from: urlValue)
                }
                
            }
        }
        
       
        
        if obb?.isCellCalled == nil {
            obb?.isCellCalled = false
        }
        
        if obb != nil {
            showButton(cell, obb!, indexPath)
        }
        
        let total_cell = (leadsJSON?.data.count)!
        
        let rows = 15
        if indexPath.row == (total_cell - 1) {
            if downloading == .canDownload {
                if total_cell % rows == 0 {
                    let page = total_cell / rows
                    downloading = .downloading
                    getListing ("\(page + 1)")
                }
            }
        }
        
        if boolCurrent {
            cell.btnDeleteHistory.isHidden = true
            cell.viewDeleteHistory.isHidden = true
        } else {
            cell.btnDeleteHistory.isHidden = false
            cell.viewDeleteHistory.isHidden = false
            if cell.lblStatus.text?.lowercased() == "DISPUTED".lowercased() {
                cell.btnDeleteHistory.isHidden = true
                cell.viewDeleteHistory.isHidden = true
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now(), execute: {
            if subscriptionStatus == true {
                cell.lblStatus.unblur()
                cell.lblName.unblur()
                cell.lblTime.unblur()
                cell.lblAddress.unblur()
                cell.lblDetail.unblur()
            }else{
                cell.lblServiceType.text = "NA"
                if obb?.serviceName != nil {
                    if obb!.serviceName.count > 0 {
                        cell.lblServiceType.text = obb?.serviceName.capFirstLetter()
                    }
                }
                
                cell.lblServiceType2.text = "NA"
                if obb?.tradieType != nil {
                    if obb!.tradieType.count > 0 {
                        cell.lblServiceType2.text = obb?.tradieType.capFirstLetter()
                    }
                }
                
                cell.lblDetail.text = obb?.detail
                if (self.leadsJSON?.data.count ?? 0) > 0 {
                    
                    cell.lblStatus.clipsToBounds = true
                    cell.lblName.clipsToBounds = true
                    cell.lblTime.clipsToBounds = true
                    cell.lblAddress.clipsToBounds = true
                    cell.lblDetail.clipsToBounds = true
                    
                    cell.lblStatus.blur()
                    cell.lblName.blur()
                    cell.lblTime.blur()
                    cell.lblAddress.blur()
                    cell.lblDetail.blur()
                }
            }
        }) 
        
        return cell
    }
    
    func showButton (_ cell: MyBookingsCell, _ leads: Leads, _ indexPath: IndexPath) {
        cell.btnMapPin.isHidden = true
        cell.btnChat.isHidden = true
        cell.videChatCount.isHidden = true
        cell.btnCall.isHidden = true
        cell.btnCross.isHidden = true
        cell.btnRight.isHidden = true
        cell.btnDelete.isHidden = true
        cell.viewTaskDone.isHidden = true
        
        let type = getType (leads)
        
        cell.view3.isHidden = true
        cell.statusBackgroundView.isHidden = true
        cell.statusLabelLeadingConstraint.constant = 15
        
        switch type {
        case .adminsetteled:
            cell.lblStatus.text = "Settled".uppercased()
            break
        case .waittouseraccept:
            cell.lblStatus.text = "pending".uppercased()
            print("PPPPPPPPP------")
            if chatshowValue == "1" {
                cell.btnChat.isHidden = false
                cell.videChatCount.isHidden = false
            }
           
            //cell.view3.isHidden = false
            
            break
        case .needtoacceptreject:
            cell.lblStatus.text = "new lead".uppercased()
            cell.statusBackgroundView.isHidden = false
            cell.statusLabelLeadingConstraint.constant = 25
            cell.btnRight.isHidden = false
            cell.btnCross.isHidden = false
            cell.view3.isHidden = false
            break
        case .acceptedbyboth_confirm:
            cell.lblStatus.text = "confirmed".uppercased()
            cell.btnMapPin.isHidden = false
            if chatshowValue == "1" {
                cell.btnChat.isHidden = false
                cell.videChatCount.isHidden = false
            }
            
            cell.btnCall.isHidden = false
            cell.viewTaskDone.isHidden = false
            cell.taskNotSelected()
            cell.view3.isHidden = false
            break
        case .waitcompletebyuser:
            cell.lblStatus.text = "completed".uppercased()
            break
        case .userrejected:
            cell.lblStatus.text = "declined".uppercased()
            break
        case .rejectedbyme:
            cell.lblStatus.text = "rejected".uppercased()
            break
        case .jobcompleted:
            cell.lblStatus.text = "completed".uppercased()
            break
        case .desputed:
            cell.lblStatus.text = "disputed".uppercased()
            break
        default:
            break
        }
        cell.lblStatus.textColor = getStatusColor((cell.lblStatus.text?.lowercased())!)
        return
    }
    
    func getType (_ leads: Leads) -> Stats_MyBooking {
        var dispute = 0
        
        if Int(leads.dispute) == 1 {
            dispute = 1
        }
        
        let ob = leads
        
        if dispute == 0 {
            if ob.status! == "cancel" {
                //type = "decline" // rejected by user
                return .adminsetteled
            } else if ob.providerStatus! == "reject" {
                //type = "decline" // rejected by user
                return .userrejected
            } else if ob.providerStatus! == "accept" && ob.userStatus! == "pending" {
                //type = "pending" //  wait for user to accept
                return .waittouseraccept
            } else if ob.providerStatus! == "pending" && ob.userStatus! == "pending" {
                //type = "pending" // show accept and reject button
                return .needtoacceptreject
            } else if ob.providerStatus! == "pending" && ob.userStatus! == "reject" {
                //type = "decline" // rejected by user
                return .userrejected
            } else if ob.providerStatus! == "accept" && ob.userStatus! == "reject" {
                //type = "decline" // rejected by user
                return .userrejected
            } else if ob.providerStatus! == "accept" && ob.userStatus! == "accept" {
                //type = "accepted" // need to show complete button
                return .acceptedbyboth_confirm
            } else if ob.providerStatus! == "completed" && ob.userStatus! == "accept" {
                //type = "provider_competed" // provider has been complete
                return .waitcompletebyuser
            } else if ob.providerStatus! == "pending" && ob.userStatus! == "accept" {
                //type = "pending" // show accept and reject button
                return .needtoacceptreject
            } else if ob.providerStatus! == "reject" && ob.userStatus! == "accept" {
                //type = "decline" // rejected by tradie
                return .rejectedbyme
            } else if ob.providerStatus! == "completed" && ob.userStatus! == "completed" {
                //type = "both_competed" // complete by both
                return .jobcompleted
            } else if ob.providerStatus! == "completed" && ob.userStatus! == "deleted" {
                //type = "both_competed" // complete by both
                return .jobcompleted
            }
        } else {
            if ob.providerStatus! == "completed" && ob.userStatus! == "completed" {
                //type = "both_competed"
                return .jobcompleted
            } else {
                //type = "disputed"
                return .desputed
            }
        }
        
        return .none
    }
}

extension MyBookings: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, TabbarCellDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return kAppDelegate.tabItems().count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TabbarCell", for: indexPath) as! TabbarCell
        cell.indexPath = indexPath
        cell.delegate = self
        
        let dt = kAppDelegate.tabItems()[indexPath.row] as! NSMutableDictionary
        
        if dt.number("isselected").boolValue {
            cell.imgCell.image = (dt["selected"] as! UIImage)
            cell.lblTitle.textColor = UIColor.hexColor(0xEF4136)
        } else {
            cell.imgCell.image = (dt["unselected"] as! UIImage)
            cell.lblTitle.textColor = UIColor.hexColor(0x707070)
        }
        
        cell.lblTitle.text = dt["title"] as? String
        
        if kAppDelegate.tabItems().count == (indexPath.row + 1) {
            cell.lblBorder.isHidden = true
        } else {
            cell.lblBorder.isHidden = false
        }
        
        if indexPath.row == 1 || indexPath.row == 2 {
            cell.lblBorder.isHidden = true
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let hh: CGFloat = 60
        return CGSize(width: hh, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    func tabbarClickedAt(_ indexPath: IndexPath) {
        kAppDelegate.tabbarClicked(indexPath, self.navigationController)
    }
}

//MARK: - Payment decision

extension MyBookings {
    func saveReceiptDataToServer (_ md: NSMutableDictionary) {
        //print("Harish md-[\(md)]-")
        
        let param = params()
        
        param["expires_date"] = "0"
        param["original_purchase_date"] = "0"
        param["json"] = "0"
        
        param["pending_renewal_info"] = "pending_renewal_info"
        param["expiration_intent"] = "expiration_intent"
        
        param["pending_renewal_info_any"] = "pending_renewal_info_any"
        param["pending_renewal_info"] = "pending_renewal_info"
        param["expiration_intent"] = "expiration_intent"
        //param["expiration_intent"] = "342"
        param["expires_date"] = "expires_date"
        param["original_purchase_date"] = "original_purchase_date"
        param["transaction_id"] = "transaction_id"
        
        if param["uid"] == nil {
            param["uid"] = "0"
        }
        
        if param["latitude"] == nil {
            param["latitude"] = "0"
        }
        
        if param["longitude"] == nil {
            param["longitude"] = "0"
        }
        
        param["reciept_data"] = "reciept_data"
        param["subscription_type"] = "subscription_type"
        param["start_date"] = Int(Date().timeStamp())
        param["end_date"] = Int(Date().timeStamp())
        param["apple_reciept_data"] = "apple_reciept_data"
        param["trail_type"] = "trail"
        
        param["subscription_type"] = "-[\(md)]-"
        
        Http.instance().json(api_save_purchase_history, param, "POST", aai: false, popup: false, prnt: false, nil, nil, sync: false, defaultCalling: true) { (json, para, ss, ht, data) in
            //print("2Harish json-\(json)-")
        }
    }
    
    func verifyReceipt(completion: @escaping (VerifyReceiptResult) -> Void) {
        SwiftyStoreKit.verifyReceipt(using: appleValidator, completion: completion)
    }
    
    func otherUserWork () {
        if self.boolDeviceUser == false {
            self.viewSubscriptionExpired.isHidden = true
            self.consHtSubs.constant = 0
        }
    }
    
    func purchsed () {
        DispatchQueue.main.async {
            Http.stopActivityIndicator()
            
            self.consHtSubs.constant = 0
            
            kAppDelegate.boolSubscriptionExpired = false
            kAppDelegate.setPurchased()
            
            print("purchased")
        }
    }
    
    func notPurchsed (status:String = "") {
        DispatchQueue.main.async {
            Http.stopActivityIndicator()
            
            
            
            if status == "end"{
                self.viewSubscriptionExpired.isHidden = true
            }else{
                //MARK: InAppPurchase - Uncomment bottom and comment the true condition - Himanshu Jangid
                //self.viewSubscriptionExpired.isHidden = false
                self.viewSubscriptionExpired.isHidden = true
            }
            
            //            self.viewSubscriptionExpired.isHidden = false
            //self.consHtSubs.constant = 48
            self.consHtSubs.constant = 0
            kAppDelegate.boolSubscriptionExpired = true
            
            //            self.lblExpiry.text = "SUBSCRIBE NOW"
            
            self.lblExpiry.text = "Start 30 days free trial"
            
            //            self.otherUserWork ()
            
            print("45purchase now")
        }
    }
    
    func sendPurchaseDataToServer (_ receipt: NSDictionary, _ dt: NSDictionary) {
        print("receipt-[\(receipt)]-")
        
        let notify_type = "INITIAL_SETUP"
        
        let expires_date_ms = dt.number("expires_date_ms").intValue
        let sevendays = 60 * 60 * 24 * 7
        
        let param = params()
        param["customer_id"] = dt.string("original_transaction_id")
        
        kAppDelegate.setOriginalTransactionId(dt.string("original_transaction_id"))
        
        param["purchase_start_date"] = expires_date_ms - sevendays
        param["purchase_end_date"] = expires_date_ms
        param["sevendays"] = sevendays
        
        if dt.string("is_trial_period") == "false" {
            param["is_trial"] = "0"
        } else {
            param["is_trial"] = "1"
        }
        
        param["notify_type"] = notify_type
        param["transaction_id"] = dt.string("transaction_id")
        param["product_id"] = dt.string("product_id")
        param["environment"] = receipt.string("environment")
        param["raw_data"] = "\(receipt)"
        
        //print("param-[\(param)]-")
        
        Http.instance().json(api_ios_purchase_membership, param, "POST", aai: false, popup: false, prnt: true, nil, nil, sync: false, defaultCalling: true) { (json, para, ss, ht, data) in
            print("3Harish json-\(json)-")
            
        }
    }
    
}

extension MyBookings: SKRequestDelegate {
    func requestDidFinish(_ request: SKRequest) {
        //print("1 requestDidFinish-[\(request)]-")
    }
    
    func request(_ request: SKRequest, didFailWithError error: Error) {
        //print("2 request didFailWithError-[\(request)]-[\(error)]-")
        
        if kAppDelegate.allowTestingPopup() {
            self.showSubscriptionPopup ("Popup 13", "-[\(request)]-[\(error)]-")
        }
    }
    
    func refreshReceipt () {
        let refreshReceiptRequest = SKReceiptRefreshRequest(receiptProperties: nil)
        
        refreshReceiptRequest.delegate = self
        
        refreshReceiptRequest.start()
    }
}

extension MyBookings {
    func getAddressFromServer () {
        let param = params()
        Http.instance().json(api_tradie_online_address, param, "POST", aai: false, popup: false, prnt: false, nil, nil, sync: false, defaultCalling: true) { (json, para, ss, ht, data) in
            //print("3111 Harish json-\(json)-")
            
            if let json = json as? NSDictionary {
                if let data = json["data"] as? NSArray {
                    for i in 0..<data.count {
                        if let dt = data[i] as? NSDictionary {
                            
                            let latitude = dt.string("latitude")
                            let longitude = dt.string("longitude")
                            let online_address = dt.string("online_address")
                            
                            let ob = Addresses("")
                            ob.address = online_address
                            ob.latitude = latitude
                            ob.longitude = longitude
                            
                            kAppDelegate.setUserAddress(ob)
                            
                            self.setAddress ()
                            
                            break
                        }
                    }
                }
            }
        }
    }
}

struct LeadsJSON: Codable {
    let success: Int
    var data: [Leads]
}

class Leads: Codable {
    let id: Int!
    let city: String!
    let country: String!
    let state: String!
    let postcode: String!
    let title: String!
    let serviceID: Int!
    let serviceName, detail, address, serviceType: String!
    let date, time, tradieType, status: String!
    let unreadmessage: Int!
    let createdBy, dispute: Int!
    let disputeResion: String!
    let providerID: Int!
    let type, userStatus, providerStatus: String!
    let uid: Int!
    let fullName, profilePic, mobile, latitude: String!
    let longitude: String!
    var isSelected = false
    var isCellCalled = false
    var images: [images]
    
    enum CodingKeys: String, CodingKey {
        
        case city
        case country
        case state
        case postcode
        case id, title
        case serviceID = "service_id"
        case serviceName = "service_name"
        case detail, address
        case serviceType = "service_type"
        case date, time
        case tradieType = "tradie_type"
        case unreadmessage = "unreadmessage"
        case status
        case createdBy = "created_by"
        case dispute
        case disputeResion = "dispute_resion"
        case providerID = "provider_id"
        case type
        case userStatus = "user_status"
        case providerStatus = "provider_status"
        case uid
        case fullName = "full_name"
        case profilePic = "profile_pic"
        case mobile, latitude, longitude
        case images
    }
}

class images: Codable {
    let created_at: String!
    let id: Int!
    let image_url: String!
    let job_post_id: Int!
    let type: String!
    let updated_at: String!
    
    enum CodingKeys: String, CodingKey {
        case created_at = "created_at"
        case id = "id"
        case image_url = "image_url"
        case job_post_id = "job_post_id"
        case type = "type"
        case updated_at = "updated_at"
    }
}

enum Stats_MyBooking {
    case waittouseraccept
    case needtoacceptreject
    case acceptedbyboth_confirm
    case waitcompletebyuser
    case userrejected
    case rejectedbyme
    case jobcompleted
    case desputed
    case adminsetteled
    /*case complete_provider
     case complete_both
     case decline
     case accepted*/
    case none
}

extension MyBookings {
    func getSubcriptionDetailsFromServer () {
        kAppDelegate.boolPurchasedFromIAP = true
        boolServerPuchase = false
        Http.instance().json(api_get_current_subscription, params(), "POST", aai: true, popup: true, prnt: true, nil, nil, sync: false, defaultCalling: true) { (json, para, ss, ht, data) in
            var boolData = false
            DispatchQueue.main.async {
                self.viewTab.isHidden = false
            }
            
            if let json = json as? NSDictionary {
                print("json \(json)")

                
                
                if let data = json["data"] as? NSDictionary {
                    
                    
                    let isFebVal = data.number("isFab")
                    print("isFeb == ",isFebVal)
                    if isFebVal == 0 {
                        isFeb = 0
                    }else if isFebVal == 1 {
                        isFeb = 1
                    }else{
                        isFeb = 0
                    }
                    
                    let cancelStatus = data.string("status")
                    print(cancelStatus)
                    cancelStatusVal = "\(cancelStatus)"
                    
                    let timestamp = data.string("end_date")
                    let status = data.string("status")
                    self.purchasedDeviceType = data.string("device_type")
                    
                    if timestamp.count > 0 && (status != "end") {
                        boolData = true
                        let time = data.number("end_date").doubleValue
                        kAppDelegate.serverCustomerId = data.string("ios_customer_id")
                        var date: Date = Date()
                        if timestamp.count == 13 {
                            date = Date.init(timeIntervalSince1970: time/1000)
                        } else {
                            date = Date.init(timeIntervalSince1970: time)
                        }
                        kAppDelegate.serverExpiryDate = date
                        let date1 = Date()
                        print("Expiry date-[\(date)]-current-[\(date1)]")
                        let int = date1.timeIntervalSince(date)
                        if int > 0 {
                            subscriptionStatus = false
                            print("x1 Not purchased----[]-")
                            self.notPurchsed(status: status)
                        } else {
                            self.purchsed()
                            subscriptionStatus = true
                            self.boolServerPuchase = true
                            kAppDelegate.boolPurchasedFromIAP = false
                            print("Purchased-----")
                        }
                    }else{
                        self.notPurchsed(status: status)
                        subscriptionStatus = false
                    }
                }else{
                    print("Not Purchased 2")
                    subscriptionStatus = false
                }
                
                if let paymentSetting = json["paymentSetting"] as? Int {
                    print("paymentSetting",paymentSetting)
                    if paymentSetting == 1 {
                        paymentSettingStatus = true
                    }else{
                        paymentSettingStatus = false
                        subscriptionStatus = true
                    }
                        
                }
                print("paymentSettingStatus : ",paymentSettingStatus)
                
            }else{
                subscriptionStatus = false
                print("Not Purchased")
            }
        }
    }
    
    func purchaseDetailsFromIAP () {
        Http.startActivityIndicator()
        
        let mdReceptQuery = NSMutableDictionary()
        
        verifyReceipt { (result) in
            switch result {
            case .success(let receipt):
                DispatchQueue.main.async {
                    mdReceptQuery["success receipt"] = "-\(receipt)-"
                    
                    self.verifyReceiptJsonFromServer(receipt as NSDictionary, mdReceptQuery)
                }
            case .error(let error):
                //self.viewSubscriptionDecision.removeFromSuperview()
                print("Verify receipt Failed: \(error)")
                
                if kAppDelegate.allowTestingPopup() {
                    self.showSubscriptionPopup ("Popup 12", "-[\(result)]-")
                }
                
                self.notPurchsed ()
                
                mdReceptQuery["error"] = "-\(error)-"
                
                if let receiptFileURL = Bundle.main.appStoreReceiptURL {
                    let receiptData = try? Data(contentsOf: receiptFileURL)
                    
                    if let recieptString = receiptData?.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0)) {
                        mdReceptQuery["recieptString"] = recieptString
                    }
                }
                
                self.saveReceiptDataToServer (mdReceptQuery)
                
                self.lblExpiry.text = "START \(kAppDelegate.purchaseTrailDays) DAYS FREE TRAIL"
            }
        }
    }
    
    func verifyReceiptJsonFromServer (_ receipt: NSDictionary, _ mdQuery: NSMutableDictionary) {
        boolApplePuchase = false
        if let pending_renewal_info = receipt["pending_renewal_info"] as? NSArray {
            print("pending_renewal_info-\(pending_renewal_info.count)-")
        }
        if let latest_receipt_info = receipt["latest_receipt_info"] as? NSArray {
            var boolPurchased = false
            for i in 0..<latest_receipt_info.count {
                if let last = latest_receipt_info[i] as? NSDictionary {
                    let time = last.number("expires_date_ms").doubleValue
                    kAppDelegate.setOriginalTransactionId(last.string("original_transaction_id"))
                    let date = Date.init(timeIntervalSince1970: time/1000)
                    let date1 = Date()
                    let int = date1.timeIntervalSince(date)
                    print("Expiry  date-[\(date)]-Current-[\(date1)]-[\(last.number("original_transaction_id"))]-[\(int)]-")
                    if int > 0 {
                        
                    } else {
                        boolPurchased = true
                        
                        self.boolApplePuchase = true
                        
                        self.purchsed()
                        
                        kAppDelegate.setPurchasedDate (time)
                        
                        print("purchased")
                        
                        if kAppDelegate.allowTestingPopup() {
                            self.showSubscriptionPopup ("Popup 9", "-[\(date)]-[\(date1)]-[\(last)]-")
                        }
                        self.sendPurchaseDataToServer(receipt, last)
                        break
                    }
                }
                
                if boolPurchased {
                    break
                }
            }
            
            if boolPurchased == false {
                if kAppDelegate.allowTestingPopup() {
                    self.showSubscriptionPopup ("Popup 10", "-[\(latest_receipt_info)]-")
                }
                
                self.notPurchsed()
                
                print("5purchase now-[\(self.boolServerPuchase)]-[\(self.boolDeviceUser)]-[\(self.boolApplePuchase)]-")
            }
        } else {
            if kAppDelegate.allowTestingPopup() {
                self.showSubscriptionPopup ("Popup 11", "-[\(receipt)]-")
            }
            
            self.notPurchsed()
            
            self.lblExpiry.text = "START \(kAppDelegate.purchaseTrailDays) DAYS FREE TRAIL"
        }
        
        Http.stopActivityIndicator()
    }
}




class image_Video_Show: UIViewController {
    
    var images_Upload = [images]()
    @IBOutlet weak var videoView: UIView!
    @IBOutlet weak var viewBack: UIView!
    @IBOutlet weak var Img_View: UIImageView!
    @IBOutlet weak var pageCtr: UIPageControl!
    var currentIndex = 0
    let playerController = AVPlayerViewController()
    var player = AVPlayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        
        let swip = UISwipeGestureRecognizer(target: self, action: #selector(updateNewData))
        swip.direction = .left
        pageCtr.numberOfPages = images_Upload.count
        pageCtr.currentPage = currentIndex
        viewBack.addGestureRecognizer(swip)
        viewBack.isUserInteractionEnabled = true
        Img_View.addGestureRecognizer(swip)
        Img_View.isUserInteractionEnabled = true
        view.addGestureRecognizer(swip)
        
        let swipRight = UISwipeGestureRecognizer(target: self, action: #selector(updateNewDataRight))
        swipRight.direction = .right
        viewBack.addGestureRecognizer(swipRight)
        Img_View.addGestureRecognizer(swipRight)
        view.addGestureRecognizer(swipRight)
        
        if images_Upload.count > 0 {
            let type = images_Upload[currentIndex].type ?? ""
            if type == "image" {
                videoView.isHidden = true
                Img_View.isHidden = false
                showImg(imgUrl: (images_Upload[currentIndex].image_url ?? ""))
            }else{
                Img_View.isHidden = true
                videoView.isHidden = false
                playVideo(imgUrl: (images_Upload[currentIndex].image_url ?? ""))
            }
        }
        
    }
    
    func showImg(imgUrl:String) {
        if let url = URL(string: imgUrl) {
            Img_View.sd_setImage(with: url)
            Img_View.sd_imageIndicator = SDWebImageActivityIndicator.gray
        }
    }
    
    func playVideo(imgUrl:String) {
        guard let movieURL = URL(string: "\(imgUrl)")
        else { return }
        playerController.removeFromParent()
        player = AVPlayer(url: movieURL)
        playerController.entersFullScreenWhenPlaybackBegins = true
        playerController.player = player
        self.addChild(playerController)
        self.videoView.addSubview(playerController.view)
        playerController.view.frame = self.videoView.frame
        playerController.view.frame = CGRect(x: 0, y: 0, width: self.videoView.frame.width, height: self.videoView.frame.height)
        player.play()
    }
    
    @objc func updateNewData() {
        
        player.pause()
        playerController.removeFromParent()
        print("Left")
        print("Index: ",currentIndex)
        if images_Upload.count > 0 {
            if currentIndex < images_Upload.count-1 {
                currentIndex = currentIndex + 1
                let type = images_Upload[currentIndex].type ?? ""
                if type == "image" {
                    pageCtr.currentPage = currentIndex
                    videoView.isHidden = true
                    Img_View.isHidden = false
                    showImg(imgUrl: (images_Upload[currentIndex].image_url ?? ""))
                }else{
                    pageCtr.currentPage = currentIndex
                    Img_View.isHidden = true
                    videoView.isHidden = false
                    playVideo(imgUrl: (images_Upload[currentIndex].image_url ?? ""))
                }
            }else{
                currentIndex = 0
                let type = images_Upload[currentIndex].type ?? ""
                if type == "image" {
                    pageCtr.currentPage = currentIndex
                    videoView.isHidden = true
                    Img_View.isHidden = false
                    showImg(imgUrl: (images_Upload[currentIndex].image_url ?? ""))
                }else{
                    pageCtr.currentPage = currentIndex
                    Img_View.isHidden = true
                    videoView.isHidden = false
                    playVideo(imgUrl: (images_Upload[currentIndex].image_url ?? ""))
                }
            }
        }
    }
    
    @objc func updateNewDataRight() {
        player.pause()
        playerController.removeFromParent()
        print("RightSwip")
        print("Index: ",currentIndex)
        if images_Upload.count > 0 {
            if currentIndex > 0 {
                currentIndex = currentIndex - 1
                let type = images_Upload[currentIndex].type ?? ""
                if type == "image" {
                    pageCtr.currentPage = currentIndex
                    videoView.isHidden = true
                    Img_View.isHidden = false
                    showImg(imgUrl: (images_Upload[currentIndex].image_url ?? ""))
                }else{
                    pageCtr.currentPage = currentIndex
                    Img_View.isHidden = true
                    videoView.isHidden = false
                    playVideo(imgUrl: (images_Upload[currentIndex].image_url ?? ""))
                }
            }else{
                currentIndex = images_Upload.count - 1
                let type = images_Upload[currentIndex].type ?? ""
                if type == "image" {
                    pageCtr.currentPage = currentIndex
                    videoView.isHidden = true
                    Img_View.isHidden = false
                    showImg(imgUrl: (images_Upload[currentIndex].image_url ?? ""))
                }else{
                    pageCtr.currentPage = currentIndex
                    Img_View.isHidden = true
                    videoView.isHidden = false
                    playVideo(imgUrl: (images_Upload[currentIndex].image_url ?? ""))
                }
            }
        }
    }
    
    @IBAction func Action_Close(_ sender: UIButton) {
        player.pause()
        playerController.removeFromParent()
        self.navigationController?.popViewController(animated: true)
    }
    
}





extension UIImageView {
    
    func downloadAndDisplayImage(from url: URL) {
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, let image = UIImage(data: data), let beginImage = CIImage(image: image) else { return }
            
            let context = CIContext(options: nil)
            let currentFilter = CIFilter(name: "CIGaussianBlur")
            currentFilter!.setValue(beginImage, forKey: kCIInputImageKey)
            currentFilter!.setValue(40, forKey: kCIInputRadiusKey)
            
            let cropFilter = CIFilter(name: "CICrop")
            cropFilter!.setValue(currentFilter!.outputImage, forKey: kCIInputImageKey)
            cropFilter!.setValue(CIVector(cgRect: beginImage.extent), forKey: "inputRectangle")
            
            let output = cropFilter!.outputImage
            let cgimg = context.createCGImage(output!, from: output!.extent)
            let processedImage = UIImage(cgImage: cgimg!)
            DispatchQueue.main.async {
                self.image = processedImage
            }
        }
        task.resume()
    }
}


var chatshowValue = ""
