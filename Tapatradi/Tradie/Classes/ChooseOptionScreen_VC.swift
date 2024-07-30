//
//  ChooseOptionScreen_VC.swift
//  Tradie
//
//  Created by Admin on 29/02/24.
//

import UIKit
import Common

class ChooseOptionScreen_VC: UIViewController {

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func actionTradieLogin(_ sender: UIButton) {
        Config.shared.appRole = "provider"
        UserDefaults.standard.set("provider", forKey: "userRoll")
        let loginViewController = Route.login(model: LoginScreenData(title: UIImage(named: "Login Title")!)).controller as! LoginViewController
        loginViewController.delegate = NavigationManager.shared
        self.navigationController?.pushViewController(loginViewController, animated: true)
    }
    
    @IBAction func actionTapATradieLogin(_ sender: UIButton) {
        Config.shared.appRole = "user"
        UserDefaults.standard.set("user", forKey: "userRoll")
        let loginViewController = Route.login(model: LoginScreenData(title: UIImage(named: "Login Title")!)).controller as! LoginViewController
        loginViewController.delegate = NavigationManager.shared
        self.navigationController?.pushViewController(loginViewController, animated: true)
    }

}
