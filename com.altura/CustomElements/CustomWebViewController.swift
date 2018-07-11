//
//  CustomWebViewController.swift
//  com.altura
//
//  Created by adrian aguilar on 11/7/18.
//  Copyright © 2018 Altura S.A. All rights reserved.
//

import UIKit
import WebKit

class CustomWebViewController: UIViewController,WKNavigationDelegate {
    
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var titleV: UINavigationItem!
    
    
    var url_string = "https://www.google.com"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.navigationDelegate = self
        
        let url = URL(string: url_string)!
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
        
        titleV.title = url_string
        
    }

    @IBAction func Back(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func openSafari(_ sender: Any) {
        //abre la url en el navegador por defecto en est caso safari
        if let url = URL(string: self.url_string) {
            UIApplication.shared.open(url, options: [:])
        }
    }
    
    @IBAction func shareUrl(_ sender: Any) {
        
        let text = "Puntos de Recaudo - Interagua"
        let myWebsite = NSURL(string:self.url_string)
        let shareAll = [text , myWebsite] as [Any]
        let activityViewController = UIActivityViewController(activityItems: shareAll, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        self.present(activityViewController, animated: true, completion: nil)
        
    }
    
    
}
