//
//  UploadPhotos.swift
//  Tradie
//
//  Created by Apple on 07/05/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import AssetsLibrary
import OpalImagePicker
import Photos
import ImageScrollView
import Alamofire




class UploadPhotos: UIViewController {
    
    @IBOutlet weak var headerView: HeaderView!
    
    @IBAction func actionBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    var selectedAssesArray:[Any]? = nil
    
    @IBOutlet weak var viewPicture: UIView!
    
    @IBOutlet weak var cltnView: UICollectionView!
    
    @IBOutlet weak var lblProgess: UILabel!
    @IBOutlet weak var viewProgress: UIView!
    override func viewWillAppear(_ animated: Bool) {
        kAppDelegate.currentVC = self
        headerView.updateData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewProgress.isHidden = true
        viewProgress.layer.cornerRadius = 15
        viewProgress.layer.borderColor = UIColor.darkGray.cgColor
        viewProgress.layer.borderWidth = 1
        
        viewPicture.border5(16)
        viewPicture.shadow(16, 0)
        
        getGalleryList()
    }
    
    var layoutPhotos: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        let width = (UIScreen.main.bounds.size.width - 30) / 2
        layout.estimatedItemSize = CGSize(width: width, height: 140)
        return layout
    }()
    
    @IBAction func actionOpenImageSelector(_ sender: Any) {
        picturePicker ()
    }
    
    @IBAction func backAction(_ sender: UIButton) {
        if galleryJSON?.data.count == 0{
            let alert = UIAlertController(title: "Tap A Tradie", message: "Please upload photos for your work", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel))
            self.present(alert, animated: true)
        }else{
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func actionSaveImage(_ sender: Any) {
    }
    
    var galleryJSON: GalleryJSON?
    
    //MARK: - Image Zoom
    
    @IBOutlet var viewImageZoom: UIView!
    
    @IBAction func actionRemoveImageZoom(_ sender: Any) {
        viewImageZoom.removeFromSuperview()
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

extension UploadPhotos: ImageScrollViewDelegate {
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

struct GalleryJSON: Codable {
    let success: Int
    let data: [Gallery11]
}

struct Gallery11: Codable {
    let id, uid: Int
    let image: String
}

extension UploadPhotos {
    func getGalleryList () {
        let param = params()
        Http().startActivityIndicator()
        
        Http.instance().json(api_provider_gallery_image_list, param, "POST", aai: true, popup: true, prnt: true, nil, nil, sync: false, defaultCalling: false) { (json, paras, str, data) in
            let jsonExp = json as? NSDictionary
            Http().stopActivityIndicator()
            if jsonExp != nil {
                if jsonExp?.number("success").intValue == SESSIONEXPIRED {
                   kAppDelegate.sessionExpired(self)
                    Http().stopActivityIndicator()
                    return
                }
            }
            if data != nil {
                do {
                    Http().stopActivityIndicator()
                    self.galleryJSON = try JSONDecoder().decode(GalleryJSON.self, from: data!)
                    if self.galleryJSON != nil {
                        if (self.galleryJSON?.data.count)! == 0 {
                            self.viewPicture.isHidden = false
                            self.cltnView.isHidden = true
                        } else {
                            self.viewPicture.isHidden = true
                            self.cltnView.isHidden = false
                        }
                    }
                    self.cltnView.reloadData()
                } catch let error {
                    Http().stopActivityIndicator()
                    print("Error: \(error)")
                }
            }
        }
    }
}

extension UploadPhotos: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func picturePicker () {
        /*let imagePicker = OpalImagePickerController()
        
        imagePicker.allowedMediaTypes = Set(arrayLiteral: PHAssetMediaType.image)
        imagePicker.maximumSelectionsAllowed = 5
        
        //Present Image Picker
        presentOpalImagePickerController(imagePicker, animated: true, select: { (im) in
            print("im-\(im)-")
            //Save Images, update UI
            
            var imageArr: [UIImage] = []
            
            for i in 0..<im.count {
                let cc = im[i].getAssetThumbnail(CGSize(width: 500, height: 500))
                
                print("img-\(cc)-")
                
                imageArr.append(cc!)
            }
            
            //Dismiss Controller
            imagePicker.dismiss(animated: true, completion: nil)
            
            if imageArr.count > 0 {
                self.uploadProfilePicture (imageArr)
            }
        }, cancel: {
            //Cancel action?
            
        })
        
        return*/
        
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
            self.uploadProfilePicture1(pickedImage)
        } else if let pickedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            self.uploadProfilePicture1(pickedImage)
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
        let imagePicker = OpalImagePickerController()
        imagePicker.allowedMediaTypes = Set(arrayLiteral: PHAssetMediaType.image)
        imagePicker.maximumSelectionsAllowed = 5
        //Present Image Picker
        presentOpalImagePickerController(imagePicker, animated: true, select: { (im) in
            var imageArr: [UIImage] = []
            for i in 0..<im.count {
                let cc = im[i].getAssetThumbnail(CGSize(width: 500, height: 500))
                imageArr.append(cc!)
            }
            imagePicker.dismiss(animated: true, completion: nil)
            if imageArr.count > 0 {
                self.API_UploadImage(imgarry: imageArr)
            }
        }, cancel: {
        })
    }
    
    func uploadProfilePicture1 (_ image1: UIImage?) {
        let param = params()
        
        let image = NSMutableArray()
        
        if image1 != nil {
            let md = NSMutableDictionary()
            md["image"] = image1
            md["param"] = "image[0]"
            image.add(md)
        } else {
            if self.selectedAssesArray != nil {
                for i in 0..<(self.selectedAssesArray?.count)! {
                    if let ob = self.selectedAssesArray![i] as? BR_ImageInfo {
                        let md = NSMutableDictionary()
                        md["image"] = ob.image
                        md["param"] = "image[\(i)]"
                        image.add(md)
                    }
                }
            }
        }
        
//        uploadProfilePictureNow (image)
        
        if let img = image1{
            self.API_UploadImage(imgarry:[img])
        }

    }
    
    //Previous Unused
    func uploadProfilePicture (_ imageAr: [UIImage]) {
        let image = NSMutableArray()
        
        for i in 0..<imageAr.count {
            let md = NSMutableDictionary()
            md["image"] = imageAr[i]
            md["param"] = "image[\(i)]"
            image.add(md)
        }
        
        if image.count == 0 {
            Http.alert("", "Please select picture to upload.")
            return
        }
        
        uploadProfilePictureNow (image)
    }
    
    
    func API_UploadImage(imgarry:[UIImage]){
        
        var param = [String:String]()
    
        let user = UserDefaults.standard
        
        guard let authToken = user.object(forKey: KEY_ACCESSTOEKN) as? String else {
            print("api token nil")
            return
        }
        
        let ob = kAppDelegate.getUserAddress()
        
        if ob?.latitude != nil && ob?.longitude != nil {
            param["latitude"] = (ob?.latitude)!
            param["longitude"] = (ob?.longitude)!
            param["online_address"] = (ob?.address)!
            
            if let city = ob?.city {
                param["city"] = city
            }
            
            if let state = ob?.state {
                param["state"] = state
            }
            
            if let country = ob?.country {
                param["country"] = country
            }
        }
        
        if let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            param["version"] = appVersion
        }
        
        
        let userId = Key_User_id.getUserValue()
        
        if userId != nil {
            param["uid"] = "\(userId!)"
        }
        
        param["device_id"] = "\(UIDevice.current.identifierForVendor!.uuidString)_provider"
        
        param["access_token"] = authToken
        param["api_key"] = "$2a$06$hsTL2DeUKS5pUV.YlY/CSuVesppz0ha4hZdcsB7gN8VKRQRBwKct6"
        param["device_type"] = "2"
        param["role"] = "provider"
        
        
        
        var imgData = [Data]()
        
        for image in imgarry{
            
            guard let imgD = image.pngData() else {return}
            imgData.append(imgD)
            
        }
        Http.startActivityIndicator()
        uploadMediaRequest(imagesData: imgData, imageparam: "image", endPoint:api_provider_upload_image, param, nil, "image") { response in
            print("-----",response)
            Http.stopActivityIndicator()
            if response["success"] as! Int == 1{
                self.getGalleryList()
            }
            Http.alert("", response["message"] as? String)
        }
    }
    
    
    
    func uploadProfilePictureNow (_ image: NSMutableArray) {
        let param = params()
        Http.instance().json(api_provider_upload_image, param, "POST", aai: true, popup: true, prnt: true, nil, image, sync: false, defaultCalling: false) { (json, para, str, http, data) in
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
                    self.getGalleryList()
                }
                Http.alert("", json?.string("message"))
            }
        }
    }
}

extension UploadPhotos: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, RestaurantGalleryCellDelegate, AlertDelegate {
    func alertZero() {
        let vc = story_Payment.viewController("ChooseSubscripiton") as? ChooseSubscripiton
        vc?.boolFromMenu = false
        self.navigationController?.pushViewController(vc!, animated: false)
    }
    
    func alertOne() {
        
    }

    func addPhoto () {
        picturePicker ()
    }
    
    func removePhoto (_ indexPath: IndexPath) {
//        if kAppDelegate.boolSubscriptionExpired {
//            Http.alert("", "Your subscription has been expired", [self, "Subscribe", "Cancel"])
//            
//            return
//        }
        
        let param = params()
        
        let ob = galleryJSON!.data[indexPath.row-1]
        
        param["image_id"] = ob.id
        
        Http.instance().json(api_provider_delete_image, param, "POST", aai: true, popup: true, prnt: true, nil, nil, sync: false, defaultCalling: false) { (json, para, str, http, data) in
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
                    self.getGalleryList()
                }
                
                Http.alert("", json?.string("message"))
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if galleryJSON != nil {
            return galleryJSON!.data.count + 1
        }
        
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RestaurantGalleryCell", for: indexPath) as! RestaurantGalleryCell
        
        cell.imgGallery.border(nil, 5, 0)
        cell.indexPath = indexPath
        cell.delegate = self
        
        if indexPath.row == 0 {
            cell.btnRemove.isHidden = true
            cell.viewAddPhoto.isHidden = false
            cell.viewAddPhoto.border(UIColor.hexColor(0xDFDFDF), 4, 1)
            cell.imgDelete.isHidden = true
        } else {
            cell.imgDelete.isHidden = false
            cell.btnRemove.isHidden = false
            cell.viewAddPhoto.isHidden = true
            cell.imgGallery.border5(4)
            
            let ob = galleryJSON!.data[indexPath.row-1]
            let url = "\(Server)gallery/\(ob.uid)/\(ob.image)"

            cell.imgGallery.uiimage(url, "Group 2826", true, nil)
            
            cell.cnsWidth.constant = (cltnView.frame.size.width - 8) / 3
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (cltnView.frame.size.width - 8) / 3
        
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let ob = galleryJSON!.data[indexPath.row-1]
        
        let url = "\(Server)gallery/\(ob.uid)/\(ob.image)"
        
        let imgUser = UIImageView()
        
        imgUser.downloadUIImage(url) { (image, bool) in
            if image != nil {
                self.zoomUIImage(image!)
            } else {
                Toast.toast("Picture not available")
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

class RestaurantGalleryCell: UICollectionViewCell {
    @IBOutlet weak var viewAddPhoto: UIView!
    
    @IBOutlet weak var imgDelete: UIImageView!
    @IBOutlet weak var btnRemove: UIButton!
    
    @IBAction func actionRemovePhoto(_ sender: Any) {
        delegate.removePhoto(indexPath)
    }
    
    @IBOutlet weak var btnAddGallery: UIButton!
    
    @IBAction func actionAddGallery(_ sender: Any) {
        delegate.addPhoto()
    }
    
    var indexPath: IndexPath!
    var delegate: RestaurantGalleryCellDelegate!
    
    @IBOutlet weak var imgGallery: UIImageView!
    
    @IBOutlet weak var cnsTrail: NSLayoutConstraint!
    @IBOutlet weak var cnsBottom: NSLayoutConstraint!
    @IBOutlet weak var cnsLeading: NSLayoutConstraint!
    @IBOutlet weak var cnsTop: NSLayoutConstraint!
    @IBOutlet weak var cnsHeight: NSLayoutConstraint!
    @IBOutlet weak var cnsWidth: NSLayoutConstraint!
}

protocol RestaurantGalleryCellDelegate {
    func addPhoto ()
    func removePhoto (_ indexPath: IndexPath)
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



extension UploadPhotos{
    
    //MARK: - UPLOAD MEDIA IN MULTI-PART with Header
     func uploadMediaRequest(imagesData:[Data], imageparam:String, endPoint: String, _ param : [String : String],_ fileParams:[String : Any]?, _ fileName: String, callback: @escaping ([String : Any]) -> Void) {
        let headers = HTTPHeaders([ "content-type": "multipart/form-data", "Authorization":""])
        print("url \(endPoint)")
        print("param \(param)")
        print("headers \(headers)")
         DispatchQueue.main.async {
            self.viewProgress.isHidden = false
            self.lblProgess.text = "Progress : 0%"
         }
        AF.upload(multipartFormData:{ multiPart in
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
                        workingHoursJson = String(data: theJSONData,
                                                  encoding: .ascii)!
                        print("JSON string = \(workingHoursJson)")
                    }
                }
            }
            for imagedata in imagesData{
                multiPart.append(imagedata, withName: imageparam, fileName: "\(Date().timeIntervalSince1970).jpg", mimeType: "image/jpeg")
            }
        }, to:endPoint, method:.post, headers:headers)
        .uploadProgress(queue: .main, closure: { progress in
            DispatchQueue.main.async {
                self.viewProgress.isHidden = false
                var value = "\(progress.fractionCompleted * 100)"
                let valueFinal = value.components(separatedBy: ".")
                if valueFinal.count>0{
                    self.lblProgess.text = "Progress : \(valueFinal[0])%"
                }
            }
            print("Upload Progress: \(progress.fractionCompleted)")
            if Int(progress.fractionCompleted) == 1{
                DispatchQueue.main.asyncAfter(deadline: .now()+2, execute: {
                    self.lblProgess.text = "Progress : 100%"
                   self.viewProgress.isHidden = true
                })
                print("Image upload success")
            }
        })
        .responseJSON(completionHandler: { response in
            print("image upload debug \(param)\n response \(response)")
            DispatchQueue.main.async {
                self.viewProgress.isHidden = true
            }
            self.requestCallBack(result: response.result, callback: callback)
        })
        .cURLDescription { (description) in
            DispatchQueue.main.async {
                self.viewProgress.isHidden = true
            }
            print("curl description \(description)")
        }
    }
    
    
    
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
