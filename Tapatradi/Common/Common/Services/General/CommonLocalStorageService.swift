//
//  LocalStorage.swift
//  Common
//
//  Created by Aman Maharjan on 29/09/2021.
//

import Foundation
import Alamofire

public class LocalStorageService {
        
    private let storage = UserDefaults.standard
    
    init() { }
    
    public func getObject(for key: String) -> Any? {
        return storage.object(forKey: key)
    }
    
    public func set(_ value: String, for key: String) {
        storage.set(value, forKey: key)
        storage.synchronize()
    }
    
    public func removeObject(for key: String) {
        storage.removeObject(forKey: key)
        storage.synchronize()
    }
}

public class CommonLocalStorageService: LocalStorageService {
    
    public static var shared = CommonLocalStorageService()
    
    private override init() { super.init() }
    
    private enum Key: String {
        case introductionComplete = "Key_Introduction"
        case accessToken = "access-token"
    }
    
    public var introductionComplete: Bool? {
        get {
            let value = getObject(for: Key.introductionComplete.rawValue) as? String
            guard let value = value else { return false }
            return value == "1"
        }
        set {
            guard let newValue = newValue, newValue == true else {
                removeObject(for: Key.introductionComplete.rawValue)
                return
            }
            set("1", for: Key.introductionComplete.rawValue)
        }
    }
    
    public var accessToken: String? {
        get {
            return getObject(for: Key.accessToken.rawValue) as? String
        }
        set {
            guard let newValue = newValue else {
                removeObject(for: Key.accessToken.rawValue)
                return
            }
            set(newValue, for: Key.accessToken.rawValue)
        }
    }
}
