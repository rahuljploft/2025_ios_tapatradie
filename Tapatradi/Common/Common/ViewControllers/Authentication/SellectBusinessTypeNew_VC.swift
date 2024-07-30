//
//  SellectBusinessTypeNew_VC.swift
//  Common
//
//  Created by Admin on 20/02/23.
//

import UIKit

class SellectBusinessTypeNew_VC: UIViewController {

    
    @IBOutlet weak var viewSignUp: UIView!
    @IBOutlet weak var btnGetStarted: UIButton!
    @IBOutlet weak var actionSignUp: UIButton!
    @IBOutlet weak var viewCommercial: UIView!
    @IBOutlet weak var viewResidential: UIView!
    
    var selectedArr : [Int] = []
    var residentialSelected = true
    var commercialSelected = true
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //203C54
        
        viewResidential.layer.cornerRadius = 5
        viewResidential.layer.borderColor = UIColor.systemGreen.cgColor
        viewResidential.layer.borderWidth = 1
        viewResidential.layer.shadowColor = UIColor.lightGray.cgColor
        viewResidential.layer.shadowOffset = .zero
        viewResidential.layer.shadowOpacity = 0.5
        viewResidential.layer.shadowRadius = 1
        
        viewSignUp.clipsToBounds = true
        viewSignUp.layer.cornerRadius = 17.5
        
        viewCommercial.layer.cornerRadius = 5
        viewCommercial.layer.borderColor = UIColor.systemGreen.cgColor
        viewCommercial.layer.borderWidth = 1
        viewCommercial.layer.shadowColor = UIColor.lightGray.cgColor
        viewCommercial.layer.shadowOffset = .zero
        viewCommercial.layer.shadowOpacity = 0.5
        viewCommercial.layer.shadowRadius = 1
        
        btnGetStarted.layer.cornerRadius = 5
        actionSignUp.layer.cornerRadius = 17.5
        
        tabBarColor()
    }
    
    @IBAction func actionBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
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
    
    @IBAction func actionSignUp(_ sender: UIButton) {
        
        if commercialSelected == false && residentialSelected == false {
            let alert = UIAlertController(title: "Tap A Tradie", message: "Please select Service Type", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel))
            self.present(alert, animated: true)
        }else{
            if commercialSelected == true && residentialSelected == true {
                leadType = "residential,commercial"
            }else if commercialSelected == true {
                leadType = "commercial"
            }else{
                leadType = "residential"
            }
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "SelectLocationNew_VC") as! SelectLocationNew_VC
            self.navigationController?.push(viewController: vc,animated: true)
        }        
       
    }
    
    @IBAction func actionResidential(_ sender: Any) {
        if residentialSelected {
            
            residentialSelected = false
            viewResidential.layer.borderWidth = 0
        }else{
            
            residentialSelected = true
            viewResidential.layer.borderWidth = 1
        }
    }
    
    @IBAction func actionCommericial(_ sender: UIButton) {
        if commercialSelected {
            commercialSelected = false
            viewCommercial.layer.borderWidth = 0
        }else{
            commercialSelected = true
            viewCommercial.layer.borderWidth = 1
        }
    }
    
}


extension UIViewController {
    
    func tabBarColor() {
        if #available(iOS 13.0, *) {
            let statusBar = UIView(frame: UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.windowScene?.statusBarManager?.statusBarFrame ?? CGRect.zero)
            statusBar.backgroundColor = hexStringToUIColor(hex: "0x203C54")
            UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.addSubview(statusBar)
        } else {
            let statusBar = UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar") as? UIView
            statusBar?.backgroundColor = hexStringToUIColor(hex: "0x203C54")
        }
    }
    
    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }

        if ((cString.count) != 6) {
            return UIColor.gray
        }

        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)

        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}
