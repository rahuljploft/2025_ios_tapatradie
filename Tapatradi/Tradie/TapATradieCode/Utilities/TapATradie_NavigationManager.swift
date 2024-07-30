//
//  NavigationManager.swift
//  TapATradie
//
//  Created by Aman Maharjan on 06/10/2021.
//

import Foundation
import Common
import UIKit

public class TapATradie_NavigationManager {
    
    public static var shared = TapATradie_NavigationManager()
    
    private init() { }
    
    public var navigationController: UINavigationController?
}

extension TapATradie_NavigationManager: LoginViewControllerDelegate {
    
    
    public func otpGenerated_TapATradie(userId: Int, phoneCode: String, mobile: String, code: Int, serviceIdTr: String?, latitudeValNewTr: String?, longitudeValNewTr: String?, leadTypeTr: String?, addressValNewTr: String?) {
        print("Tap A Tradie")
    }
    
    public func otpGenerated(userId: Int, phoneCode: String, mobile: String, code: Int, serviceIdTr: String?, latitudeValNewTr: String?, longitudeValNewTr: String?, leadTypeTr: String?, addressValNewTr: String?) {
        assert(navigationController != nil)
        print("inside navigation manager")
        // TODO: refactor later
        let vc = TapATradie_story_Auth.TapATradie_viewController("MobileVerification") as! TapATradie_MobileVerification
        vc.uid = String(userId)
        vc.countryCode = phoneCode
        vc.mobileNumber = mobile
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    public func otpGenerated(userId: Int, phoneCode: String, mobile: String, code: Int) {
        assert(navigationController != nil)
        print("inside navigation manager")
        // TODO: refactor later
        let vc = TapATradie_story_Auth.TapATradie_viewController("MobileVerification") as! TapATradie_MobileVerification
        vc.uid = String(userId)
        vc.countryCode = phoneCode
        vc.mobileNumber = mobile
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
