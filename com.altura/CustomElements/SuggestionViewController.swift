//
//  SuggestionViewController.swift
//  com.altura
//
//  Created by adrian aguilar on 26/6/18.
//  Copyright © 2018 Altura S.A. All rights reserved.
//

import UIKit
import SQLite

class SuggestionViewController: UIViewController {

    let ws = WService();
    let dbase = DBase();
    var db: Connection!
    
    var user = User.init(id_user: 0, document: "", person: "", email: "", phone: "", sync_date: "", adress: "", status: 1, error: 1)
    
    @IBOutlet weak var text: UITextView!
    @IBOutlet weak var sendButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let status = dbase.connect_db()
        if( status.value ){
            print("entra a buscar usuario")
            user = self.dbase.loadUsersDB()
            
            
        }
        
        // Do any additional setup after loading the view.
    }
    @IBAction func send(_ sender: Any) {
        
        if text.text.trimmingCharacters(in: .whitespaces) != ""{
            
            self.ws.sendSuggest(id_user: self.user.id_user, message: self.text.text,
                success:{ (message) -> Void in
                    self.showAlert(message: "Se enviaron sus comentarios",tipo: 2)
                print("\(message)")
                //self.showAlert(message: message)
                
            }, error:{ (message) -> Void in
                    print("\(message)")
                if message != ""{
                    self.showAlert(message: message,tipo: 1)
                }else{
                    self.showAlert(message: "Se genero un problema al enviar los comentarios",tipo: 1)
                }
                
                
                })
            print("press")
            //dismiss(animated: true)
        }else{
            showAlert(message: "Por favor ingrese sus comentarios",tipo: 1)
        }
        
    }
    
    @IBAction func Back(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
    
    @IBAction func exit(_ sender: UIButton) {
        print("press")
        dismiss(animated: true)
    }
    
    //funcion para mostrar alerta
    func showAlert(message: String, tipo: Int){
        print("entra a alerta")
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert);
        let btn_alert = UIAlertAction(title: "Aceptar", style: .default) { (UIAlertAction) in
            self.dismiss(animated: true, completion: nil)
        }
        let btn_alert1 = UIAlertAction(title: "Aceptar", style: .default) { (UIAlertAction) in
            
        }
        
        if tipo == 1 {
            alert.addAction(btn_alert1);
        }else{
            alert.addAction(btn_alert);
        }
        
        self.present(alert, animated: true, completion: nil);
    }
    
    //HABILITA LA OPCION DE OCULTAR EL TECLADO CUANDO SE LE DA EN CUALQUIER PARTE DE LA PANTALLA Y PARA MOVER LA VIEW SI EL TECLADO OCULTA EL TEXTFIELD
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}
