//
//  Route.swift
//  Common
//
//  Created by Aman Maharjan on 27/09/2021.
//

import Foundation
import UIKit

public enum Route {
    case login(model: LoginScreenData)
    case selectCountry(model: [Country1], delegate: SelectCountryDelegate?)
    
    public var viewControllerName: String {
        switch self {
        case .login:
            return "LoginViewController"
        case .selectCountry:
            return "SelectCountryViewController"
        }
    }
    
    public var storyboardName: String {
        switch self {
        case .login, .selectCountry:
            return "Authentication"
        }
    }
    
    public var controller: UIViewController {
        let bundle = Bundle(for: DummyClass.self)
        let controller = UIStoryboard(name: self.storyboardName, bundle: bundle).instantiateViewController(withIdentifier: viewControllerName)
        
        switch self {
        case .login(let model):
            (controller as! LoginViewController).model = model
        case .selectCountry(let model, let delegate):
            let selectCountryViewController = (controller as! SelectCountryViewController)
            selectCountryViewController.modalPresentationStyle = .overCurrentContext
            selectCountryViewController.model = model
            selectCountryViewController.delegate = delegate
        }
        
        return controller
    }
}
