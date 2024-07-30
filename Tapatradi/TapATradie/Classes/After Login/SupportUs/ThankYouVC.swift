//
//  ThankYouVC.swift
//  TapATradie
//
//  Created by Sarjan Singh on 24/01/22.
//

import UIKit

protocol ThankyouDelegate: AnyObject{
    func thankyouDismissed()
}

class ThankYouVC: UIViewController {

    
    @IBOutlet weak var btnOk: UIButton!
    @IBOutlet weak var viewThankYou: UIView!
    
    weak var delegate: ThankyouDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        btnOk.layer.cornerRadius = 8
        viewThankYou.layer.cornerRadius = 8
//        viewThankYou.layer.borderColor = 
        
    }
    
    
    
    @IBAction func btnOktapped(_ sender: UIButton) {
        self.dismiss(animated: true) {
            self.delegate?.thankyouDismissed()
        }
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
