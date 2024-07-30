//
//  RequestTradie.swift
//  TapATradie
//
//  Created by Apple on 23/04/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import Common

import AssetsLibrary
import OpalImagePicker
import Photos
import ImageScrollView
import Alamofire
import ProgressHUD

extension RequestTradie: DrawerTransitionDelegate, SideMenuDelegate {
    
    func initMenu () {
        leftMenu = story_Home.viewController("CustomerMenuViewController") as! CustomerMenuViewController
        leftMenu.delegate = self
        
        self.leftDrawerTransition = DrawerTransition(target: self, drawer: leftMenu)
        self.leftDrawerTransition.setPresentCompletion {  }
        self.leftDrawerTransition.setDismissCompletion {  }
        self.leftDrawerTransition.edgeType = .left
    }
    
    func menuClicked (_ vc: String) {
        if vc == Key_Menu_VC_AboutUs {
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
        } else if vc == Key_Menu_VC_InviteFriends {
            let vc = story_Invite.viewController("InviteFriends")
            self.navigationController?.pushViewController(vc!, animated: false)
        }else if vc == Key_Menu_VC_Support{
            let vc = story_Invite.viewController("SupportVC")
            self.navigationController?.pushViewController(vc!, animated: false)
        }//MARK: Himanshu Update
        else if vc == Key_Menu_VC_HowItWork {
            let vc = story_Invite.viewController("HowItWork_Screen")
            self.navigationController?.pushViewController(vc!, animated: false)
        }else if vc == Key_Menu_VC_FAQ {
            let vc = story_Invite.viewController("FrequentlyAskedQuestion")
            self.navigationController?.pushViewController(vc!, animated: false)
        }
    }
}

class RequestTradie: UIViewController {
    var forServiceCalled: String?
    var imgData = [Data]()
    var videoData = [Data]()
    var totalData : Data?
    
    var finalData = [storDataVideo]()
    var statusDataGreater = true
    var imgList = [UIImage]()
    var strList = [String]()
    var arrSelectedTradies: Array<Int>? //= Array()
    var tradieCount = 0
    
    var boolAPISuccess = false
    
    
    var serviceIDS = ""
    
    struct storDataVideo {
        var video : Data
        var type : String
    }
    
    func addPopUp (_ boolSuccess: Bool, _ msg: String) {
        if boolSuccess {
            imgPopup.image = UIImage(named: "requesticon")
            lblPopupTitle.text = "Thankyou!"
            lblPopupMessage.text = "Your request is successfully submited. Tradies who are interested in your job will contact you directly."
        } else {
            imgPopup.image = #imageLiteral(resourceName: "Group 4655-1")
            lblPopupTitle.text = "Error"
            lblPopupMessage.text = msg//"Something went wrong."
        }
        
        imgPopup.superview?.border5(16)
        
        viewPopUp.frame = self.view.bounds
        self.view.addSubview(viewPopUp)
    }
    
    @IBOutlet weak var const_Height: NSLayoutConstraint!
    @IBOutlet weak var const_Width: NSLayoutConstraint!
    
    @IBOutlet weak var btnViewRequest: UIView!
    @IBOutlet weak var btn_Request: UIButton!
    @IBOutlet weak var view_FullView: UIView!
    @IBOutlet weak var btn_CancelRequest: UIButton!
    @IBOutlet weak var PhotoView_Height: NSLayoutConstraint!
    @IBOutlet weak var selectedPhoto_CollectionView: UICollectionView!
    @IBOutlet var viewPopUp: UIView!
    @IBOutlet weak var imgPopup: UIImageView!
    @IBOutlet weak var lblPopupTitle: UILabel!
    @IBOutlet weak var lblPopupMessage: UILabel!
    var statusCancel = true
    
    @IBAction func actionRemovePopup(_ sender: Any) {
        viewPopUp.removeFromSuperview()
        if boolAPISuccess {
            kAppDelegate.tabbarClicked(IndexPath(row: 1, section: 0), self.navigationController)
        }
    }
    
    @IBAction func actinoCancel(_ sender: UIButton) {
        self.view_FullView.isHidden = true
        request.cancelAllRequests()
    }
    
    @IBAction func actionRemovePopup_new(_ sender: Any) {
        viewPopUp.removeFromSuperview()
        
        if boolAPISuccess {
            kAppDelegate.tabbarClicked(IndexPath(row: 1, section: 0), self.navigationController)
        }
    }
    
    var services: Services?
    var tradies: Tradies?
    
    @IBOutlet weak var tfJobTitle: UITextField!
    @IBOutlet weak var tvJobDetail: UITextField!
    @IBOutlet weak var tfPostcode: UITextField!
    //@IBOutlet weak var tfPinCodecode: UITextField!
    
    @IBOutlet weak var viewDate: UIView!
    @IBOutlet weak var viewTime: UIView!
    
    @IBOutlet weak var lblDate: UILabel!
    
    @IBAction func actionDate(_ sender: Any) {
        self.view.endEditing(true)
        
        pkrDate.minimumDate = Date()
        
        viewDatePicker.frame = self.view.bounds
        self.view.addSubview(viewDatePicker)
    }
    
    @IBOutlet weak var lblTime: UILabel!
    
    @IBAction func actionTime(_ sender: Any) {
        self.view.endEditing(true)
        
        preventTimeSelectionInThePast()
        
        viewTimePicker.frame = self.view.bounds
        self.view.addSubview(viewTimePicker)
    }
    
    private func preventTimeSelectionInThePast() {
        let today = Date().dateComponent
        let now = Date()
        pkrTime.minimumDate = pkrDate.date.dateComponent == today ? now: nil
    }
    
    @IBOutlet weak var btnImmediately: UIButton!
    @IBOutlet weak var btnChooseDate: UIButton!
    @IBOutlet weak var btnResidential: UIButton!
    @IBOutlet weak var btnCommercial: UIButton!
    
    @IBOutlet weak var cnstnSelectYourTradieType: NSLayoutConstraint!
    
    var search = ""
    let request = AF
    var postCode = ""
    
    @IBOutlet weak var lblDisplayCountOfJobTitle: UILabel!
    @IBOutlet weak var lblDisplayCountOfJobDetail: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

       
        
        btnViewRequest.layer.cornerRadius = 10
        btnViewRequest.layer.shadowColor = UIColor.gray.cgColor
        btnViewRequest.layer.shadowOffset = .zero
        btnViewRequest.layer.shadowOpacity = 0.5
        btnViewRequest.layer.shadowRadius = 2
        
        btn_CancelRequest.layer.cornerRadius = 10
        btn_CancelRequest.layer.shadowColor = UIColor.gray.cgColor
        btn_CancelRequest.layer.shadowOffset = .zero
        btn_CancelRequest.layer.shadowOpacity = 0.5
        btn_CancelRequest.layer.shadowRadius = 2
        
        
        view_FullView.isHidden = true
        btn_Request.layer.cornerRadius = 5
        btn_Request.layer.borderColor = UIColor.gray.cgColor
        btn_Request.layer.borderWidth = 0.5
        
        PhotoView_Height.constant = 0
        selectedPhoto_CollectionView.delegate = self
        selectedPhoto_CollectionView.dataSource = self
        let ob = kAppDelegate.getUserAddress()
        kAppDelegate.obAddresses = ob
        
        lblDisplayCountOfJobTitle.text = "0/50"
        lblDisplayCountOfJobDetail.text = "0/500"
        tfPostcode.text = ob?.address
        
        tfJobTitle.delegate = self
        tvJobDetail.delegate = self
        tfPostcode.delegate = self
        //tfPinCodecode.delegate = self
        
        viewDate.border(UIColor.black, 6, 0.25)
        viewTime.border(UIColor.black, 6, 0.25)
        
        btnImmediately.border(UIColor.black, 6, 0.25)
        btnChooseDate.border(UIColor.black, 6, 0.25)
        btnResidential.border(UIColor.black, 6, 0.25)
        btnCommercial.border(UIColor.black, 6, 0.25)
        
        btnImmediately.checked(boolImmediately)
        btnChooseDate.checked(boolChooseDate)
        btnResidential.checked(boolResidential)
        btnCommercial.checked(boolCommercial)
        
        if #available(iOS 13.4, *) {
            pkrDate.preferredDatePickerStyle = .wheels
            pkrTime.preferredDatePickerStyle = .wheels
        }
        
        initMenu ()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_ :)))
        self.view.addGestureRecognizer(tap)
        tap.cancelsTouchesInView = false
        
        
        DispatchQueue.main.asyncAfter(deadline: .now()+3) {
            if kAppDelegate.obAddresses != nil {
                if kAppDelegate.obAddresses?.latitude != nil && kAppDelegate.obAddresses?.longitude != nil {
                    let latitude = (kAppDelegate.obAddresses?.latitude)!
                    let longitude = (kAppDelegate.obAddresses?.longitude)!
                    self.getAddressFromLatLon(pdblLatitude: "\(latitude)", withLongitude: "\(longitude)")
                }
            }
        }
        
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        self.view.endEditing(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        kAppDelegate.currentVC = self
        
        if services != nil && tradies != nil {
            btnNext.setTitle("Post", for: .normal)
        } else {
            btnNext.setTitle("Send Request", for: .normal)
        }
    }
    
    private var leftMenu  = CustomerMenuViewController()
    private var leftDrawerTransition:DrawerTransition!
    
    var boolImmediately = false
    var boolChooseDate = false
    var boolResidential = false
    var boolCommercial = false
    
    @IBAction func actionImmediately(_ sender: UIButton) {
        self.view.endEditing(true)
        boolChooseDate = false
        updateChooseView ()
        btnChooseDate.checked(boolChooseDate)
        boolImmediately = !boolImmediately
        sender.checked(boolImmediately)
    }
    
    func updateChooseView () {
        if boolChooseDate {
            viewTime.isHidden = false
            viewDate.isHidden = false
            cnstnSelectYourTradieType.constant = 100
        } else {
            viewTime.isHidden = true
            viewDate.isHidden = true
            cnstnSelectYourTradieType.constant = 40
        }
    }
    
    @IBAction func actionChooseDate(_ sender: UIButton) {
        self.view.endEditing(true)
        
        boolImmediately = false
        
        btnImmediately.checked(boolImmediately)
        
        boolChooseDate = !boolChooseDate
        
        updateChooseView ()
        
        sender.checked(boolChooseDate)
    }
    
    @IBAction func actionResidential(_ sender: UIButton) {
        self.view.endEditing(true)
        
        boolCommercial = false
        
        btnCommercial.checked(boolCommercial)
        
        boolResidential = !boolResidential
        sender.checked(boolResidential)
    }
    
    @IBAction func actionCommercial(_ sender: UIButton) {
        self.view.endEditing(true)
        
        boolResidential = false
        
        btnResidential.checked(boolResidential)
        
        boolCommercial = !boolCommercial
        sender.checked(boolCommercial)
    }
    
    @IBOutlet var viewDatePicker: UIView!
    @IBOutlet weak var pkrDate: UIDatePicker!
    
    @IBAction func actionCancelDate(_ sender: Any) {
        viewDatePicker.removeFromSuperview()
    }
    
    let Formate_Date = "yyyy-MM-dd"
    let Formate_Time_Server = "HH:mm:ss"
    let Formate_Time_Show = "hh:mm a"
    
    @IBAction func actionDoneDate(_ sender: Any) {
        viewDatePicker.removeFromSuperview()
        
        lblDate.text = pkrDate.date.getStringDate(Formate_Date)
    }
    
    @IBOutlet var viewTimePicker: UIView!
    @IBOutlet weak var pkrTime: UIDatePicker!
    
    @IBAction func actionTimeCancel(_ sender: Any) {
        viewTimePicker.removeFromSuperview()
    }
    
    @IBAction func actionTimeDone(_ sender: Any) {
        viewTimePicker.removeFromSuperview()
        
        serverTime = pkrTime.date.getStringDate(Formate_Time_Server)
        
        let hh = pkrTime.date.getStringDate(Formate_Time_Show)
        let hhh = get12HourTime(hh)
        lblTime.text = hhh
    }
    
    var serverTime = ""
    
    @IBOutlet var btnNext: UIButton!
    
    var boolSendToAll = false
    
    @IBAction func actionNext(_ sender: Any) {
        self.view.endEditing(true)
        print("NEXT")
        if validation () {
            if forServiceCalled != nil {
                //Residential
                if forServiceCalled != "both" {
                    if forServiceCalled! == "Residential" && boolResidential {
                    } else if forServiceCalled! != "Residential" && boolCommercial {
                        
                    } else {
                        if boolResidential {
                            Http.alert("", "Trady don't provide residential service type")
                            return
                        } else if boolCommercial {
                            Http.alert("", "Trady don't provide commercial service type")
                            return
                        }
                        
                    }
                }
            }
            let param = params()
            param["title"] = tfJobTitle.text
            param["detail"] = tvJobDetail.text
            param["address"] = tfPostcode.text
            
            if boolImmediately {
                let date = Date()
                param["service_type"] = "immediately"
                param["date"] = date.getStringDate(Formate_Date)
                param["time"] = date.getStringDate(Formate_Time_Server)
            } else if boolChooseDate {
                param["service_type"] = "later"
                param["date"] = lblDate.text?.replacingOccurrences(of: "Date", with: "")
                param["time"] = serverTime.replacingOccurrences(of: "Time", with: "")
            }
            if boolResidential {
                param["tradie_type"] = "residential"
            } else if boolCommercial {
                param["tradie_type"] = "commercial"
            }
            param["search"] = search
            param["service_id"] = services?.id
            param["postcode"] = postCode
            if kAppDelegate.obAddresses != nil {
                if kAppDelegate.obAddresses?.latitude != nil && kAppDelegate.obAddresses?.longitude != nil {
                    param["latitude"] = (kAppDelegate.obAddresses?.latitude)!
                    param["longitude"] = (kAppDelegate.obAddresses?.longitude)!
                    param["city"] = (kAppDelegate.obAddresses?.city)!
                    param["state"] = (kAppDelegate.obAddresses?.state)!
                    param["country"] = (kAppDelegate.obAddresses?.country)!
                }
            }
            
            
            
            if tradies != nil || boolSendToAll {
                if tradies == nil {
                    param["tradie_id"] = "0"
                    
                    if services == nil {
                        param["search_type"] = search_type
                        
                        if search_type == "services" {
                            param["service_id"] = serviceIDS
                            
                            let arr = serviceIDS.components(separatedBy: ",")
                            
                            if arr.count > 0 {
                                param["service_id"] = arr[0]
                            }
                        } else {
                            param["service_id"] = "0"
                        }
                    }
                } else {
                    param["tradie_id"] = tradies?.id
                }
                
                param.addStaticLocation()
                
                param.addSearchType()
                
                var count111 = 0
                
                if self.arrSelectedTradies != nil {
                    count111 = self.arrSelectedTradies!.count
                }
                
                if self.tradieCount == 1 {
                    if self.arrSelectedTradies!.count > 0 {
                        let arr = NSArray (array: self.arrSelectedTradies!)
                        param ["tradie_id"] = arr.componentsJoined(by: ",")
                    }
                } else if count111 == self.tradieCount {
                    if tradies?.id == nil {
                        param ["tradie_id"] = "0"
                    }
                } else {
                    if self.arrSelectedTradies!.count > 0 {
                        let arr = NSArray (array: self.arrSelectedTradies!)
                        param ["tradie_id"] = arr.componentsJoined(by: ",")
                    }
                }
                
                //MARK: Himanshu Update -- New Code Write For selected tradie request
                if count111 != 0 {
                    let arr = NSArray (array: self.arrSelectedTradies!)
                    param ["tradie_id"] = arr.componentsJoined(by: ",")
                }
                
                print("H param-[\(param)]-")
                
                createPostAPICall(videoData: videoData, imagesData: imgData, imageparam: "images", endPoint: api_user_job_request_to_tradie, param: param as! [String : Any])
            } else {
                if tradies == nil {
                    param["tradie_id"] = "0"
                } else {
                    param["tradie_id"] = tradies?.id
                }
                
                let vc = story_Home.viewController("TradieList") as! TradieList
                vc.paramSendToAll = param
                param["search_type"] = ""
                
                vc.tradie_type = param["tradie_type"] as? String
                vc.services = services
                vc.tradiesJSON = nil
                vc.search = search
                vc.boolGoToServiceSelection = false
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    
    func getAddressFromLatLon(pdblLatitude: String, withLongitude pdblLongitude: String) {
        var center : CLLocationCoordinate2D = CLLocationCoordinate2D()
        let lat: Double = Double("\(pdblLatitude)") ?? 0.0
        let lon: Double = Double("\(pdblLongitude)") ?? 0.0
        let ceo: CLGeocoder = CLGeocoder()
        center.latitude = lat
        center.longitude = lon
        
        print("pdblLatitude",pdblLatitude)
        print("pdblLongitude",pdblLongitude)
        
        let loc: CLLocation = CLLocation(latitude:center.latitude, longitude: center.longitude)
        ceo.reverseGeocodeLocation(loc, completionHandler: {(placemarks, error) in
            if (error != nil)
            {
                print("reverse geodcode fail: \(error!.localizedDescription)")
                return
            }
            
            guard let chack = placemarks else{
                return
            }
            
            let pm = placemarks! as [CLPlacemark]
            
            if pm.count > 0 {
                if placemarks?[0] != nil {
                    let pm = placemarks![0]
                    var addressString : String = ""
                    if pm.postalCode != nil {
                        print("\(pm.postalCode ?? "")")
                        self.postCode = "\(pm.postalCode ?? "")"
                    }
                    print(pm.postalCode)
                }
            }
        })
    }
    

    @IBAction func Action_UploadDoc(_ sender: Any) {
        print("Upload Doc")
        picturePicker()
    }
    
    
    
    var search_type = ""
    
    func validateGenericString(_ string: String) -> Bool {
        return string.range(of: ".*[$&+:;=\\\\?#|/<>^*()%!].*", options: .regularExpression) == nil
    }
    
    
    func validation () -> Bool {
        var msg: String? = nil
        
        print(validateGenericString(tfJobTitle.text ?? ""))
        if !validateGenericString(tfJobTitle.text ?? "") {
            msg = "Special character are not allowed in job title!"
            showAlert(msgVal: "Special character are not allowed in job title!")
        }
        
        print(validateGenericString(tvJobDetail.text ?? ""))
        if !validateGenericString(tvJobDetail.text ?? "") {
            msg = "Special character are not allowed in job detail!"
            showAlert(msgVal: "Special character are not allowed in job detail!")
        }
        
        
        print("Add Validation")
        
        print(tfJobTitle.text?.count ?? 0)
        if (tfJobTitle.text?.count ?? 0) >= 50 {
            msg = "Please enter character less then 50 in job title!"
            showAlert(msgVal: "Please enter character less then 50 in  job title!")
        }
        
        print(tvJobDetail.text?.count ?? 0)
        if (tvJobDetail.text?.count ?? 0) >= 500 {
            msg = "Please enter character less then 500 in job detail!"
            showAlert(msgVal: "Please enter character less then 500 in  job detail!")
        }
        
        
        if tfJobTitle.text?.count == 0 {
            msg = "Please enter job title."
        } else if tvJobDetail.text?.count == 0 {
            msg = "Please enter job detail."
        } else if tfPostcode.text?.count == 0 {
            msg = "please enter address."
        } else if boolImmediately == false && boolChooseDate == false {
            msg = "Please select when would you like your services"
        } else if boolChooseDate == true && lblDate.text == "Date" {
            msg = "Please select date."
        } else if boolChooseDate == true && lblTime.text == "Time" {
            msg = "Please select time."
        } else if boolResidential == false && boolCommercial == false {
            msg = "Please select your tradie type."
        }
        
        if msg != nil {
            Http.alert("", msg!)
            return false
        } else {
            return true
        }
    }
    
    
    func showAlert(msgVal:String) {
        let alert = UIAlertController(title: "Tap A Tradie", message: "\(msgVal)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel))
        self.present(alert, animated: true)
    }
}

extension RequestTradie: PlanceApiDelegate {
    func PlaceApiData(_ ob: Addresses) {
        kAppDelegate.obAddresses = ob
        tfPostcode.text = ob.address!
    }
}

extension RequestTradie: UITextFieldDelegate, UITextViewDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == tfPostcode {
            let place = story_Auth.viewController("PlaceApiViewController") as! PlaceApiViewController
            place.delegate = self
            self.present(place, animated: true, completion: nil)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string == "\n" {
            textField.resignFirstResponder()
            
            return false
        }
        
        if  tfJobTitle == textField {
            let newLength = textField.text!.count + string.count - range.length
            
            self.lblDisplayCountOfJobTitle.text = "\(String(describing:newLength))/50"
            
            if tfJobTitle.text?.count ?? 0 > 48 {
                if string.count == 0 {
                    return true
                }
                
                return false
            } else {
                return true
            }
        }else if tvJobDetail == textField {
            let newLength = textField.text!.count + string.count - range.length
            
            self.lblDisplayCountOfJobDetail.text = "\(String(describing:newLength))/500"
            
            if tvJobDetail.text?.count ?? 0 > 498 {
                if string.count == 0 {
                    return true
                }
                
                return false
            } else {
                return true
            }
            
        }
        
        return true
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            
            return false
        }
        
        return true
    }
}

extension UIButton {
    func checked (_ bool: Bool) {
        self.setTitleColor(UIColor.hexColor(0x343432), for: .normal)
        if bool {
            self.layer.borderColor = UIColor.hexColor(0x008000).cgColor
            self.layer.borderWidth = 1
        } else {
            self.layer.borderColor = UIColor.black.cgColor
            self.layer.borderWidth = 0.25
        }
    }
}

extension NSMutableDictionary {
    func addSearchType () {
        let searchType = self["search_type"] as? String
        if searchType == nil {
            self["search_type"] = ""
        }
    }
}

extension String {
    var url: URL? {
        if let str = addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
            return URL(string: str)
        }
        return nil
    }
}

extension String {
    func concat (_ add: String?, _ with: String = ",") -> String {
        if add == nil {
            return self
        }
        
        if add!.count == 0 {
            return self
        }
        
        var str = self
        
        if str.count == 0 {
            str = add!
        } else {
            str = "\(str)\(with)\(add!)"
        }
        
        return str
    }
}





//MARK: Upload Doc Section

extension RequestTradie: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    func picturePicker () {
        let myalert = UIAlertController(title: "Choose option", message: "", preferredStyle: UIAlertController.Style.actionSheet)
        
        myalert.addAction(UIAlertAction(title: "Camera", style: .default) { (action:UIAlertAction!) in
            self.openCamera()
        })
        
        myalert.addAction(UIAlertAction(title: "Gallery", style: .default) { (action:UIAlertAction!) in
            self.openGallary()
        })
        
        myalert.addAction(UIAlertAction(title: "Cancel", style: .cancel) { (action:UIAlertAction!) in
        })
        self.present(myalert, animated: true)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            print("Camera Upload Profile Picture")
            if self.finalData.count < 5 {
                guard let imgD = pickedImage.pngData() else {return}
                self.totalData = (self.totalData ?? Data()) + imgD
                self.finalData.append(storDataVideo(video: imgD, type: "image"))
                self.imgList.append(pickedImage)
                DispatchQueue.main.async {
                    if self.imgList.count > 3 {
                        self.PhotoView_Height.constant = 250
                    }else{
                        self.PhotoView_Height.constant = 125
                    }
                    self.statusDataGreater = false
                    self.selectedPhoto_CollectionView.reloadData()
                }
                
            }else{
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "", message: "Maximum Image/Video Uploading limit is 5", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { alertVal in
                    }))
                    self.present(alert, animated: true)
                }
            }
        } else {
            print(info[UIImagePickerController.InfoKey.mediaURL])
            guard let myAsset = info[UIImagePickerController.InfoKey.mediaURL] as? NSURL else {
                print("Return Done")
                return
            }
            do {
                let videoData = try? Data(contentsOf: (myAsset as URL))
                print(videoData)
                //let image = i.getAssetThumbnail(CGSize(width: 500, height: 500))
                self.imgList.append(UIImage(named: "requesticon")!)
                self.totalData = (self.totalData ?? Data()) + videoData!
                print("total Data -",self.totalData)
                self.strList.append("video")
                self.finalData.append(storDataVideo(video: videoData!, type: "video"))
                self.videoData.append(videoData!)
                self.checkDataGreater()
            }
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.isNavigationBarHidden = false
        self.dismiss(animated: true, completion: nil)
    }
    
    func openCamera() {
        let imagePicker = UIImagePickerController()
        imagePicker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .camera)!
        imagePicker.delegate = self
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera)) {
            
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        } else {
            let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func openGallary() {
        print(imgData)
        let mexImages = 5-self.finalData.count
        print(mexImages)
        if mexImages != 0 {
            let imagePicker = OpalImagePickerController()
            imagePicker.allowedMediaTypes = Set(arrayLiteral: PHAssetMediaType.image, PHAssetMediaType.video)
            imagePicker.maximumSelectionsAllowed = mexImages
            //Present Image Picker
            presentOpalImagePickerController(imagePicker, animated: true, select: { (im) in
                let countval = im.count
                var increase = 0
                for i in im {
                    print(i)
                    let type = "\(i.mediaType.rawValue)"
                    print(type)
                    if type == "1" {
                        let image = i.getAssetThumbnail(CGSize(width: 500, height: 500))
                        guard let imgD = image!.pngData() else {return}
                        self.totalData = (self.totalData ?? Data()) + imgD
                        self.imgList.append(image!)
                        print("total Data -",self.totalData)
                        increase = increase + 1
                        self.imgData.append(imgD)
                        self.strList.append("Image")
                        self.finalData.append(storDataVideo(video: imgD, type: "image"))
                        self.checkDataGreater()
                        self.alert(inc: increase, Cou: countval)
                    }else{
                        PHImageManager.default().requestAVAsset(forVideo: i, options: nil, resultHandler: { [self] (asset, mix, nil) in
                            guard let myAsset = asset as? AVURLAsset else {
                                return
                            }
                            do {
                                let videoDataNew = try Data(contentsOf: (myAsset.url))
                                print(videoDataNew)
                                
                                //let image = i.getAssetThumbnail(CGSize(width: 500, height: 500))
                                self.imgList.append(UIImage(named: "requesticon")!)
                                self.totalData = (self.totalData ?? Data()) + videoDataNew
                                print("total Data -",self.totalData)
                                increase = increase + 1
                                self.strList.append("video")
                                self.finalData.append(storDataVideo(video: videoDataNew, type: "video"))
                                self.videoData.append(videoDataNew)
                                self.checkDataGreater()
                                self.alert(inc: increase, Cou: countval)
                            } catch  {
                                print("exception catch at block - while uploading video")
                            }
                        })
                    }
                }
                
                
                
                
                print(self.imgData)
                var imageArr: [UIImage] = []
                for i in 0..<im.count {
                    let cc = im[i].getAssetThumbnail(CGSize(width: 500, height: 500))
                    imageArr.append(cc!)
                }
                
                
                //Dismiss Controller
                imagePicker.dismiss(animated: true, completion: nil)
                if imageArr.count > 0 {
                    self.API_UploadImage(imgarry: imageArr)
                }
            }, cancel: {
                print("Cancel")
            })
            
        }else{
            let alert = UIAlertController(title: "", message: "Maximum 5 Images/Videos are allowed to select", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { alertView in
                print("")
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func alert(inc: Int,Cou: Int){
        print("increase",inc)
        print("countval",Cou)
        if inc == Cou {
            print("Alert Show")
            if self.statusDataGreater == true {
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "", message: "Please Select Images/Video Less then 500 MB", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { res in
                        print("Cancel")
                        self.totalData?.removeAll()
                    }))
                    self.present(alert, animated: true)
                }
            }
        }
    }
    
    func checkDataGreater() {
        let str = "\(self.totalData ?? Data())"
        print(str)
        let dataArr = str.components(separatedBy: " ")
        print(dataArr)
        if dataArr.count > 0 {
            let convertedData = Double(dataArr[0])
            print(convertedData ?? 0.0)
            let finalTest = (convertedData ?? 0.0)/1000000
            print(finalTest)
            if finalTest > 500 {
                statusDataGreater = true
                DispatchQueue.main.async {
                    if self.imgList.count > 3 {
                        if self.statusDataGreater == true {
                            self.PhotoView_Height.constant = 0
                        }else{
                            self.PhotoView_Height.constant = 250
                        }
                    }else{
                        if self.statusDataGreater == true {
                            self.PhotoView_Height.constant = 0
                        }else{
                            self.PhotoView_Height.constant = 125
                        }
                    }
                    self.selectedPhoto_CollectionView.reloadData()
                }
            }else{
                statusDataGreater = false
                DispatchQueue.main.async {
                    if self.imgList.count > 3 {
                        if self.statusDataGreater == true {
                            self.PhotoView_Height.constant = 0
                        }else{
                            self.PhotoView_Height.constant = 250
                        }
                    }else{
                        if self.statusDataGreater == true {
                            self.PhotoView_Height.constant = 0
                        }else{
                            self.PhotoView_Height.constant = 125
                        }
                    }
                    self.selectedPhoto_CollectionView.reloadData()
                }
            }
        }
        
    }
 
    
    
    func API_UploadImage(imgarry:[UIImage]){
        //Add Param Here
        
        for image in imgarry{
            guard let imgD = image.pngData() else {return}
            //print("Data: ",imgD)
            //imgList = imgarry
        }

        if imgList.count > 3 {
            if statusDataGreater == true {
                PhotoView_Height.constant = 0
            }else{
                PhotoView_Height.constant = 250
            }
        }else{
            if statusDataGreater == true {
                PhotoView_Height.constant = 0
            }else{
                PhotoView_Height.constant = 125
            }
        }
        selectedPhoto_CollectionView.reloadData()
        
    }
    

    
}


extension PHAsset {
    func getAssetThumbnail (_ size: CGSize = CGSize(width: 100, height: 100)) -> UIImage? {
        let manager = PHImageManager.default()
        let option = PHImageRequestOptions()
        var thumbnail: UIImage?
        option.isSynchronous = true
        manager.requestImage(for: self, targetSize: size, contentMode: .aspectFit, options: option, resultHandler: {(result, info)->Void in
            if result != nil {
                thumbnail = result!
            }
        })
        return thumbnail
    }
}


extension RequestTradie{
    
    
    //MARK: - UPLOAD MEDIA IN MULTI-PART with Header
//    func uploadMediaRequest(imagesData:[Data], imageparam:String, endPoint: String, _ param : [String : Any],_ fileParams:[String : Any]?, _ fileName: String, callback: @escaping ([String : Any]) -> Void) {
//        //For file upload make send content-type  multipart
//        let headers = HTTPHeaders([ "content-type": "multipart/form-data", "Authorization":""])
//        print("url \(endPoint)")
//        print("param \(param)")
//        print("headers \(headers)")
//
//        AF.upload(multipartFormData:{ multiPart in
//
//            for (key, value) in param {
//                if let temp = value as? String {
//                    multiPart.append(temp.data(using: .utf8)!, withName: key)
//                }
//                if let temp = value as? Int {
//                    multiPart.append("\(temp)".data(using: .utf8)!, withName: key)
//                }
//                if let temp = value as? NSArray {
//                    temp.forEach({ element in
//                        let keyObj = key + "[]"
//                        if let string = element as? String {
//                            multiPart.append(string.data(using: .utf8)!, withName: keyObj)
//                        } else
//                        if let num = element as? Int {
//                            let value = "\(num)"
//                            multiPart.append(value.data(using: .utf8)!, withName: keyObj)
//                        }
//                    })
//
//                }
//                if let dict = value as? NSDictionary{
//                    var workingHoursJson = String()
//                    if let theJSONData = try? JSONSerialization.data(
//                        withJSONObject: dict,
//                        options: []) {
//                        multiPart.append(theJSONData, withName: "working_hours")
//                        workingHoursJson = String(data: theJSONData, encoding: .ascii)!
//                        print("JSON string = \(workingHoursJson)")
//                    }
//                }
//            }
//
//
//            for imagedata in imagesData{
//                multiPart.append(imagedata, withName: imageparam, fileName: "\(Date().timeIntervalSince1970).jpg", mimeType: "image/jpeg")
//            }
//
//        }, to:endPoint, method:.post, headers:headers)
//        .uploadProgress(queue: .main, closure: { progress in
//            //Current upload progress of file
//            print("Upload Progress: \(progress.fractionCompleted)")
//            if Int(progress.fractionCompleted) == 1{
//                print("Image upload success")
//            }
//        })
//        .responseJSON(completionHandler: { response in
//            print("image upload debug \(param)\n response \(response)")
//            self.requestCallBack(result: response.result, callback: callback)
//        })
//        .cURLDescription { (description) in
//            print("curl description \(description)")
//        }
//
//    }
    
    //MARK: ImageUpload Start ---------
    func createPostAPICall(videoData:[Data],imagesData:[Data], imageparam:String, endPoint: String,  param : [String : Any]) {
        ProgressHUD.colorProgress = .systemOrange
        ProgressHUD.colorAnimation = .systemBlue
        ProgressHUD.colorBackground = .black.withAlphaComponent(0.5)
        ProgressHUD.colorHUD = .systemGray
        ProgressHUD.animationType = .circleStrokeSpin
        ProgressHUD.showProgress(0.001)
        let mainWindow = UIApplication.shared.windows.first ?? UIWindow()
        view_FullView.isHidden = false
        const_Width.constant = view.frame.width
        const_Height.constant = view.frame.height
        view_FullView.isHidden = false
        mainWindow.addSubview(self.view_FullView!)
        
        
        //let headers = HTTPHeader(name: "content-type", value: "multipart/form-data")
        let headers = HTTPHeaders(["content-type": "multipart/form-data","Authorization": ""])
        print("url \(endPoint)")
        print("param \(param)")
        print("headers \(headers)")
        
        
        
        request.upload(multipartFormData:{ multiPart in
            for (key, value) in param {
                if let temp = value as? String {
                    multiPart.append(temp.data(using: .utf8)!, withName: key)
                }
                if let temp = value as? Int {
                    multiPart.append("\(temp)".data(using: .utf8)!, withName: key)
                }
                if let temp = value as? NSArray {
                    temp.forEach({ element in
                        let keyObj = key + "[]"
                        if let string = element as? String {
                            multiPart.append(string.data(using: .utf8)!, withName: keyObj)
                        } else
                        if let num = element as? Int {
                            let value = "\(num)"
                            multiPart.append(value.data(using: .utf8)!, withName: keyObj)
                        }
                    })
                }
                if let dict = value as? NSDictionary{
                    var workingHoursJson = String()
                    if let theJSONData = try? JSONSerialization.data(
                        withJSONObject: dict,
                        options: []) {
                        multiPart.append(theJSONData, withName: "working_hours")
                        workingHoursJson = String(data: theJSONData, encoding: .ascii)!
                        print("JSON string = \(workingHoursJson)")
                    }
                }
            }
            
            print(self.finalData)
            for imagedata in self.finalData{
                if imagedata.type == "video" {
                    multiPart.append(imagedata.video, withName:imageparam, fileName: "video.mp4", mimeType: "video/mp4")
                }else{
                    multiPart.append(imagedata.video, withName:imageparam, fileName: "image.jpg", mimeType: "image/jpeg")
                }
            }
        }, to:endPoint, method:.post, headers:headers)
        .uploadProgress(queue: .main, closure: { progress in
            ProgressHUD.showProgress(progress.fractionCompleted)
            print("Progress Progress Progress :- ",progress.fractionCompleted)
            self.const_Width.constant = self.view.frame.width
            self.const_Height.constant = self.view.frame.height
            mainWindow.addSubview(self.view_FullView!)
            if progress.fractionCompleted > 1{
                print("Success Full Uploaded...")
            }
        })
        .responseJSON(completionHandler: { response in
            print("image upload debug \(param)\n response \(response)")
            switch response.result {
            case .success(let site):
                let dict = site as? NSDictionary
                print(dict)
                //self.view_FullView.removeFromSuperview()
                self.view_FullView.isHidden = true
                ProgressHUD.dismiss()
                print(dict?["message"] as? String ?? "")
                print(dict?["post_id"] as? Int ?? 0)
                print(dict?["success"] as? Int ?? 0)
                let success = dict?["success"] as? Int ?? 0
                let message = dict?["message"] as? String ?? ""
                if success == SESSIONEXPIRED {
                    kAppDelegate.sessionExpired(self)
                    return
                }
                if dict != nil {
                    if success == 1 {
                        self.boolAPISuccess = true
                        self.addPopUp(true, "")
                    } else if success == 0 {
                        self.boolAPISuccess = false
                        self.addPopUp(false, (message))
                    }
                }
            case .failure(let err):
                //self.view_FullView.removeFromSuperview()
                self.view_FullView.isHidden = true
                ProgressHUD.dismiss()
                print("Error -- ",err.localizedDescription)
            }
        })
        .cURLDescription { (description) in
            print("curl description \(description)")
        }
    }
    //MARK: ImageUpload End ---------
    

    
    
     func requestCallBack(result: Result<Any, AFError>, callback: ([String : Any]) -> Void) {
        switch result {
        case .success(let info):
//            print(JSON(info))
//            Common.sharedInstance.printMsg(info)
            
            if let dic = info as? [String : Any]{
                if let code = dic["code"] as? Int, code == Code.expireToken.rawValue{
//                    Common.sharedInstance.hideHud();
                    Http.stopActivityIndicator()
                    print("====================================================================================================================================================")
//                    print(kErrorExpiredToken)
                    
                    
                    return
                }else if let code = dic["code"] as? Int, code == Code.maintainenceToken.rawValue {
//                    Common.sharedInstance.hideHud();
        
                    Http.stopActivityIndicator()
                   let msg = dic["message"] as? String
                    print("====================================================================================================================================================")
                    print(msg)
                    return
                    
                    
                }else{
                    callback(dic);
                }
                return
            }
            
        case .failure(let error):
//            Common.sharedInstance.printMsg(error.localizedDescription)
            print(error.localizedDescription)
//            callback(getErrorMessage(error.localizedDescription));
            
        }
        
    }
}


public enum Code : Int {
    case updateApp                  = 402
    case updateAppOptional          = 403
    case expireToken                = 501
    case maintainenceToken          = 503
}



extension RequestTradie: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if statusDataGreater == true {
            return 0
        }else{
            return imgList.count
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "selectedCell_Img", for: indexPath) as! selectedCell_Img
        cell.Img_CrossButton.tag = indexPath.row
        cell.Img_CrossButton.layer.cornerRadius = cell.Img_CrossButton.frame.width/2
        cell.Img_CrossButton.addTarget(self, action: #selector(updateSelectedPhoto), for: .touchUpInside)
        print(imgList[indexPath.row])
        cell.Img_Photo.image = imgList[indexPath.row]
        cell.Img_Photo.layer.shadowColor = UIColor.gray.cgColor
        cell.Img_Photo.layer.shadowRadius = 1
        cell.Img_Photo.layer.shadowOffset = .zero
        cell.Img_Photo.layer.shadowOpacity = 0.5
        
        cell.view_Card.layer.cornerRadius = 8
        cell.Img_Photo.layer.cornerRadius = 8
        cell.Img_Height.constant = selectedPhoto_CollectionView.frame.width/3.2
        cell.Img_Width.constant = selectedPhoto_CollectionView.frame.width/3.2
        return cell
    }
    
    @objc func updateSelectedPhoto(sender:UIButton) {
        print("\(sender.tag)")
        
        finalData.remove(at: sender.tag)
        imgList.remove(at: sender.tag)
        if imgList.count == 0 {
            PhotoView_Height.constant = 0
        }else if imgList.count > 3 {
            PhotoView_Height.constant = 250
        }else{
            PhotoView_Height.constant = 125
        }
        selectedPhoto_CollectionView.reloadData()
    }
    
}


class selectedCell_Img: UICollectionViewCell {
    
    @IBOutlet weak var view_Card: UIView!
    @IBOutlet weak var Img_Photo: UIImageView!
    @IBOutlet weak var Img_Height: NSLayoutConstraint!
    @IBOutlet weak var Img_Width: NSLayoutConstraint!
    
    @IBOutlet weak var Img_CrossButton: UIButton!
}
