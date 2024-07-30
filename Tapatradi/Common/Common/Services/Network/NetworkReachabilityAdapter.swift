//
//  NetworkReachabilityAdapter.swift
//  Common
//
//  Created by Aman Maharjan on 30/09/2021.
//

import Foundation
import Alamofire

public protocol NetworkReachabilityAdapterProtocol {
    @discardableResult
    func startListening(onUpdatePerforming listener: @escaping NetworkReachabilityManager.Listener) -> Bool?
}

public class NetworkReachabilityAdapter: NetworkReachabilityAdapterProtocol {
    
    public static var shared = NetworkReachabilityAdapter()
    
    private let reachabilityManager = NetworkReachabilityManager(host: "www.google.com")
    
    private init() { }
    
    @discardableResult
    public func startListening(onUpdatePerforming listener: @escaping NetworkReachabilityManager.Listener) -> Bool? {
        reachabilityManager?.startListening(onUpdatePerforming: listener)
    }
    
}
