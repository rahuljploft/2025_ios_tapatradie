//
//  CountryList_TVC.swift
//  Common
//
//  Created by Admin on 15/03/22.
//

import UIKit

class CountryList_TVC: UITableViewCell {

    @IBOutlet weak var lbl_CountryName: UILabel!
    @IBOutlet weak var lbl_CountryCode: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
