//
//  Introduction.swift
//  TapATradie
//
//  Created by Apple on 18/04/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import Common

class Introduction: UIViewController {

    override func viewWillAppear(_ animated: Bool) {
        print("Tap A Tradie Intro Screen")
        kAppDelegate.currentVC = self
        NavigationManager.shared.navigationController = self.navigationController
    }
    
    @IBAction func signInButtonTapped(_ sender: Any) {
        let loginViewController = Route.login(model: LoginScreenData(title: UIImage(named: "Slogan")!)).controller as! LoginViewController
        loginViewController.delegate = NavigationManager.shared
        self.navigationController?.pushViewController(loginViewController, animated: true)
    }
}
