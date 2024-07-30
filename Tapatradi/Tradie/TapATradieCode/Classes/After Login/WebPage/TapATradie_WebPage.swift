//
//  WebPage.swift
//  TapATradie
//
//  Created by Apple on 04/05/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import WebKit

enum TapATradie_LinkType {
    case termsncondition
    case privacypolicy
    case aboutus
    case none
}

class TapATradie_WebPage: UIViewController {

    var linkType: TapATradie_LinkType = .none
        
    @IBOutlet weak var lblHeader: UILabel!
    
    @IBAction func actionBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        TapATradie_kAppDelegate.TapATradie_currentVC = self
        
        var url = ""
        
        if linkType == .termsncondition {
            lblHeader.text = "Terms and Conditions"
            url = TapATradie_url_termsandconditions
        } else if linkType == .privacypolicy {
            url = TapATradie_url_privacypolicy
            lblHeader.text = "Privacy Policy"
        } else if linkType == .aboutus {
            url = TapATradie_url_aboutus
            lblHeader.text = "About Us"
        }
        
        print("url-\(url)-")
        
        addWebView (url)
    }
    
    func addWebView (_ link: String) {
        guard let url = NSURL(string: link) else {
            return
        }
        let request = NSURLRequest(url: url as URL)
        
        print("Request-[\(link)]-[\(request)]-")
        
        let webView = WKWebView(frame: self.view.frame)
        webView.navigationDelegate = self
        webView.load(request as URLRequest)
        
        let frame = CGRect(x: 0, y: 80, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height - 80)
        webView.frame = frame
        
        self.view.addSubview(webView)
    }
    
  
}

extension TapATradie_WebPage: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print("Started to load")
        Http.startActivityIndicator()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("Finished loading")
        Http.stopActivityIndicator()
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: NSError) {
        print(error.localizedDescription)
        Http.stopActivityIndicator()
    }
}
