//
//  DeletePopUpVC.swift
//  Tradie
//
//  Created by Admin on 18/01/23.
//

import UIKit

protocol DeleteAccount {
    func deleteAccountSuccess()
}


class DeletePopUpVC: UIViewController {

    @IBOutlet weak var viewCan: UIView!
    @IBOutlet weak var lbl_Email: UILabel!
    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var viewMainCard: UIView!
    @IBOutlet weak var viewCancel: UIView!
    @IBOutlet weak var viewDelete: UIView!
    @IBOutlet weak var viewDone: UIView!
    @IBOutlet weak var viewSelection: UIView!
    var delegate: DeleteAccount!
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        lbl_Email.isHidden = true
        viewDelete.layer.cornerRadius = 12
        viewDelete.layer.borderColor = UIColor.black.cgColor
        viewDelete.backgroundColor = UIColor.black
        viewDelete.layer.borderWidth = 1
        
        viewCancel.layer.cornerRadius = 12
        viewCancel.layer.borderColor = UIColor.gray.cgColor
        viewCancel.layer.borderWidth = 1
        
        viewDone.isHidden = true
        viewDone.layer.cornerRadius = 12
        viewDone.layer.borderColor = UIColor.gray.cgColor
        viewDone.layer.borderWidth = 1
        
        viewMainCard.layer.cornerRadius = 12
        viewMainCard.layer.shadowColor = UIColor.gray.cgColor
        viewMainCard.layer.shadowOffset = .zero
        viewMainCard.layer.shadowOpacity = 0.5
        viewMainCard.layer.shadowRadius = 2
    }
    
    @IBAction func actinoCancel(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    @IBAction func actinoDelete(_ sender: UIButton) {
        let userID = Key_User_id.getUserValue() ?? ""
        let params : [String:String] = [
            "userId":"\(userID)",
        ]
        print(params)
        deleteAPICall(params: params)
    }
    
    @IBAction func actinoOk(_ sender: UIButton) {
        dismiss(animated: true) {
            self.delegate.deleteAccountSuccess()
        }
    }
    
    
    //MARK: Post API With Header
    func deleteAPICall(params:[String:Any]?) {
        let url = URL(string: "\(deleteAccount)")
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        request.timeoutInterval = 180
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        if let paramVal = params {
            let postString = DeletePopUpVC.getPostString(params: paramVal)
            request.httpBody = postString.data(using: .utf8)
        }
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let dataVal = data {
                let json = try! JSONSerialization.jsonObject(with: dataVal, options: [])
                print("Response :- \(json)")
                let jsonDict = json as? NSDictionary
                let status = (jsonDict?["success"] as? Int) ?? 0
                if status == 1 {
                    DispatchQueue.main.async {
                        self.lbl_Email.isHidden = false
                        self.lblMessage.text = "Your advert has been deleted successfully. We are sorry to see you go and would appreciate your feed back so we can improve our service and hopefully see you back onboard some day. "
                        self.viewSelection.isHidden = true
                        self.viewCan.isHidden = true
                        self.viewDone.isHidden = false
                    }
                    
                }
            }else{
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
