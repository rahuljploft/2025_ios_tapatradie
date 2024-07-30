//
//  TabBarView.swift
//  TapATradie
//
//  Created by Aman Maharjan on 16/10/2021.
//

import Foundation
import UIKit

struct TabBarItem {
    let title: String
    let image: UIImage
}

class TabBarView: UIView {
    
    static let nibName = "\(TabBarView.self)"
    
    @IBOutlet var view: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBInspectable var selectedItem: Int = 0
    @IBInspectable var showSelection: Bool = true
    
    static let data: [TabBarItem] = [
        TabBarItem(title: "Home", image: #imageLiteral(resourceName: "Home Selected")),
        TabBarItem(title: "Jobs", image: #imageLiteral(resourceName: "Bookings")),
        TabBarItem(title: "Help", image: #imageLiteral(resourceName: "Help")),
        TabBarItem(title: "Profile", image: #imageLiteral(resourceName: "Profile")),
    ]
    //update call 
    override var intrinsicContentSize: CGSize {
        return CGSize(width: self.frame.width, height: 65 + UIApplication.shared.safeAreaInsets.bottom)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    private func commonInit() {
        view = loadViewFromNib(nibName: Self.nibName, frame: self.bounds)
        self.addSubview(view)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.collectionView.register(UINib(nibName: TabBarCell.nibName, bundle: nil), forCellWithReuseIdentifier: TabBarCell.nibName)
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
    }
    
}

extension TabBarView: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Self.data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TabBarCell.nibName, for: indexPath) as! TabBarCell
        
        let item = Self.data[indexPath.row]
        
        if (showSelection && indexPath.row == selectedItem) {
            cell.backgroundColor = UIColor.hexColor(0xFCEDD9)
        }
        else {
            cell.backgroundColor = UIColor.clear
        }
        
        cell.icon.image = item.image
        cell.label.text = item.title
        
        if showSelection && (indexPath.row + 1 == selectedItem || selectedItem == indexPath.row || Self.data.count == (indexPath.row + 1)) {
            cell.border.isHidden = true
        } else {
            cell.border.isHidden = false
        }
        
        return cell
    }
    
}

extension TabBarView: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.frame.size.width / CGFloat(Self.data.count), height: self.frame.size.height - UIApplication.shared.safeAreaInsets.bottom)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}

extension TabBarView: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let navigationController = self.parentViewController?.navigationController
        
        let viewControllers = navigationController?.viewControllers
        for vc in viewControllers! {
            if (vc is Home && indexPath.row == 0) ||
                (vc is MyBookings && indexPath.row == 1) ||
                (vc is Help && indexPath.row == 2) ||
                (vc is MyProfile && indexPath.row == 3) {
                navigationController?.popToViewController(vc, animated: false)
                break
            }
        }
        
        var vc: UIViewController?
        switch indexPath.row {
        case 0:
            vc = story_Home.viewController("Home")
        case 1:
            vc = story_Tradie.viewController("MyBookings")
        case 2:
            vc = story_Home.viewController("Help")
        case 3:
            vc = story_Tradie.viewController("MyProfile")
        default:
            return
        }
        
        navigationController?.pushViewController(vc!, animated: false)
    }
    
}
