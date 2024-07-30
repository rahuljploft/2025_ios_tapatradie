//
//  StoreToDevice.swift
//  HarishFrameworkSwift4
//
//  Created by Harish on 17/11/17.
//  Copyright © 2017 Harish. All rights reserved.
//

import UIKit
let keyChainItemWrapperIdentifier = "KeyChainItemWrapper_Identifier"
public class StoreToDevice: NSObject {
    var service = "password1"
    var account = "password2"
    
    init(_ service: String, _ account: String) {
        self.service = service
        self.account = account
        
        StoreToDevice.obb = KeychainPasswordItem(service: self.service, account: self.account)
    }
  
    static var obb: KeychainPasswordItem!//(service: self.service, account: self.account)

//    static let obb = KeychainPasswordItem(service: self.service, account: self.account)
    
    public func setDeviceStoredData (_ data: String) {
        do {
            try StoreToDevice.obb.savePassword(data)
        } catch {
        }
    }
    public func getStoredData () -> String? {
        do {
            return try StoreToDevice.obb.readPassword()
        } catch { }
        return nil
    }
}
