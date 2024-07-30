//
//  NotificationsCell.swift
//  TapATradie
//
//  Created by mac on 07/03/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit

class NotificationsCell: UITableViewCell {
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDesc: UILabel!
    @IBOutlet weak var imgRead: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
