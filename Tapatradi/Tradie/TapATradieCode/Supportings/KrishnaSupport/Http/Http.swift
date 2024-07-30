//
//  Http.swift
//  SupportingProject
//
//  Created by Harish on 16/01/18.
//  Copyright © 2018 Harish. All rights reserved.
//
import UIKit
let kCouldnotconnect = "Could not connect to the server. Please try again later."
let kInternetNotAvailable = "Please establish network connection."
open class Http: NSObject {
    open class func instance () -> Http {
        return Http()
    }
    public func json (_ api: String?,
                      _ params: NSMutableDictionary?,
                      _ method: String?,
                      aai: Bool,
                      popup: Bool,
                      prnt: Bool,
                      _ header: NSDictionary?,
                      _ images: NSMutableArray?,
                      sync: Bool,
                      defaultCalling: Bool,
                      completionHandler: @escaping (Any?, NSMutableDictionary?, String, HTTPURLResponse?, Data?) -> Swift.Void) {
        let httpParams = HttpParams(api)
        httpParams.api = api
        httpParams.params = params
        httpParams.method = method
        httpParams.aai = aai
        httpParams.popup = popup
        httpParams.prnt = prnt
        httpParams.header = header
        httpParams.images = images
        httpParams.sync = sync
        httpParams.defaultCalling = defaultCalling
        self.jsonWithParamObject(httpParams) { (httpResourse) in
            completionHandler(httpResourse?.json, httpResourse?.params,
                              (httpResourse?.jsonString)!, httpResourse?.response, httpResourse?.data)
        }
    }
    public func json (_ api: String?,
                      _ params: NSMutableDictionary?,
                      _ method: String?,
                      aai: Bool,
                      popup: Bool,
                      prnt: Bool,
                      _ header: NSDictionary?,
                      _ images: NSMutableArray?,
                      sync: Bool,
                      defaultCalling: Bool,
                      completionHandler: @escaping (Any?, NSMutableDictionary?, String, Data?) -> Swift.Void) {
        let httpParams = HttpParams(api)
        httpParams.api = api
        httpParams.params = params
        httpParams.method = method
        httpParams.aai = aai
        httpParams.popup = popup
        httpParams.prnt = prnt
        httpParams.header = header
        httpParams.images = images
        httpParams.sync = sync
        self.jsonWithParamObject(httpParams) { (httpResourse) in
            completionHandler(httpResourse?.json, httpResourse?.params, (httpResourse?.jsonString)!, httpResourse?.data)
        }
    }
    func sessionConfig () -> URLSessionConfiguration {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 180.0
        config.timeoutIntervalForResource = 180.0
        config.requestCachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        return config
    }
    public func jsonWithParamObject (_ httpParams: HttpParams, completionHandler: @escaping (HttpResponse?) -> Swift.Void) {
//        let reach = ReachabilityKrishna.init(hostname: "google.com")
//        if (reach?.isReachable)! {
            if httpParams.aai {
                startActivityIndicator()
            }
            let request = makeDecision (httpParams)
            addHeader (request, httpParams)
            startSession(request, httpParams, completionHandler)
//        } else {
//            if httpParams.aai {
//                stopActivityIndicator()
//            }
//            if httpParams.popup {
//                alert("Network message!", kInternetNotAvailable)
//            }
//            let httpResponse = HttpResponse(nil)
//            httpResponse.params = httpParams.params
//            completionHandler (httpResponse)
//        }
    }
    func makeDecision (_ httpParams: HttpParams) -> NSMutableURLRequest {
        var request = NSMutableURLRequest(url:
            NSURL(string: (httpParams.api!.addingPercentEncoding(
                withAllowedCharacters: .urlQueryAllowed)!))! as URL)
        if httpParams.method == "GET" && httpParams.params != nil {
            var url = httpParams.api! + "?"
            for (key, value) in httpParams.params! {
                url += "\((key as? String)!)=\(value)&"
            }
            request = NSMutableURLRequest(url:
                NSURL(string: (url.addingPercentEncoding(withAllowedCharacters:
                    .urlQueryAllowed)!))! as URL)
        } else if httpParams.method == "POST" {
            request.httpMethod = httpParams.method!
            //httpParams.defaultCalling = true
            
            var data: Data! = Data()
            do {
                if httpParams.params == nil {
                    data = try JSONSerialization.data(withJSONObject: [],
                                                      options: [])
                    request.httpBody = data
                } else if httpParams.method == "POST" {
                    defaultCallingTrue(request, httpParams)
                    
                    /*if httpParams.defaultCalling {
                        defaultCallingTrue(request, httpParams)
                    } else {
                        defaultCallingFalse(request, httpParams, data)
                    }*/
                }
            } catch {
                if httpParams.aai {
                    stopActivityIndicator()
                }
                print("JSON serialization failed:  \(error)")
            }
            if httpParams.defaultCalling {
                request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
                request.addValue("application/json", forHTTPHeaderField: "Accept")
                request.addValue("\(data.count)", forHTTPHeaderField: "Content-Length")
            }
        } else if httpParams.method == nil || httpParams.params == nil || httpParams.method == "GET" {
        }
        return request
    }
    func addHeader (_ request: NSMutableURLRequest, _ httpParams: HttpParams) {
        if httpParams.header != nil {
            if (httpParams.header?.count)! > 0 {
                for (key, _) in httpParams.header! {
                    request.setValue(httpParams.header?.object(forKey: key) as? String, forHTTPHeaderField: "\(key)")
                }
            }
        }
    }
    func startSession(_ request: NSMutableURLRequest, _ httpParams: HttpParams,
                      _ completionHandler: @escaping (HttpResponse?) -> Swift.Void) {
        let config = sessionConfig ()
        let session = URLSession(configuration: config)
        var semaphore: DispatchSemaphore!
        if httpParams.sync {
            semaphore = DispatchSemaphore(value: 0)
        }
        let task = session.dataTask(with: request as URLRequest, completionHandler: {(data, response, error) in
            let httpObject = HttpObject(completionHandler)
            httpObject.completionHandler = completionHandler
            httpObject.data = data
            httpObject.response = response
            httpObject.error = error
            httpObject.api = httpParams.api
            httpObject.params = httpParams.params
            httpObject.aai = httpParams.aai
            httpObject.popup = httpParams.popup
            httpObject.prnt = httpParams.prnt
            if error != nil {
                if httpParams.aai {
                    self.stopActivityIndicator()
                }
            }
            if httpParams.sync {
                semaphore.signal()
                self.jsonThread(httpObject)
            } else {
                DispatchQueue.global().async {
                    self.jsonThread(httpObject)
                }
            }
        })
        task.resume()
        if httpParams.sync {
            _ = semaphore.wait(timeout: .distantFuture)
        }
    }
    func defaultCallingTrue(_ request: NSMutableURLRequest, _ httpParams: HttpParams) {
        
        let para = httpParams.params as? [String: Any]
        
        if httpParams.images != nil {
            let boundary = generateBoundaryString()
            
            let data = NSMutableData()
            
            request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

            for (key, value) in para! {
                data.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
                data.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".data(using: String.Encoding.utf8)!)
                data.append("\(value)\r\n".data(using: String.Encoding.utf8)!)
            }
            
            let filename = "user-profile.jpg"
            
            for iii in 0..<(httpParams.images?.count)! {
                let mdd = (httpParams.images?[iii] as? NSMutableDictionary)!
                let param = (mdd["param"] as? String)!
                let image = (mdd["image"] as? UIImage)!
                
                ///let imageData = image.jpegData(compressionQuality: 1)//pngData()
                let imageData = image.resize(300).jpegData(compressionQuality: 1.0)
                
                data.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
                data.append("Content-Disposition: form-data; name=\"\(param)\"; filename=\"\(filename)\"\r\n".data(using: String.Encoding.utf8)!)
                data.append("Content-Type: application/octet-stream\r\n\r\n".data(using: String.Encoding.utf8)!)
                data.append(imageData!)
                data.append("\r\n".data(using: String.Encoding.utf8)!)
                data.append("--\(boundary)--\r\n".data(using: String.Encoding.utf8)!)
            }
            
            request.httpBody = data as Data
        } else {
            request.httpBody = para!.percentEscaped().data(using: .utf8)
        }
    }
    
    func defaultCallingFalse(_ request: NSMutableURLRequest, _ httpParams: HttpParams, _ data: Data) {
        let boundary = generateBoundaryString()
        request.setValue("multipart/form-data; boundary=\(boundary)",
            forHTTPHeaderField: "Content-Type")
        let newParams = NSMutableDictionary()
        for (key, value) in httpParams.params! {
            //newParams.setValue(value, forKey: (key as? String)!)
            //newParams.setValue(value, forKey: key as! String)
            newParams.setValue(value, forKey: key as! String)
        }
        var data = data
        
        if httpParams.images != nil {
            for iii in 0..<(httpParams.images?.count)! {
                let mdd = (httpParams.images?[iii] as? NSMutableDictionary)!
                let param = (mdd["param"] as? String)!
                let image = (mdd["image"] as? UIImage)!
                
                //let imageData = image.pngData()
                let imageData = image.resize(300).jpegData(compressionQuality: 1.0)
                
                print("image-\(param)-\(image)-\(String(describing: imageData!.count/(8*1024)))-")
                let fname = "test\(iii).png"
                data.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
                data.append(
                    "Content-Disposition: form-data; name=\"\(param)\"; filename=\"\(fname)\"\r\n"
                        .data(using: String.Encoding.utf8)!)
                data.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
                data.append("Content-Type: application/octet-stream\r\n\r\n"
                    .data(using: String.Encoding.utf8)!)
                data.append(imageData!)
                data.append("\r\n".data(using: String.Encoding.utf8)!)
                data.append("--\(boundary)--\r\n".data(using: String.Encoding.utf8)!)
            }
        }
        
        data.append("\r\n--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
        
        for (key, value) in newParams {
            data.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n"
                .data(using: String.Encoding.utf8)!)
            data.append("\(value)".data(using: String.Encoding.utf8)!)
            data.append("\r\n--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
        }
        
        request.httpBody = data
    }
    func defaultCallingFalse1(_ request: NSMutableURLRequest, _ httpParams: HttpParams, _ data: Data) {
        let boundary = generateBoundaryString()
        request.setValue("multipart/form-data; boundary=\(boundary)",
            forHTTPHeaderField: "Content-Type")
        let newParams = NSMutableDictionary()
        newParams.setValue("", forKey: "")
        newParams.setValue("", forKey: "")
        newParams.setValue("", forKey: "")
        for (key, value) in httpParams.params! {
            newParams.setValue(value, forKey: (key as? String)!)
        }
        var data = data
        for (key, value) in newParams {
            data.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n"
                .data(using: String.Encoding.utf8)!)
            data.append("\(value)".data(using: String.Encoding.utf8)!)
            data.append("\r\n--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
        }
        if httpParams.images != nil {
            for iii in 0..<(httpParams.images?.count)! {
                let mdd = (httpParams.images?[iii] as? NSMutableDictionary)!
                let param = (mdd["param"] as? String)!
                let image = (mdd["image"] as? UIImage)!
                
                //let imageData = image.pngData()
                let imageData = image.resize(300).jpegData(compressionQuality: 1.0)
                
                print("image-\(param)-\(image)-\(String(describing: imageData!.count/(8*1024)))-")
                let fname = "test\(iii).png"
                data.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
                data.append(
                    "Content-Disposition: form-data; name=\"\(param)\"; filename=\"\(fname)\"\r\n"
                        .data(using: String.Encoding.utf8)!)
                data.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
                data.append("Content-Type: application/octet-stream\r\n\r\n"
                    .data(using: String.Encoding.utf8)!)
                data.append(imageData!)
                data.append("\r\n".data(using: String.Encoding.utf8)!)
                data.append("--\(boundary)--\r\n".data(using: String.Encoding.utf8)!)
            }
        }
        request.httpBody = data
    }
    public func jsonThread(_ httpObject: HttpObject) {
        if httpObject.error != nil {
            printError(httpObject)
        } else {
            printSuccess(httpObject)
        }
        if httpObject.aai {
            stopActivityIndicator ()
        }
    }
    public func generateBoundaryString() -> String {
        return "Boundary-\(NSUUID().uuidString)"
    }
}

extension Dictionary {
    func percentEscaped() -> String {
        return map { (key, value) in
            let escapedKey = "\(key)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
            let escapedValue = "\(value)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
            return escapedKey + "=" + escapedValue
            }
            .joined(separator: "&")
    }
}

extension CharacterSet {
    static let urlQueryValueAllowed: CharacterSet = {
        let generalDelimitersToEncode = ":#[]@" // does not include "?" or "/" due to RFC 3986 - Section 3.4
        let subDelimitersToEncode = "!$&'()*+,;="
        
        var allowed = CharacterSet.urlQueryAllowed
        allowed.remove(charactersIn: "\(generalDelimitersToEncode)\(subDelimitersToEncode)")
        return allowed
    }()
}
