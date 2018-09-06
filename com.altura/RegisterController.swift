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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
     
        print("first")
        identifier_txt.text = self.identifier
        email_txt.text = self.email
        pass1_txt.text = self.pass
        pass2_txt.text = self.pass
        
        label_error.text = "Ingrese todos los parámetros"
        
        let txt1 = self.pass1_txt.text
        let txt2 = self.pass2_txt.text
        
    }
    
    @IBAction func fromRegisterSecondView( segue: UIStoryboardSegue!){
        
    }
    
    /*override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
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
    }*/
    
    //HABILITA LA OPCION DE OCULTAR EL TECLADO CUANDO SE LE DA EN CUALQUIER PARTE DE LA PANTALLA
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func Longin(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func validatePass(_ sender: Any) {
        let txt1 = self.pass1_txt.text
        let txt2 = self.pass2_txt.text
        var pass_ok = false
        var text = "* "
        if( (txt1 == txt2) && txt1 != "" && txt2 != "" ){
            pass_ok = true
            self.pass1_txt.layer.borderWidth = 0
            self.pass2_txt.layer.borderWidth = 0
        }else{
            let myColor = UIColor.red
            self.pass1_txt.layer.borderColor = myColor.cgColor
            self.pass2_txt.layer.borderColor = myColor.cgColor
            self.pass1_txt.layer.borderWidth = 1.0
            self.pass2_txt.layer.borderWidth = 1.0
            pass_ok = false
            text = text + "Las contraseñas no coinciden"
        }
        
        let identifier_ok = verificarCedula(cedula: self.identifier_txt.text!)
        if !identifier_ok {
            let myColor = UIColor.red
            self.identifier_txt.layer.borderColor = myColor.cgColor
            self.identifier_txt.layer.borderWidth = 1.0
            
            if text == "* " {
                text = text + "Ingrese una cédula válida"
            }else{
                text = text + ", Ingrese una cédula válida"
            }
        }else{
            self.identifier_txt.layer.borderWidth = 0
        }
        
        
        let email_ok = isValidEmail(string: self.email_txt.text!)
        
        if !email_ok {
            
            let myColor = UIColor.red
            self.email_txt.layer.borderColor = myColor.cgColor
            self.email_txt.layer.borderWidth = 1.0
            
            
            if text == "* " {
                text = text + "Ingrese un correo válido"
            }else{
                text = text + ", Ingrese un correo válido"
            }
        }else{
            self.email_txt.layer.borderWidth = 0
        }
        
        
        if pass_ok && identifier_ok && email_ok{
            let viewController = self.storyboard?.instantiateViewController(withIdentifier: "RegisterSecondController") as! RegisterSecondController
                viewController.identifier = identifier_txt.text!
                viewController.email = email_txt.text!
                viewController.pass = pass1_txt.text!
                viewController.contract = self.contract
                viewController.names = self.names
                viewController.address = self.address
                viewController.telephone = self.telephone
                self.present(viewController, animated: true)
        }else{
            self.label_error.text = text
        }
    }
    
}
