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
    
    
    @IBOutlet weak var prog1: UIImageView!
    @IBOutlet weak var prog2: UIImageView!
    @IBOutlet weak var prog3: UIImageView!
    
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
            prog1.alpha = 1
            prog2.alpha = 1
            prog3.alpha = 1
        }else{
            prog1.alpha = 1
            prog2.alpha = 0.3
            prog3.alpha = 0.3
        }
        
        
        
        
        
        
    }
    
    

    @IBAction func exit(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
}
