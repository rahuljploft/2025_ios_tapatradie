//
//  NetworkLogger.swift
//  Common
//
//  Created by Aman Maharjan on 30/09/2021.
//

import Foundation
import Alamofire

public class NetworkLogger: EventMonitor {
    public let queue = DispatchQueue(label: "com.tapatradie.common.networklogger")
    
    public func requestDidFinish(_ request: Request) {
        print(request.description)
    }
    
    public func request<Value>(_ request: DataRequest, didParseResponse response: DataResponse<Value, AFError>) {
        guard let data = response.data else {
            return
        }
        if let json = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) {
            print(json)
        }
    }
}
