//
//  AlertView.swift
//  Borobear
//
//  Created by mac on 28/09/19.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit

extension AlertView: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
        }
        
        return true
    }
}

class AlertView: UIView {
    
    @IBOutlet weak var viewBG: UIView!
    
    @IBOutlet weak var lblTitle: UILabel!
    
    @IBOutlet weak var tvMessage: UITextView!
    
    var onResult : ((String?)-> Void)!
    
    static let instance = AlertView.initLoader()
    class func initLoader() -> AlertView {
        return UINib(nibName: "AlertView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! AlertView
    }
    
    override func awakeFromNib() {
        self.backgroundColor = UIColor.black.withAlphaComponent(0.3)
    }
    
    func present(_ title: String, _ message:String, onCompletion: @escaping (String?) -> Void) {
        UIApplication.shared.keyWindow?.rootViewController?.view.addSubview(self)
                
        self.onResult = onCompletion
        
        self.frame = UIScreen.main.bounds
        
        displayUIview()
        
        lblTitle.text = title
        tvMessage.text = message
        
        self.layoutIfNeeded()
    }
    
    @IBAction func actionSendReceiptToServer(_ sender: Any) {
        //remove()
        onResult("actionSendReceiptToServer")
    }
    
    @IBAction func actionRemoveView(_ sender: Any) {
        remove()
    }
    
    @IBAction func btnCancel(_ sender: UIButton) {
        remove()
        onResult("btnCancel")
    }
    
    func remove(){
        UIView.animate(withDuration: 0.3, animations: {
            self.viewBG.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        }) { (true) in
            self.removeFromSuperview()
        }
    }
    
    func displayUIview() {
        self.viewBG.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.viewBG.alpha = 0
        
        UIView.animate(withDuration: 0.3, animations: {
            self.viewBG.alpha = 1
            self.viewBG.transform = CGAffineTransform(scaleX: 1, y: 1)
        })
    }
}
