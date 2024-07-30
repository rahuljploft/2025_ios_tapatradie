//
//  RequestInterceptor.swift
//  Common
//
//  Created by Aman Maharjan on 30/09/2021.
//

import Foundation
import Alamofire

public class NetworkRequestInterceptor: RequestInterceptor {
    let retryLimit = 5
    let retryDelay: TimeInterval = 10
    
    public func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        let urlRequest = urlRequest
        
        // add headers here using urlRequest, if necessary
        
        completion(.success(urlRequest))
    }
    
    public func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        let response = request.task?.response as? HTTPURLResponse
        //Retry for 5xx status codes
        if
            let statusCode = response?.statusCode,
            (500...599).contains(statusCode),
            request.retryCount < retryLimit {
            completion(.retryWithDelay(retryDelay))
        } else {
            return completion(.doNotRetry)
        }
    }
}

