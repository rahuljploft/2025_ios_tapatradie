//
//  InviteFriends.swift
//  TapATradie
//
//  Created by mac on 17/07/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class InviteFriends: UIViewController {

    @IBOutlet weak var lblSiteUrl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
