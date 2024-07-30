//
//  NewLeadsCell_CVC.swift
//  Common
//
//  Created by Admin on 20/02/23.
//

import UIKit

class NewLeadsCell_CVC: UITableViewCell {
    
    @IBOutlet weak var viewCommonInfo: UIView!
    
    @IBOutlet weak var viewJobDetail: UIView!
    @IBOutlet weak var img_Profile: UIImageView!
    
    @IBOutlet weak var viewBlurImg: UIView!
    
    
    @IBOutlet weak var lbl_JobStatus: BlurredLabel!
    @IBOutlet weak var lbl_SenderName: BlurredLabel!
    @IBOutlet weak var lbl_Date: BlurredLabel!
    @IBOutlet weak var lbl_Address: BlurredLabel!
    
    @IBOutlet weak var lbl_JobTitle: UILabel!
    @IBOutlet weak var lbl_ServiceRequired: UILabel!
    @IBOutlet weak var lbl_ServiceType: UILabel!
    @IBOutlet weak var lbl_Detail: UILabel!
    
    @IBOutlet weak var btnAccept: UIButton!
    @IBOutlet weak var btnDecline: UIButton!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func updateCell() {
        btnAccept.clipsToBounds = true
        btnAccept.layer.cornerRadius = 5
        btnDecline.clipsToBounds = true
        btnDecline.layer.cornerRadius = 5

        //lbl_JobStatus.clipsToBounds = false
        lbl_JobStatus.blur()
        
        //lbl_SenderName.clipsToBounds = false
        lbl_SenderName.blur()
        
        //lbl_Date.clipsToBounds = false
        lbl_Date.blur()
        
        //lbl_Address.clipsToBounds = false
        lbl_Address.blur()   
    }
    
}
