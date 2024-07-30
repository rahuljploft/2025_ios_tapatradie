//
//  SupportVC.swift
//  TapATradie
//
//  Created by Sarjan Singh on 24/01/22.
//

import UIKit
import DropDown
import ObjectMapper

class SupportVC: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var txtSelectCategory: UITextField!
    @IBOutlet weak var txtMessage: UITextView!
    @IBOutlet var viewTxtC: [UIView]!
    @IBOutlet weak var lblPlaceholder: UILabel!
    
    let dropDown = DropDown()
    var categoryJSON: CategoryJSON?
    
    var selectedId:String?
    
    //MARK: - ViewLife Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        _ = viewTxtC.map({($0 as UIView).setCornerRadiusWithBorder(cornerRadius: 2, clipsToBound: false, borderWidth: 0.25, borderColor: UIColor(named: "#000000")?.cgColor)})
        txtMessage.delegate = self
        
        dropDown.anchorView = txtSelectCategory
//        dropDown.dataSource = ["Car", "Motorcycle", "Truck"]
        dropDown.width = 200
        
        getCategory()
        
    }
    
    
    
    //MARK: - Action
    
    @IBAction func btnCategoryTapped(_ sender: Any) {
        
        dropDown.show()
        
        // Action triggered on selection
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            
            print("Selected item: \(item) at index: \(index)")
            self.txtSelectCategory.text = item
            self.selectedId = String(self.categoryJSON?.data[index].id ?? 0)
            
        }
        
        
    }
    
    
    @IBAction func btnSubmitTapped(_ sender: UIButton) {
        if validate() {
            if txtSelectCategory.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""{
                Http.alert("Error", "Please select Category")
            }else if txtMessage.text.trimmingCharacters(in: .whitespacesAndNewlines) == ""{
                Http.alert("Error", "Please enter message")
            }else{
                supportEnquiry()
            }
        }
        
        
    }
    
    
    
    
    
    func validate() -> Bool {
        
        
        if (txtMessage.text?.count ?? 0) >= 255 {
            alert(msg: "Please enter character less then 255 in message!")
            return false
        }
        
        print(validateGenericString(txtMessage.text ?? ""))
        if !validateGenericString(txtMessage.text ?? "") {
            alert(msg: "Special character are not allowed in message!")
            return false
        }
        
        return true
    }


    func validateGenericString(_ string: String) -> Bool {
        return string.range(of: ".*[$&+:;=\\\\?#|/<>^*()%!].*", options: .regularExpression) == nil
    }


 func alert(msg:String) {
        let alert = UIAlertController(title: "Tap A Tradie", message: "\(msg)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel))
        self.present(alert, animated: true)
    }
    
    
    
    
    var arrShimmer: [String] = []
    
    
    
    func getCategory() {
        arrShimmer = ["", "", ""]
        let param = params()
//        param["search"] = ""
//        param["fixed_service"] = "1"
//        param["page"] = "all"
//        
        Http.instance().json(api_get_category_list, param, "GET", aai: true, popup: true, prnt: true, nil, nil, sync: false, defaultCalling: false) { (json, paras, str, data) in
            let jsonExp = json as? NSDictionary
            if jsonExp != nil {
                if jsonExp?.number("success").intValue == SESSIONEXPIRED {
                   kAppDelegate.sessionExpired(self)
                    return
                }
            }
            
            if data != nil {
                do {
                    self.categoryJSON = try JSONDecoder().decode(CategoryJSON.self, from: data!)
                    print(self.categoryJSON?.message)
//                    if self.categoryJSON != nil {
//                        let ob = Services("")
//                        ob.name = "More"
//                        ob.id = -99999
//                        self.servicesJSON?.data.append(ob)
//                    }
                    self.dropDown.dataSource.removeAll()
                    if self.categoryJSON != nil{
                        for cat in self.categoryJSON!.data{
                            self.dropDown.dataSource.append(cat.name)
                        }
                    }
                    self.arrShimmer = []
                } catch let error {
                    print("Error: \(error)")
                }
            }
        }
    }
    
    
    func supportEnquiry() {
        
        arrShimmer = ["", "", ""]
        
        let param = params()
        
        guard let userId = UserDefaults.standard.string(forKey: Key_User_id) else{
            return
        }
        
        
        param["uid"] = userId
        param["categoryId"] = self.selectedId
        param["message"] = txtMessage.text ?? ""

        Http.instance().json(api_get_support_enquiry, param, "POST", aai: true, popup: true, prnt: true, nil, nil, sync: false, defaultCalling: false) { (json, paras, str, data) in
            
            let jsonExp = json as? NSDictionary
            
            if jsonExp != nil {
                if jsonExp?.number("success").intValue == SESSIONEXPIRED {
                   kAppDelegate.sessionExpired(self)
                    
                    
                    return
                }
            }
            
            if data != nil {
                do {
//                    self.categoryJSON = try JSONDecoder().decode(CategoryJSON.self, from: data!)
//                    print(self.categoryJSON?.message)
                    
//                    if self.categoryJSON != nil {
//                        let ob = Services("")
//                        ob.name = "More"
//                        ob.id = -99999
//                        self.servicesJSON?.data.append(ob)
//                    }
//
                    self.showThankYou()
                    
                    
                    self.arrShimmer = []
                    
                } catch let error {
                    print("Error: \(error)")
                }
            }
        }
    }
    
    
    
    func showThankYou(){
        
        self.txtSelectCategory.text = ""
        self.txtMessage.text = ""
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "ThankYouVC") as! ThankYouVC
        vc.view.backgroundColor = UIColor(white: 0, alpha: 0.7)
        vc.modalPresentationStyle = .overFullScreen
        vc.delegate = self
        self.present(vc, animated: true, completion: nil)
//        self.navigationController?.push(viewController: vc, animated: true)
    
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}


//MARK: - Textview delegate

extension SupportVC: UITextViewDelegate{
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        //        if textView.text == ""{
        self.lblPlaceholder.isHidden = true
        //        }else{
        //            self.lblPlaceholder.isHidden = true
        //        }
        
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        if textView.text == ""{
            self.lblPlaceholder.isHidden = false
        }else{
            self.lblPlaceholder.isHidden = true
        }
        
    }
    
}


extension SupportVC: ThankyouDelegate{

    func thankyouDismissed() {
        let vc = story_Tradie.viewController("MyBookings") as! MyBookings
        self.navigationController?.push(viewController: vc)
    }

}





// MARK: - CategoryJSON
struct CategoryJSON: Codable {

    let success: Int
    let message: String
    let data: [CategoryList]

}

// MARK: - Datum
struct CategoryList: Codable {
    
    let id: Int
    let name: String
    
}
