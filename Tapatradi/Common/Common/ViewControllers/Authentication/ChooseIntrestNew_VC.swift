//
//  ChooseIntrestNew_VC.swift
//  Common
//
//  Created by Admin on 19/02/23.
//

import UIKit

class ChooseIntrestNew_VC: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    @IBOutlet weak var viewBackShow: UIView!
    
    @IBOutlet weak var viewNextTop: UIView!
    @IBOutlet weak var btnNextTop: UIButton!
    
    @IBOutlet weak var lbl_SelectCat: UILabel!
    @IBOutlet weak var lbl_AllCate: UILabel!
    @IBOutlet weak var viewSearch: UIView!
    @IBOutlet weak var btnMore: UIButton!
    @IBOutlet weak var tblHeight: NSLayoutConstraint!
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var txtSearch: UITextField!
    @IBOutlet weak var viewSignUP: UIView!
    @IBOutlet weak var actionSignUp: UIButton!
    @IBOutlet weak var tblCategoryList: UITableView!
    
    var workItemReferance : DispatchWorkItem? = nil
    var selectedArr : [Int] = []
    var moreServiceList : ServiceList?
    var moreStatus = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //203C54
        viewBackShow.isHidden = true
        viewNextTop.clipsToBounds = true
        viewNextTop.layer.cornerRadius = 17.5
        //btnNext.layer.cornerRadius = 5
        txtSearch.delegate = self
        tblCategoryList.delegate = self
        tblCategoryList.dataSource = self
        viewSignUP.clipsToBounds = true
        viewSignUP.layer.cornerRadius = 17.5
        self.tblCategoryList.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        getSerivcesList(search: "")
        tabBarColor()
        
       
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        print(txtSearch.text ?? "")
        self.workItemReferance?.cancel()
        let searchWorkItem = DispatchWorkItem {
            let search = self.txtSearch.text ?? ""
            self.getSerivcesList(search: search)
        }
        self.workItemReferance = searchWorkItem
        DispatchQueue.main.asyncAfter(deadline: .now()+1, execute: searchWorkItem)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if(keyPath == "contentSize"){
            if let newvalue = change?[.newKey] {
                let newsize  = newvalue as! CGSize
                print("Height : ",newsize.height)
                self.tblHeight.constant = newsize.height
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.moreServiceList?.data?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell_TVC") as! CategoryCell_TVC
        if selectedArr[indexPath.row] == 1 {
            cell.ImgCheck.image = UIImage(named: "check 2")
        }else{
            cell.ImgCheck.image = UIImage(named: "EmptyCheckBox")
        }
        cell.lbl_Title.text = self.moreServiceList?.data?[indexPath.row].name ?? ""
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if selectedArr[indexPath.row] == 1 {
            selectedArr[indexPath.row] = 0
        }else{
            selectedArr[indexPath.row] = 1
        }
        tblCategoryList.reloadData()
    }
    
    @IBAction func actionMore(_ sender: Any) {
        viewBackShow.isHidden = false
        moreStatus = true
        viewNextTop.isHidden = true
        lbl_SelectCat.isHidden = true
        lbl_AllCate.isHidden = true
        btnMore.isHidden = true
        viewSearch.isHidden = true
        getMoreSerivcesList()
    }
    
    
    @IBAction func actionNext(_ sender: UIButton) {
        serviceId = ""
        for i in  0..<selectedArr.count {
            if selectedArr[i] == 1 {
                if let id = self.moreServiceList?.data?[i].id {
                    serviceId.append("\(id),")
                }
            }
        }
        if serviceId != "" {
            print(serviceId)
            serviceId =  "\(serviceId.dropLast())"
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "SellectBusinessTypeNew_VC") as! SellectBusinessTypeNew_VC
            self.navigationController?.push(viewController: vc,animated: true)
        }else{
            let alert = UIAlertController(title: "Tap A Tradie", message: "Please select atlest one service", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel))
            self.present(alert, animated: true)
        }
    }
    
    @IBAction func actionBack(_ sender: UIButton) {
        if moreStatus == true {
            viewBackShow.isHidden = true
            viewNextTop.isHidden = false
            moreStatus = false
            lbl_SelectCat.isHidden = false
            lbl_AllCate.isHidden = false
            btnMore.isHidden = false
            viewSearch.isHidden = false
            txtSearch.text = ""
            getSerivcesList(search: "")
        }
    }
    
    @IBAction func actionSignUp(_ sender: UIButton) {
        loginShowStatus = true
        self.navigationController?.popViewController(animated: true)
    }
    
    func getMoreSerivcesList() {
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
            "device_id": "\(devideID)",
            "fixed_service": "0",
            "device_type": "2",
            "page": "all",
            "role": "provider",
            "search": "",
            "uid": "25273",
            "version": "1.25.8"]
        
        let get_services_list_withoutkey = "\(BaseUrl)get-services-list-withoutkey"
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
                        self.moreServiceList = try! JSONDecoder().decode(ServiceList.self, from: data!)
                        self.selectedArr.removeAll()
                        for _ in 0..<(self.moreServiceList?.data?.count ?? 0) {
                            self.selectedArr.append(0)
                        }
                        self.tblCategoryList.reloadData()
                    }
                }
            }else{
                print(error)
            }
        }
        task.resume()
    }
    
    func getSerivcesList(search:String) {
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
            "device_type": "2",
            "fixed_service": "1",
            "page": "all",
            "role": "provider",
            "search": "\(search)",
            "uid": "25273",
            "version": "1.25.8"];

        let get_services_list_withoutkey = "\(BaseUrl)get-services-list-withoutkey"
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
                        self.moreServiceList = try! JSONDecoder().decode(ServiceList.self, from: data!)
                        self.selectedArr.removeAll()
                        for _ in 0..<(self.moreServiceList?.data?.count ?? 0) {
                            self.selectedArr.append(0)
                        }
                        self.tblCategoryList.reloadData()
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




