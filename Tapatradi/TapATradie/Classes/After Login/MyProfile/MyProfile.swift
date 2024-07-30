//
//  MyProfile.swift
//  TapATradie
//
//  Created by Apple on 29/04/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import ImageScrollView

class MyProfile: UIViewController, DeleteAccount {
    func deleteAccountSuccess() {
        print("Logout Successfully")
        kAppDelegate.logout (self)
    }
    
    
    @IBOutlet weak var viewc: UIView!
    @IBOutlet weak var viewDelete: UIView!
    
    @IBOutlet weak var tblView: UITableView!
    
    @IBOutlet weak var btnCamera: UIButton!
    
    @IBAction func actionCamera(_ sender: Any) {
        actionChangeProfilePicture("")
    }
    
    @IBOutlet weak var btnChange: UIButton!
    
    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    var previousValue = 1000
    
    override func viewWillAppear(_ animated: Bool) {
        kAppDelegate.currentVC = self
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewDelete.layer.cornerRadius = 5
        viewDelete.layer.borderWidth = 1
        viewDelete.layer.borderColor = UIColor.gray.cgColor
        let profilePic = Key_User_profile_pic.getUserValue() as! String
        if profilePic.count > 0 {
            let url = "\(Server)profile/\(Key_User_id.getUserValue() as! Int)/\(Key_User_profile_pic.getUserValue() as! String)"
            print("url-\(url)-")
            imgUser.downloaded(from: "\(url)",contentMode: .scaleToFill)
            print("First")
        } else {
            print("Second")
            imgUser.image = UIImage(named: "Group 2826")
            //btnChange.isHidden = true
            //btnCamera.isHidden = false
        }
        btnCamera.isHidden = false
        btnChange.isHidden = true
        imgUser.superview!.border(UIColor.white, imgUser.frame.size.height/2, 2)
        tfmFullName.backgroundColor = UIColor.white
        tfmEmail.backgroundColor = UIColor.white
        tfmMobile.backgroundColor = UIColor.white
        tfmFullName.placeHolder = "Full Name"
        tfmEmail.placeHolder = "Email"
        tfmEmail.keyboardType = UIKeyboardType.emailAddress
        tfmMobile.placeHolder = "Mobile No."
        tfmMobile.keyboardType = UIKeyboardType.numberPad
        tfmFullName.text = ((Key_User_full_name.getUserValue() as? String)?.capFirstLetter())!
        tfmEmail.text = (Key_User_email.getUserValue() as? String)!
        
        
        
        
        //tfmMobile.text = (Key_User_mobile.getUserValue() as? String)!
        tfmMobile.text = (Key_User_mobile_withCode.getUserValue() as? String)!
        if tfmFullName.text.count == 0 {
            tfmFullName.messageText = "Required"
        } else {
            tfmFullName.messageText = ""
        }
        if tfmEmail.text.count == 0 {
            tfmEmail.messageText = ""
        } else {
            tfmEmail.messageText = ""
        }
        if tfmMobile.text.count == 0 {
            tfmMobile.messageText = "Required"
        } else {
            tfmMobile.messageText = ""
        }
        
        setFirstName ()
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_ :)))
        self.view.addGestureRecognizer(tap)
        tap.cancelsTouchesInView = false
        //viewc.addShadow(cornerRadius: 6)
        //tblView.layer.cornerRadius = 8
        //tblView.clipsToBounds = true
        viewc.setCornerRadiusWithBorder(cornerRadius: 6, clipsToBound: true, borderWidth: 1, borderColor: UIColor(named: "#000000 - 10")?.cgColor)
        viewc.addShadow(offset: CGSize(width: 0, height: 4), color: .lightGray, radius: 4, opacity: 0.25, cornerRadius: 6)
   
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        print("\(textField.text ?? "")")
        
        let bool = validEmail ("\(textField.text ?? "")")
        //print(bool)
        if bool {
            (textField.superview as? MaterialTextFieldView)?.status = .varified
            (textField.superview as? MaterialTextFieldView)?.showNoError()
        } else {
            (textField.superview as? MaterialTextFieldView)?.status = .error
            (textField.superview as? MaterialTextFieldView)?.lblMsg.text = wrongEmailMsg
            (textField.superview as? MaterialTextFieldView)?.showError()
            (textField.superview as? MaterialTextFieldView)?.lblMsg.isHidden = false
        }
        
    }
    
    
    @IBAction func actionDeleteAccount(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "MyDeleteAccountVC") as! MyDeleteAccountVC
        vc.modalPresentationStyle = .overFullScreen
        vc.delegate = self
        self.present(vc, animated: true)
    }
    
    
    func setFirstName () {
        lblName.text = ((Key_User_full_name.getUserValue() as? String))!
    }
    
    override func viewDidAppear(_ animated: Bool) {
        tfmMobile.isUserInteractionEnabled = false
        
        if tfmFullName.text.count == 0 {
            tfmFullName.hideImg = true
        } else {
            tfmFullName.hideImg = false
        }
        
        if tfmEmail.text.count == 0 {
            tfmEmail.hideImg = true
        } else {
            tfmEmail.hideImg = false
        }
        
        if tfmMobile.text.count == 0 {
            tfmMobile.hideImg = true
        } else {
            tfmMobile.hideImg = false
        }
        
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        self.view.endEditing(true)
    }
    
    @IBOutlet weak var tfmFullName: MaterialTextFieldView!
    @IBOutlet weak var tfmEmail: MaterialTextFieldView!
    @IBOutlet weak var tfmMobile: MaterialTextFieldView!
    
    func validation () -> Bool {
        var msg: String? = nil
        
        if (tfmFullName.textField.text?.count ?? 0) >= 250 {
            msg = "Please enter name less then 250 character."
            showAlr(msg: msg ?? "")
        } else if (tfmEmail.textField.text?.count ?? 0) >= 250 {
            msg = "Please enter email less then 250 character."
            showAlr(msg: msg ?? "")
        }  else if (tfmMobile.textField.text?.count ?? 0) >= 250 {
            msg = "Please enter mobile number less then 250 character."
            showAlr(msg: msg ?? "")
        }
        
        print(validateGenericString(tfmFullName.textField.text ?? ""))
        if !validateGenericString(tfmFullName.textField.text ?? "") {
            msg = "Special character are not allowed in name!"
            showAlr(msg: msg ?? "")
        }

        
        
        if tfmFullName.status == .nodata {
            msg = "Please enter full name."
        } else if tfmFullName.status == .notvarified {
            msg = "Please enter valid full name."
        } else if tfmFullName.status == .error {
            msg = "Please enter valid full name."
        } else if tfmEmail.status == .nodata {
            msg = "Please enter email."
        } else if tfmEmail.status == .notvarified {
            msg = "Please enter valid email."
        } else if tfmEmail.status == .error {
            msg = "Please enter valid email."
        } else if tfmMobile.status == .nodata {
            msg = "Please enter mobile."
        } else if tfmMobile.status == .notvarified {
            msg = "Please enter valid mobile number."
        } else if tfmMobile.status == .error {
            msg = "Please enter valid mobile number."
        }
        
        if msg == nil {
            return true
        } else {
            tfmFullName.checkEmpty(30, "Full name can't be empty.")
            tfmEmail.validateEmail(true)
            return false
        }
    }
    
    
    func showAlr(msg:String) {
        let alert = UIAlertController(title: "Tap A Tradie", message: "\(msg)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel))
        self.present(alert, animated: true)
    }
    
    func validateGenericString(_ string: String) -> Bool {
        return string.range(of: ".*[$&+:;=\\\\?#|/<>^*()%!].*", options: .regularExpression) == nil
    }

    
    @IBAction func actionUpdateNow(_ sender: Any) {
        if validation () {
            let param = params()
            param["fullname"] = tfmFullName.textField.text
            param["email"] = tfmEmail.textField.text
            param["mobile"] = tfmMobile.textField.text
            
            Http.instance().json(api_user_update_profile, param, "POST", aai: true, popup: true, prnt: true, nil, nil, sync: false, defaultCalling: false) { (json, para, str, http, data) in
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
                        Key_User_full_name.setUserValue(self.tfmFullName.textField.text!)
                        Key_User_email.setUserValue(self.tfmEmail.textField.text!)
                        Key_User_mobile.setUserValue(self.tfmMobile.textField.text!)
                        
                        self.setFirstName ()
                    }
                    
                    Http.alert("", json?.string("message"))
                }
            }
        }
    }
    
    @IBAction func actionChangeProfilePicture(_ sender: Any) {
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
    
    func uploadProfilePicture (_ image1: UIImage) {
        let param = params()
        
        let image = NSMutableArray()
        let md = NSMutableDictionary()
        md["image"] = image1
        md["param"] = "image"
        image.add(md)
        
        Http.instance().json(api_upload_profile_picture, param, "POST", aai: true, popup: true, prnt: true, nil, image, sync: false, defaultCalling: false) { (json, para, str, http, data) in
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
                    self.imgUser.image = image1
                    Key_User_profile_pic.setUserValue((json?.string("data"))!)
                }
                Http.alert("", json?.string("message"))
            }
        }
    }
    
    //MARK: - Image Zoom
    
    @IBOutlet var viewImageZoom: UIView!
    
    @IBAction func actionRemoveImageZoom(_ sender: Any) {
        viewImageZoom.removeFromSuperview()
    }
    
    @IBAction func actionZoomImage(_ sender: Any) {
        zoomImage ()
        
        //viewImageZoom.frame = self.view.bounds
        //self.view.addSubview(viewImageZoom)
    }
    
    func zoomImage () {
//        let url = "\(Server)profile/\(Key_User_id.getUserValue()!)/\(Key_User_profile_pic.getUserValue() as! String)"
//        imgUser.downloadUIImage(url) { (image, bool) in
//            if image != nil {
//                self.zoomUIImage(image!)
//            } else {
//                Toast.toast("Picture not available")
//            }
//        }
        
        DispatchQueue.main.async {
            if self.imgUser.image != nil {
                self.zoomUIImage(self.imgUser.image!)
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

extension MyProfile: ImageScrollViewDelegate {
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

extension NSMutableData {
    func appendString(string: String) {
        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: true)
        append(data!)
    }
}

extension MyProfile: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 0
    }
}

extension MyProfile: UITextFieldDelegate {
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
        
        print("Chenge ---------")
        
        let str = textField.text! + string
        
        let superV = (textField.superview as? MaterialTextFieldView)
        
        if superV == tfmMobile {
            if str.count > 13 {
                return false
            } else if textField.text!.count <= 1 && string.count == 0 {
                (textField.superview as? MaterialTextFieldView)?.status = .nodata
                (textField.superview as? MaterialTextFieldView)?.showNoValidation()
                (textField.superview as? MaterialTextFieldView)?.lblMsg.text = "Required"
            } else if textField.text!.count < 7 {
                (textField.superview as? MaterialTextFieldView)?.status = .error
                (textField.superview as? MaterialTextFieldView)?.lblMsg.text = "minimum 8 digit required."
                (textField.superview as? MaterialTextFieldView)?.showError()
            } else if textField.text!.count == 8 && string.count == 0 {
                (textField.superview as? MaterialTextFieldView)?.status = .error
                (textField.superview as? MaterialTextFieldView)?.lblMsg.text = "minimum 8 digit required."
                (textField.superview as? MaterialTextFieldView)?.showError()
            } else if str.count >= 8 {
                (textField.superview as? MaterialTextFieldView)?.lblMsg.text = ""
                (textField.superview as? MaterialTextFieldView)?.status = .varified
                (textField.superview as? MaterialTextFieldView)?.showNoError()
            }
        } else if superV == tfmEmail {
            
            if textField.text!.count <= 1 && string.count == 0 {
                (textField.superview as? MaterialTextFieldView)?.status = .nodata
                (textField.superview as? MaterialTextFieldView)?.showNoValidation()
                (textField.superview as? MaterialTextFieldView)?.lblMsg.text = ""
            } else {
                tfmEmail.textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
                //print("\(textField.text ?? "")")
                //print(str)
                //print(tfmEmail.textField.text ?? "")
                let bool = validEmail (str)
                //print(bool)
                if bool {
                    (textField.superview as? MaterialTextFieldView)?.status = .varified
                    (textField.superview as? MaterialTextFieldView)?.showNoError()
                } else {
                    (textField.superview as? MaterialTextFieldView)?.status = .error
                    (textField.superview as? MaterialTextFieldView)?.lblMsg.text = wrongEmailMsg
                    (textField.superview as? MaterialTextFieldView)?.showError()
                    (textField.superview as? MaterialTextFieldView)?.lblMsg.isHidden = false
                }
            }
        } else if superV == tfmFullName {
            
            if textField.text!.count <= 1 && string.count == 0 {
                (textField.superview as? MaterialTextFieldView)?.status = .nodata
                (textField.superview as? MaterialTextFieldView)?.showNoValidation()
                (textField.superview as? MaterialTextFieldView)?.lblMsg.text = "Required"
            } else if textField.text!.count < 3 {
                (textField.superview as? MaterialTextFieldView)?.status = .error
                (textField.superview as? MaterialTextFieldView)?.lblMsg.text = "invalid full name."
                (textField.superview as? MaterialTextFieldView)?.showError()
            } else {
                (textField.superview as? MaterialTextFieldView)?.status = .varified
                (textField.superview as? MaterialTextFieldView)?.showNoError()
            }
            
            
            
            //MARK: Himanshu Update -- --
            let count = tfmFullName.textField.text?.count ?? 0
            print("count: ",count)
            print("previousValue: ",previousValue)
            if count == 1 && count < previousValue {
                previousValue = count
                //tfmFullName.hideImg = true
                (textField.superview as? MaterialTextFieldView)?.showError()
            } else if count == 1 && count > previousValue {
                //tfmFullName.hideImg = false
                previousValue = count
                (textField.superview as? MaterialTextFieldView)?.showNoError()
            }else{
                //tfmFullName.hideImg = false
                previousValue = count
                (textField.superview as? MaterialTextFieldView)?.showNoError()
            }
            

        }
    
        
        return true
    }
}

func validEmail(_ testStr: String) -> Bool {
    let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    
    let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
    return emailTest.evaluate(with: testStr)
}

extension MyProfile: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.uploadProfilePicture(pickedImage)
        } else if let pickedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            self.uploadProfilePicture(pickedImage)
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.isNavigationBarHidden = false
        self.dismiss(animated: true, completion: nil)
    }
    
    func openCamera() {
        let imagePicker = UIImagePickerController()
        
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
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        imagePicker.allowsEditing = false
        self.present(imagePicker, animated: true, completion: nil)
    }
}


extension UIImageView {
    func downloaded(from url: URL, contentMode mode: ContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() { [weak self] in
                self?.image = image
            }
        }.resume()
    }
    func downloaded(from link: String, contentMode mode: ContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
}
