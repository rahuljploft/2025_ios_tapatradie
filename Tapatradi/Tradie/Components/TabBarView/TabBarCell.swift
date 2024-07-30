//
//  TabBarCollectionViewCell.swift
//  TapATradie
//
//  Created by Aman Maharjan on 16/10/2021.
//

import UIKit

class TabBarCell: UICollectionViewCell {
    
    static let nibName = "\(TabBarCell.self)"

    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var border: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

}
