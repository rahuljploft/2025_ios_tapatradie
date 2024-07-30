//
//  MyChatScreen_VC.swift
//  Tradie
//
//  Created by Admin on 28/02/23.
//MyChatScreen_VC

import UIKit
import SocketIO
import StoreKit
import Network
import SDWebImage

import AssetsLibrary
import OpalImagePicker
import Photos
import ImageScrollView
import Alamofire
import ProgressHUD
import AVKit
import MobileCoreServices
import UniformTypeIdentifiers
import IQKeyboardManager

class MyChatScreen_VC: UIViewController, UITableViewDelegate, UITableViewDataSource, OpenMediaFile,UIImagePickerControllerDelegate & UINavigationControllerDelegate,UIDocumentMenuDelegate,UIDocumentPickerDelegate {
    @IBOutlet weak var viewBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var lbl_UplodingProgress: UILabel!
    @IBOutlet weak var viewProgress: UIView!
    
    @IBOutlet weak var txt_Message: UITextField!
    @IBOutlet weak var viewProfile: UIView!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lbl_Name: UILabel!
    @IBOutlet weak var lbl_OnlineStatus: UILabel!
    @IBOutlet weak var viewChat: UIView!
    @IBOutlet weak var tblChat: UITableView!
    
    let request = AF
    var finalData = [storDataVideo]()
    var userID = ""
    
    
    var roomID_New = ""
    var providerId = ""
    var jobId = ""
    
    var profileURl = ""
    var name = ""
    var lastCount = 0
    
    var chatList : ChatListModel?
    let manager = SocketManager(socketURL: URL(string: Server)!, config: [.compress, .forceWebsockets(true)])
    
    struct storDataVideo {
        var video : Data
        var type : String
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        IQKeyboardManager.shared().isEnabled = false
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil)
        
        
        
        txt_Message.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
       
        connected()
        self.viewProgress.isHidden = true
        viewProgress.layer.cornerRadius = viewProgress.frame.height/2
        
        let image = "\(Server)profile/\(userID)/\(profileURl)"
        print(image)
        if let url = URL(string: image) {
            imgProfile.sd_setImage(with: url,placeholderImage: UIImage(named: "user"))
            imgProfile.sd_imageIndicator = SDWebImageActivityIndicator.gray
        }
        lbl_Name.text = "\(name)"
        print("userID",userID)
        print("providerId",providerId)
        
        updateScreen()
        tblChat.delegate = self
        tblChat.dataSource = self
        tblChat.register(UINib(nibName: "NewReciveTextMessage_TVC", bundle: nil), forCellReuseIdentifier: "NewReciveTextMessage_TVC")
        tblChat.register(UINib(nibName: "NewSendTextMessage_TVC", bundle: nil), forCellReuseIdentifier: "NewSendTextMessage_TVC")
        tblChat.register(UINib(nibName: "NewReciverImageMessage_TVC", bundle: nil), forCellReuseIdentifier: "NewReciverImageMessage_TVC")
        tblChat.register(UINib(nibName: "NewSendImageMessage_TVC", bundle: nil), forCellReuseIdentifier: "NewSendImageMessage_TVC")
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        IQKeyboardManager.shared().isEnabled = true
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        print("Text Change....")
        self.typingMessage()
    }

    @IBAction func actionMultiMedia(_ sender: UIButton) {
        self.txt_Message.endEditing(true)
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "MultiMediaIssues_VC") as! MultiMediaIssues_VC
        vc.modalPresentationStyle = .overFullScreen
        vc.delegate = self
        self.present(vc, animated: true)
    }
    
    
    @IBAction func actionBack(_ sender: UIButton) {
        self.readMessage()
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func actionSendMessage(_ sender: UIButton) {
        self.txt_Message.endEditing(true)
        self.sendMessage()
    }
    
    func openMediaFile(type: MediaType) {
        self.finalData.removeAll()
        
        switch type {
        case .Camera:
            print("Open Camera")
            openCamera()
            //photoVideoSelecter()
        case .Gallry:
            print("Open Gallry")
            openGallary()
        case .Document:
            print("Open Document")
            selectFiles()
        case .Audio:
            print("Open Audio")
            audioFiles()
        case .Video:
            print("Open Video")
            openVideoPicker()
        }
    }
    
    
    
    func audioFiles() {
        if #available(iOS 14.0, *) {
            let supportedTypes = [UTType.mp3,UTType.wav,UTType.aiff]
            let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: supportedTypes, asCopy: true)
            documentPicker.delegate = self
            documentPicker.allowsMultipleSelection = false
            documentPicker.shouldShowFileExtensions = true
            self.present(documentPicker, animated: true, completion: nil)
        }
    }
    
    
    func selectFiles() {
        if #available(iOS 14.0, *) {
            let supportedTypes = [UTType.image, UTType.text, UTType.plainText, UTType.utf8PlainText,    UTType.utf16ExternalPlainText, UTType.utf16PlainText,    UTType.delimitedText, UTType.commaSeparatedText,    UTType.tabSeparatedText, UTType.utf8TabSeparatedText, UTType.rtf,    UTType.pdf, UTType.webArchive, UTType.image, UTType.jpeg,    UTType.tiff, UTType.gif, UTType.png, UTType.bmp, UTType.ico,    UTType.rawImage, UTType.svg, UTType.livePhoto, UTType.movie,    UTType.video, UTType.audio, UTType.quickTimeMovie, UTType.mpeg,    UTType.mpeg2Video, UTType.mpeg2TransportStream, UTType.mp3,    UTType.mpeg4Movie, UTType.mpeg4Audio, UTType.avi, UTType.aiff,    UTType.wav, UTType.midi, UTType.archive, UTType.gzip, UTType.bz2,    UTType.zip, UTType.appleArchive, UTType.spreadsheet, UTType.epub]
            let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: supportedTypes, asCopy: true)
            documentPicker.delegate = self
            documentPicker.allowsMultipleSelection = false
            documentPicker.shouldShowFileExtensions = true
            self.present(documentPicker, animated: true, completion: nil)
        }
    }
    
    
    public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let myURL = urls.first else {
            return
        }
        print("import result : \(myURL)")
        
        do {
            let videoData = try Data(contentsOf: (myURL))
            print(videoData)
            self.finalData.append(storDataVideo(video: videoData, type: "file"))
            if self.finalData.count > 0 {
                print("\(myURL.pathExtension)")
                if "\(myURL.pathExtension)".lowercased() == "mp3".lowercased() || "\(myURL.pathExtension)".lowercased() == "WAV".lowercased() || "\(myURL.pathExtension)".lowercased() == "AIFF".lowercased() {
                    self.createDocsPostAPICall(extensionVal: "\(myURL.pathExtension)",typeVal: "audio", imageparam: "image", endPoint: upload_file_for_chat, param: [:])
                }else{
                    self.createDocsPostAPICall(extensionVal: "\(myURL.pathExtension)",typeVal: "file", imageparam: "image", endPoint: upload_file_for_chat, param: [:])
                }
            }
        } catch  {
            print("exception catch at block - while uploading video")
        }
        
    }
          

    public func documentMenu(_ documentMenu:UIDocumentMenuViewController, didPickDocumentPicker documentPicker: UIDocumentPickerViewController) {
        documentPicker.delegate = self
        present(documentPicker, animated: true, completion: nil)
    }


    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        print("view was cancelled")
        dismiss(animated: true, completion: nil)
    }


}




extension MyChatScreen_VC {
    
    
    func photoVideoSelecter() {
        let alert = UIAlertController(title: "Choose Option", message: "", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Photo", style: .default,handler: { alr in
            self.openCamera()
        }))
        alert.addAction(UIAlertAction(title: "Video", style: .default,handler: { alr in
            self.openVideo()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel,handler: { alr in
           
        }))
        self.present(alert, animated: true)
    }
    
    //MARK: Camera Work Start ------
    
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
    
    
    func openVideo() {
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

    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            print("Camera Upload Profile Picture")
            guard let imgData = pickedImage.pngData() else {return}
            print(imgData)
            self.finalData.removeAll()
            self.finalData.append(storDataVideo(video: imgData, type: "image"))
            
            picker.dismiss(animated: true) {
                print("Image Clicked")
                if self.finalData.count > 0 {
                    print(self.finalData[0].video)
                    if self.checkData500Greater(dataVal: self.finalData[0].video) {
                        let alert = UIAlertController(title: "", message: "Please Select Images/Video Less then 500 MB", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { res in
                            print("Cancel")
                            self.finalData.removeAll()
                        }))
                        self.present(alert, animated: true)
                    }else{
                        self.createPostAPICall(typeVal: "image", imageparam: "image", endPoint: upload_file_for_chat, param: [:])
                    }
                }
            }
            
        }else{
            print(info[UIImagePickerController.InfoKey.mediaURL])
            guard let myAsset = info[UIImagePickerController.InfoKey.mediaURL] as? NSURL else {
                print("Return Done")
                return
            }
            do {
                let videoData = try? Data(contentsOf: (myAsset as URL))
                print(videoData)
                self.finalData.append(storDataVideo(video: videoData!, type: "video"))
                if self.finalData.count > 0 {
                    if self.checkData500Greater(dataVal: self.finalData[0].video) {
                        let alert = UIAlertController(title: "", message: "Please Select Images/Video Less then 500 MB", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { res in
                            print("Cancel")
                            self.finalData.removeAll()
                        }))
                        self.present(alert, animated: true)
                    }else{
                        self.createPostAPICall(typeVal: "video", imageparam: "image", endPoint: upload_file_for_chat, param: [:])
                    }
                    
                }
            }
            
            picker.dismiss(animated: true)
        }
        

    }
    
            
    func checkData500Greater(dataVal:Data) -> Bool {
        let str = "\(dataVal ?? Data())"
        print(str)
        let dataArr = str.components(separatedBy: " ")
        print(dataArr)
        if dataArr.count > 0 {
            let convertedData = Double(dataArr[0])
            print(convertedData ?? 0.0)
            let finalTest = (convertedData ?? 0.0)/1000000
            print(finalTest)
            if finalTest > 500 {
                print("Greate")
                return true
            }else{
                return false
            }
        }else{
            return false
        }
    }
    
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.isNavigationBarHidden = false
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    
    //MARK: Gallery Work Start ------------
    func openGallary() {
        self.finalData.removeAll()
        let imagePicker = OpalImagePickerController()
        imagePicker.allowedMediaTypes = Set(arrayLiteral: PHAssetMediaType.image)
        imagePicker.maximumSelectionsAllowed = 1
        presentOpalImagePickerController(imagePicker, animated: true, select: { (im) in
            let countval = im.count
            for i in im {
                print(i)
                let type = "\(i.mediaType.rawValue)"
                print(type)
                if type == "1" {
                    let image = i.getAssetThumbnail(CGSize(width: 500, height: 500))
                    guard let imgData = image!.pngData() else {return}
                    print(imgData)
                    self.finalData.append(storDataVideo(video: imgData, type: "image"))
                }else{
                    PHImageManager.default().requestAVAsset(forVideo: i, options: nil, resultHandler: { [self] (asset, mix, nil) in
                        guard let myAsset = asset as? AVURLAsset else {
                            return
                        }
                        do {
                            let videoData = try Data(contentsOf: (myAsset.url))
                            print(videoData)
                            self.finalData.append(storDataVideo(video: videoData, type: "video"))
                        } catch  {
                            print("exception catch at block - while uploading video")
                        }
                    })
                }
            }
            imagePicker.dismiss(animated: true) {
                print("Uploaded Done")
                if self.finalData.count > 0 {
                    if self.checkData500Greater(dataVal: self.finalData[0].video) {
                        let alert = UIAlertController(title: "", message: "Please Select Images/Video Less then 500 MB", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { res in
                            print("Cancel")
                            self.finalData.removeAll()
                        }))
                        self.present(alert, animated: true)
                    }else{
                        self.createPostAPICall(typeVal: "image", imageparam: "image", endPoint: upload_file_for_chat, param: [:])
                    }
                }
            }
        }, cancel: {
            print("Cancel")
        })
    }
    
    
    
    
    //MARK: Gallery Work Start ------------
    func openVideoPicker() {
        self.finalData.removeAll()
        let imagePicker = OpalImagePickerController()
        imagePicker.allowedMediaTypes = Set(arrayLiteral: PHAssetMediaType.video,PHAssetMediaType.image)
        imagePicker.maximumSelectionsAllowed = 1
        presentOpalImagePickerController(imagePicker, animated: true, select: { (im) in
            for i in im {
                let type = "\(i.mediaType.rawValue)"
                print(type)
                if type == "1" {
                    let image = i.getAssetThumbnail(CGSize(width: 500, height: 500))
                    guard let imgData = image!.pngData() else {return}
                    print(imgData)
                    self.finalData.append(storDataVideo(video: imgData, type: "image"))
                    if self.finalData.count > 0 {
                        
                        if self.checkData500Greater(dataVal: self.finalData[0].video) {
                            let alert = UIAlertController(title: "", message: "Please Select Images/Video Less then 500 MB", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { res in
                                print("Cancel")
                                self.finalData.removeAll()
                            }))
                            self.present(alert, animated: true)
                        }else{
                            self.createPostAPICall(typeVal: "video", imageparam: "image", endPoint: upload_file_for_chat, param: [:])
                        }
                        
                        
                    }
                }else{
                    PHImageManager.default().requestAVAsset(forVideo: i, options: nil, resultHandler: { [self] (asset, mix, nil) in
                        guard let myAsset = asset as? AVURLAsset else {
                            print("Return Done")
                            return
                        }
                        do {
                            let videoData = try Data(contentsOf: (myAsset.url))
                            print(videoData)
                            self.finalData.append(storDataVideo(video: videoData, type: "video"))
                            if self.finalData.count > 0 {
                                
                                if self.checkData500Greater(dataVal: self.finalData[0].video) {
                                    let alert = UIAlertController(title: "", message: "Please Select Images/Video Less then 500 MB", preferredStyle: .alert)
                                    alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { res in
                                        print("Cancel")
                                        self.finalData.removeAll()
                                    }))
                                    self.present(alert, animated: true)
                                }else{
                                    self.createPostAPICall(typeVal: "video", imageparam: "image", endPoint: upload_file_for_chat, param: [:])
                                }
                                
                            }
                        } catch  {
                            print("exception catch at block - while uploading video")
                        }
                    })
                }
            }
            imagePicker.dismiss(animated: true) {
                print("Uploaded Video Done \(self.finalData)")
                
            }
        }, cancel: {
            print("Cancel")
        })
    }
    
    
}




extension MyChatScreen_VC {
        
    func createDocsPostAPICall(extensionVal:String,typeVal:String,imageparam:String, endPoint: String,  param : [String : Any]) {
        let headers = HTTPHeaders(["content-type": "multipart/form-data","Authorization": ""])
        
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
            for imagedata in self.finalData{
                multiPart.append(imagedata.video, withName:imageparam, fileName: "file.\(extensionVal)", mimeType: "pdf/text")
            }
        }, to:endPoint, method:.post, headers:headers)
        .uploadProgress(queue: .main, closure: { progress in
            //ProgressHUD.showProgress(progress.fractionCompleted)
            self.viewProgress.isHidden = false
            self.lbl_UplodingProgress.text = "File Uploading : \(Int(progress.fractionCompleted*100))%"
            print("\(progress)")
            print("Progress Progress Progress :- ",progress.fractionCompleted)
            if progress.fractionCompleted > 1{
                print("Success Full Uploaded...")
            }
        })
        .responseJSON(completionHandler: { response in
            print("image upload debug \(param)\n response \(response)")
            switch response.result {
            case .success(let site):
                let dict = site as? NSDictionary
                //ProgressHUD.dismiss()
                
                self.viewProgress.isHidden = true
                
                let success = dict?["success"] as? Int ?? 0
                let message = dict?["message"] as? String ?? ""
                if success == SESSIONEXPIRED {
                    kAppDelegate.sessionExpired(self)
                    return
                }
                if dict != nil {
                    if success == 1 {
                        print("Success 1")
                        let dictData = dict?["data"] as? NSDictionary
                        let url = dictData?["imageUrl"] as? String ?? ""
                        if url != "" {
                            self.sendMessageMedia(type: typeVal, url: "\(url)")
                        }
                    } else if success == 0 {
                        DispatchQueue.main.async {
                            let alert = UIAlertController(title: "Tap A Tadie", message: "Failed to send message please try again!", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "OK", style: .cancel,handler: { value in
                                print("Cancel")
                            }))
                            self.present(alert, animated: true)
                        }
                    }
                }
            case .failure(let err):
                //ProgressHUD.dismiss()
                self.viewProgress.isHidden = true
                print(err.localizedDescription)
            }
        })
        .cURLDescription { (description) in
            print("curl description \(description)")
        }
    }
    
    
    
    
    func createPostAPICall(typeVal:String,imageparam:String, endPoint: String,  param : [String : Any]) {
        let headers = HTTPHeaders(["content-type": "multipart/form-data","Authorization": ""])
        
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
            for imagedata in self.finalData{
                if imagedata.type == "video" {
                    multiPart.append(imagedata.video, withName:imageparam, fileName: "video.mp4", mimeType: "video/mp4")
                }else{
                    multiPart.append(imagedata.video, withName:imageparam, fileName: "image.jpg", mimeType: "image/jpeg")
                }
            }
        }, to:endPoint, method:.post, headers:headers)
        .uploadProgress(queue: .main, closure: { progress in
            //ProgressHUD.showProgress(progress.fractionCompleted)
            
            self.viewProgress.isHidden = false
            self.lbl_UplodingProgress.text = "File Uploading : \(Int(progress.fractionCompleted*100))%"
            
            print("Progress Progress Progress :- ",progress.fractionCompleted)
            if progress.fractionCompleted > 1{
                print("Success Full Uploaded...")
            }
        })
        .responseJSON(completionHandler: { response in
            print("image upload debug \(param)\n response \(response)")
            switch response.result {
            case .success(let site):
                let dict = site as? NSDictionary
                
                self.viewProgress.isHidden = true
                //lbl_UplodingProgress
                
                let success = dict?["success"] as? Int ?? 0
                let message = dict?["message"] as? String ?? ""
                if success == SESSIONEXPIRED {
                    kAppDelegate.sessionExpired(self)
                    return
                }
                if dict != nil {
                    if success == 1 {
                        print("Success 1")
                        let dictData = dict?["data"] as? NSDictionary
                        let url = dictData?["imageUrl"] as? String ?? ""
                        if url != "" {
                            self.sendMessageMedia(type: typeVal, url: "\(url)")
                        }
                    } else if success == 0 {
                        DispatchQueue.main.async {
                            let alert = UIAlertController(title: "Tap A Tadie", message: "Failed to send message please try again!", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "OK", style: .cancel,handler: { value in
                                print("Cancel")
                            }))
                            self.present(alert, animated: true)
                        }
                    }
                }
            case .failure(let err):
                //ProgressHUD.dismiss()
                self.viewProgress.isHidden = true
                //lbl_UplodingProgress
                print(err.localizedDescription)
            }
        })
        .cURLDescription { (description) in
            print("curl description \(description)")
        }
    }
}







extension MyChatScreen_VC {
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.chatList?.data.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let data = self.chatList?.data[indexPath.row]
        if "\(data?.senderID ?? 0)" == providerId && "\(data?.type ?? "")" == "image" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "NewSendImageMessage_TVC") as! NewSendImageMessage_TVC
            cell.updateCell()
            cell.selectionStyle = .none
            cell.lbl_date.text = timeStampToDate(dateVal: "\(data?.createdOn ?? "")")
            cell.lbl_SenderName.text = "\(data?.senderName ?? "")"
            let profileURl = "\(Server)profile/\(data?.senderID ?? 0)/\(data?.senderprofile ?? "")"
            print("profileURl \(profileURl)")
            if let url = URL(string: profileURl) {
                cell.imgProfile.sd_setImage(with: url,placeholderImage: UIImage(named: "user"))
                //cell.imgProfile.sd_imageIndicator = SDWebImageActivityIndicator.gray
            }
            
            let messageURl = "\(data?.message ?? "")"
            print("messageURl : \(messageURl)")
            if let url = URL(string: messageURl) {
                cell.imgMessage.sd_setImage(with: url)
                //cell.imgMessage.sd_imageIndicator = SDWebImageActivityIndicator.gray
            }
            return cell
        }
        else if "\(data?.senderID ?? 0)" != providerId && "\(data?.type ?? "")" == "image" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "NewReciverImageMessage_TVC") as! NewReciverImageMessage_TVC
            cell.updateCell()
            cell.selectionStyle = .none
            cell.lbl_date.text = timeStampToDate(dateVal: "\(data?.createdOn ?? "")")
            cell.lbl_ReciverName.text = "\(data?.receiverName ?? "")"
            let profileURl = "\(Server)profile/\(data?.senderID ?? 0)/\(data?.senderprofile ?? "")"
            print("profileURl \(profileURl)")
            if let url = URL(string: profileURl) {
                cell.imgProfile.sd_setImage(with: url,placeholderImage: UIImage(named: "user"))
                //cell.imgProfile.sd_imageIndicator = SDWebImageActivityIndicator.gray
            }
            
            let messageURl = "\(data?.message ?? "")"
            print("messageURl : \(messageURl)")
            if let url = URL(string: messageURl) {
                cell.imgMessage.sd_setImage(with: url)
                //cell.imgMessage.sd_imageIndicator = SDWebImageActivityIndicator.gray
            }
            
            return cell
        }
        else if "\(data?.senderID ?? 0)" == providerId && "\(data?.type ?? "")" == "audio" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "NewSendImageMessage_TVC") as! NewSendImageMessage_TVC
            cell.updateCell()
            cell.selectionStyle = .none
            
            
            cell.lbl_date.text = timeStampToDate(dateVal: "\(data?.createdOn ?? "")")
            cell.lbl_SenderName.text = "\(data?.senderName ?? "")"
            
            let profileURl = "\(Server)profile/\(data?.senderID ?? 0)/\(data?.senderprofile ?? "")"
            print("profileURl \(profileURl)")
            if let url = URL(string: profileURl) {
                cell.imgProfile.sd_setImage(with: url,placeholderImage: UIImage(named: "user"))
                //cell.imgProfile.sd_imageIndicator = SDWebImageActivityIndicator.gray
            }
            cell.imgMessage.image = UIImage(named: "audioSend")
            //,fileSend
            
            return cell
        }
        else if "\(data?.senderID ?? 0)" != providerId && "\(data?.type ?? "")" == "audio" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "NewReciverImageMessage_TVC") as! NewReciverImageMessage_TVC
            cell.updateCell()
            cell.selectionStyle = .none
            
            cell.lbl_date.text = timeStampToDate(dateVal: "\(data?.createdOn ?? "")")
            cell.lbl_ReciverName.text = "\(data?.senderName ?? "")"
            
            let profileURl = "\(Server)profile/\(data?.senderID ?? 0)/\(data?.senderprofile ?? "")"
            print("profileURl \(profileURl)")
            if let url = URL(string: profileURl) {
                cell.imgProfile.sd_setImage(with: url,placeholderImage: UIImage(named: "user"))
                //cell.imgProfile.sd_imageIndicator = SDWebImageActivityIndicator.gray
            }
            cell.imgMessage.image = UIImage(named: "audioSend")
            //,fileSend
            
            return cell
        }
        else if "\(data?.senderID ?? 0)" == providerId && "\(data?.type ?? "")" == "video" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "NewSendImageMessage_TVC") as! NewSendImageMessage_TVC
            cell.updateCell()
            cell.selectionStyle = .none
            
            cell.lbl_date.text = timeStampToDate(dateVal: "\(data?.createdOn ?? "")")
            cell.lbl_SenderName.text = "\(data?.senderName ?? "")"
            
            let profileURl = "\(Server)profile/\(data?.senderID ?? 0)/\(data?.senderprofile ?? "")"
            print("profileURl \(profileURl)")
            if let url = URL(string: profileURl) {
                cell.imgProfile.sd_setImage(with: url,placeholderImage: UIImage(named: "user"))
                //cell.imgProfile.sd_imageIndicator = SDWebImageActivityIndicator.gray
            }
            cell.imgMessage.image = UIImage(named: "play-button")
            //,fileSend
            
            return cell
        }
        else if "\(data?.senderID ?? 0)" != providerId && "\(data?.type ?? "")" == "video" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "NewReciverImageMessage_TVC") as! NewReciverImageMessage_TVC
            cell.updateCell()
            cell.selectionStyle = .none
            
            cell.lbl_date.text = timeStampToDate(dateVal: "\(data?.createdOn ?? "")")
            cell.lbl_ReciverName.text = "\(data?.senderName ?? "")"
            
            let profileURl = "\(Server)profile/\(data?.senderID ?? 0)/\(data?.senderprofile ?? "")"
            print("profileURl \(profileURl)")
            if let url = URL(string: profileURl) {
                cell.imgProfile.sd_setImage(with: url,placeholderImage: UIImage(named: "user"))
                //cell.imgProfile.sd_imageIndicator = SDWebImageActivityIndicator.gray
            }
            cell.imgMessage.image = UIImage(named: "play-button")
            //,fileSend
            
            return cell
        }
        else if "\(data?.senderID ?? 0)" == providerId && "\(data?.type ?? "")" == "file" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "NewSendImageMessage_TVC") as! NewSendImageMessage_TVC
            cell.updateCell()
            cell.selectionStyle = .none
            
            
            cell.lbl_date.text = timeStampToDate(dateVal: "\(data?.createdOn ?? "")")
            cell.lbl_SenderName.text = "\(data?.senderName ?? "")"
            
            let profileURl = "\(Server)profile/\(data?.senderID ?? 0)/\(data?.senderprofile ?? "")"
            print("profileURl \(profileURl)")
            if let url = URL(string: profileURl) {
                cell.imgProfile.sd_setImage(with: url,placeholderImage: UIImage(named: "user"))
                //cell.imgProfile.sd_imageIndicator = SDWebImageActivityIndicator.gray
            }
            let message = data?.message ?? ""
            cell.imgMessage.image = UIImage(named: "\(fileName(type:message))")
            
            
            return cell
        }
        else if "\(data?.senderID ?? 0)" != providerId && "\(data?.type ?? "")" == "file" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "NewReciverImageMessage_TVC") as! NewReciverImageMessage_TVC
            cell.updateCell()
            cell.selectionStyle = .none
            
            cell.lbl_date.text = timeStampToDate(dateVal: "\(data?.createdOn ?? "")")
            cell.lbl_ReciverName.text = "\(data?.senderName ?? "")"
            
            let profileURl = "\(Server)profile/\(data?.senderID ?? 0)/\(data?.senderprofile ?? "")"
            print("profileURl \(profileURl)")
            if let url = URL(string: profileURl) {
                cell.imgProfile.sd_setImage(with: url,placeholderImage: UIImage(named: "user"))
                //cell.imgProfile.sd_imageIndicator = SDWebImageActivityIndicator.gray
            }
            let message = data?.message ?? ""
            cell.imgMessage.image = UIImage(named: "\(fileName(type:message))")
            
            
            return cell
        }
        else if "\(data?.senderID ?? 0)" == providerId && "\(data?.type ?? "")" == "message" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "NewSendTextMessage_TVC") as! NewSendTextMessage_TVC
            cell.updateCell()
            cell.selectionStyle = .none
            
            cell.lbl_date.text = timeStampToDate(dateVal: "\(data?.createdOn ?? "")")
            cell.lbl_SenderName.text = "\(data?.senderName ?? "")"
            
            let profileURl = "\(Server)profile/\(data?.senderID ?? 0)/\(data?.senderprofile ?? "")"
            print("profileURl \(profileURl)")
            if let url = URL(string: profileURl) {
                cell.imgProfile.sd_setImage(with: url,placeholderImage: UIImage(named: "user"))
                //cell.imgProfile.sd_imageIndicator = SDWebImageActivityIndicator.gray
            }
            cell.lbl_Message.text = "\(data?.message ?? "")"
            
            return cell
        }
        else if "\(data?.senderID ?? 0)" != providerId && "\(data?.type ?? "")" == "message" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "NewReciveTextMessage_TVC") as! NewReciveTextMessage_TVC
            cell.updateCell()
            cell.selectionStyle = .none
            
            cell.lbl_DateName.text = timeStampToDate(dateVal: "\(data?.createdOn ?? "")")
            cell.lbl_ReciverName.text = "\(data?.senderName ?? "")"
            
            let profileURl = "\(Server)profile/\(data?.senderID ?? 0)/\(data?.senderprofile ?? "")"
            print("profileURl \(profileURl)")
            if let url = URL(string: profileURl) {
                cell.imgProfile.sd_setImage(with: url,placeholderImage: UIImage(named: "user"))
                //cell.imgProfile.sd_imageIndicator = SDWebImageActivityIndicator.gray
            }
            cell.lbl_Message.text = "\(data?.message ?? "")"
            
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "NewReciveTextMessage_TVC") as! NewReciveTextMessage_TVC
            cell.updateCell()
            cell.selectionStyle = .none
            return cell
        }
            
    }
    
    func fileName(type:String) -> String {
        if type.contains("xls") || type.contains("xlsx") {
            return "excle"
        }else if type.contains("doc") || type.contains("docx") {
            return "doc"
        }else if type.contains("ppt") || type.contains("pptx") {
            return "ppt"
        }else if type.contains("pdf") {
            return "pdf"
        }else if type.contains("txt") {
            return "txt"
        }
        return "fileSend"
      
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = self.chatList?.data[indexPath.row]
        
        if "\(data?.type ?? "")" == "image" {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ImageZoomView_VC") as! ImageZoomView_VC
            vc.modalPresentationStyle = .overFullScreen
            vc.imageURl = "\(data?.message ?? "")"
            self.present(vc, animated: true)
        }else if "\(data?.type ?? "")" == "video" {
            guard let videoURL = URL(string: "\(data?.message ?? "")") else {
                return
            }
            let player = AVPlayer(url: videoURL)
            let playerViewController = AVPlayerViewController()
            playerViewController.player = player
            self.present(playerViewController, animated: true) {
                playerViewController.player!.play()
            }
        }else if "\(data?.type ?? "")" == "file" {
            if let url = URL(string: "\(data?.message ?? "")") {
                UIApplication.shared.open(url)
            }
        }else if "\(data?.type ?? "")" == "audio" {
            if let url = URL(string: "\(data?.message ?? "")") {
                UIApplication.shared.open(url)
            }
        }
    }
    
}




extension MyChatScreen_VC {
    
    func updateScreen() {
        viewProfile.clipsToBounds = true
        viewProfile.layer.cornerRadius = 25
        viewProfile.layer.borderColor = UIColor.white.cgColor
        viewProfile.layer.borderWidth = 1.5
        
        viewChat.layer.cornerRadius = viewChat.frame.height/2
        viewChat.layer.shadowRadius = 2
        viewChat.layer.shadowColor = UIColor.gray.cgColor
        viewChat.layer.shadowOpacity = 0.5
        viewChat.layer.shadowOffset = .zero
    }
    
}








//MARK: Socket Connection -----

extension MyChatScreen_VC {
    
    func connected() {
        let socket = manager.defaultSocket
        socket.on(clientEvent: .connect) {data, ack in
            print("socket connected")
            //self.joinChatRoom(userId: "\(self.userID)", providerId: "\(self.providerId)", jobId: "\(self.jobId)")
            self.joinChatRoom(userId: "\(self.userID)", providerId: "\(self.providerId)", jobId: "\(self.jobId)")
            print(data,ack)
            
        }
        socket.on(clientEvent: .error) {data, ack in
            print("socket error")
            print(data,ack)
        }
        socket.connect()
    }
    
    func joinChatRoom(userId: String,providerId:String,jobId:String) {
        let socket = manager.defaultSocket
        socket.emit("joinChat", "\(userId)","\(providerId)","\(jobId)")
        self.getMessage()
        self.isTyping()
        self.readMessage()
    }
        
    func getMessage() {
        let socket = manager.defaultSocket
        socket.on("getMessageList") { (dataArray, socketAck) -> Void in
            print(dataArray)
            self.lbl_OnlineStatus.text = "Online"
            guard let data = UIApplication.jsonData(from: dataArray) else {
                return
            }
            print(data)
            do {
                let jsonData = Data("\(dataArray[0])".utf8)
                self.chatList = try! JSONDecoder().decode(ChatListModel.self, from: jsonData)
                print(self.chatList?.roomId ?? "")
                self.roomID_New = self.chatList?.roomId ?? ""
                print(self.chatList)
                DispatchQueue.main.async {
                    if self.lastCount != self.chatList?.data.count ?? 0 {
                        self.lastCount = self.chatList?.data.count ?? 0
                        self.tblChat.reloadData()
                        self.tblChat.scrollToBottom(isAnimated: false)
                    }
                }
            }catch{
                print(error)
            }
            
        }
    }
    
    
    func isTyping() {
        let socket = manager.defaultSocket
        socket.on("getUserTyping") { (dataArray, socketAck) -> Void in
            let dict = dataArray[0] as? NSDictionary
            let id = dict?["userId"] as? String ?? ""
            print(id)
            
            let userId = Key_User_id.getUserValue()
            print("\(userId ?? "")")
            
            if id != "\(userId ?? "")" {
                print("Show Typing........")
                self.lbl_OnlineStatus.text = "Typing........"
                DispatchQueue.main.asyncAfter(deadline: .now()+3) {
                    self.lbl_OnlineStatus.text = "Online"
                }
            }else{
                print("Hide")
                self.lbl_OnlineStatus.text = "Online"
            }
           
            
            guard let data = UIApplication.jsonData(from: dataArray) else {
                return
            }
            print(data)
        }
    }
    
    func sendMessage() {
        let message = txt_Message.text ?? ""
        if message == "" {
            let alert  = UIAlertController(title: "Tap A Tradie", message: "Please Enter message first!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }else{
            self.txt_Message.text = ""
            let socket = manager.defaultSocket
            let data = ["type":"message","roomId":"\(self.roomID_New)","senderId":"\(providerId)","receiverId":"\(userID)","message":"\(message)"]
            socket.emit("sendMessageApp", data)
        }
        
    }
    
    func sendMessageMedia(type:String,url:String) {
        let socket = manager.defaultSocket
        let data = ["type":"\(type)","roomId":"\(self.roomID_New)","senderId":"\(providerId)","receiverId":"\(userID)","message":"\(url)"]
        print(data)
        socket.emit("sendMessageApp", data)
    }
    
    func readMessage() {
        let socket = manager.defaultSocket
        socket.emit("messageList", "\(roomID_New)","\(providerId)")
    }
    
    func typingMessage() {
        let socket = manager.defaultSocket
        print("\(providerId)")
        print("\(jobId)")
        let userId = Key_User_id.getUserValue()
        print("\(userId ?? "")")
        socket.emit("usertyping", "\(roomID_New)","\(userId ?? "")")
    }
        
}







extension UIApplication {
    
    static func jsonString(from object:Any) -> String? {
        
        guard let data = jsonData(from: object) else {
            return nil
        }
        
        return String(data: data, encoding: String.Encoding.utf8)
    }
    
    static func jsonData(from object:Any) -> Data? {
        
        guard let data = try? JSONSerialization.data(withJSONObject: object, options: []) else {
            return nil
        }
        
        return data
    }
    
    
}


extension UIViewController {
    
    func timeStampToDate(dateVal:String) -> String {
        let time = Double(dateVal) ?? 0
        var date: Date = Date()
        if dateVal.count == 13 {
            date = Date.init(timeIntervalSince1970: time/1000)
        } else {
            date = Date.init(timeIntervalSince1970: time)
        }
        let date1 = Date()
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "hh:mm a"
        return dateFormatterPrint.string(from: date)
    }
}


extension UITableView {

    func scrollToBottom(isAnimated:Bool = true){

        DispatchQueue.main.async {
            let indexPath = IndexPath(
                row: self.numberOfRows(inSection:  self.numberOfSections-1) - 1,
                section: self.numberOfSections - 1)
            if self.hasRowAtIndexPath(indexPath: indexPath) {
                self.scrollToRow(at: indexPath, at: .bottom, animated: isAnimated)
            }
        }
    }

    func scrollToTop(isAnimated:Bool = true) {

        DispatchQueue.main.async {
            let indexPath = IndexPath(row: 0, section: 0)
            if self.hasRowAtIndexPath(indexPath: indexPath) {
                self.scrollToRow(at: indexPath, at: .top, animated: isAnimated)
           }
        }
    }

    func hasRowAtIndexPath(indexPath: IndexPath) -> Bool {
        return indexPath.section < self.numberOfSections && indexPath.row < self.numberOfRows(inSection: indexPath.section)
    }
}



extension MyChatScreen_VC {
    
    @objc func keyboardWillShow(_ notification: NSNotification) {
        // Move the view only when the usernameTextField or the passwordTextField are being edited
        if txt_Message.isEditing || txt_Message.isEditing {
            moveViewWithKeyboard(notification: notification, viewBottomConstraint: self.viewBottomConstraint, keyboardWillShow: true)
        }
    }
    
    @objc func keyboardWillHide(_ notification: NSNotification) {
        moveViewWithKeyboard(notification: notification, viewBottomConstraint: self.viewBottomConstraint, keyboardWillShow: false)
    }
    
    func moveViewWithKeyboard(notification: NSNotification, viewBottomConstraint: NSLayoutConstraint, keyboardWillShow: Bool) {
        // Keyboard's size
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        let keyboardHeight = keyboardSize.height
        
        // Keyboard's animation duration
        let keyboardDuration = notification.userInfo![UIResponder.keyboardAnimationDurationUserInfoKey] as! Double
        
        // Keyboard's animation curve
        let keyboardCurve = UIView.AnimationCurve(rawValue: notification.userInfo![UIResponder.keyboardAnimationCurveUserInfoKey] as! Int)!
        
        // Change the constant
        if keyboardWillShow {
            let safeAreaExists = (self.view?.window?.safeAreaInsets.bottom != 0) // Check if safe area exists
            let bottomConstant: CGFloat = 5
            viewBottomConstraint.constant = keyboardHeight + (safeAreaExists ? 0 : bottomConstant)
        }else {
            viewBottomConstraint.constant = 5
        }
        
        // Animate the view the same way the keyboard animates
        let animator = UIViewPropertyAnimator(duration: keyboardDuration, curve: keyboardCurve) { [weak self] in
            // Update Constraints
            self?.view.layoutIfNeeded()
        }
        
        // Perform the animation
        animator.startAnimation()
    }
    
}
