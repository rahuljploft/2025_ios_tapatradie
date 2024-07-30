//
//  SelectLocationCell.swift
//  TapATradie
//
//  Created by Apple on 22/04/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
protocol SelectLocationCellDelegate {
    func select(_ indexPath: IndexPath)
}

class SelectLocationCell: UITableViewCell {

    var indexPath: IndexPath!
    var delegate: SelectLocationCellDelegate!
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func actionSelected(_ sender: Any) {
        delegate.select(indexPath)
    }
}
