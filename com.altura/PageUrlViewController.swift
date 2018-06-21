//
//  PageUrlViewController.swift
//  com.altura
//
//  Created by adrian aguilar on 18/6/18.
//  Copyright © 2018 Altura S.A. All rights reserved.
//

import UIKit
import WebKit

class PageUrlViewController: UIViewController {
    @IBOutlet weak var webView: WKWebView!
    
    var url = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.navigationItem.leftBarButtonItem?.title = "Regresar"
        navigationController?.hidesBarsOnSwipe = true
        
        navigationController?.hidesBarsWhenKeyboardAppears = false
        
        print(url)
        let url_page = URL(string: self.url)
        let request = URLRequest(url: url_page!)
        webView.load(request)
        
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func gestureActionUp(_ sender: Any) {
       
        print("entra en gesture"); navigationController?.navigationBar.isHidden = false
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
