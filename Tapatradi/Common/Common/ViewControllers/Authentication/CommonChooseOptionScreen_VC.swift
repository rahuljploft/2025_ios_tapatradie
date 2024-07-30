//
//  CommonChooseOptionScreen_VC.swift
//  Common
//
//  Created by Admin on 13/03/24.
//

import UIKit

class CommonChooseOptionScreen_VC: UIViewController {

    public var delegate: LoginViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func actionTradieLogin(_ sender: UIButton) {
        Config.shared.appRole = "provider"
        let loginViewController = Route.login(model: LoginScreenData(title: UIImage(named: "Login Title")!)).controller as! LoginViewController
        loginViewController.delegate = delegate
        self.navigationController?.pushViewController(loginViewController, animated: true)
    }
    
    @IBAction func actionTapATradieLogin(_ sender: UIButton) {
        Config.shared.appRole = "user"
        let loginViewController = Route.login(model: LoginScreenData(title: UIImage(named: "Login Title")!)).controller as! LoginViewController
        loginViewController.delegate = delegate
        self.navigationController?.pushViewController(loginViewController, animated: true)
    }

}
