//
//  StatusProcessViewController.swift
//  com.altura
//
//  Created by adrian aguilar on 4/7/18.
//  Copyright © 2018 Altura S.A. All rights reserved.
//

import UIKit

class StatusProcessViewController: UIViewController {
    
    @IBOutlet weak var navigationBar: UINavigationItem!
    
    var titleView = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationBar.title = titleView
        
        
    }

    @IBAction func exit(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
}
