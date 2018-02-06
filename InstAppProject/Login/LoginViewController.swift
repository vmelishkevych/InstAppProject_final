//
//  LoginViewController.swift
//  InstAppProject
//
//  Created by Torris on 11/9/17.
//  Copyright © 2017 Vasiliy Melishkevych. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UIWebViewDelegate {
    
    weak var webView: UIWebView?
    
    let initClosure: (_ token: Token?) -> ()
    
    init(initClosure: @escaping (_ token: Token?) -> ()) {
        self.initClosure = initClosure
        super.init(nibName: nil, bundle: nil)
    }
    

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        
        print("Login viewDidLoad begin!!!")
        
        var rect = self.view.bounds
        rect.origin = CGPoint.zero
        
        let webView = UIWebView(frame: rect)
        
       // webView.autoresizingMask = UIViewAutoresizing(rawValue: UIViewAutoresizing.RawValue(UInt8(UIViewAutoresizing.flexibleHeight.rawValue) | UInt8(UIViewAutoresizing.flexibleWidth.rawValue)))

        self.view.addSubview(webView)
        
        self.webView = webView
        
        self.webView?.delegate = self
        
        
        
        let urlString = "https://api.instagram.com/oauth/authorize/?client_id=fcb0c87aa5b74f06aea104f2e0b55fc3&redirect_uri=https://oauth.vk.com/blank.html&response_type=token&scope=public_content"
        
        
        if let url = URL(string: urlString) {
            
            let request = URLRequest(url: url)
            self.webView?.loadRequest(request)
        }
        
        print("Login viewDidLoad end!!!")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        
        self.webView?.delegate = nil
    }
    
    //MARK: help methods
    
    // present alert on view
    
    func showAllertController(withTitle title: String?, andMessage message: String?) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle:.alert)
        let actionCancel = UIAlertAction(title: "Hide a message", style: .cancel) { (action) in
            
            self.navigationController?.popViewController(animated: true)
        }
        
        alert.addAction(actionCancel)
        
        present(alert, animated: true, completion: nil)
    }

    
    
    
    //MARK: UIWebViewDelegate
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        
        let urlString = request.url?.absoluteString
        
        if let urlString = urlString {
            
            if urlString.hasPrefix("https://oauth.vk.com/blank.html#access_token=") {
                
                let token = Token()
                
                let fragments = urlString.components(separatedBy: "#")
                
                if let pair = fragments.last {
                    
                    let values = pair.components(separatedBy: "=")
                    
                    if values.count == 2 {
                        
                        if let key = values.first, key == "access_token" {
                            
                            token.tokenString = values.last
                            
                            self.initClosure(token)
                            
                            self.webView?.delegate = nil
                            navigationController?.popViewController(animated: true)
                            
                            return false
                            
                        }
                    }
                }
            } else if urlString.hasPrefix("https://oauth.vk.com/blank.html?error=access_denied") ||  urlString.hasPrefix("https://oauth.vk.com/blank.html?error_reason=user_denied") {
                
                self.webView?.delegate = nil
                self.initClosure(nil)
                
                self.showAllertController(withTitle: "Access denied",
                                          andMessage: "Please try to login again")
                
                return false
            }
            
        }
        
        return true
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        
        self.initClosure(nil)
        self.showAllertController(withTitle: "Authorization error",
                                  andMessage: """
            \(error.localizedDescription)
            Please try to login again
            """)
    }

}



