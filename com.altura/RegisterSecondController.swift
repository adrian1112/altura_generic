//
//  RegisterSecondController.swift
//  altura
//
//  Created by adrian aguilar on 18/5/18.
//  Copyright © 2018 adrian aguilar. All rights reserved.
//

import UIKit
import Foundation
import SQLite

class RegisterSecondController: UIViewController {
    @IBOutlet weak var contract_txt: UITextField!
    @IBOutlet weak var names_txt: UITextField!
    @IBOutlet weak var address_txt: UITextField!
    @IBOutlet weak var telephone_txt: UITextField!
    
    @IBOutlet weak var acept_term_select: UISwitch!
    @IBOutlet weak var send_data_select: UISwitch!
    
    var txt_alert=""
    
    var identifier = ""
    var email = ""
    var pass = ""
    var contract = ""
    var names = ""
    var address = ""
    var telephone = ""
    
    var db: Connection!
    let usersT = Table("usuarios")
    let id_usersT = Expression<Int>("id")
    let name_userT = Expression<String>("nombre")
    var email_user_T = Expression<String>("email")
    let identifier_user_T = Expression<String>("cedula")
    let address_user_T = Expression<String>("direccion")
    let telephone_user_T = Expression<String>("telefono")
    let contract_user_T = Expression<String>("contrato")
    let password_user_T = Expression<String>("contrasena")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("second")
        print(self.db)
        contract_txt.text = self.contract
        names_txt.text = self.names
        address_txt.text = self.address
        telephone_txt.text = self.telephone
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "register" {
            let registro = segue.destination as! RegisterController
            registro.identifier = self.identifier
            registro.email = self.email
            registro.pass = self.pass
            registro.contract = self.contract_txt.text!
            registro.names = self.names_txt.text!
            registro.address = self.address_txt.text!
            registro.telephone = self.telephone_txt.text!
            registro.db = self.db
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func registerUser(_ sender: Any) {
        
        let identifier = self.identifier
        let email = self.email
        let pass = self.pass
        let contract = self.contract_txt.text!
        let names = self.names_txt.text!
        let address = self.address_txt.text!
        let telephone = self.telephone_txt.text!
        
        let insertUser = self.usersT.insert(self.identifier_user_T <- identifier,self.email_user_T <- email, self.password_user_T <- pass, self.contract_user_T <- contract, self.name_userT <- names, self.address_user_T <- address, self.telephone_user_T <- telephone)
        do{
            try self.db.run(insertUser)
            self.txt_alert = "Se creo el usuario correctamente"
            self.showAlert(status: 1)
            print("se creo el usuario")
        }catch let Result.error(message, code, statement){
            if( code == 19){
                self.txt_alert = "Ya existe un usuario con el correo ingresado"
                self.showAlert(status: 2)
                print("usuario ya existe, \(message)")
            }else{
                self.txt_alert = "Error al crear el usuario"
                self.showAlert(status: 3)
                print(" * constraint failed: \(message), in \(statement) , code \(code)")
            }
        }catch{
            self.txt_alert = "Error al crear el usuario"
            self.showAlert(status: 3)
            print(error)
            print("no se creo el usuario")
        }
    }
    
    func redirectLogin(status: Int){
        if(status == 1){
            let viewController = self.storyboard?.instantiateViewController(withIdentifier: "initController") as! InitController
            self.present(viewController, animated: true, completion: nil)
        }else if( status == 2){
            
        }else{
            
        }
    }
    
    //funcion para mostrar alerta
    func showAlert(status: Int){
        print("entra a alerta")
        let alert = UIAlertController(title: nil, message: self.txt_alert, preferredStyle: .alert);
        let btn_alert = UIAlertAction(title: "Aceptar", style: .default) { (UIAlertAction) in  self.redirectLogin(status: status);
        }
        alert.addAction(btn_alert);
        self.present(alert, animated: true, completion: nil);
    }
}
