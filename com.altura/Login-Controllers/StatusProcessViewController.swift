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
    
    @IBOutlet weak var process_text: UILabel!
    @IBOutlet weak var description_text: UILabel!
    @IBOutlet weak var number_process_text: UILabel!
    @IBOutlet weak var date_init_text: UILabel!
    @IBOutlet weak var date_end_text: UILabel!
    @IBOutlet weak var status_text: UILabel!
    
    
    @IBOutlet weak var sta1: UILabel!
    @IBOutlet weak var sta2: UILabel!
    @IBOutlet weak var sta3: UILabel!
    
    
    var titleView = ""
    var process = Process.init("", "", "", "", "", UIImage(named: "proceso")!, false, "", "")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.title = titleView
        
        self.process_text.text =  process.title
        self.description_text.text = process.subtitle
        self.number_process_text.text = process.code
        self.date_init_text.text = process.date
        self.status_text.text = process.status
        self.date_end_text.text = process.date_end
        
        if(process.status == "ATENDIDO"){
            sta1.backgroundColor =  UIColor.green
            sta2.backgroundColor =  UIColor.green
            sta3.backgroundColor =  UIColor.green
        }else if(process.status == "ANULADO"){
            sta1.backgroundColor =  UIColor.green
            sta2.backgroundColor =  UIColor.red
            sta3.backgroundColor = UIColor.red
        }else{
            sta1.backgroundColor =  UIColor.green
            //sta2.backgroundColor =  UIColor.red
            //sta3.backgroundColor = UIColor.red
        }
        
        
        
        
        
        
    }
    
    

    @IBAction func exit(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
}
