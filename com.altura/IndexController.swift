//
//  IndexController.swift
//  com.altura
//
//  Created by adrian aguilar on 20/5/18.
//  Copyright © 2018 Altura S.A. All rights reserved.
//

import UIKit

class IndexController: UIViewController {
    
    @IBOutlet weak var itemBar1: UIBarButtonItem!
    @IBOutlet weak var itemBar2: UIBarButtonItem!
    @IBOutlet weak var itemBar3: UIBarButtonItem!
    @IBOutlet weak var itemBar4: UIBarButtonItem!
    
    @IBOutlet weak var logOut_btn: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let width = UIScreen.main.bounds.width/4
        
        itemBar1.drawRect(CGRectMake(0, 0, 30, 30))
            
            = CGRect(x: itemBar1.frame.origin.x, y: itemBar1.frame.origin.y, height: itemBar1.frame.height, width: width)
        
        itemBar2.frame = CGRect(x: itemBar2.frame.origin.x, y: itemBar2.frame.origin.y, height: itemBar2.frame.height, width: width)
        
        itemBar3.frame = CGRect(x: itemBar3.frame.origin.x, y: itemBar3.frame.origin.y, height: itemBar3.frame.height, width: width)
        
        itemBar4.frame = CGRect(x: itemBar4.frame.origin.x, y: itemBar4.frame.origin.y, height: itemBar4.frame.height, width: width)
        // Do any additional setup after loading the view.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func LogOut(_ sender: Any) {
        
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "initController") as! InitController
        self.present(viewController, animated: true)
    }

}
