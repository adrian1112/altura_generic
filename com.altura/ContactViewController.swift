//
//  ContactViewController.swift
//  com.altura
//
//  Created by adrian aguilar on 11/7/18.
//  Copyright © 2018 Altura S.A. All rights reserved.
//

import UIKit

class ContactViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func callCenter(_ sender: Any) {
        
        let number = "0997396690"
        Utils.call(number: number)
        
    }
    
    @IBAction func chatOnline(_ sender: Any) {
        
    }
    
    @IBAction func close(_ sender: Any) {
        dismiss(animated: true)
    }
    
    //HABILITA LA OPCION DE OCULTAR EL TECLADO CUANDO SE LE DA EN CUALQUIER PARTE DE LA PANTALLA
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        dismiss(animated: true)
    }
}

class Utils: NSObject {
    class func call(number: String) {
        print("entra en llamada")
        let num = "tel://" + number
        //if let url = NSURL(string: num) {
        if let url = URL(string: num) {
            
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url , options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    
    
}
