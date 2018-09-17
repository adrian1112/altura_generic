//
//  ChatViewController.swift
//  com.altura
//
//  Created by adrian aguilar on 17/9/18.
//  Copyright © 2018 Altura S.A. All rights reserved.
//

import UIKit
import SystemConfiguration
import SQLite


class ChatViewController: UIViewController,UIWebViewDelegate {
    
    let dbase = DBase();
    var db: Connection!
    
    
    
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var titleV: UINavigationItem!
    
    
    var url_string = "http://chatinteragua.americancallcenter.com/aheevaChat/guestINTERAGUA/application.html?lang=SP&clientType=GUEST&userName=anonimo_tc1537212619&flag=1537212619&userEmail=anonimo&attachedData=%7B%22CHATTYPE%22%3A%22SAC%22%2C%22REGNUM%22%3A%22tc1537212619%22%2C%22CUSTOMERNAME%22%3A%22anonimo_tc1537212619%22%7D"
    var user = User.init(id_user: 0, document: "", person: "", email: "", phone: "", sync_date: "", adress: "", status: 1, error: 1);
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let status = dbase.connect_db()
        if( status.value ){
            user = dbase.loadUsersDB()
        }
        
        url_string = getUrl()
        print(url_string)
        
        let request_url = URLRequest(url: URL(string: url_string)!)
        webView.loadRequest(request_url)
        
        //let url = URL(string: url_string)!
        //webView.load(URLRequest(url: url))
        //webView.allowsBackForwardNavigationGestures = true
        //titleV.title = url_string
        
    }
    
    @IBAction func Back(_ sender: Any) {
        dismiss(animated: true)
    }
    
    func getUrl() -> String {
        let flag = Int64(NSDate().timeIntervalSince1970)
        print(flag)
        let tag = "tc"
        let regNum = "\(tag)\(flag)"
        
        let lang = "SP"
        let clientType = "GUEST"
        let user = "anonimo"
        
        let userName = "\(user)_\(regNum)"
        let chatType = "SAC"
        
        var userEmail = user;
        var customUserName = userName
        
        if self.user.error != 1 {
            userEmail = self.user.email!
            customUserName = self.user.person
        }
        
        let attachedData = "{\"CHATTYPE\":\"\(chatType)\",\"REGNUM\":\"\(regNum)\",\"CUSTOMERNAME\":\"\(customUserName)\"}";
        
        let url = "http://chatinteragua.americancallcenter.com/aheevaChat/guestINTERAGUA/application.html?lang=\(lang)&clientType=\(clientType)&userName=\(userName)&flag=\(flag)&userEmail=\(userEmail)&attachedData=\(codeUtf8(data: attachedData))"
        
        return url
    }
    
    
    
    /*@IBAction func openSafari(_ sender: Any) {
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
        
    }*/
    

}
