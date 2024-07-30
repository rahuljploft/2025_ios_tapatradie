//
//  SubscriptionListCell.swift
//  Tradie
//
//  Created by Admin on 18/01/23.
//

import UIKit

class SubscriptionListCell: UITableViewCell {

    @IBOutlet weak var lblDueDate: UILabel!
    @IBOutlet weak var viewCard: UIView!
    @IBOutlet weak var imgLogo: UIImageView!
    @IBOutlet weak var viewImage: UIView!
    @IBOutlet weak var lblSubscrptionTitle: UILabel!
    @IBOutlet weak var lblDetail: UILabel!
    @IBOutlet weak var lblAmount: UILabel!
    @IBOutlet weak var lbl_Detail: UILabel!
    @IBOutlet weak var lbl_Detail2: UILabel!
    @IBOutlet weak var viewReadMore: UIView!
    @IBOutlet weak var lbl_DEtailtxt: UILabel!
    @IBOutlet weak var btn_OpenFremium: UIButton!
    @IBOutlet weak var hideCard: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
