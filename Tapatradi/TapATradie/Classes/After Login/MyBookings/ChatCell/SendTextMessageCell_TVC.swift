//
//  SendTextMessageCell_TVC.swift
//  TapATradie
//
//  Created by Admin on 01/03/23.
//

import UIKit

class SendTextMessageCell_TVC: UITableViewCell {

    @IBOutlet weak var viewProfile: UIView!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var msgView: UIView!
    
    @IBOutlet weak var lbl_SenderName: UILabel!
    @IBOutlet weak var lbl_Message: UILabel!
    @IBOutlet weak var lbl_date: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateCell() {
        msgView.clipsToBounds = true
        msgView.layer.maskedCorners = [.layerMinXMaxYCorner,.layerMaxXMinYCorner,.layerMinXMinYCorner]
        msgView.layer.cornerRadius = 12
        
        viewProfile.clipsToBounds = true
        viewProfile.layer.cornerRadius = viewProfile.frame.height/2
    }
    
}
