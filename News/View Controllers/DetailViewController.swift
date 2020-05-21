//
//  ViewController.swift
//  News
//
//  Created by Roman Topchii on 19.05.2020.
//  Copyright © 2020 Roman Topchii. All rights reserved.
//

import UIKit
import WebKit

class DetailViewController: UIViewController, WKUIDelegate {
    
    @IBOutlet var webView: WKWebView!
    
    var url : URL?
    var html : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = false
        self.navigationItem.title = "Article"
        
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        
        view = webView
        
        if let html = html{
            self.webView.loadHTMLString(html, baseURL: nil)
        }
        else {
            if let url = url{
                self.webView.load(URLRequest(url: url))
            }
        }
    }
}
