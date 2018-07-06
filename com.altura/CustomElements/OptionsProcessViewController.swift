//
//  OptionsProcessViewController.swift
//  com.altura
//
//  Created by adrian aguilar on 4/7/18.
//  Copyright © 2018 Altura S.A. All rights reserved.
//

import UIKit

class OptionsProcessViewController: UIViewController {
    
    var contrato = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func NewProcess1(_ sender: UIButton) {
        
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "techRequestViewController") as! TechRequestViewController
        viewController.contrato = self.contrato
            self.present(viewController, animated: true, completion: nil)
        
        
    }
    
    @IBAction func newProcess2(_ sender: UIButton) {
        
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "billRequestViewController") as! BillRequestViewController
        viewController.contrato = self.contrato
        self.present(viewController, animated: true, completion: nil)
    }
    
    @IBAction func exit(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
}
