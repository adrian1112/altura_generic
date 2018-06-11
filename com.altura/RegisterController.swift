//
//  RegisterController.swift
//  altura
//
//  Created by adrian aguilar on 18/5/18.
//  Copyright © 2018 adrian aguilar. All rights reserved.
//
import UIKit
import Foundation
import SQLite

class RegisterController: UIViewController {
    @IBOutlet weak var identifier_txt: UITextField!
    @IBOutlet weak var email_txt: UITextField!
    @IBOutlet weak var pass1_txt: UITextField!
    @IBOutlet weak var pass2_txt: UITextField!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var label_error: UILabel!
    
    var identifier = ""
    var email = ""
    var pass = ""
    var contract = ""
    var names = ""
    var address = ""
    var telephone = ""
    
    var db: Connection!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
     
        print("first")
        print(self.db)
        identifier_txt.text = self.identifier
        email_txt.text = self.email
        pass1_txt.text = self.pass
        pass2_txt.text = self.pass
        
        let txt1 = self.pass1_txt.text
        let txt2 = self.pass2_txt.text
        if( (txt1 == txt2) && txt1 != "" && txt2 != "" ){
            self.nextButton.isEnabled = true
            self.label_error.isHidden = true
        }else{
            self.nextButton.isEnabled = false
            self.label_error.isHidden = false
        }
        
    }
    
    @IBAction func fromRegisterSecondView( segue: UIStoryboardSegue!){
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "register_2" {
            let registro2 = segue.destination as! RegisterSecondController
            registro2.identifier = identifier_txt.text!
            registro2.email = email_txt.text!
            registro2.pass = pass1_txt.text!
            registro2.contract = self.contract
            registro2.names = self.names
            registro2.address = self.address
            registro2.telephone = self.telephone
            registro2.db = self.db
            
        }
    }
    
    //HABILITA LA OPCION DE OCULTAR EL TECLADO CUANDO SE LE DA EN CUALQUIER PARTE DE LA PANTALLA
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func validatePass(_ sender: Any) {
        let txt1 = self.pass1_txt.text
        let txt2 = self.pass2_txt.text
        if( (txt1 == txt2) && txt1 != "" && txt2 != "" ){
            self.nextButton.isEnabled = true
            self.label_error.isHidden = true
        }else{
            self.nextButton.isEnabled = false
            self.label_error.isHidden = false
        }
    }
}
