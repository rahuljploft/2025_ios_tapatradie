//
//  HowItWork_Screen.swift
//  TapATradie
//
//  Created by MacBook Air on 10/05/22.
//

import UIKit

class HowItWork_Screen: UIViewController {
    
    @IBOutlet weak var View_one: UIView!
    @IBOutlet weak var View_two: UIView!
    @IBOutlet weak var View_three: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        View_one.layer.cornerRadius = View_one.frame.height/2
        View_two.layer.cornerRadius = View_one.frame.height/2
        View_three.layer.cornerRadius = View_one.frame.height/2
    }
    @IBAction func downloadCustomerApp_touchUpInside(_ sender: UIButton) {
        share("Check out the Customer app", "https://apps.apple.com/us/app/tap-a-tradie/id1473400994")
    }
    
    @IBAction func downloadTradieApp_TouchUpInside(_ sender: UIButton) {
        share("Check out the Tradie app", "https://apps.apple.com/us/app/tradie/id1473400813")
    }
    
    func share (_ title: String, _ url: String) {
        if let myWebsite = URL(string: url) {//Enter link to your app here
            let objectsToShare = [title, url, myWebsite] as [Any]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            
            activityVC.popoverPresentationController?.sourceView = self.view
            self.present(activityVC, animated: true, completion: nil)
        }
    }
    
}
