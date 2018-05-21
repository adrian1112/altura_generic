//
//  IndexController.swift
//  com.altura
//
//  Created by adrian aguilar on 20/5/18.
//  Copyright © 2018 Altura S.A. All rights reserved.
//

import UIKit

class IndexController: UIViewController {
    
    
    @IBOutlet weak var logOut_btn: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func LogOut(_ sender: Any) {
        
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        self.present(viewController, animated: true)
    }

}
