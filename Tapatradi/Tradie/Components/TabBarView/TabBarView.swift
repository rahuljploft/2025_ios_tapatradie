//
//  TabBarView.swift
//  TapATradie
//
//  Created by Aman Maharjan on 16/10/2021.
//

import Foundation
import UIKit
import Common

var isFeb = 0
var subscriptionStatus = false
var paymentSettingStatus = true
var cancelStatusVal = ""

var imgPrem = "Premium"
var titlePrem = "Premium"

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
    
    var isTabBarHidden = false
    
    static var data: [TabBarItem] = [
        TabBarItem(title: "Profile", image: #imageLiteral(resourceName: "Profile")),
        TabBarItem(title: "New Leads", image: #imageLiteral(resourceName: "New Leads")),
        TabBarItem(title: "History", image: #imageLiteral(resourceName: "History")),
        //MARK: InAppPurchase - (Comment Help and Show Premium for In App Screen)
        
        //TabBarItem(title: "Help", image: #imageLiteral(resourceName: "Customer Support")),
        TabBarItem(title: "\(titlePrem)", image: UIImage(named: "\(imgPrem)")!),
    ]
    
    static let TapATradie_data: [TabBarItem] = [
        TabBarItem(title: "Home", image: #imageLiteral(resourceName: "Home Selected")),
        TabBarItem(title: "Jobs", image: #imageLiteral(resourceName: "Bookings")),
        TabBarItem(title: "Help", image: #imageLiteral(resourceName: "Help")),
        TabBarItem(title: "Profile", image: #imageLiteral(resourceName: "Profile")),
    ]

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
        
        DispatchQueue.main.asyncAfter(deadline: .now()+1, execute: {
            print("paymentSettingStatus",paymentSettingStatus)
            if paymentSettingStatus == false {
                TabBarView.data = [
                    TabBarItem(title: "Profile", image: #imageLiteral(resourceName: "Profile")),
                    TabBarItem(title: "New Leads", image: #imageLiteral(resourceName: "New Leads")),
                    TabBarItem(title: "History", image: #imageLiteral(resourceName: "History")),
                    //MARK: InAppPurchase - (Comment Help and Show Premium for In App Screen)
                    
                    //TabBarItem(title: "Help", image: #imageLiteral(resourceName: "Customer Support")),
                    TabBarItem(title: "Help", image: UIImage(named: "Customer Support")!),
                ]
            }else{
                TabBarView.data = [
                    TabBarItem(title: "Profile", image: #imageLiteral(resourceName: "Profile")),
                    TabBarItem(title: "New Leads", image: #imageLiteral(resourceName: "New Leads")),
                    TabBarItem(title: "History", image: #imageLiteral(resourceName: "History")),
                    //MARK: InAppPurchase - (Comment Help and Show Premium for In App Screen)
                    
                    //TabBarItem(title: "Help", image: #imageLiteral(resourceName: "Customer Support")),
                    TabBarItem(title: "Premium", image: UIImage(named: "Premium")!),
                ]
            }
            self.collectionView.reloadData()
        })
    }
    
}

extension TabBarView: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (Config.shared.appRole == "provider") ? Self.data.count : Self.TapATradie_data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if (Config.shared.appRole == "provider") {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TabBarCell.nibName, for: indexPath) as! TabBarCell
            let item = Self.data[indexPath.row]
            if (showSelection && indexPath.row == selectedItem) {
                cell.backgroundColor = UIColor.hexColor(0xFCEDD9)
            } else {
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
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TabBarCell.nibName, for: indexPath) as! TabBarCell
            let item = Self.TapATradie_data[indexPath.row]
            if (showSelection && indexPath.row == selectedItem) {
                cell.backgroundColor = UIColor.TapATradie_hexColor(0xFCEDD9)
            }
            else {
                cell.backgroundColor = UIColor.clear
            }
            cell.icon.image = item.image
            cell.label.text = item.title
            if showSelection && (indexPath.row + 1 == selectedItem || selectedItem == indexPath.row || Self.TapATradie_data.count == (indexPath.row + 1)) {
                cell.border.isHidden = true
            } else {
                cell.border.isHidden = false
            }
            return cell
        }
    }
    
}

extension TabBarView: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if (Config.shared.appRole == "provider") {
            if (self.frame.size.height - UIApplication.shared.safeAreaInsets.bottom)
                > 0 && (self.frame.size.width / CGFloat(Self.data.count)) > 0 {
                return CGSize(width: self.frame.size.width / CGFloat(Self.data.count), height: self.frame.size.height - UIApplication.shared.safeAreaInsets.bottom)
            }else{
                return CGSize(width: 0, height: 0)
            }
        }else{
            return CGSize(width: self.frame.size.width / CGFloat(Self.TapATradie_data.count), height: self.frame.size.height - UIApplication.shared.safeAreaInsets.bottom)
        }
       
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}

extension TabBarView: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if (Config.shared.appRole == "provider") {
            let navigationController = self.parentViewController?.navigationController
            if let viewControllers = navigationController?.viewControllers {
                for vc in viewControllers {
                    if subscriptionStatus == true {
                        if (vc is Profile && indexPath.row == 0) ||
                            (vc is MyBookings && indexPath.row == 1) ||
                            (vc is MyBookings && indexPath.row == 2) ||
                            (vc is ChooseSubscripiton && indexPath.row == 3) {
                            navigationController?.popToViewController(vc, animated: false)
                            break
                        }
                    }else{
                        if (vc is Profile && indexPath.row == 0) ||
                            (vc is MyBookings && indexPath.row == 1) ||
                            (vc is MyBookings && indexPath.row == 2) ||
                            (vc is PaymentScreenVC && indexPath.row == 3) {
                            navigationController?.popToViewController(vc, animated: false)
                            break
                        }
                    }
                }
            }
            var vc: UIViewController?
            switch indexPath.row {
            case 0:
                vc = story_Profile.viewController("Profile")
            case 1:
                vc = story_Tradie.viewController("MyBookings")
                (vc as! MyBookings).boolCurrent = true
            case 2:
                vc = story_Tradie.viewController("MyBookings")
                (vc as! MyBookings).boolCurrent = false
            case 3:
                if paymentSettingStatus == false {
                    vc = story_Home.viewController("Help")
                }else{
                    //MARK: InAppPurchase - (Comment Help and Show Premium for In App Screen) - Himanshu Jangid
                    if isFeb == 0 {
                        if subscriptionStatus == true {
                            vc = story_Payment.viewController("ChooseSubscripiton")
                        }else{
                            vc = story_Home.viewController("PaymentScreenVC")
                        }
                    }else{
                        if subscriptionStatus == true {
                            vc = story_Payment.viewController("ChooseSubscripiton")
                        }else{
                            vc = story_Home.viewController("PaymentScreenVC")
                        }
                        //vc = story_Home.viewController("PaymentScreenVC")
                    }
                    //vc = story_Home.viewController("Help")
                    //vc = story_Payment.viewController("ChooseSubscripiton")
                }
            default:
                return
            }
            navigationController?.pushViewController(vc!, animated: false)
        }else{
            let navigationController = self.parentViewController?.navigationController
            let viewControllers = navigationController?.viewControllers
            for vc in viewControllers! {
                if (vc is TapATradie_Home && indexPath.row == 0) ||
                    (vc is TapATradie_MyBookings && indexPath.row == 1) ||
                    (vc is TapATradie_Help && indexPath.row == 2) ||
                    (vc is TapATradie_MyProfile && indexPath.row == 3) {
                    navigationController?.popToViewController(vc, animated: false)
                    break
                }
            }
            var vc: UIViewController?
            switch indexPath.row {
            case 0:
                vc = TapATradie_story_Home.TapATradie_viewController("Home")
            case 1:
                vc = TapATradie_story_Tradie.TapATradie_viewController("MyBookings")
            case 2:
                vc = TapATradie_story_Home.TapATradie_viewController("Help")
            case 3:
                vc = TapATradie_story_Tradie.TapATradie_viewController("MyProfile")
            default:
                return
            }
            navigationController?.pushViewController(vc!, animated: false)
        }
    }
    
    
    
}
