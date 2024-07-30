//
//  CommonApiService.swift
//  Common
//
//  Created by Aman Maharjan on 05/10/2021.
//

import Foundation
import Alamofire

var tokenSecret = ""
var ipSecret = ""

open class CommonApiService {
    static let shared = CommonApiService()
    
    let sessionManager: Session = {
        let configuration = URLSessionConfiguration.af.default
        configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
        let networkLogger = NetworkLogger()
        let interceptor = NetworkRequestInterceptor()
        
        return Session(
            configuration: configuration,
            interceptor: interceptor,
            cachedResponseHandler: nil,
            eventMonitors: [networkLogger])
    }()
    
    func generateAccessToken(completion: @escaping (AccessToken_Internal) -> Void) {
        sessionManager.request(CommonApiRouter.generateAccessToken)
            .responseDecodable(of: AccessToken_Internal.self) { response in
                guard let accessToken = response.value else { return }
                completion(accessToken)
            }
    }
    
    func generateOtp(_ phoneCode: String, _ mobile: String, completion: @escaping (Otp) -> Void) {
        sessionManager.request(CommonApiRouter.generateOtp(phoneCode, mobile))
            .responseDecodable(of: Otp.self) { response in
                guard let otp = response.value else { return }
                completion(otp)
            }
    }
}

