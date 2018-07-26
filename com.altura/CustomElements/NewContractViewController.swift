//
//  NewContractViewController.swift
//  com.altura
//
//  Created by adrian aguilar on 4/7/18.
//  Copyright © 2018 Altura S.A. All rights reserved.
//

import UIKit

class NewContractViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func Next(_ sender: UIButton) {
        dismiss(animated: true)
    }
    @IBAction func exit(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    //HABILITA LA OPCION DE OCULTAR EL TECLADO CUANDO SE LE DA EN CUALQUIER PARTE DE LA PANTALLA
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        dismiss(animated: true)
    }
    

}
