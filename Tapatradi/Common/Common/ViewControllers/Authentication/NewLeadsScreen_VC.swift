//
//  NewLeadsScreen_VC.swift
//  Common
//
//  Created by Admin on 20/02/23.
//

import UIKit
import SDWebImage
import DynamicBlurView
import CoreGraphics

var serviceId = ""
var latitudeValNew = ""
var longitudeValNew = ""
var leadType = ""
var addressValNew = ""

class NewLeadsScreen_VC: UIViewController, UITableViewDelegate, UITableViewDataSource, NewLeadsWork {
    func newLeadsWork(back: Bool) {
        if back == false {
            self.getDomeyNewLeadsList()
        }else{
            for controller in self.navigationController!.viewControllers as Array {
                if controller.isKind(of: ChooseIntrestNew_VC.self) {
                    self.navigationController!.popToViewController(controller, animated: true)
                    break
                }
            }
        }
    }
    

    
    @IBOutlet weak var lbl_img: UILabel!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var viewCard: UIView!
    @IBOutlet weak var viewOneHide: UIView!
    @IBOutlet weak var viewTwoHide: UIView!
    
    @IBOutlet weak var viewSignuP: UIView!
    @IBOutlet weak var actionSignUp: UIButton!
    @IBOutlet weak var tblNewLeads: UITableView!
    
    var newLeadsList: NewLeadsList?
    var residentialSelected = true
    var commercialSelected = true
    var otherserviceid = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        actionSignUp.clipsToBounds = true
        actionSignUp.layer.cornerRadius = 17.5
        tabBarColor()
        tblNewLeads.delegate = self
        tblNewLeads.dataSource = self
        getNewLeadsList()
        btnCancel.clipsToBounds = true
        btnCancel.layer.cornerRadius = 5
        viewCard.layer.cornerRadius = 5
        viewCard.layer.borderColor = UIColor.darkGray.cgColor
        viewCard.layer.borderWidth = 1
        
        viewOneHide.isHidden = true
        viewTwoHide.isHidden = true
    }
  
    @IBAction func actionNext(_ sender: UIButton) {
        loginShowStatus = true
        for controller in self.navigationController!.viewControllers as Array {
            if controller.isKind(of: LoginViewController.self) {
                self.navigationController!.popToViewController(controller, animated: true)
                break
            }
        }
    }
    
    @IBAction func actionCancelSigniin(_ sender: UIButton) {
        viewOneHide.isHidden = true
        viewTwoHide.isHidden = true
        
       
    }
    
    @IBAction func actionSigniInnn(_ sender: UIButton) {
        viewOneHide.isHidden = true
        viewTwoHide.isHidden = true
        loginShowStatus = true
        for controller in self.navigationController!.viewControllers as Array {
            if controller.isKind(of: LoginViewController.self) {
                self.navigationController!.popToViewController(controller, animated: true)
                break
            }
        }
    }
    
    @IBAction func actionBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return newLeadsList?.data?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewLeadsCell_CVC") as! NewLeadsCell_CVC
        
        let Server = "https://api.tapatradie.com/"
        //let Server = "http://3.109.98.222:3349/"
        cell.img_Profile.layer.cornerRadius = 50
        if let url = URL(string: "\(Server)\(newLeadsList?.data?[indexPath.row].profilePic ?? "")") {
            print(url)
            cell.viewBlurImg.backgroundColor = UIColor.lightGray
            cell.viewBlurImg.layer.cornerRadius = 50
            cell.viewBlurImg.clipsToBounds = true
            cell.img_Profile.downloadAndDisplayImage(from: url)
        }
        
        cell.lbl_JobStatus.text = "\(newLeadsList?.data?[indexPath.row].status ?? "")"
        let title = "\(newLeadsList?.data?[indexPath.row].fullName ?? "")"
        if title == "" {
            cell.lbl_SenderName.text = "Test User"
        }else{
            cell.lbl_SenderName.text = title
        }
        
        cell.lbl_Date.text = "\(newLeadsList?.data?[indexPath.row].date ?? "")"
        cell.lbl_Address.text = "\(newLeadsList?.data?[indexPath.row].address ?? "")"
  
        
        cell.lbl_JobTitle.text = "\(newLeadsList?.data?[indexPath.row].title ?? "")"
        cell.lbl_ServiceRequired.text = "\(newLeadsList?.data?[indexPath.row].serviceName ?? "")"
        cell.lbl_ServiceType.text = "\(newLeadsList?.data?[indexPath.row].serviceType ?? "")"
        cell.lbl_Detail.text = "\(newLeadsList?.data?[indexPath.row].detail ?? "")"
        
        cell.btnAccept.addTarget(self, action: #selector(openPopUp), for: .touchUpInside)
        cell.btnDecline.addTarget(self, action: #selector(openPopUp), for: .touchUpInside)
        cell.updateCell()
        return cell
    }
    
    
  


    
    
    
    @objc func openPopUp() {
        viewOneHide.isHidden = false
        viewTwoHide.isHidden = false
    }
    
    
    func getDomeyNewLeadsList() {
        let Server = "https://api.tapatradie.com/"
        //let Server = "http://3.109.98.222:3349/"
        let BaseUrl = "\(Server)v6/api/"
        
        print(Config.shared.appRole)
        var devideID = UIDevice.current.identifierForVendor?.uuidString ?? ""
        if "\(Config.shared.appRole)" == "provider" {
            devideID = "\(devideID)_provider"
        }
        
        let params = [
            "api_key": "$2a$06$hsTL2DeUKS5pUV.YlY/CSuVesppz0ha4hZdcsB7gN8VKRQRBwKct6",
            "device_id": devideID,
            "service_id": "\(otherserviceid)",
            "latitude": latitudeValNew,
            "longitude": longitudeValNew,
            "lead_type": leadType] as [String : String]
        
        let get_services_list_withoutkey = "\(BaseUrl)provider-leads-new"
        let url = URL(string: "\(get_services_list_withoutkey)")

        print(params)
        print(url)
        
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        request.timeoutInterval = 180
        request.addValue("application/json", forHTTPHeaderField: "Accept")

        let postString = ChooseIntrestNew_VC.getPostString(params: params)
        request.httpBody = postString.data(using: .utf8)

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let dataVal = data {
                let json = try! JSONSerialization.jsonObject(with: dataVal, options: [])
                print("Response :- \(json)")
                let jsonDict = json as? NSDictionary
                let status = (jsonDict?["success"] as? Int) ?? 0
                if status == 1 {
                    DispatchQueue.main.async {
                        self.newLeadsList = try! JSONDecoder().decode(NewLeadsList.self, from: data!)
                        self.tblNewLeads.reloadData()
                    }
                }
            }
        }
        task.resume()
    }
    
    
    func getNewLeadsList() {
        let Server = "https://api.tapatradie.com/"
        //let Server = "http://3.109.98.222:3349/"
        let BaseUrl = "\(Server)v6/api/"
        
        print(Config.shared.appRole)
        var devideID = UIDevice.current.identifierForVendor?.uuidString ?? ""
        if "\(Config.shared.appRole)" == "provider" {
            devideID = "\(devideID)_provider"
        }
        
        let params = [
            "api_key": "$2a$06$hsTL2DeUKS5pUV.YlY/CSuVesppz0ha4hZdcsB7gN8VKRQRBwKct6",
            "device_id": devideID,
            "service_id": "\(serviceId)",
            "latitude": latitudeValNew,
            "longitude": longitudeValNew,
            "lead_type": leadType] as [String : String]
        
        let get_services_list_withoutkey = "\(BaseUrl)provider-leads-new"
        let url = URL(string: "\(get_services_list_withoutkey)")

        print(params)
        print(url)
        
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        request.timeoutInterval = 180
        request.addValue("application/json", forHTTPHeaderField: "Accept")

        let postString = ChooseIntrestNew_VC.getPostString(params: params)
        request.httpBody = postString.data(using: .utf8)

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let dataVal = data {
                let json = try! JSONSerialization.jsonObject(with: dataVal, options: [])
                print("Response :- \(json)")
                let jsonDict = json as? NSDictionary
                let status = (jsonDict?["success"] as? Int) ?? 0
                self.otherserviceid = "\((jsonDict?["otherserviceid"] as? Int) ?? 0)"
                if status == 1 {
                    self.newLeadsList = try? JSONDecoder().decode(NewLeadsList.self, from: data!)
                    DispatchQueue.main.async {
                        self.tblNewLeads.reloadData()
                        if (self.newLeadsList?.data?.count ?? 0) == 0 {
                            let vc = self.storyboard?.instantiateViewController(withIdentifier: "AlertPopUp_VC") as! AlertPopUp_VC
                            vc.delegate = self
                            vc.modalPresentationStyle = .overFullScreen
                            self.present(vc, animated: true)
                        }
                    }
                }else{
                    if (self.newLeadsList?.data?.count ?? 0) == 0 {
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AlertPopUp_VC") as! AlertPopUp_VC
                        vc.delegate = self
                        vc.modalPresentationStyle = .overFullScreen
                        self.present(vc, animated: true)
                    }
                }
            }
        }
        task.resume()
    }
    
 
}






extension UIImageView {
    func blureImage() {
        
        var context = CIContext(options: nil)
        let currentFilter = CIFilter(name: "CIGaussianBlur")
        
        if self.image == nil {
            
            let beginImage = CIImage(image: UIImage(named: "user1")!)
            currentFilter!.setValue(beginImage, forKey: kCIInputImageKey)
            currentFilter!.setValue(40, forKey: kCIInputRadiusKey)
            
            let cropFilter = CIFilter(name: "CICrop")
            cropFilter!.setValue(currentFilter!.outputImage, forKey: kCIInputImageKey)
            cropFilter!.setValue(CIVector(cgRect: beginImage!.extent), forKey: "inputRectangle")
            
            let output = cropFilter!.outputImage
            let cgimg = context.createCGImage(output!, from: output!.extent)
            let processedImage = UIImage(cgImage: cgimg!)
            self.image = processedImage
        }else{
            let beginImage = CIImage(image: self.image!)
            currentFilter!.setValue(beginImage, forKey: kCIInputImageKey)
            currentFilter!.setValue(40, forKey: kCIInputRadiusKey)
            
            let cropFilter = CIFilter(name: "CICrop")
            cropFilter!.setValue(currentFilter!.outputImage, forKey: kCIInputImageKey)
            cropFilter!.setValue(CIVector(cgRect: beginImage!.extent), forKey: "inputRectangle")
            
            let output = cropFilter!.outputImage
            let cgimg = context.createCGImage(output!, from: output!.extent)
            let processedImage = UIImage(cgImage: cgimg!)
            self.image = processedImage
        }
        
        
    }
    
    
    func downloadAndDisplayImage(from url: URL) {
                
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data,
                  let image = UIImage(data: data),
                  let beginImage = CIImage(image: image)
                    
            else {
                return
            }
            
            let context = CIContext(options: nil)
            let currentFilter = CIFilter(name: "CIGaussianBlur")
            currentFilter!.setValue(beginImage, forKey: kCIInputImageKey)
            currentFilter!.setValue(50, forKey: kCIInputRadiusKey)
            
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
















































public enum TrackingMode: CustomStringConvertible {
    case tracking
    case common
    case none

    public var description: String {
        switch self {
        case .tracking:
            return RunLoop.Mode.tracking.rawValue
        case .common:
            return RunLoop.Mode.common.rawValue
        case .none:
            return ""
        }
    }
}


open class DynamicBlurView: UIView {
    open override class var layerClass: AnyClass {
        BlurLayer.self
    }

    private var blurLayer: BlurLayer {
        layer as! BlurLayer
    }

    private var staticImage: UIImage?
    private var displayLink: CADisplayLink? {
        didSet {
            oldValue?.invalidate()
        }
    }

    private var renderingTarget: UIView? {
        window != nil
            ? (isDeepRendering ? window : superview)
            : nil
    }

    private var relativeLayerRect: CGRect {
        blurLayer.current.convertRect(to: renderingTarget?.layer)
    }

    /// Radius of blur.
    open var blurRadius: CGFloat {
        get { blurLayer.blurRadius }
        set { blurLayer.blurRadius = newValue }
    }

    /// Default is none.
    open var trackingMode: TrackingMode = .none {
        didSet {
            if trackingMode != oldValue {
                linkForDisplay()
            }
        }
    }

    /// Blend color.
    open var blendColor: UIColor?

    /// Blend mode.
    open var blendMode: CGBlendMode = .plusLighter

    /// Default is 3.
    open var iterations = 3

    /// If the view want to render beyond the layer, should be true.
    open var isDeepRendering = false

    /// When none of tracking mode, it can change the radius of blur with the ratio. Should set from 0 to 1.
    open var blurRatio: CGFloat = 1 {
        didSet {
            if oldValue != blurRatio, let blurredImage = staticImage.flatMap(imageBlurred) {
                blurLayer.draw(blurredImage)
            }
        }
    }

    /// Quality of captured image.
    open var quality: CaptureQuality {
        get { blurLayer.quality }
        set { blurLayer.quality = newValue }
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        isUserInteractionEnabled = false
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        isUserInteractionEnabled = false
    }

    open override func didMoveToWindow() {
        super.didMoveToWindow()

        if trackingMode == .none {
            renderingTarget?.layoutIfNeeded()
            staticImage = currentImage()
        }
    }

    open override func didMoveToSuperview() {
        super.didMoveToSuperview()

        if superview == nil {
            displayLink = nil
        } else {
            linkForDisplay()
        }
    }

    func imageBlurred(_ image: UIImage) -> UIImage? {
        image.blurred(
            radius: blurLayer.currentBlurRadius,
            iterations: iterations,
            ratio: blurRatio,
            blendColor: blendColor,
            blendMode: blendMode
        )
    }

    func currentImage() -> UIImage? {
        renderingTarget.flatMap { view in
            blurLayer.snapshotImageBelowLayer(view.layer, in: isDeepRendering ? view.bounds : relativeLayerRect)
        }
    }
}

extension DynamicBlurView {
    open override func display(_ layer: CALayer) {
        if let blurredImage = (staticImage ?? currentImage()).flatMap(imageBlurred) {
            blurLayer.draw(blurredImage)

            if isDeepRendering {
                blurLayer.contentsRect = relativeLayerRect.rectangle(blurredImage.size)
            }
        }
    }
}

extension DynamicBlurView {
    private func linkForDisplay() {
        displayLink = UIScreen.main.displayLink(withTarget: self, selector: #selector(DynamicBlurView.displayDidRefresh(_:)))
        displayLink?.add(to: .main, forMode: RunLoop.Mode(rawValue: trackingMode.description))
    }

    @objc private func displayDidRefresh(_ displayLink: CADisplayLink) {
        display(layer)
    }
}

extension DynamicBlurView {
    /// Remove cache of blur image then get it again.
    open func refresh() {
        blurLayer.refresh()
        staticImage = nil
        blurRatio = 1
        display(layer)
    }

    /// Remove cache of blur image.
    open func remove() {
        blurLayer.refresh()
        staticImage = nil
        blurRatio = 1
        layer.contents = nil
    }

    /// Should use when needs to change layout with animation when is set none of tracking mode.
    public func animate() {
        blurLayer.animate()
    }
}


class BlurLayer: CALayer {
    private static let blurRadiusKey = "blurRadius"
    private static let blurLayoutKey = "blurLayout"
    private static let opacityKey = "opacity"
    @NSManaged var blurRadius: CGFloat
    @NSManaged private var blurLayout: CGFloat

    private var fromBlurRadius: CGFloat?
    var currentBlurRadius: CGFloat {
        presentation()?.blurRadius ?? fromBlurRadius ?? blurRadius
    }

    var current: BlurLayer {
        presentation() ?? self
    }

    var quality: CaptureQuality = .medium

    override class func needsDisplay(forKey key: String) -> Bool {
        key == blurRadiusKey || key == blurLayoutKey
            ? true
            : super.needsDisplay(forKey: key)
    }

    open override func action(forKey event: String) -> CAAction? {
        if event == BlurLayer.blurRadiusKey {
            fromBlurRadius = nil

            if let action = super.action(forKey: BlurLayer.opacityKey) as? CABasicAnimation {
                fromBlurRadius = current.blurRadius

                action.keyPath = event
                action.fromValue = fromBlurRadius
                return action
            }
        }

        if event == BlurLayer.blurLayoutKey, let action = super.action(forKey: BlurLayer.opacityKey) as? CABasicAnimation {
            action.keyPath = event
            action.fromValue = 0
            action.toValue = 1
            return action
        }

        return super.action(forKey: event)
    }
}

extension BlurLayer {
    func refresh() {
        fromBlurRadius = nil
    }

    func animate() {
        UIView.performWithoutAnimation {
            blurLayout = 0
        }
        blurLayout = 1
    }

    func snapshotImageBelowLayer(_ layer: CALayer, in rect: CGRect) -> UIImage? {
        guard let context = CGContext.imageContext(in: rect, isOpaque: isOpaque, quality: quality) else {
            return nil
        }

        renderBelowLayer(layer, in: context)

        defer {
            UIGraphicsEndImageContext()
        }

        return UIGraphicsGetImageFromCurrentImageContext()
    }
}

extension CALayer {
    func draw(_ image: UIImage) {
        contents = image.cgImage
        contentsScale = image.scale
    }

    func renderBelowLayer(_ layer: CALayer, in context: CGContext) {
        let layers = hideOverlappedLayers(layer.sublayers)
        layer.render(in: context)
        layers.forEach {
            $0.isHidden = false
        }
    }

    func hideOverlappedLayers(_ layers: [CALayer]?) -> [CALayer] {
        var hiddenLayers: [CALayer] = []
        for layer in layers?.reversed() ?? [] {
            if isHung(in: layer) {
                hiddenLayers.append(contentsOf: hideOverlappedLayers(layer.sublayers))
                break
            }

            if !layer.isHidden {
                layer.isHidden = true
                hiddenLayers.append(layer)
            }

            if layer === self {
                break
            }
        }
        return hiddenLayers
    }

    func isHung(in target: CALayer) -> Bool {
        var layer = superlayer
        while layer != nil {
            if layer === target {
                return true
            }
            layer = layer?.superlayer
        }

        return false
    }
}


extension CALayer {
    func convertRect(to layer: CALayer?) -> CGRect {
        convert(bounds, to: layer)
    }
}




extension CGRect {
    func rectangle(_ s: CGSize) -> CGRect {
        CGRect(
            x: origin.x / s.width,
            y: origin.y / s.height,
            width: size.width / s.width,
            height: size.height / s.height
        )
    }
}



extension CGContext {
    static func imageContext(in rect: CGRect, isOpaque opaque: Bool, quality: CaptureQuality) -> CGContext? {
        UIGraphicsBeginImageContextWithOptions(rect.size, opaque, quality.imageScale)
        guard let context = UIGraphicsGetCurrentContext() else {
            return nil
        }

        context.translateBy(x: -rect.origin.x, y: -rect.origin.y)
        context.interpolationQuality = quality.interpolationQuality

        return context
    }

    func makeImage(with blendColor: UIColor?, blendMode: CGBlendMode, size: CGSize) -> CGImage? {
        if let color = blendColor {
            setFillColor(color.cgColor)
            setBlendMode(blendMode)
            fill(CGRect(origin: .zero, size: size))
        }

        return makeImage()
    }
}



public enum CaptureQuality {
    case `default`
    case low
    case medium
    case high

    var imageScale: CGFloat {
        switch self {
        case .default, .high:
            return 0
        case .low, .medium:
            return  1
        }
    }

    var interpolationQuality: CGInterpolationQuality {
        switch self {
        case .default, .low:
            return .none
        case .medium, .high:
            return .default
        }
    }
}




class BlurredLabel: UILabel {

    func blur(_ blurRadius: Double = 2.5) {
        let blurredImage = getBlurryImage(blurRadius)
        let blurredImageView = UIImageView(image: blurredImage)
        blurredImageView.translatesAutoresizingMaskIntoConstraints = false
        blurredImageView.tag = 100
        blurredImageView.contentMode = .center
        blurredImageView.backgroundColor = .white
        addSubview(blurredImageView)
        NSLayoutConstraint.activate([
            blurredImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            blurredImageView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }

    func unblur() {
        subviews.forEach { subview in
            if subview.tag == 100 {
                subview.removeFromSuperview()
            }
        }
    }

    private func getBlurryImage(_ blurRadius: Double = 2.5) -> UIImage? {
        UIGraphicsBeginImageContext(bounds.size)
        layer.render(in: UIGraphicsGetCurrentContext()!)
        guard let image = UIGraphicsGetImageFromCurrentImageContext(),
            let blurFilter = CIFilter(name: "CIGaussianBlur") else {
            UIGraphicsEndImageContext()
            return nil
        }
        UIGraphicsEndImageContext()

        blurFilter.setDefaults()

        blurFilter.setValue(CIImage(image: image), forKey: kCIInputImageKey)
        blurFilter.setValue(blurRadius, forKey: kCIInputRadiusKey)

        var convertedImage: UIImage?
        let context = CIContext(options: nil)
        if let blurOutputImage = blurFilter.outputImage,
            let cgImage = context.createCGImage(blurOutputImage, from: blurOutputImage.extent) {
            convertedImage = UIImage(cgImage: cgImage)
        }

        return convertedImage
    }
}
