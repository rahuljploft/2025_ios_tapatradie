//
//  CategoryCell_TVC.swift
//  Common
//
//  Created by Admin on 19/02/23.
//

import UIKit

class CategoryCell_TVC: UITableViewCell {

    @IBOutlet weak var ImgCheck: UIImageView!
    @IBOutlet weak var lbl_Title: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
