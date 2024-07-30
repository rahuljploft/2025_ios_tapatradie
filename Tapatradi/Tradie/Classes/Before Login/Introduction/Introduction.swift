//
//  Introduction.swift
//  Tradie
//
//  Created by Apple on 18/04/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import Common

class Introduction: BaseVC, UIScrollViewDelegate {
    
    @IBOutlet weak var btnSignin: UIButton!
    @IBOutlet weak var scrlView: UIScrollView!
    var workItemReferance : DispatchWorkItem? = nil
    
    override func viewWillAppear(_ animated: Bool) {
        kAppDelegate.currentVC = self
        btnSignin.isHidden = true
        print("Tradie Intro Screen")
        NavigationManager.shared.navigationController = self.navigationController
        scrlView.delegate = self
    }
    
    @IBAction func signinButtonTapped(_ sender: Any) {
        self.workItemReferance?.cancel()
        let story = UIStoryboard(name: "Authentication", bundle: nil)
        let vc = story.instantiateViewController(withIdentifier: "ChooseOptionScreen_VC") as! ChooseOptionScreen_VC
        self.navigationController?.pushViewController(vc, animated: true)
        
        
//        let loginViewController = Route.login(model: LoginScreenData(title: UIImage(named: "Login Title")!)).controller as! LoginViewController
//        loginViewController.delegate = NavigationManager.shared
//        self.navigationController?.pushViewController(loginViewController, animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let height = scrlView.frame.size.width
        let contentYoffset = scrlView.contentOffset.x
        let distanceFromBottom = scrlView.contentSize.width - contentYoffset
        btnSignin.isHidden = true
        if distanceFromBottom <= height {
            self.workItemReferance?.cancel()
            let searchWorkItem = DispatchWorkItem {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "ChooseOptionScreen_VC") as! ChooseOptionScreen_VC
                self.navigationController?.pushViewController(vc, animated: true)
//                let loginViewController = Route.login(model: LoginScreenData(title: UIImage(named: "Login Title")!)).controller as! LoginViewController
//                loginViewController.delegate = NavigationManager.shared
//                self.navigationController?.pushViewController(loginViewController, animated: true)
            }
            self.workItemReferance = searchWorkItem
            DispatchQueue.main.asyncAfter(deadline: .now()+3, execute: searchWorkItem)
            
            btnSignin.isHidden = false
        }else{
            btnSignin.isHidden = true
            self.workItemReferance?.cancel()
        }
    }
    
}


