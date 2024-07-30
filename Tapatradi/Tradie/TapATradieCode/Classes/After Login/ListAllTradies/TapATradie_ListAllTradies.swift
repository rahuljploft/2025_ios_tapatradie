//
//  ListAllTradies.swift
//  TapATradie
//
//  Created by Apple on 30/04/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import SDWebImage
import ImageScrollView

protocol TapATradie_ListAllTradiesCellDelegate {
    func deleteClicked (_ indexPath: IndexPath)
    func cellClicked (_ indexPath: IndexPath)
    func rightClicked (_ indexPath: IndexPath)
    func chatList (_ indexPath: IndexPath)
    func crossClicked (_ indexPath: IndexPath)
    func cellViewProfile (_ indexPath: IndexPath)
    func cellSelectCheckBox (_ indexPath: IndexPath)
    func cellImageZoom (_ indexPath: IndexPath)
}

class TapATradie_ListAllTradiesCell: UITableViewCell {
    @IBOutlet weak var btnSelectCheckBox: UIButton!
    
    @IBAction func actionImageZoom(_ sender: Any) {
        delegate.cellImageZoom(indexPath)
    }
    
    @IBAction func actionSelectCheckBox (_ sender: Any) {
        delegate.cellSelectCheckBox (indexPath)
    }
    
    @IBOutlet weak var viewTopView: UIView!
    
    @IBAction func actionViewProfile(_ sender: Any) {
        delegate.cellViewProfile (indexPath)
    }
    
    @IBAction func actionDelete(_ sender: Any) {
        delegate.deleteClicked(indexPath)
    }
    
    @IBOutlet weak var lblDecline: UILabel!
    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var btnRight: UIButton!
    @IBOutlet weak var btnCross: UIButton!
    @IBOutlet weak var btnChatList: UIButton!
    
    @IBOutlet weak var lblCountList: UILabel!
    @IBOutlet weak var viewCountList: UIView!
    var indexPath: IndexPath!
    var delegate: TapATradie_ListAllTradiesCellDelegate!
    
    @IBOutlet weak var lblOnline: UILabel!
    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var imgVerified: UIImageView!
    @IBOutlet weak var imgOnline: UIImageView!
    
    @IBAction func actionCellClicked(_ sender: Any) {
        delegate.cellClicked(indexPath)
    }
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblSubName: UILabel!
    
    @IBOutlet weak var lblRating: UILabel!
    
    @IBAction func actionRight(_ sender: Any) {
        delegate.rightClicked(indexPath)
    }
    
    @IBAction func actionChatList(_ sender: Any) {
        delegate.chatList(indexPath)
    }
    
    @IBAction func actionCross(_ sender: Any) {
        delegate.crossClicked(indexPath)
    }
    
    override func awakeFromNib() {
        imgUser.border5(imgUser.frame.size.height/2)
        lblRating.superview?.border5(2)
    }
    
}

extension TapATradie_ListAllTradies: TapATradie_ListAllTradiesCellDelegate {
    func chatList(_ indexPath: IndexPath) {
        let ob = bookings?.jobPost[indexPath.row]
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
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "MyChatScreen_VC") as! TapATradie_MyChatScreen_VC
        vc.userID = userID
        vc.providerId = providerId
        vc.jobId = jobId
        vc.name = fullName
        vc.profileURl = profilePic
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func cellImageZoom (_ indexPath: IndexPath) {
        zoomImage(indexPath)
    }
    
    func cellSelectCheckBox (_ indexPath: IndexPath) {
        let ob = bookings?.jobPost[indexPath.row]
        if ob?.providerID != nil {
            if let id = Int(ob!.providerID) {
                if self.arrCheckbox.contains(id) {
                    if let index = arrCheckbox.firstIndex(of: id) {
                        self.arrCheckbox.remove(at: index)
                    }
                } else {
                    self.arrCheckbox.append(id)
                }
            }
        }
    }
    
    func cellViewProfile(_ indexPath: IndexPath) {
        
    }
    
    func cellClicked (_ indexPath: IndexPath) {
        let ob = bookings?.jobPost[indexPath.row]
    }
    
    func deleteClicked (_ indexPath: IndexPath) {
        acceptReject("delete", indexPath)
    }
    
    func rightClicked (_ indexPath: IndexPath) {
        acceptReject("accept", indexPath)
    }
    
    func crossClicked (_ indexPath: IndexPath) {
        acceptReject("reject", indexPath)
    }
    
    func acceptReject (_ type: String, _ indexPath: IndexPath) {
        let ob = bookings?.jobPost[indexPath.row]
        
        let param = TapATradie_params()
        param["action"] = type
        //accept / reject/ completed
        
        param["pid"] = ob?.providerID
        param["job_id"] = ob?.jobPostID
        param["type"] = ob?.type
        
        Http.instance().json(TapATradie_api_user_job_action, param, "POST", aai: true, popup: true, prnt: true, nil, nil, sync: false, defaultCalling: false) { (json, para, str, http, data) in
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
                    if type == "reject" {
                        Http.alert("", "Job successfully rejected.")
                    } else if type == "delete" {
                        Http.alert("", "Job successfully deleted.")
                    } else if type == "accept" {
                        Http.alert("", "Job successfully accepted.")
                    }
                    
                    if type == "reject" {
                        self.bookings?.jobPost.remove(at: indexPath.row)
                        self.tblAllTradies.reloadData()
                    } else {
                        self.navigationController?.popViewController(animated: true)
                    }
                } else {
                    Http.alert("", json?.string("message"))
                }
            }
        }
    }
}

class TapATradie_ListAllTradies: UIViewController {
    var arrCheckbox: Array<Int> = Array()
    
    @IBAction func actionUpArrow(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBOutlet weak var lblDeclined: UILabel!
    @IBOutlet weak var lblRequirement: UILabel!
    @IBOutlet weak var lblTimeService: UILabel!
    
    @IBOutlet weak var lblHeadertitle: UILabel!
    
    @IBAction func actionMap(_ sender: Any) {
    }
    
    @IBOutlet weak var viewMap: UIView!
    
    @IBAction func actionBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    var bookings: TapATradie_Bookings?
    
    @IBOutlet weak var tblAllTradies: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewMap.border5(viewMap.frame.size.height/2)
        
        tblAllTradies.border(UIColor.TapATradie_hexColor(0xD6D5D8), 16, 1)
        
        tblAllTradies.delegate = self
        tblAllTradies.dataSource = self
        tblAllTradies.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        TapATradie_kAppDelegate.TapATradie_currentVC = self
        
        if bookings != nil {
            lblDeclined.text = bookings?.status.uppercased()
            
            if bookings?.jobPost != nil {
                if (bookings?.jobPost)!.count > 0 {
                    let obb = bookings?.jobPost[0]
                    
                    lblDeclined.text = obb?.userStatus.uppercased()
                    
                    lblRequirement.text = bookings?.serviceName.capFirstLetter()
                    
                    lblHeadertitle.text = (bookings?.serviceName.capFirstLetter())! + " Tradie List"
                    
                    if (bookings?.date.count)! > 0 && (bookings?.time.count)! > 0 {
                        let arr = bookings?.date.components(separatedBy: "T")
                        
                        if arr != nil {
                            if arr!.count == 2 {
                                let newDate = "\(arr![0]) \((bookings?.time)!)"
                                
                                let dd = newDate.converDate("yyyy-MM-dd HH:mm:ss", "dd")
                                let hh = newDate.converDate("yyyy-MM-dd HH:mm:ss", "hh:mm a")
                                let mmm = newDate.converDate("yyyy-MM-dd HH:mm:ss", "MMM, yyyy")
                                
                                lblTimeService.text = "\(TapATradie_get12HourTime(hh)) on \(dd)th \(mmm)"
                            }
                        }
                    }
                    
                    lblDeclined.textColor = TapATradie_getStatusColor((lblDeclined.text?.lowercased())!)
                }
            }
        }
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
        let ob = bookings?.jobPost[indexPath.row]

        let url = "\(TapATradie_Server)profile/\((ob?.providerID)!)/\((ob?.profilePic)!)"
        
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

extension TapATradie_ListAllTradies: ImageScrollViewDelegate {
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

func TapATradie_get12HourTime (_ convert_time: String) -> String {
    
    if convert_time.count == 5 {
        let arr = convert_time.components(separatedBy: ":")
        
        if arr.count == 2 {
            var hour = Int(arr[0])!
            
            var ampm = "a.m."
            
            if hour > 12 {
                hour -= 12
                ampm = "p.m."
            }
            
            return "\(hour):\(arr[1]) \(ampm)"
        }
        
        return convert_time
    } else {
        return convert_time.replacingOccurrences(of: "AM", with: "a.m.").replacingOccurrences(of: "PM", with: "p.m.")
    }
}

func TapATradie_getStatusColor (_ text: String) -> UIColor {
    if text.lowercased() == "confirmed" {
        return UIColor.TapATradie_hexColor(0x3BAA34)//blue
    } else if text.lowercased() == "accepted" {
        return UIColor.TapATradie_hexColor(0xDB5B1B)
    } else if text.lowercased() == "completed" {
        return UIColor.TapATradie_hexColor(0x999999)//gray
    } else if text.lowercased() == "pending" {
        return  UIColor.TapATradie_hexColor(0x575756)
    } else if text.lowercased() == "declined" {
        //return UIColor.hexColor(0xEF4136)//black
        return UIColor.black
    } else if text.lowercased() == "disputed" {
        return UIColor.TapATradie_hexColor(0xEF4136)//red
    }
    
    return UIColor.black
}

extension TapATradie_ListAllTradies: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (bookings?.jobPost.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListAllTradiesCell") as! TapATradie_ListAllTradiesCell
        
        cell.btnCross.isHidden = true
        cell.btnRight.isHidden = true
        cell.viewCountList.isHidden = true
        cell.btnChatList.isHidden = true
        cell.viewCountList.layer.cornerRadius = cell.viewCountList.layer.frame.height/2
        
        
        cell.btnDelete.isHidden = true
        
        
        
        cell.indexPath = indexPath
        cell.delegate = self
        
        let ob = bookings?.jobPost[indexPath.row]
        
        cell.btnSelectCheckBox.setImage(UIImage(), for: .normal)
        
        if ob?.providerID != nil {
            if let id = Int(ob!.providerID) {
                if self.arrCheckbox.contains(id) {
                    cell.btnSelectCheckBox.setImage(#imageLiteral(resourceName: "Group 4450"), for: .normal)
                } else {
                }
            }
        }
        
        cell.lblName.text = ob?.fullName
        cell.lblSubName.text = bookings?.serviceName.replacingOccurrences(of: ",", with: ", ").capFirstLetter()
        
        if Int((ob?.verified)!)! == 1 {
            cell.imgVerified.image = #imageLiteral(resourceName: "Group 4413")
            cell.imgVerified.isHidden = false
        } else {
            cell.imgVerified.image = #imageLiteral(resourceName: "Group 4413")
            cell.imgVerified.isHidden = true
        }
        
        if Int((ob?.online)!)! == 1 {
            cell.imgOnline.image = #imageLiteral(resourceName: "Ellipse 180")
            cell.lblOnline.text = "Online"
        } else {
            cell.imgOnline.image = #imageLiteral(resourceName: "Ellipse 1801")
            cell.lblOnline.text = "Offline"
        }
        
        if ob?.rating == nil {
            cell.lblRating.text = "0.0"
        } else if ob?.rating.count == 0 {
            cell.lblRating.text = "0.0"
        } else {
            cell.lblRating.text = "\((ob?.rating)!)".showRating()
        }
        
        
        print("\(ob?.unreadmessage ?? "0")")
        if ob?.unreadmessage == nil {
            cell.lblCountList.text = "0"
        } else {
            cell.lblCountList.text = "\(ob?.unreadmessage ?? "0")"
        }
        
        
        if cell.lblRating.text == "0.0" || cell.lblRating.text == "0" {
            cell.lblRating.superview?.isHidden = true
        } else {
            cell.lblRating.superview?.isHidden = true
        }
        
        
        
        let url = "\(TapATradie_Server)profile/\((ob?.providerID)!)/\((ob?.profilePic)!)"
        cell.imgUser.uiimage(url, "Group 2826", true, nil)
        
        if (ob?.providerStatus)! == "pending" {
            print("pending")
            cell.btnDelete.isHidden = false
        } else if (ob?.providerStatus)! == "accept" {
            print("accept")
            cell.btnRight.isHidden = false
            cell.btnChatList.isHidden = false
            
            cell.viewCountList.isHidden = false
            cell.btnCross.isHidden = false
        } else if (ob?.providerStatus)! == "reject" {
            print("reject")
            cell.lblDecline.isHidden = false
        }
        
        return cell
    }
}
