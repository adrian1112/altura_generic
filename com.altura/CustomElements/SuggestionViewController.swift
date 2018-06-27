//
//  SuggestionViewController.swift
//  com.altura
//
//  Created by adrian aguilar on 26/6/18.
//  Copyright © 2018 Altura S.A. All rights reserved.
//

import UIKit

class SuggestionViewController: UIViewController {

    
    @IBOutlet weak var text: UITextView!
    @IBOutlet weak var sendButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func send(_ sender: Any) {
        
        print("press")
        dismiss(animated: true)
    }
    
    @IBAction func Back(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
    
    @IBAction func exit(_ sender: UIButton) {
        print("press")
        dismiss(animated: true)
    }
    
    //HABILITA LA OPCION DE OCULTAR EL TECLADO CUANDO SE LE DA EN CUALQUIER PARTE DE LA PANTALLA Y PARA MOVER LA VIEW SI EL TECLADO OCULTA EL TEXTFIELD
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}
