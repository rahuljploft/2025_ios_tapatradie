//
//  ReciverImageMessageCell_TVC.swift
//  TapATradie
//
//  Created by Admin on 01/03/23.
//

import UIKit

class TapATradie_ReciverImageMessageCell_TVC: UITableViewCell {

    @IBOutlet weak var viewProfile: UIView!
    @IBOutlet weak var msgView: UIView!
    
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var imgMessage: UIImageView!
    @IBOutlet weak var lbl_ReciverName: UILabel!
    @IBOutlet weak var lbl_date: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    func updateCell() {
        msgView.clipsToBounds = true
        msgView.layer.maskedCorners = [.layerMaxXMaxYCorner,.layerMaxXMinYCorner,.layerMinXMinYCorner]
        msgView.layer.cornerRadius = 12
        
        
        imgMessage.clipsToBounds = true
        imgMessage.layer.maskedCorners = [.layerMaxXMaxYCorner,.layerMaxXMinYCorner,.layerMinXMinYCorner]
        imgMessage.layer.cornerRadius = 12
        
        viewProfile.clipsToBounds = true
        viewProfile.layer.cornerRadius = viewProfile.frame.height/2
    }
    
}
