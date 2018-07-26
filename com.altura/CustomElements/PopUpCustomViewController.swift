//
//  PopUpCustomViewController.swift
//  com.altura
//
//  Created by adrian aguilar on 29/6/18.
//  Copyright © 2018 Altura S.A. All rights reserved.
//

import UIKit

class PopUpCustomViewController: UIViewController {
    @IBOutlet weak var titleView: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var bodyView: UITextView!
    
    var title_string = ""
    var image = UIImage(named: "altura")
    var body_string = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        titleView.text = title_string
        imgView.image = image
        bodyView.text = body_string
        
    }

    @IBAction func exit(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    //HABILITA LA OPCION DE OCULTAR EL TECLADO CUANDO SE LE DA EN CUALQUIER PARTE DE LA PANTALLA
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        dismiss(animated: true)
    }
    
}
