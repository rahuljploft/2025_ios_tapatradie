//
//  NetworkReachabilityService.swift
//  Common
//
//  Created by Aman Maharjan on 30/09/2021.
//

import Foundation
import UIKit
import Alamofire

public class NetworkReachabilityService {
    
    public static let shared = NetworkReachabilityService()
    
    public let reachabilityAdapter: NetworkReachabilityAdapterProtocol = NetworkReachabilityAdapter.shared
    
    let offlineAlertController: UIAlertController = {
        UIAlertController(title: "No Network", message: "Please connect to network and try again", preferredStyle: .alert)
    }()
    
    public func startNetworkMonitoring() {
        reachabilityAdapter.startListening { status in
            switch status {
            case .notReachable:
                print("Network not reachable")
                self.showOfflineAlert()
            case .reachable(.cellular), .reachable(.ethernetOrWiFi):
                print("Network reachable (culllar, ethernet or wifi)")
                self.dismissOfflineAlert()
            case .unknown:
                print("Unknown network state")
            }
        }
    }
    
    public func showOfflineAlert() {
        UIApplication.shared.rootViewController?.present(offlineAlertController, animated: true, completion: nil)
    }
    
    public func dismissOfflineAlert() {
        UIApplication.shared.rootViewController?.dismiss(animated: true, completion: nil)
    }
}
