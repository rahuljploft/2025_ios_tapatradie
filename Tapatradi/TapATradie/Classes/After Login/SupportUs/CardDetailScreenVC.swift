//
//  CardDetailScreenVC.swift
//  Tradie
//
//  Created by Admin on 18/01/23.
//

import UIKit

protocol sussessfullPayment {
    func successPayment()
}

class CardDetailScreenVC: UIViewController {

    @IBOutlet weak var viewPleaseNote: UIView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var txtCardNumber: UITextField!
    @IBOutlet weak var txtMonth: UITextField!
    @IBOutlet weak var txtYear: UITextField!
    @IBOutlet weak var txtCVV: UITextField!
    @IBOutlet weak var txtCardName: UITextField!
    @IBOutlet weak var viewPay: UIView!
    @IBOutlet weak var lbl_Amount: UILabel!
    
    @IBOutlet weak var viewCardNumber: UIView!
    @IBOutlet weak var viewMonth: UIView!
    @IBOutlet weak var viewYear: UIView!
    @IBOutlet weak var viewCVV: UIView!
    @IBOutlet weak var viewCardName: UIView!
    var delegateNew:sussessfullPayment!
    var planeID = ""
    var tokenVal = ""
    var amount = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        indicator.isHidden = true
        viewPay.layer.cornerRadius = 25
        lbl_Amount.text = "$\(amount)"
        viewCardNumber.layer.cornerRadius = 8
        viewCardNumber.layer.borderWidth = 1
        viewCardNumber.layer.borderColor = UIColor.gray.cgColor
        
        
        viewPay.layer.cornerRadius = viewPay.frame.height/2
        viewPay.clipsToBounds = true
        
        viewPleaseNote.layer.cornerRadius = viewPleaseNote.frame.height/2
        viewPleaseNote.clipsToBounds = true
        
        viewMonth.layer.cornerRadius = 8
        viewMonth.layer.borderWidth = 1
        viewMonth.layer.borderColor = UIColor.gray.cgColor
        
        
        viewYear.layer.cornerRadius = 8
        viewYear.layer.borderWidth = 1
        viewYear.layer.borderColor = UIColor.gray.cgColor
        
        viewCVV.layer.cornerRadius = 8
        viewCVV.layer.borderWidth = 1
        viewCVV.layer.borderColor = UIColor.gray.cgColor
        
        viewCardName.layer.cornerRadius = 8
        viewCardName.layer.borderWidth = 1
        viewCardName.layer.borderColor = UIColor.gray.cgColor
        
    }
    
    @IBAction func actinoPayNow(_ sender: UIButton) {
        
        if "\(txtCardNumber.text ?? "")" == "" {
            alertShow(msg: "Please Enter Card Number")
        }else if "\(txtMonth.text ?? "")" == "" {
            alertShow(msg: "Please Enter Month Detail")
        }else if "\(txtYear.text ?? "")" == "" {
            alertShow(msg: "Please Enter Year Detail")
        }else if "\(txtCVV.text ?? "")" == "" {
            alertShow(msg: "Please Enter CVV Detail")
        }else if "\(txtCardName.text ?? "")" == "" {
            alertShow(msg: "Please Enter Card Holder Name")
        }else{
            creatCardToken()
        }
        
    }
    
    func alertShow(msg:String) {
        let alert = UIAlertController(title: "Tap A Tradie", message: "\(msg)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel))
        self.present(alert, animated: true)
    }
    
    func creatCardToken() {
        indicator.isHidden = false
        indicator.stopAnimating()
        let usernew = UserDefaults.standard
        let token = "\(usernew.object(forKey: KEY_ACCESSTOEKN) ?? "")"
        let userID = Key_User_id.getUserValue() ?? ""
        
        let params : [String:String] = [
            "access_token": "\(token)",
            "device_id": "\(UIDevice.current.identifierForVendor!.uuidString)_provider",
            "api_key": "$2a$06$hsTL2DeUKS5pUV.YlY/CSuVesppz0ha4hZdcsB7gN8VKRQRBwKct6",
            "device_type": "2",
            "uid": "\(userID)",
            "card_number": "\(txtCardNumber.text ?? "")",
            "exp_month": "\(txtMonth.text ?? "")",
            "exp_year": "\(txtYear.text ?? "")",
            "cvv": "\(txtCVV.text ?? "")",
            "name":"\(txtCardName.text ?? "")"
        ]
        
        print(params)
        //let url = URL(string: "http://3.109.98.222:3349/v4/api/create-card-token")
        let url = URL(string: "\(create_card_token)")
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        request.timeoutInterval = 180
        request.addValue("application/json", forHTTPHeaderField: "Accept")
   
        let postString = PaymentScreenVC.getPostString(params: params)
        request.httpBody = postString.data(using: .utf8)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let dataVal = data {
                let json = try! JSONSerialization.jsonObject(with: dataVal, options: [])
                print("Response :- \(json)")
                let jsonDict = json as? NSDictionary
                let status = (jsonDict?["success"] as? Int) ?? 0
                let message = (jsonDict?["message"] as? String) ?? ""
                DispatchQueue.main.async {
                    if status == 1 {
                        let status =
                        self.tokenVal = (jsonDict?["token"] as? String) ?? ""
                        self.subscriptionPayment()
                    }else{
                        self.alertShow(msg: "\(message)")
                    }
                }
            }else{
                DispatchQueue.main.async {
                    self.indicator.isHidden = true
                    self.indicator.stopAnimating()
                }
                
            }
        }
        task.resume()
    }
    
    @IBAction func actionBack(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    func subscriptionPayment() {
        let usernew = UserDefaults.standard
        let token = "\(usernew.object(forKey: KEY_ACCESSTOEKN) ?? "")"
        let userID = Key_User_id.getUserValue() ?? ""
        
        let params : [String:String] = [
            "access_token": "\(token)",
            "device_id": "\(UIDevice.current.identifierForVendor!.uuidString)_provider",
            "api_key": "$2a$06$hsTL2DeUKS5pUV.YlY/CSuVesppz0ha4hZdcsB7gN8VKRQRBwKct6",
            "device_type": "2",
            "uid": "\(userID)",
            "plan_id":"\(planeID)",
            "token":"\(tokenVal)"
        ]
        
        print(params)
        //let url = URL(string: "http://3.109.98.222:3349/v4/api/subscription-payment")
        let url = URL(string: "\(subscription_payment)")
        
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        request.timeoutInterval = 180
        request.addValue("application/json", forHTTPHeaderField: "Accept")
   
        let postString = PaymentScreenVC.getPostString(params: params)
        request.httpBody = postString.data(using: .utf8)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let dataVal = data {
                let json = try! JSONSerialization.jsonObject(with: dataVal, options: [])
                print("Response :- \(json)")
                let jsonDict = json as? NSDictionary
                let status = (jsonDict?["success"] as? Int) ?? 0
                let message = (jsonDict?["message"] as? String) ?? ""
                if status == 1 {
                    DispatchQueue.main.async {
                        self.indicator.isHidden = true
                        self.indicator.stopAnimating()
                        self.dismiss(animated: true) {
                            self.delegateNew.successPayment()
                        }
                    }
                }else{
                    DispatchQueue.main.async {
                        self.alertShow(msg: "\(message)")
                    }
                }
            }else{
                DispatchQueue.main.async {
                    self.indicator.isHidden = true
                    self.indicator.stopAnimating()
                }
                print(error)
            }
        }
        task.resume()
    }
    
    static func getPostString(params:[String:Any]) -> String {
        var data = [String]()
        for(key, value) in params
        {
            data.append(key + "=\(value)")
        }
        return data.map { String($0) }.joined(separator: "&")
    }

    
}

