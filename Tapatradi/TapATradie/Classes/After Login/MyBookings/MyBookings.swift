//
//  MyBookings.swift
//  TapATradie
//
//  Created by Apple on 27/04/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import MessageUI
import ImageScrollView
import AVFoundation
import AVKit
import SDWebImage

protocol MyBookingsCellDelegate {
    func cellViewProfile (_ indexPath: IndexPath)
    func cellDelete(_ indexPath: IndexPath)
    func cellDeleteMultiple(_ indexPath: IndexPath)
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
    func cellDeleteHistory (_ indexPath: IndexPath)
}



extension MyBookings: ListAllTradiesCellDelegate, AlertDelegate {
    func chatList(_ indexPath: IndexPath) {
        jobPostCallEmail = nil
        let data1 = getData(indexPath)//
        let ob = data1.jobPost
        
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
        if ob?.jobPostID != nil {
            jobId = "\((ob?.jobPostID)!)"
        }
        
        if ob?.fullName != nil {
            fullName = "\((ob?.fullName)!)"
        }
        
        if ob?.profilePic != nil {
            profilePic = "\((ob?.profilePic)!)"
        }
        
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "MyChatScreen_VC") as! MyChatScreen_VC
        vc.userID = userID
        vc.providerId = providerId
        vc.jobId = jobId
        vc.name = fullName
        vc.profileURl = profilePic
        
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func cellImageZoom(_ indexPath: IndexPath) {
        
    }
    
    func cellSelectCheckBox(_ indexPath: IndexPath) {
        
    }
    
    func alertZero () {
        acceptReject("delete", deleteIndexPath)
    }
    
    func alertOne () {}
    
    func cellClicked (_ indexPath: IndexPath) {
        //let ob = getData(indexPath).jobPost//bookings?.jobPost[indexPath.row]
    }
    
    func deleteClicked (_ indexPath: IndexPath) {
        
        let ob = getData(indexPath)
        
        if (ob.bookings?.jobPost.count)! == 1 {
            
            view4DeleteLastService.frame = self.view.bounds
            self.view.addSubview(view4DeleteLastService)
            deleteIndexPath = indexPath
            //            Http.alert("", "If you delete this tradie, so job will be automatically deleted.", [self, "Yes", "No"])
        } else {
            acceptReject("delete", indexPath)
        }
    }
    
    func rightClicked (_ indexPath: IndexPath) {
        acceptReject("accept", indexPath)
    }
    
    func crossClicked (_ indexPath: IndexPath) {
        acceptReject("reject", indexPath)
    }
    
    func acceptReject (_ type: String, _ indexPath: IndexPath) {
        let data1 = getData(indexPath)//
        let ob = data1.jobPost//bookings?.jobPost[indexPath.row]
        let param = params()
        param["action"] = type
        //accept / reject/ completed
        param["pid"] = ob?.providerID
        param["job_id"] = ob?.jobPostID
        param["type"] = ob?.type
        
        Http.instance().json(api_user_job_action, param, "POST", aai: true, popup: true, prnt: true, nil, nil, sync: false, defaultCalling: false) { (json, para, str, http, data) in
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
                    if type == "delete" {
                        var boolRemove = true
                        if data1.bookings?.jobPost != nil {
                            if data1.bookings!.jobPost.count == 1 {
                                boolRemove = false
                                self.getListing("1")
                            }
                        }
                        if boolRemove {
                            self.removeCell(indexPath)
                        }
                    } else {
                        self.getListing("1")
                    }
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
        }
    }
}

extension MyBookings: MyBookingsCellDelegate {
    func cellDeleteMultiple(_ indexPath: IndexPath) {
        print("cellDeleteMultiple-\(indexPath.row)-")
        
        let ob = getData(indexPath).bookings
        let param = params()
        param["job_id"] = ob?.id
        
        Http.instance().json(api_user_job_delete, param, "POST", aai: true, popup: true, prnt: true, nil, nil, sync: false, defaultCalling: false) { (json, para, str, http, data) in
            let json = json as? NSDictionary
            
            if json != nil {
                if json?.number("success").intValue == 1 {
                    self.actionCurrentBookings("")
                    //self.actionHistoryBookings("")
                }
                
                Toast.toast(json!.string("message"))
            }
        }
    }
    
    func cellDeleteHistory (_ indexPath: IndexPath) {
        btnOkDeleteHistory.tag = indexPath.row
        
        addDeleteHistoryView ()
    }
    
    func cellDeleteHistoryFromOk (_ indexPath: IndexPath) {
        let ob = getData(indexPath).bookings
        
        let param = params()
        
        param["job_id"] = ob?.id
        param["type"] = "user"
        //api_delete_history changed api to api_user_job_delete
        Http.instance().json(api_user_job_delete, param, "POST", aai: true, popup: true, prnt: true, nil, nil, sync: false, defaultCalling: false) { (json, para, str, http, data) in
            let json = json as? NSDictionary
            
            if json != nil {
                if json?.number("success").intValue == 1 {
                    self.actionHistoryBookings("")
                }
                
                Toast.toast(json!.string("message"))
            }
        }
    }
    
    func cellRateTo(_ indexPath: IndexPath) {
        indexPathRateReview = indexPath
        addRateReviewView ()
    }
    
    
    func updateHide() {
        for i in 0..<(myBookingsJSON?.data.count ?? 0) {
            let ob = myBookingsJSON?.data[i]
            ob?.isSelected = true
        }
        tblMyBookings.reloadData()
    }
    
    func cellCellClicked(_ indexPath: IndexPath) {
        for i in 0..<(myBookingsJSON?.data.count)! {
            let ob = myBookingsJSON?.data[i]
            if i == indexPath.row {
                ob?.isSelected = !(ob?.isSelected)!
            } else {
                ob?.isSelected = false
            }
        }
        
        tblMyBookings.reloadData()
        updateHide()
    }
    
    func cellListAllTradie(_ indexPath: IndexPath) {
        /*let vc = story_Tradie.viewController("ListAllTradies") as! ListAllTradies
         vc.bookings = myBookingsJSON?.data[indexPath.row]
         self.navigationController?.pushViewController(vc, animated: true)*/
        
        let ob = getData(indexPath).bookings
        
        if ob?.showAllTradies == nil {
            ob?.showAllTradies = false
        }
        
        ob?.showAllTradies = !(ob?.showAllTradies)!
        tblMyBookings.reloadData()
        updateHide()
    }
    
    func cellDelete(_ indexPath: IndexPath) {
        callAction("delete", indexPath)
    }
    
    func cellCall(_ indexPath: IndexPath) {
        jobPostCallEmail = nil
        
        let ob = myBookingsJSON?.data[indexPath.row]
        
        if ob?.jobPost != nil {
            if (ob?.jobPost.count)! > 0 {
                let ob = ob?.jobPost[0]
                jobPostCallEmail = ob
                var email = ""
                var mobile = ""
                if ob?.mobile != nil {
                    mobile = "\((ob?.mobile)!)"
                }
                if ob?.email != nil {
                    email = "\((ob?.email)!)"
                }
                let myalert = UIAlertController(title: "Choose option", message: "", preferredStyle: UIAlertController.Style.actionSheet)
                
                myalert.addAction(UIAlertAction(title: "Call \(mobile)", style: .default) { (action:UIAlertAction!) in
                    if ob?.mobile != nil {
                        if let url = URL(string: "tel://\((ob?.mobile)!)") {
                            
                            if UIApplication.shared.canOpenURL(url) {
                                UIApplication.shared.open(url, options: [:], completionHandler: nil)
                            } else {
                                Http.alert("", "Phone call not available.")
                            }
                        }
                    }
                })
                
                myalert.addAction(UIAlertAction(title: "Email \(email)", style: .default) { (action:UIAlertAction!) in
                    if !MFMailComposeViewController.canSendMail() {
                        print("Mail services are not available")
                        
                        Toast.toast("Mail services are not available")
                        
                        return
                    } else {
                        let composeVC = MFMailComposeViewController()
                        composeVC.mailComposeDelegate = self
                        
                        // Configure the fields of the interface.
                        composeVC.setToRecipients([email])
                        composeVC.setSubject("")
                        composeVC.setMessageBody("", isHTML: false)
                        
                        // Present the view controller modally.
                        self.present(composeVC, animated: true, completion: nil)
                    }
                })
                
                myalert.addAction(UIAlertAction(title: "SMS \(mobile)", style: .default) { (action:UIAlertAction!) in
                    if (MFMessageComposeViewController.canSendText()) {
                        let controller = MFMessageComposeViewController()
                        controller.body = ""
                        controller.recipients = [mobile]
                        controller.messageComposeDelegate = self
                        self.present(controller, animated: true, completion: nil)
                    } else {
                        Toast.toast("SMS not available")
                    }
                })
                
                myalert.addAction(UIAlertAction(title: "Cancel", style: .cancel) { (action:UIAlertAction!) in
                    
                })
                
                self.present(myalert, animated: true)
            }
        }
    }
    
    
    
    func cellChat(_ indexPath: IndexPath) {
        jobPostCallEmail = nil
        let ob = myBookingsJSON?.data[indexPath.row]

        if ob?.jobPost != nil {
            if (ob?.jobPost.count)! > 0 {
                let ob = ob?.jobPost[0]
                jobPostCallEmail = ob
                
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
                if ob?.jobPostID != nil {
                    jobId = "\((ob?.jobPostID)!)"
                }
                
                if ob?.fullName != nil {
                    fullName = "\((ob?.fullName)!)"
                }
                
                if ob?.profilePic != nil {
                    profilePic = "\((ob?.profilePic)!)"
                }
                
                
                print(ob?.jobPostID)
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "MyChatScreen_VC") as! MyChatScreen_VC
                vc.userID = userID
                vc.providerId = providerId
                vc.jobId = jobId
                vc.name = fullName
                vc.profileURl = profilePic
                
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        
        
        
    }
    
    
    
    func cellRight(_ indexPath: IndexPath) {
        callAction("accept", indexPath)
    }
    
    func cellMapPin(_ indexPath: IndexPath) {
        let data = getData(indexPath)
        var jobPost: JobPost?
        if data.bookings != nil {
            if data.bookings?.jobPost != nil {
                if (data.bookings?.jobPost.count)! > 0 {
                    jobPost = data.bookings?.jobPost[0]
                }
            }
        } else if data.jobPost != nil {
            jobPost = data.jobPost
        }
        if jobPost == nil {
            return
        }
        
        let vc = story_Tradie.viewController("TrackTradie") as! TrackTradie
        
        print(jobPost?.latitude)
        print(jobPost?.longitude)
        
        print(data.bookings?.latitude)
        
        vc.jobPost = jobPost
        vc.bookings = data.bookings
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func cellCross(_ indexPath: IndexPath) {
        callAction("reject", indexPath)
    }
    
    func cellConfirm(_ indexPath: IndexPath) {
        boolCurrent = false
        callAction("completed", indexPath)
    }
    
    func callAction (_ type: String,_ indexPath: IndexPath) {
        let ob = myBookingsJSON?.data[indexPath.row]
        
        let param = params()
        param["action"] = type//"completed"
        //accept / reject/ completed
        
        param["pid"] = ob?.jobPost[0].providerID
        
        if type == "reject" {
            param["job_id"] = ob?.jobPost[0].id
        } else {
            param["job_id"] = ob?.jobPost[0].jobPostID
        }
        param["type"] = ob?.jobPost[0].type
        
        Http.instance().json(api_user_job_action, param, "POST", aai: true, popup: true, prnt: true, nil, nil, sync: false, defaultCalling: false) { (json, para, str, http, data) in
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
                    if type == "completed" {
                        Http.alert("", "Job successfully confirmed.")
                    } else if type == "reject" {
                        Http.alert("", "Job successfully rejected.")
                    } else if type == "delete" {
                        Http.alert("", "Job successfully deleted.")
                    } else if type == "accept" {
                        Http.alert("", "Job successfully accepted.")
                    }
                    
                    if self.boolCurrent {
                        self.actionCurrentBookings("")
                    } else {
                        self.actionHistoryBookings("")
                    }
                } else {
                    Http.alert("", json?.string("message"))
                }
            }
        }
    }
    
    func cellDispute(_ indexPath: IndexPath) {
        indexPathRaiseADispute = indexPath
        openRaiseADisputeView ()
    }
}

extension MyBookings: MFMessageComposeViewControllerDelegate, MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        switch result {
        case MFMailComposeResult.sent:
            print("MFMailComposeResult.sent")
            Toast.toast("Email sent successfully")
            break;
            
        case MFMailComposeResult.cancelled:
            print("MFMailComposeResult.cancelled")
            Toast.toast("Email cancelled")
            break;
            
        case MFMailComposeResult.failed:
            print("MFMailComposeResult.failed")
            Toast.toast("Email failed")
            break;
        default:
            print("default")
            Toast.toast("Unknown error")
            break
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        
        switch result {
        case MessageComposeResult.sent:
            print("MessageComposeResult.sent")
            Toast.toast("SMS sent successfully")
            break;
            
        case MessageComposeResult.cancelled:
            print("MessageComposeResult.cancelled")
            Toast.toast("SMS cancelled")
            break;
            
        case MessageComposeResult.failed:
            print("MessageComposeResult.failed")
            Toast.toast("SMS failed")
            break;
        default:
            print("default")
            Toast.toast("Unknown error")
            break
        }
        
        self.dismiss(animated: true, completion: nil)
    }
}

class MyBookingsCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
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
        
        func getThumbnailImage(forUrl url: URL) -> UIImage? {
            let asset: AVAsset = AVAsset(url: url)
            let imageGenerator = AVAssetImageGenerator(asset: asset)
            do {
                let thumbnailImage = try imageGenerator.copyCGImage(at: CMTimeMake(value: 1, timescale: 60), actualTime: nil)
                return UIImage(cgImage: thumbnailImage)
            } catch let error {
                print(error)
            }
            return nil
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
    @IBOutlet weak var PhotoBottomHeight: NSLayoutConstraint!
    
    @IBOutlet weak var btnListAllTradiesHide: UIButton!
    var images_Upload = [Images_Upload]()
    var delegateNew:onPhotoClick!
    @IBOutlet weak var lblShimmer: UILabel!
    @IBOutlet weak var btnViewProfile: UIButton!
    @IBOutlet weak var btnViewProfile1: UIButton!
    @IBOutlet weak var btnDeleteHistory: UIButton!
    @IBOutlet weak var btnDeleteMultiple: UIButton!
    @IBOutlet weak var ai: UIActivityIndicatorView!
    @IBOutlet weak var lblServiceTypeTitle2: UILabel!
    @IBOutlet weak var lblServiceType2: UILabel!
    //@IBOutlet weak var cnstDetailTop: NSLayoutConstraint!
    //@IBOutlet weak var cnstTopForHideRating: NSLayoutConstraint!
    //@IBOutlet weak var cnstTopServiceType: NSLayoutConstraint!
    @IBOutlet weak var imgArrow: UIImageView!
    @IBOutlet weak var viewBottomShadow: UIView!
    //@IBOutlet weak var cnstTop: NSLayoutConstraint!
    @IBOutlet weak var viewRating: UIView!
    @IBOutlet weak var viewUserRating: FloatRatingView!
    @IBOutlet weak var lblUserReview: UILabel!
    @IBOutlet weak var viewRate: UIView!
    @IBOutlet weak var lblServiceTypeTitle: UILabel!
    @IBOutlet weak var lblServiceType: UILabel!
    @IBOutlet weak var lblDetailTitle: UILabel!
    @IBOutlet weak var lblDetail: UILabel!
    @IBOutlet weak var cnstViewHeight: NSLayoutConstraint!
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var lblRequirement: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblRating: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var imgVerified: UIImageView!
    @IBOutlet weak var imgOnline: UIImageView!
    @IBOutlet weak var lblOnline: UILabel!
    @IBOutlet weak var viewListAllTradies: UIView!
    @IBOutlet weak var btnJobDetail: UIButton!

    
    @IBAction func actionRate(_ sender: Any) {
        print("ACTION_Rte")
        delegate.cellRateTo(indexPath)
    }
    
    @IBAction func actionCellClicked(_ sender: Any) {
        print("ACTION_Rte two")
        delegate.cellCellClicked(indexPath)
    }
    
    @IBAction func actionDeleteHistory(_ sender: Any) {
        delegate.cellDeleteHistory(indexPath)
    }
    
    @IBAction func actionViewProfile (_ sender: Any) {
        delegate.cellViewProfile(indexPath)
    }
    
    
    @IBAction func actionListAllTradies(_ sender: Any) {
        print("ACTION_Rte three")
        delegate.cellCellClicked(indexPath)
        delegate.cellListAllTradie(indexPath)
    }
    
    @IBAction func ViewJobDetail(_ sender: UIButton) {
        delegate.cellCellClicked(indexPath)
        //delegate.cellListAllTradie(indexPath)
    }
    
    var indexPath: IndexPath!
    var delegate: MyBookingsCellDelegate!
    
    
    
    override func awakeFromNib() {
        imgUser.border5(imgUser.frame.size.height/2)
        lblRating.superview?.border5(2)
        lblShimmer.border5(3)
    }
    
    func dele() {
        self.photoCollection.delegate = self
        self.photoCollection.dataSource = self
    }
    
    func hideAllButtons () {
        btnDelete.isHidden = true
        btnCall.isHidden = true
        
        btnChatOut.isHidden = true
        btnRight.isHidden = true
        btnMapPin.isHidden = true
        btnCross.isHidden = true
    }
    
    @IBOutlet weak var btnDelete: UIButton!
    @IBAction func actionDelete(_ sender: Any) {
        if let btn = sender as? UIButton {
            if btn.tag == 100 {
                delegate.cellDeleteMultiple(indexPath)
                
                return
            }
        }
        delegate.cellDelete(indexPath)
    }
    @IBOutlet weak var btnChatOut: UIButton!
    @IBOutlet weak var videChatCount: UIView!
    @IBOutlet weak var lblChatCount: UILabel!
    
    @IBAction func btnChat(_ sender: UIButton) {
        delegate.cellChat(indexPath)
    }
    @IBOutlet weak var btnCall: UIButton!
    @IBAction func actionCall(_ sender: Any) {
        delegate.cellCall(indexPath)
    }
    
    @IBOutlet weak var btnRight: UIButton!
    @IBAction func actionRight(_ sender: Any) {
        delegate.cellRight(indexPath)
    }
    
    @IBOutlet weak var btnMapPin: UIButton!
    @IBAction func actionMapPin(_ sender: Any) {
        delegate.cellMapPin(indexPath)
    }
    
    @IBOutlet weak var topSpaceListAllTradie: NSLayoutConstraint!
    @IBOutlet weak var btnCross: UIButton!
    @IBAction func actionCross(_ sender: Any) {
        delegate.cellCross(indexPath)
    }
    
    @IBOutlet weak var btnConfirm: UIButton!
    @IBAction func actionConfirm(_ sender: Any) {
        delegate.cellConfirm(indexPath)
    }
    
    @IBOutlet weak var btnDispute: UIButton!
    @IBAction func actionDispute(_ sender: Any) {
        delegate.cellDispute(indexPath)
    }
}


protocol onPhotoClick {
    func openImage(images_Upload:[Images_Upload],index:Int)
    func openVideo(images_Upload:[Images_Upload],index:Int)
}

class photoCollection: UICollectionViewCell {
    @IBOutlet weak var Img_PlayPause: UIImageView!
    @IBOutlet weak var AlphaView: UIView!
    @IBOutlet weak var widthVal: NSLayoutConstraint!
    @IBOutlet weak var heightVal: NSLayoutConstraint!
    @IBOutlet weak var View_Card: UIView!
    @IBOutlet weak var Img_Photo: UIImageView!
}

extension MyBookings: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        if textView.text.count <= 1 && text.count == 0 {
            if textView == tvRaiseDispute {
                lblPlaceHolderRaiseDispute.isHidden = false
            } else {
                lblPlaceholderRateReview.isHidden = false
            }
        } else if text.count > 0 {
            if textView == tvRaiseDispute {
                lblPlaceHolderRaiseDispute.isHidden = true
            } else {
                lblPlaceholderRateReview.isHidden = true
            }
        }
        return true
    }
}


//MARK: ViewController
class MyBookings: UIViewController, onPhotoClick {
    
    func openImage(images_Upload: [Images_Upload],index:Int) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "image_Video_Show") as! image_Video_Show
        vc.images_Upload = images_Upload
        vc.currentIndex = index
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func openVideo(images_Upload: [Images_Upload],index:Int) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "image_Video_Show") as! image_Video_Show
        vc.images_Upload = images_Upload
        vc.currentIndex = index
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK: Outlet --
    @IBOutlet var view4DeleteLastService: UIView!
    @IBOutlet weak var lblNoListingAvailable: UILabel!
    @IBOutlet var viewRateReview: UIView!
    @IBOutlet weak var viewFloatRating: FloatRatingView!
    @IBOutlet weak var tblMyBookings: UITableView!
    @IBOutlet weak var lblCurrentBottm: UILabel!
    @IBOutlet weak var lblHistoryBottom: UILabel!
    @IBOutlet weak var tvRateReview: UITextView!
    @IBOutlet weak var lblPlaceholderRateReview: UILabel!
    @IBOutlet var viewRaiseADispute: UIView!
    @IBOutlet weak var viewRaiseADisputeInner: UIView!
    @IBOutlet weak var tvRaiseDispute: UITextView!
    @IBOutlet weak var lblPlaceHolderRaiseDispute: UILabel!
    @IBOutlet weak var imageScrollView: ImageScrollView!
    @IBOutlet var viewDeleteHistory: UIView!
    @IBOutlet weak var btnOkDeleteHistory: UIButton!
    @IBOutlet var viewImageZoom: UIView!
    
    //MARK: Property --
    var jobPostCallEmail: JobPost?
    var deleteIndexPath: IndexPath!
    var indexPathRateReview: IndexPath?
    var indexPathRaiseADispute: IndexPath!
    var boolCurrent = true
    var arrShimmer: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tvRaiseDispute.delegate = self
        kAppDelegate.tabbarClicked(IndexPath(row: 1, section: 0), self.navigationController)
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_ :)))
        viewRateReview.addGestureRecognizer(tap)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        kAppDelegate.currentVC = self
        if boolCurrent {
            actionCurrentBookings ("")
        } else {
            actionHistoryBookings("")
        }
    }
    
    //MARK: Action --
    @IBAction func actionRemoveRateReviewView(_ sender: Any) {
        viewRateReview.removeFromSuperview()
    }
    
    @IBAction func actionSubmitReteReview(_ sender: Any) {
        if viewFloatRating.rating == 0 {
            Http.alert("", "Please select star ratings.")
        } else if tvRateReview.text.count == 0 {
            Http.alert("", "Please enter review.")
        } else {
            self.viewRateReview.removeFromSuperview()
            let ob = myBookingsJSON?.data[indexPathRateReview!.row]
            let param = params()
            param["provider_id"] = ob?.jobPost[0].providerID
            param["job_post_id"] = ob?.id
            param["rating"] = viewFloatRating.rating
            param["review"] = tvRateReview.text
            Http.instance().json(api_user_give_review, param, "POST", aai: true, popup: true, prnt: true, nil, nil, sync: false, defaultCalling: false) { (json, para, str, http, data) in
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
                        self.getListing("1")
                    }
                    Http.alert("", json?.string("message"))
                }
            }
        }
        
    }
    
    @IBAction func actionRemoveViewRaiseDispute(_ sender: Any) {
        viewRaiseADispute.removeFromSuperview()
    }
    
    @IBAction func actionSubmitRaiseDispute(_ sender: Any) {
        if tvRaiseDispute.text.count == 0 {
            Http.alert("", "Please write your reason.")
        } else {
            self.viewRaiseADispute.removeFromSuperview()
            let ob = myBookingsJSON?.data[indexPathRaiseADispute.row]
            let param = params()
            param["job_id"] = ob?.jobPost[0].jobPostID
            param["resion"] = tvRaiseDispute.text
            
            Http.instance().json(api_user_raise_dispute, param, "POST", aai: true, popup: true, prnt: true, nil, nil, sync: false, defaultCalling: false) { (json, para, str, http, data) in
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
                        self.getListing("1")
                    }
                    Http.alert("", json?.string("message"))
                }
            }
        }
    }
    
    @IBAction func actionCurrentBookings(_ sender: Any) {
        boolCurrent = true
        lblCurrentBottm.backgroundColor = UIColor.hexColor(0xCFD0D1)
        lblHistoryBottom.backgroundColor = UIColor.clear
        downloading = .canDownload
        getListing("1")
    }
    
    @IBAction func actionHistoryBookings(_ sender: Any) {
        boolCurrent = false
        lblHistoryBottom.backgroundColor = UIColor.hexColor(0xCFD0D1)
        lblCurrentBottm.backgroundColor = UIColor.clear
        downloading = .canDownload
        getListing("1")
    }
    
    @IBAction func actionCancelDeleteHistory(_ sender: Any) {
        viewDeleteHistory.removeFromSuperview()
    }
    
    @IBAction func actionOkDeleteHistory(_ sender: Any) {
        viewDeleteHistory.removeFromSuperview()
        cellDeleteHistoryFromOk(IndexPath(row: btnOkDeleteHistory.tag, section: 0))
    }
    
    @IBAction func actionRemoveImageZoom(_ sender: Any) {
        viewImageZoom.removeFromSuperview()
    }
    
    @IBAction func actionZoomImage(_ sender: Any) {
        //zoomImage ()
        //viewImageZoom.frame = self.view.bounds
        //self.view.addSubview(viewImageZoom)
    }
    
    //MARK: Methods --
    func openRaiseADisputeView () {
        viewRaiseADisputeInner.border5(3)
        //indexPathRaiseADispute
        tvRaiseDispute.border(UIColor.hexColor(0xe8e8e8), 4, 1)
        viewRaiseADispute.frame = self.view.bounds
        self.view.addSubview(viewRaiseADispute)
    }
    
    func addRateReviewView () {
        tvRateReview.delegate = self
        tvRateReview.border(UIColor.hexColor(0xE8E8E8), 4, 1)
        tvRateReview.superview?.border5(3)
        viewRateReview.frame = self.view.bounds
        self.view.addSubview(viewRateReview)
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        self.view.endEditing(true)
    }
    
    func getListing (_ page: String) {
        if page == "1" {
            arrShimmer = ["", "", "", "", ""]
            self.tblMyBookings.reloadData()
            self.myBookingsJSON = nil
        }
        current_page = page
        let param = params()
        param["page"] = page
        if boolCurrent {
            param["lead_type"] = "new"
        } else {
            param["lead_type"] = "history"
        }
        Http.instance().json(api_user_leads, param, "POST", aai: false, popup: true, prnt: true, nil, nil, sync: false, defaultCalling: false) { (json, para, str, http, data) in
            print(json)
            
            let jsonExp = json as? NSDictionary
            
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
                    let self_myBookingsJSON = try JSONDecoder().decode(MyBookingsJSON.self, from: data!)
                    //print(self_myBookingsJSON.data[0].images.count)
                    //print(self_myBookingsJSON.data[0].images)
                    self.processJSON(self_myBookingsJSON)
                } catch let error {
                    print("1Error: \(error)")
                    var json = json as? NSDictionary
                    json = json?.getMutable(nil)
                    if json == nil {
                        Http.stopActivityIndicator()
                        return
                    }
                    var s1 = (json?.toString1())!.replacingOccurrences(of: "<null>", with: "")
                        .replacingOccurrences(of: "\t", with: "    ")
                    //MARK: Himanshu update Resolve Issues.
                    s1 = s1.replacingOccurrences(of: "\n", with: "")
                    let data = s1.data(using: String.Encoding.utf8)
                    if data != nil {
                        do {
                            let self_myBookingsJSON = try JSONDecoder().decode(MyBookingsJSON.self, from: data!)
                            //print(self_myBookingsJSON.data[0].images.count)
                            //print(self_myBookingsJSON.data[0])
                            self.processJSON(self_myBookingsJSON)
                        } catch let error {
                            self.downloading = .noData
                            print("2Error: \(error)")
                            //self.reloadTableForShimmer ()
                        }
                    } else {
                        self.downloading = .noData
                        //self.reloadTableForShimmer ()
                    }
                }
            } else {
                self.downloading = .noData
                //self.reloadTableForShimmer ()
            }
        }
    }
    
    var myBookingsJSON: MyBookingsJSON?
    var downloading: Downloading = .canDownload
    
    func processJSON (_ myBookingsJSON: MyBookingsJSON?) {
        if myBookingsJSON != nil && myBookingsJSON?.data != nil {
            if (myBookingsJSON?.data.count)! == 0 {
                self.downloading = .noData
            }
        }
        if myBookingsJSON != nil && self.myBookingsJSON == nil {
            self.myBookingsJSON = myBookingsJSON
            var i = 0
            while i < self.myBookingsJSON!.data.count {
                let ob = self.myBookingsJSON!.data[i]
                if ob.jobPost.count == 0 {
                    self.myBookingsJSON?.data.remove(at: i)
                } else {
                    var bool = false
                    for k in 0..<ob.jobPost.count {
                        let dtt = ob.jobPost[k]
                        if dtt.providerStatus == "deleted" {
                            bool = true
                            break
                        }
                    }
                    if bool {
                        self.myBookingsJSON?.data.remove(at: i)
                    } else {
                        i += 1
                    }
                }
            }
        } else if myBookingsJSON != nil && self.myBookingsJSON != nil {
            for i in 0..<(myBookingsJSON?.data.count)! {
                let ob = myBookingsJSON?.data[i]
                if ob!.jobPost.count != 0 {
                    var bool = true
                    for k in 0..<ob!.jobPost.count {
                        let dtt = ob!.jobPost[k]
                        if dtt.providerStatus == "deleted" {
                            bool = false
                            break
                        }
                    }
                    if bool {
                        self.myBookingsJSON?.data.append((myBookingsJSON?.data[i])!)
                    }
                }
            }
        }
        if self.downloading != .noData {
            self.downloading = .canDownload
        }
        self.reloadTableForShimmer ()
    }
    
    func reloadTableForShimmer () {
        DispatchQueue.global().async {
            //sleep(5)
            self.arrShimmer = []
            DispatchQueue.main.async {
                self.tblMyBookings.reloadData()
                self.updateHide()
            }
        }
    }
    
    //delete last Service
    @IBAction func btnCross(_ sender: Any) {
        self.view4DeleteLastService.removeFromSuperview()
    }
    
    @IBAction func btn4DeleteOk(_ sender: Any) {
        self.view4DeleteLastService.removeFromSuperview()
        acceptReject("delete", deleteIndexPath)
    }
    
    var current_page = "1"
    
    //MARK: - MyBooking
    @IBAction func actionSelectAddress(_ sender: Any) {
        let vc = story_Auth.viewController("SeeTradiesArround") as! SeeTradiesArround
        vc.pushToViewController = nil
        vc.popToViewController = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK: - Delete History
    func addDeleteHistoryView () {
        btnOkDeleteHistory.superview?.border5(3)
        
        viewDeleteHistory.frame = UIScreen.main.bounds
        self.view.addSubview(viewDeleteHistory)
    }
    
    
    
    func zoomImage (_ jobPost: JobPost) {
        let ob = jobPost as? JobPost
        
        let url = "\(Server)profile/\((ob?.providerID)!)/\((ob?.profilePic)!)"
        
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
    
    
}

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

extension MyBookings: UITableViewDelegate, UITableViewDataSource {
    func cellViewProfile (_ indexPath: IndexPath) {
        //print("IndexPath-\(indexPath)-")
        let data = getData(indexPath)
        var ob: JobPost?
        if data.jobPost != nil {
            ob = data.jobPost
            //print("1ob?.id-\(ob?.id)-")
        } else if data.bookings != nil {
            //print("data.bookings-\(data.bookings)-")
            let obb = data.bookings
            if obb?.jobPost != nil {
                if (obb?.jobPost.count ?? 0) > 0 {
                    ob = obb?.jobPost[0]
                    //print("2ob?.id-\(ob?.id)-")
                }
            }
        }
        
        if ob?.providerID != nil {
            //zoomImage(ob!)
            let obc = Tradies()
            obc.id = Int(ob?.providerID ?? "0") ?? 0
            let vc = story_Tradie.viewController("TradieProfile") as! TradieProfile
            vc.tradies = obc
            //vc.tradiesJSON = self.tradiesJSON
            //vc.services = services
            //vc.search = search
            //vc.tradie_type = tradie_type
            //vc.paramSendToAll = paramSendToAll
            //vc.boolGoToServiceSelection = boolGoToServiceSelection
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let c1 = arrShimmer.count
        
        if c1 > 0 {
            //print("Height",188)
            return 188
        }
        
        let data = getData(indexPath)
        
        if data.jobPost != nil {
            //print("Height",88)
            return 88
        } else {
            let obb = data.bookings
            
            if obb?.isSelected == nil {
                obb?.isSelected = false
            }
            
            if obb?.isSelected == false {
                let obb =  getData(indexPath).bookings
                if obb?.jobPost != nil {
                    if (obb?.jobPost.count ?? 0) > 0 {
                        let ob = obb?.jobPost[0]
                        print("Height",cellHeight (obb!, ob!, indexPath))
                        return CGFloat(cellHeight (obb!, ob!, indexPath))
                    }
                }
                print("Height",180)
                return 180
            } else {
                print(tblMyBookings.rowHeight)
                print(tblMyBookings.estimatedRowHeight + 200)
                defer{
                    print(tableView.cellForRow(at: indexPath)?.heightAnchor)
                }
                return tblMyBookings.estimatedRowHeight
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let c1 = arrShimmer.count
        
        //print("Harish c1-\(c1)-")
        
        if c1 > 0 {
            return c1
        }
        
        let count = totalCells ()
        
        if count == 0 {
            lblNoListingAvailable.isHidden = false
        } else {
            lblNoListingAvailable.isHidden = true
        }
        
        return count
    }
    
    func totalCells () -> Int {
        var count = 0
        
        if myBookingsJSON?.data != nil {
            for i in 0..<(myBookingsJSON?.data.count ?? 0) {
                count += 1
                
                let ob = myBookingsJSON?.data[i]
                
                if ob?.showAllTradies == nil {
                    ob?.showAllTradies = false
                }
                
                if (ob?.showAllTradies ?? false) {
                    if ob?.jobPost != nil {
                        count += (ob?.jobPost.count)!
                    }
                }
            }
        }
        
        return count
    }
    
    func removeCell (_ indexPath: IndexPath) {
        var count = 0
        
        if myBookingsJSON?.data != nil {
            for i in 0..<(myBookingsJSON?.data.count ?? 0) {
                let ob = myBookingsJSON?.data[i]
                
                if ob?.isSelected == nil {
                    ob?.isSelected = false
                }
                
                if ob?.showAllTradies == nil {
                    ob?.showAllTradies = false
                }
                
                if count == indexPath.row {
                    
                } else if (ob?.showAllTradies)! {
                    if ob?.jobPost != nil {
                        for j in 0..<(ob?.jobPost.count)! {
                            count += 1
                            if count == indexPath.row {
                                if ob?.jobPost != nil {
                                    if ob!.jobPost.count > j {
                                        ob?.jobPost.remove(at: j)
                                    }
                                }
                                tblMyBookings.reloadData()
                                updateHide()
                            }
                        }
                    }
                }
                count += 1
            }
        }
    }
    
    func getData (_ indexPath: IndexPath) -> (bookings: Bookings?, jobPost: JobPost?, boolLast: Bool) {
        var count = 0
        
        if myBookingsJSON?.data != nil {
            for i in 0..<(myBookingsJSON?.data.count ?? 0) {
                let ob = myBookingsJSON?.data[i]
                
                if ob?.isSelected == nil {
                    ob?.isSelected = false
                }
                
                if ob?.showAllTradies == nil {
                    ob?.showAllTradies = false
                }
                
                if count == indexPath.row {
                    return (ob, nil, false)
                } else if (ob?.showAllTradies)! {
                    if ob?.jobPost != nil {
                        for j in 0..<(ob?.jobPost.count)! {
                            let obb = ob?.jobPost[j]
                            
                            count += 1
                            
                            if count == indexPath.row {
                                var last = false
                                
                                if j == ((ob?.jobPost.count)! - 1) {
                                    last = true
                                }
                                
                                return (ob, obb, last)
                            }
                        }
                    }
                }
                
                count += 1
            }
        }
        
        return (nil, nil, false)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let c1 = arrShimmer.count
        if c1 > 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MyBookingsCell") as! MyBookingsCell
            cell.lblShimmer.superview?.isHidden = false
            cell.lblShimmer.isHidden = false
            cell.lblShimmer.startShimmeringEffect()
            lblNoListingAvailable.isHidden = true
            return cell
        }
        let data = getData(indexPath)
        if data.jobPost != nil {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ListAllTradiesCell") as! ListAllTradiesCell
            
            cell.btnCross.isHidden = true
            cell.btnRight.isHidden = true
            cell.viewCountList.isHidden = true
            cell.viewCountList.layer.cornerRadius = cell.viewCountList.frame.height/2
            cell.btnChatList.isHidden = true
            cell.btnDelete.isHidden = true
            cell.indexPath = indexPath
            cell.delegate = self
            let ob = data.jobPost//bookings?.jobPost[indexPath.row]
            cell.lblName.text = ob?.fullName
            cell.lblSubName.text = data.bookings?.serviceName.replacingOccurrences(of: ",", with: ", ").capFirstLetter()
            let checkOne = Int(ob?.verified ?? "0") ?? 0
            
            print("\(ob?.unreadmessage ?? "0")")
            if ob?.unreadmessage == nil {
                cell.lblCountList.text = "0"
            } else {
                cell.lblCountList.text = "\(ob?.unreadmessage ?? "0")"
            }
            
            if checkOne == 1 {
                cell.imgVerified.image = #imageLiteral(resourceName: "Group 4413")
                cell.imgVerified.isHidden = false
            } else {
                cell.imgVerified.image = #imageLiteral(resourceName: "Group 4413")
                cell.imgVerified.isHidden = true
            }
            let checkTwo = Int(ob?.online ?? "0") ?? 0
            if checkTwo == 1 {
                cell.imgOnline.image = #imageLiteral(resourceName: "Ellipse 180")
                cell.lblOnline.text = "Online"
            } else {
                cell.imgOnline.image = #imageLiteral(resourceName: "Ellipse 1801")
                cell.lblOnline.text = "Offline"
            }
            if ob?.avgRating == nil {
                cell.lblRating.text = "0.0"
            } else if ob?.avgRating.count == 0 {
                cell.lblRating.text = "0.0"
            } else {
                cell.lblRating.text = "\((ob?.avgRating)!)".showRating()
            }
            if cell.lblRating.text == "0.0" || cell.lblRating.text == "0" {
                cell.lblRating.superview?.isHidden = true
            } else {
                cell.lblRating.superview?.isHidden = false
            }
            let url = "\(Server)profile/\((ob?.providerID)!)/\((ob?.profilePic)!)"
            cell.imgUser.uiimage(url, "Group 2826", true, nil)
            if (ob?.userStatus)! == "reject" {
                cell.lblDecline.isHidden = false
            } else if (ob?.providerStatus)! == "pending" {
                cell.btnDelete.isHidden = false
                cell.lblDecline.isHidden = true
            } else if (ob?.providerStatus)! == "accept" {
                if chatshowValue == "1" {
                    cell.btnChatList.isHidden = false
                    cell.viewCountList.isHidden = false
                }
                cell.btnRight.isHidden = false
                cell.btnCross.isHidden = false
            } else if (ob?.providerStatus)! == "reject" {
                cell.lblDecline.isHidden = false
            }
            if data.boolLast == false {
                cell.viewTopView.isHidden = true
                cell.lblDecline.superview?.border5(0)
            } else {
                cell.viewTopView.isHidden = false
                cell.lblDecline.superview?.border(UIColor.hexColor(0xD6D5D8), 16, 1)
            }
            cell.selectionStyle = .none
            processPaging (indexPath)
            return cell
        } else if data.bookings != nil {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MyBookingsCell") as! MyBookingsCell
            
            
            cell.videChatCount.layer.cornerRadius = cell.videChatCount.frame.height/2
           
            
            cell.delegateNew = self
            //MARK: Current History
            print("Image Count:",data.bookings?.images.count ?? 0)
            if (data.bookings?.images.count ?? 0) > 3 {
                cell.PhotoHeight.constant = 250
            }else if (data.bookings?.images.count ?? 0) == 0 {
                cell.PhotoHeight.constant = 0
            }else{
                cell.PhotoHeight.constant = 140
            }
            
            
            
            cell.dele()
            cell.lblShimmer.isHidden = true
            cell.lblShimmer.superview?.isHidden = true
            cell.lblShimmer.stopShimmeringEffect ()
            cell.btnMapPin.isHidden = true
            cell.btnCall.isHidden = true
            cell.btnChatOut.isHidden = true
            cell.videChatCount.isHidden = true
            
            cell.btnCross.isHidden = true
            
            cell.btnRight.isHidden = true
            cell.btnDelete.isHidden = true
            cell.btnDeleteMultiple.isHidden = true
            cell.btnConfirm.isHidden = true
            cell.viewListAllTradies.isHidden = false
            cell.PhotoBottomHeight.constant = 40
            cell.btnListAllTradiesHide.isHidden = false
            cell.btnDispute.isHidden = true
            //cell.viewListAllTradies.isHidden = true
            cell.viewRate.isHidden = true
            cell.viewRating.isHidden = true
            cell.ai.startAnimating()
            let obb = data.bookings
            
            
            print("UUUUUUUUUUUUU)))))))))))______________",obb?.unreadmessage)
            if obb?.unreadmessage != nil {
                print(obb?.unreadmessage)
                cell.lblChatCount.text = "\(obb?.unreadmessage ?? "0")"
            }
            
            
            if obb?.isSelected == nil {
                obb?.isSelected = false
            }
            if obb?.showAllTradies == nil {
                obb?.showAllTradies = false
            }
            if (obb?.isSelected)! {
                cell.images_Upload = data.bookings?.images ?? []
                cell.photoCollection.reloadData()
                cell.View_Collection.isHidden = false
                cell.lblDetail.isHidden = false
                cell.lblDetailTitle.isHidden = false
                cell.lblServiceTypeTitle.isHidden = false
                cell.lblServiceType.isHidden = false
                cell.lblServiceTypeTitle2.isHidden = false
                cell.lblServiceType2.isHidden = false
                cell.lblDetail.text = obb?.detail
                cell.lblServiceType.text = obb?.serviceName.capFirstLetter()
                cell.lblServiceType2.text = obb?.tradieType.capFirstLetter()
                if (data.bookings?.images.count ?? 0) == 0 {
                    cell.View_Collection.isHidden = true
                    
                }
            } else {
                cell.images_Upload = []
                cell.photoCollection.reloadData()
                cell.View_Collection.isHidden = true
                cell.lblDetail.isHidden = true
                cell.lblDetailTitle.isHidden = true
                cell.lblServiceTypeTitle.isHidden = true
                cell.lblServiceType.isHidden = true
                cell.lblServiceTypeTitle2.isHidden = true
                cell.lblServiceType2.isHidden = true
            }
            cell.indexPath = indexPath
            cell.delegate = self
            if obb?.jobPost != nil {
                if (obb?.jobPost.count)! > 0 {
                    let ob = obb?.jobPost[0]
                    cell.lblName.text = ob?.fullName.capFirstLetter()
                    cell.lblStatus.text = ob?.userStatus.uppercased()
                    cell.lblRequirement.text = (obb?.title.capFirstLetter())!
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
                    
                    if Int((ob?.verified)!) == 1 {
                        cell.imgVerified.image = #imageLiteral(resourceName: "Group 4413")
                        cell.imgVerified.isHidden = false
                    } else {
                        cell.imgVerified.image = #imageLiteral(resourceName: "Group 4413")
                        cell.imgVerified.isHidden = true
                    }
                    
                    if Int((ob?.online)!) == 1 {
                        cell.imgOnline.image = #imageLiteral(resourceName: "Ellipse 180")
                        cell.lblOnline.text = "Online"
                    } else {
                        cell.imgOnline.image = #imageLiteral(resourceName: "Ellipse 1801")
                        cell.lblOnline.text = "Offline"
                    }
                    
                    if ob?.avgRating == nil {
                        cell.lblRating.text = "0.0"
                    } else if ob?.avgRating.count == 0 {
                        cell.lblRating.text = "0.0"
                    } else {
                        cell.lblRating.text = "\((ob?.avgRating)!)".showRating()
                    }
                    
                    let url = "\(Server)profile/\((ob?.providerID)!)/\((ob?.profilePic)!)"
                    cell.imgUser.uiimage(url, "Group 2826", true, nil)
                    
                    if obb != nil && ob != nil {
                        showButton(cell, obb!, ob!, indexPath)
                    }
                }
            }
            
            let bool = showAllTradies(obb!, (obb?.jobPost[0])!)
            
            var minus = 0
            
            if bool {
                minus = 21
                
                cell.lblRating.superview?.isHidden = true
                cell.lblName.isHidden = true
                //cell.cnstDetailTop.constant = 180
            } else {
                //cell.cnstDetailTop.constant = 201
                cell.lblRating.superview?.isHidden = false
                cell.lblName.isHidden = false
            }
            
            //cell.cnstTopForHideRating.constant = CGFloat(37 - minus)
            //cell.cnstTopServiceType.constant = CGFloat(131 - minus)
            
            if bool && (obb?.showAllTradies)! {
                cell.viewBottomShadow.isHidden = false
                cell.imgArrow.image = #imageLiteral(resourceName: "Group 4457-2")
            } else {
                cell.imgArrow.image = #imageLiteral(resourceName: "Group 4457-1")
                cell.viewBottomShadow.isHidden = true
            }
            
            if cell.viewRating.isHidden {
                //cell.cnstTop.constant = -8
            } else {
                //cell.cnstTop.constant = 8
            }
            
            var boolHide = false
            
            boolHide = bool
            
            cell.lblOnline.isHidden = boolHide
            cell.imgOnline.isHidden = boolHide
            
            if boolHide {
                cell.imgVerified.isHidden = boolHide
            }
            
            cell.imgUser.isHidden = boolHide
            
            processPaging (indexPath)
            
            if boolCurrent {
                cell.btnDeleteHistory.isHidden = true
            } else {
                cell.viewListAllTradies.isHidden = true
                cell.PhotoBottomHeight.constant = 0
                cell.btnJobDetail.isHidden = false
                cell.btnDeleteHistory.isHidden = false
            }
            
            if cell.lblRating.text == "0.0" || cell.lblRating.text == "0" {
                cell.lblRating.superview?.isHidden = true
            } else {
                cell.lblRating.superview?.isHidden = false
            }
            
            if cell.viewListAllTradies.isHidden == false {
                cell.lblRating.superview?.isHidden = true
                
                if obb?.jobPost != nil {
                    var count = 0
                    
                    for j in 0..<(obb?.jobPost.count)! {
                        let obl = obb?.jobPost[j]
                        
                        if (obl?.providerStatus)! == "pending" {
                            count += 1
                        }
                    }
                    
                    if count == (obb?.jobPost.count)! {
                        cell.btnDeleteMultiple.isHidden = false
                    }
                }
            }
            
            cell.btnViewProfile.isHidden = !(cell.viewListAllTradies.isHidden)
            cell.btnViewProfile1.isHidden = !(cell.viewListAllTradies.isHidden)
            
            cell.ai.isHidden = !(cell.viewListAllTradies.isHidden)
            //cell.lblShimmer.superview?.superview?.addSubview (cell.lblShimmer.superview!)
            if let status = obb?.status {
                if status == "cancel" {
                    cell.lblStatus.text = "Settled".uppercased()
                    cell.btnDispute.isHidden = true
                }
            }
            cell.btnConfirm.isHidden = cell.btnDispute.isHidden
            
            if cell.btnCross.isHidden == false || cell.btnCall.isHidden == false || cell.btnRight.isHidden == false || cell.btnDelete.isHidden == false || cell.btnChatOut.isHidden == false || cell.btnDispute.isHidden == false || cell.btnConfirm.isHidden == false {
                cell.topSpaceListAllTradie.constant = 62
            }else{
                cell.topSpaceListAllTradie.constant = 15
            }
            
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    func processPaging (_ indexPath: IndexPath) {
        let total_cell = totalCells ()
        
        //let rows = 15
        //9713541062
        
        //print("total_cell-\(indexPath.row)-\(total_cell)-\(downloading)-\(total_cell % rows)-")
        
        if indexPath.row == (total_cell - 1) {
            if downloading == .canDownload {
                /*if total_cell % rows == 0 {
                 let page = total_cell / rows
                 
                 downloading = .downloading
                 getListing ("\(page + 1)")
                 }*/
                
                let current_page = Int(self.current_page)! + 1
                
                downloading = .downloading
                getListing ("\(current_page)")
            }
        }
    }
    
    func cellHeight (_ bookings: Bookings, _ jobPost: JobPost, _ indexPath: IndexPath) -> CGFloat {
        
        let data = getData(indexPath)
        
        if data.jobPost != nil {
            print("1XXXXXXXXX -[\(indexPath.row)]-")
            print("Height Return eight",88)
            return 88
        } else {
            let ob = data.bookings
            
            if ob?.isSelected == nil {
                ob?.isSelected = false
            }
            
            let type = getType(ob!)
            
            let extra: CGFloat = 0
            
            let bool = showAllTradies(ob!, (ob?.jobPost[0])!)
            
            if (ob?.isSelected)! {
                print("2XXXXXXXXX -[\(indexPath.row)]-")
                print("Height Return eight",tblMyBookings.estimatedRowHeight - extra)
                return tblMyBookings.estimatedRowHeight - extra
            } else {
                if bool {
                    print("3XXXXXXXXX -[\(indexPath.row)]-")
                    print("Height Return three",180 - 21 - extra)
                    return 180 - 21 - extra
                } else {
                    if boolCurrent {
                        if type == "disputed" {
                            print("4XXXXXXXXX -[\(indexPath.row)]-")
                            print("Height Return one",150 - extra)
                            return 150 - extra
                        } else {
                            print("5XXXXXXXXX -[\(indexPath.row)]-")
                            print("Height Return two",190 - extra)
                            return 210 - extra
                        }
                    } else {
                        if (jobPost.rating.count == 0 &&
                            jobPost.review.count == 0) &&
                            (type == "both_competed" ||
                             type == "provider_competed") {
                            print("6XXXXXXXXX -[\(indexPath.row)]-")
                            print("Height Return four",180 - extra)
                            return 180 - extra
                        } else {
                            if type == "disputed" {
                                print("7XXXXXXXXX -[\(indexPath.row)]-")
                                print("Height Return five",180 - extra)
                                return 180 - extra
                            } else if type == "admin_competed" {
                                print("8XXXXXXXXX -[\(indexPath.row)]-")
                                print("Height Return six",180 - extra)
                                return 180 - extra
                            } else {
                                print("9XXXXXXXXX -[\(indexPath.row)]-")
                                print("Height Return seven",160 - extra)
                                return 160 - extra
                            }
                        }
                    }
                }
            }
        }
    }
    
    func getType (_ bookings: Bookings) -> String {
        var dispute = 0
        
        if Int(bookings.dispute) == 1 {
            dispute = 1
        }
        
        var single = 0
        
        if bookings.type.lowercased() == "single" {
            single = 1
        }
        
        var type = ""
        
        for i in 0..<bookings.jobPost.count {
            let ob = bookings.jobPost[i]
            
            if dispute == 0 {
                if ob.providerStatus! == "completed" && ob.userStatus! == "accept" && bookings.status == "completed" {
                    type = "admin_competed"
                } else
                if ob.providerStatus! == "reject" && ob.userStatus! == "pending" {
                    if type != "pending" && type != "both_competed" && type != "provider_competed" {
                        type = "pending"
                    }
                } else if ob.providerStatus! == "accept" && ob.userStatus! == "pending" {
                    if type != "pending" && type != "both_competed" && type != "provider_competed" {
                        type = "pending"
                    }
                } else if ob.providerStatus! == "pending" && ob.userStatus! == "pending" {
                    if type != "pending" && type != "both_competed" && type != "provider_competed" {
                        type = "pending"
                    }
                } else if ob.providerStatus! == "pending" && ob.userStatus! == "reject" {
                    if type != "pending" && type != "both_competed" && type != "provider_competed" {
                        type = "decline"
                    }
                } else if ob.providerStatus! == "accept" && ob.userStatus! == "accept" {
                    if type != "pending" {
                        type = "accepted"
                    }
                } else if ob.providerStatus! == "accept" && ob.userStatus! == "accept" {
                    if type != "pending" {
                        type = "accepted"
                    }
                } else if ob.providerStatus! == "completed" && ob.userStatus! == "accept" {
                    type = "provider_competed"
                } else if ob.providerStatus! == "pending" && ob.userStatus! == "accept" {
                    if type != "competed" || type != "decline" || type != "accepted" {
                        type = "pending"
                    }
                } else if ob.providerStatus! == "reject" && ob.userStatus! == "accept" {
                    if type != "complete" {
                        type = "decline"
                    }
                } else if ob.providerStatus! == "completed" && ob.userStatus! == "completed" {
                    type = "both_competed"
                }
                
            } else {
                if ob.providerStatus! == "completed" && ob.userStatus! == "completed" {
                    type = "both_competed"
                } else {
                    type = "disputed"
                }
            }
        }
        
        return type
    }
    
    func showButton (_ cell: MyBookingsCell, _ bookings: Bookings, _ jobPost: JobPost, _ indexPath: IndexPath) {
        cell.btnMapPin.isHidden = true
        cell.btnCall.isHidden = true
        cell.btnChatOut.isHidden = true
        cell.videChatCount.isHidden = true
        cell.btnCross.isHidden = true
        cell.btnRight.isHidden = true
        cell.btnDelete.isHidden = true
        cell.btnConfirm.isHidden = true
        cell.viewListAllTradies.isHidden = false
        cell.PhotoBottomHeight.constant = 40
        cell.btnListAllTradiesHide.isHidden = false
        cell.btnDispute.isHidden = true
        //cell.viewListAllTradies.isHidden = true
        cell.viewRate.isHidden = true
        cell.viewRating.isHidden = true
        
        var dispute = 0
        
        if Int(bookings.dispute) == 1 {
            dispute = 1
        }
        
        var single = 0
        
        if bookings.type.lowercased() == "single" {
            single = 1
        }
        
        let type = getType (bookings)
        
        if type == "admin_competed" {
            cell.lblStatus.text = "completed".uppercased()
            
            cell.btnConfirm.isHidden = true
            cell.PhotoBottomHeight.constant = 40
            cell.viewListAllTradies.isHidden = false
            cell.btnListAllTradiesHide.isHidden = false
            cell.btnDispute.isHidden = true
            
            if jobPost.rating.count == 0 && jobPost.review.count == 0 {
                cell.viewRate.isHidden = false
                cell.viewRating.isHidden = true
                
                cell.lblUserReview.text = ""
            } else {
                cell.viewRate.isHidden = true
                
                if bookings.isSelected {
                    cell.viewRating.isHidden = false
                    cell.viewUserRating.rating = Double(jobPost.rating)!
                    cell.lblUserReview.text = jobPost.review
                } else {
                    cell.viewRating.isHidden = true
                    cell.lblUserReview.text = ""
                }
            }
            cell.btnJobDetail.isHidden = true
        } else if type == "pending" {
            if single == 1 {
                cell.lblStatus.text = "pending".uppercased()
                cell.btnDelete.isHidden = false
            } else {
                cell.lblStatus.text = "pending".uppercased()
                cell.viewListAllTradies.isHidden = false
                cell.PhotoBottomHeight.constant = 40
            }
            
            cell.btnJobDetail.isHidden = true
        } else if type == "accepted" {
            if single == 1 {
            } else {
            }
            
            cell.lblStatus.text = "accepted".uppercased()
            
            cell.btnCall.isHidden = false
            
            if chatshowValue == "1" {
                cell.btnChatOut.isHidden = false
                cell.videChatCount.isHidden = false
            }
            
            
            if bookings.serviceType.lowercased() == "immediately" {
                cell.btnMapPin.isHidden = false
            } else {
                cell.btnMapPin.isHidden = true
            }
            cell.viewListAllTradies.isHidden = true
            cell.PhotoBottomHeight.constant = 0
            cell.PhotoBottomHeight.constant = 0
            cell.btnJobDetail.isHidden = false
        } else if type == "provider_competed" {
            if single == 1 { } else { }
            cell.btnConfirm.isHidden = false
            cell.viewListAllTradies.isHidden = true
            cell.PhotoBottomHeight.constant = 0
            cell.btnListAllTradiesHide.isHidden = true
            cell.btnDispute.isHidden = false
            cell.lblStatus.text = "completed".uppercased()
            cell.btnJobDetail.isHidden = true
            
            //MARK: Current
        } else if type == "both_competed" {
            if single == 1 {
            } else {
            }
            cell.lblStatus.text = "completed".uppercased()
            if jobPost.rating.count == 0 && jobPost.review.count == 0 {
                cell.viewRate.isHidden = false
                cell.viewRating.isHidden = true
                
                cell.lblUserReview.text = ""
            } else {
                cell.viewRate.isHidden = true
                
                if bookings.isSelected {
                    cell.viewRating.isHidden = false
                    cell.viewUserRating.rating = Double(jobPost.rating)!
                    cell.lblUserReview.text = jobPost.review
                } else {
                    cell.viewRating.isHidden = true
                    cell.lblUserReview.text = ""
                }
            }
            cell.btnJobDetail.isHidden = true
        } else if type == "decline" {
            if single == 1 {
            } else {
            }
            
            cell.lblStatus.text = "decline".uppercased()
            cell.btnJobDetail.isHidden = true
        } else if type == "disputed" {
            if single == 1 {
            } else {
            }
            
            cell.lblStatus.text = "disputed".uppercased()
            
            if boolCurrent {
                cell.btnConfirm.isHidden = false
                cell.viewListAllTradies.isHidden = true
                cell.PhotoBottomHeight.constant = 0
                cell.btnListAllTradiesHide.isHidden = true
            } else {
                cell.viewRate.isHidden = false
            }
            cell.btnJobDetail.isHidden = true
        }
        
        if cell.lblUserReview.text == "" && type != "pending" {
            //cell.cnstTop.constant = -5
        } else {
            //cell.cnstTop.constant = 20
        }
        
        cell.lblStatus.textColor = getStatusColor((cell.lblStatus.text?.lowercased())!)
        
        return
    }
    
    func showAllTradies (_ bookings: Bookings, _ jobPost: JobPost) -> Bool {
        if bookings.type == "multiple" {
            let type = getType (bookings)
            
            if type == "pending" {
                return true
            } else if type == "accepted" {
                return false
            } else if type == "provider_competed" {
                return false
            } else if type == "both_competed" {
                return false
            } else if type == "decline" {
                return true
            } else if type == "disputed" {
                return true
            }
            
            if jobPost.providerStatus != "accept" &&
                jobPost.userStatus != "accept" {
                return true
            } else {
                return false
            }
        } else {
            return false
        }
    }
}

enum ShowType {
    case call
    case map
    case delete
    case rightcross
    case alllisttradie
    case none
}

struct MyBookingsJSON1: Codable {
    let success: String
    let message: String
    let data: [Bookings]
}

class MyBookingsJSON: Codable {
    let success: String!
    let message: String!
    var data: [Bookings]!
}

struct Bookings1: Codable {
    let id: String
    let title: String
    let serviceID: String
    let detail, address, latitude, longitude: String
    let serviceType, date, time, tradieType: String
    let createdOn: String
    let createdBy: String
    let updatedOn: String
    let updatedBy: String
    let status: String
    let dispute: String
    let disputeResion, type, serviceName: String
    var jobPost: [JobPost]
    //var images: [Images_Upload]
    
    enum CodingKeys: String, CodingKey {
        case id, title
        case serviceID = "service_id"
        case detail, address, latitude, longitude
        case serviceType = "service_type"
        case date, time
        case tradieType = "tradie_type"
        case createdOn = "created_on"
        case createdBy = "created_by"
        case updatedOn = "updated_on"
        case updatedBy = "updated_by"
        case status, dispute
        case disputeResion = "dispute_resion"
        case type
        case serviceName = "service_name"
        //case images = "images"
        case jobPost = "job_post"
    }
}

class Bookings: Codable {
    let id: String!
    let title: String!
    let serviceID: String!
    let detail, address, latitude, longitude: String!
    let serviceType, date, time, tradieType: String!
    let unreadmessage: String!
    let createdOn: String!
    let createdBy: String!
    let updatedOn: String!
    let updatedBy: String!
    let status: String!
    let dispute: String!
    var isSelected: Bool! = false
    var showAllTradies: Bool! = false
    let disputeResion, type, serviceName: String!
    var jobPost: [JobPost]!
    var images: [Images_Upload]
    
    enum CodingKeys: String, CodingKey {
        case id, title
        case serviceID = "service_id"
        case unreadmessage = "unreadmessage"
        case detail, address, latitude, longitude
        case serviceType = "service_type"
        case date, time
        case tradieType = "tradie_type"
        case createdOn = "created_on"
        case createdBy = "created_by"
        case updatedOn = "updated_on"
        case updatedBy = "updated_by"
        case status, dispute
        case disputeResion = "dispute_resion"
        case type
        case serviceName = "service_name"
        case jobPost = "job_post"
        case images = "images"
    }
}

class JobPost: Codable {
    let id, jobPostID, uid, providerID: String!
    let type, userStatus, providerStatus, fullName: String!
    let profilePic: String!
    let online, verified: String!
    let latitude, longitude, mobile, review, email: String!
    let rating: String!
    let avgRating: String!
    let unreadmessage: String!
    
    enum CodingKeys: String, CodingKey {
        case id
        case jobPostID = "job_post_id"
        case email = "email"
        case uid
        case providerID = "provider_id"
        case type
        case userStatus = "user_status"
        case providerStatus = "provider_status"
        case fullName = "full_name"
        case profilePic = "profile_pic"
        case unreadmessage = "unreadmessage"
        case online, verified, latitude, longitude, mobile, review, rating
        case avgRating = "avg_rating"
    }
}

class Images_Upload: Codable {
    let created_at: String!
    let id: String!
    let image_url: String!
    let job_post_id: String!
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

/*struct JobPost: Codable {
 let id, jobPostID, uid, providerID: String
 let type, userStatus, providerStatus, fullName: String
 let profilePic: String
 let online, verified: String
 let latitude, longitude, mobile, review: String
 let rating: String
 let avgRating: String
 
 enum CodingKeys: String, CodingKey {
 case id
 case jobPostID = "job_post_id"
 case uid
 case providerID = "provider_id"
 case type
 case userStatus = "user_status"
 case providerStatus = "provider_status"
 case fullName = "full_name"
 case profilePic = "profile_pic"
 case online, verified, latitude, longitude, mobile, review, rating
 case avgRating = "avg_rating"
 }
 }*/

// MARK: Encode/decode helpers

class JSONNullBookings: Codable, Hashable {
    
    public static func == (lhs: JSONNullBookings, rhs: JSONNullBookings) -> Bool {
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



var chatshowValue = ""



class image_Video_Show: UIViewController {
    
    var images_Upload = [Images_Upload]()
    @IBOutlet weak var pageCtr: UIPageControl!
    @IBOutlet weak var videoView: UIView!
    @IBOutlet weak var viewBack: UIView!
    @IBOutlet weak var Img_View: UIImageView!
    var currentIndex = 0
    let playerController = AVPlayerViewController()
    var player = AVPlayer()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pageCtr.numberOfPages = images_Upload.count
        pageCtr.currentPage = currentIndex
        let swip = UISwipeGestureRecognizer(target: self, action: #selector(updateNewData))
        swip.direction = .left
        viewBack.addGestureRecognizer(swip)
        viewBack.isUserInteractionEnabled = true
        Img_View.addGestureRecognizer(swip)
        Img_View.isUserInteractionEnabled = true
        view.addGestureRecognizer(swip)
        view.isUserInteractionEnabled = true
        
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
