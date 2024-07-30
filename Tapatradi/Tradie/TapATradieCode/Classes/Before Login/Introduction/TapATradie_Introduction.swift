//
//  Introduction.swift
//  TapATradie
//
//  Created by Apple on 18/04/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import Common

class TapATradie_Introduction: UIViewController {

    override func viewWillAppear(_ animated: Bool) {
        print("Tap A Tradie Intro Screen")
        TapATradie_kAppDelegate.TapATradie_currentVC = self
        TapATradie_NavigationManager.shared.navigationController = self.navigationController
    }
    
    @IBAction func signInButtonTapped(_ sender: Any) {
//        let loginViewController = Route.login(model: LoginScreenData(title: UIImage(named: "Slogan")!)).controller as! LoginViewController
//        loginViewController.delegate = TapATradie_NavigationManager.shared
//        self.navigationController?.pushViewController(loginViewController, animated: true)
        
        let story = UIStoryboard(name: "Authentication", bundle: nil)
        let vc = story.instantiateViewController(withIdentifier: "ChooseOptionScreen_VC") as! ChooseOptionScreen_VC
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
