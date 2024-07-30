//
//  ViewController.swift
//  TapATradie
//
//  Created by Apple on 18/04/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.view.backgroundColor = UIColor.blue
    }

    override func viewWillAppear(_ animated: Bool) {
        kAppDelegate.currentVC = self
    }

}

