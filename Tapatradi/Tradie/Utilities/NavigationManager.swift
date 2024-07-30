//
//  NavigationManager.swift
//  Tradie
//
//  Created by Aman Maharjan on 07/10/2021.
//

import Foundation
import Common
import UIKit

public class NavigationManager {
    
    public static var shared = NavigationManager()
    
    private init() { }
    
    public var navigationController: UINavigationController?
}

extension NavigationManager: LoginViewControllerDelegate {
    public func otpGenerated(userId: Int, phoneCode: String, mobile: String, code: Int, serviceIdTr: String?, latitudeValNewTr: String?, longitudeValNewTr: String?, leadTypeTr: String?, addressValNewTr: String?) {
        print("inside navigation manager")
        // TODO: refactor later
        let vc = story_Auth.viewController("MobileVerification") as! MobileVerification
        vc.uid = String(userId)
        vc.countryCode = phoneCode
        vc.mobileNumber = mobile
        vc.otp = String(code)
        
        
        serviceIdTradi = serviceIdTr ?? ""
        latitudeValNewTradi = latitudeValNewTr ?? ""
        longitudeValNewTradi = longitudeValNewTr ?? ""
        leadTypeTradi = leadTypeTr ?? ""
        addressValNewTradi = addressValNewTr ?? ""
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK: New Change For Code Combine
    public func otpGenerated_TapATradie(userId: Int, phoneCode: String, mobile: String, code: Int, serviceIdTr: String?, latitudeValNewTr: String?, longitudeValNewTr: String?, leadTypeTr: String?, addressValNewTr: String?) {
        assert(navigationController != nil)
        print("inside navigation manager")
        // TODO: refactor later
        let vc = TapATradie_story_Auth.viewController("MobileVerification") as! TapATradie_MobileVerification
        vc.uid = String(userId)
        vc.countryCode = phoneCode
        vc.mobileNumber = mobile
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    public func otpGenerated_TapATradie(userId: Int, phoneCode: String, mobile: String, code: Int) {
        assert(navigationController != nil)
        print("inside navigation manager")
        // TODO: refactor later
        let vc = story_Auth.viewController("MobileVerification") as! TapATradie_MobileVerification
        vc.uid = String(userId)
        vc.countryCode = phoneCode
        vc.mobileNumber = mobile
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
