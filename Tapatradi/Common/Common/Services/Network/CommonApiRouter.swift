//
//  NetworkRouter.swift
//  Common
//
//  Created by Aman Maharjan on 04/10/2021.
//

import Foundation
import Alamofire

public protocol ApiRouter {
    var path: String { get }
    var method: HTTPMethod { get }
    var uniqueParameters: [String: String]? { get }
}

public extension ApiRouter {
    
    var baseURL: String {
        return "https://api.tapatradie.com/v6/api/"
        //return "http://3.109.98.222:3349/v6/api"
    }
    
    func commonParameters() -> [String: String] {
        print(Config.shared.appRole)
        var devideID = UIDevice.current.identifierForVendor?.uuidString ?? ""
        if "\(Config.shared.appRole)" == "provider" {
            devideID = "\(devideID)_provider"
        }
        
        print("Common ----- ",[
            "api_key": "$2a$06$hsTL2DeUKS5pUV.YlY/CSuVesppz0ha4hZdcsB7gN8VKRQRBwKct6",
            "device_type": "2",
            "accessType": Config.shared.appRole,
            "device_id": devideID,
            "token": tokenSecret,
            "ip":ipSecret
        ])
        
        return [
            "api_key": "$2a$06$hsTL2DeUKS5pUV.YlY/CSuVesppz0ha4hZdcsB7gN8VKRQRBwKct6",
            "device_type": "2",
            "accessType": Config.shared.appRole,
            "device_id": devideID,
            "token": tokenSecret,
            "ip":ipSecret
        ]
    }
    
    func mergedParameters() -> [String: String] {
        guard let uniqueParameters = uniqueParameters else { return commonParameters() }
        
        var result = commonParameters().merging(uniqueParameters) { (current, _) in current }
        print(result)
        if let acessToken = CommonLocalStorageService.shared.accessToken {
            result["access_token"] = acessToken
        }
        
        return result
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = try baseURL.asURL().appendingPathComponent(path)
        var request = URLRequest(url: url)
        request.method = method
        if method == .get {
            request = try URLEncodedFormParameterEncoder()
                .encode(mergedParameters(), into: request)
        } else if method == .post {
            request = try URLEncodedFormParameterEncoder().encode(mergedParameters(), into: request)
            request.setValue("application/json", forHTTPHeaderField: "Accept")
        }
        return request
    }
    
}

public enum CommonApiRouter: ApiRouter, URLRequestConvertible {
    case generateAccessToken
    case generateOtp(_ phoneCode: String, _ mobile: String)
    
    public var path: String {
        switch self {
        case .generateAccessToken:
            return "genrate-access-tokan"
        case .generateOtp:
            return "user-otp-registration"
        }
    }
    
    public var method: HTTPMethod {
        switch self {
        case .generateAccessToken:
            return .post
        case .generateOtp:
            return .post
        }
    }
    
    public var uniqueParameters: [String: String]? {
        switch self {
        case .generateAccessToken:
            return nil
        case .generateOtp(let phoneCode, let mobile):
            return ["country_code": phoneCode, "phone_number": mobile]
        }
    }
}
