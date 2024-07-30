//
//  ArgAppUpdater.swift
//  Sorion
//
//  Created by Anup Gupta on 04/04/18.
//  Copyright © 2018 GeekGuns. All rights reserved.
//


import UIKit

enum TapATradie_VersionError: Error {
    case invalidBundleInfo, invalidResponse
}

class TapATradie_LookupResult: Decodable {
    var results: [TapATradie_AppInfo]
}

class TapATradie_AppInfo: Decodable {
    var version: String
    var trackViewUrl: String
    //let identifier = Bundle.main.infoDictionary?["CFBundleIdentifier"] as? String,
    // You can add many thing based on "http://itunes.apple.com/lookup?bundleId=\(identifier)"  response
    // here version and trackViewUrl are key of URL response
    // so you can add all key beased on your requirement.
    
}

class TapATradie_ArgAppUpdater: NSObject {
    private static var _instance: TapATradie_ArgAppUpdater?;
    
    private override init() {
        
    }
    
    public static func getSingleton() -> TapATradie_ArgAppUpdater {
        if (TapATradie_ArgAppUpdater._instance == nil) {
            TapATradie_ArgAppUpdater._instance = TapATradie_ArgAppUpdater.init();
        }
        return TapATradie_ArgAppUpdater._instance!;
    }
    
    private func getAppInfo(completion: @escaping (TapATradie_AppInfo?, Error?) -> Void) -> URLSessionDataTask? {
        guard let identifier = Bundle.main.infoDictionary?["CFBundleIdentifier"] as? String,
            let url = URL(string: "http://itunes.apple.com/lookup?bundleId=\(identifier)") else {
                DispatchQueue.main.async {
                    completion(nil, TapATradie_VersionError.invalidBundleInfo)
                }
                return nil
        }
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            do {
                if let error = error { throw error }
                guard let data = data else { throw TapATradie_VersionError.invalidResponse }
                
                print("Data:::",data)
                print("response###",response)
                
                let result = try JSONDecoder().decode(TapATradie_LookupResult.self, from: data)
                
                let dictionary = try? JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                
                print("dictionary",dictionary)
                
                
                guard let info = result.results.first else { throw TapATradie_VersionError.invalidResponse }
                print("result:::",result)
                completion(info, nil)
            } catch {
                completion(nil, error)
            }
        }
        task.resume()
        
        print("task ******", task)
        return task
    }
    private  func checkVersion(force: Bool) {
        
        let info = Bundle.main.infoDictionary
        let currentVersion = info?["CFBundleShortVersionString"] as? String
        _ = getAppInfo { (info, error) in
            
            let appStoreAppVersion = info?.version
  
            if let error = error {
                print(error)
                
                
                
            }else if appStoreAppVersion!.compare(currentVersion!, options: .numeric) == .orderedDescending {
                //                print("needs update")
               // print("hiiii")
                DispatchQueue.main.async {
                    let topController: UIViewController = UIApplication.shared.keyWindow!.rootViewController!
                    
                    topController.TapATradie_showAppUpdateAlert(Version: (info?.version ?? ""), Force: force, AppURL: (info?.trackViewUrl ?? ""))
            }
                
            }
        }
        
        
    }
    
    func showUpdateWithConfirmation() {
        checkVersion(force : false)
    }
    
    func showUpdateWithForce() {
        checkVersion(force : true)
    }
    
    
    
}

extension UIViewController {
    
    
    fileprivate func TapATradie_showAppUpdateAlert( Version : String, Force: Bool, AppURL: String) {
        print("AppURL:::::",AppURL)
        
//        let bundleName = Bundle.main.infoDictionary!["CFBundleName"] as! String;
//        let alertMessage = "\(bundleName) Version \(Version) is available on AppStore."
        let alertMessage = "New Version \(Version) is available on AppStore. Keep Your App up to date for better experience."
        let alertTitle = "New Version"
        
        
        let alertController = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        
        
        if !Force {
            let notNowButton = UIAlertAction(title: "Not Now", style: .default) { (action:UIAlertAction) in
                print("Don't Call API");
                
                
            }
            alertController.addAction(notNowButton)
        }
        
        let updateButton = UIAlertAction(title: "Update", style: .default) { (action:UIAlertAction) in
            print("Call API");
            print("No update")
            guard let url = URL(string: AppURL) else {
                return
            }
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
            
        }
        
        alertController.addAction(updateButton)
        self.present(alertController, animated: true, completion: nil)
    }
}
