//
//  ViewController.swift
//  altura
//
//  Created by adrian aguilar on 15/5/18.
//  Copyright © 2018 adrian aguilar. All rights reserved.
//

import UIKit
import SQLite
// import Alamofire
import CryptoSwift
import UserNotifications


class ViewController: UIViewController {
    
    //dependencias
    let ws = WService();
    let dbase = DBase();
    
    @IBOutlet weak var user_txt: UITextField!
    @IBOutlet weak var pass_txt: UITextField!
    @IBOutlet weak var btn_in: UIButton!
    @IBOutlet weak var btn_reg: UIButton!
    
    
    
    var txt_alert=""
    var user = UserDB(id: nil, name: nil, email: nil, identifier: nil, addresss: nil, telephone: nil, contract: nil, pass: nil )
    
    let status: Bool = false
    var db: Connection!
    
    var complete = false
    var error = true
    
    
    
    var user_in = User(id_user: 0, document: "", person: "", email: "", phone: "", sync_date: "", adress: "", status: 0, error: "")
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func fromRegisterView( segue: UIStoryboardSegue!){
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "login_register" {
            _ = segue.destination as! RegisterController
            //login.db = self.db
        }
    }
    
    //se ejecuta despues de dibujar el view
    // print(string) -> imprime en consola el dato
    override func viewDidLoad() {
        super.viewDidLoad();
        
        //** opcion de notificacion **
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge,  .sound]) { (success, error) in
                if error != nil {
                    print("Se denegaron los permisos para recibir notificaciones")
                }else{
                    //self.notificationPop()
                    print("Se autorizó las notificaciones")
                }
            }
        
        //** opciones de navegacion **
        navigationController?.hidesBarsOnSwipe = true
        //navigationController?.hidesBarsOnTap = true
        navigationController?.hidesBarsWhenKeyboardAppears = false
        
        
        btn_in.layer.cornerRadius = 20
        btn_in.clipsToBounds = true
        btn_reg.layer.cornerRadius = 20
        btn_reg.clipsToBounds = true
        btn_reg.layer.borderWidth = 1
        btn_reg.layer.borderColor = UIColor(red:28/255, green:81/255, blue:221/255, alpha: 1).cgColor
        // Do any additional setup after loading the view, typically from a nib.
        
        
        
        let status = dbase.connect_db()
        if( status.value ){
            self.db = status.conec;
            
            let status_t = dbase.createTables()
            if(status_t){
                self.btn_in.isEnabled = true
                self.btn_reg.isEnabled = true
                dbase.printAllUsers()
                print("Tablas creadas correctamente")
                
                ws.loadAgencies(success: {
                    (agencies) -> Void in
                    
                    do{
                        try self.db.execute("DROP TABLE IF EXISTS agencias;")
                        print("Se vacio la tabla agenicas correctamente")
                    }catch let Result.error(message, code, statement){
                        print("mensaje: \(message), codigo: \(code), statment: \(String(describing: statement)) ")
                    }catch {
                        print(error)
                    }
                    
                    self.dbase.insertAgencies(places: agencies as! [place])
                    print("se inserto correctamente las agencias")
                }, error: {
                    (agencies,message) -> Void in
                        print("devolvio null en las agencias")
                })
            }else{
                self.btn_in.isEnabled = false
                self.btn_reg.isEnabled = false
                print("Error creando tablas")
            }
        }else{
            self.btn_in.isEnabled = false
            self.btn_reg.isEnabled = false
            print("No se pudo conectar a la base")
        }
    }
    
       
    
    
    @IBAction func logIn(_ sender: Any) {
        let user_name = user_txt.text!
        let pass = pass_txt.text!
        print(user_name,pass)
        
        var internet = false
        if Connectivity.isConnectedToInternet {
            print("Connected")
            internet = true
            
        } else {
            print("No Internet")
            let alert = UIAlertController(title: nil, message: "No tiene acceso a Internet", preferredStyle: .alert);
            let btn_alert = UIAlertAction(title: "Cerrar", style: .default) { (UIAlertAction) in
            }
            alert.addAction(btn_alert);
            self.present(alert, animated: true, completion: nil);
        }
        
        if(user_name != "" && pass != "" && internet){
            let usr_encrypt = user_name;
            let pass_encrypt = pass;
            
            print("usuario: \(user_name) , contraseña: \(pass)")
            
            
            self.user_txt.text = ""
            self.pass_txt.text = ""
            
            self.complete = false
            self.error = true
            
            ws.loadUser(usr_id: user_name, pass: pass, success: {
                (value,user) -> Void in
                print("entra en success: \(value) , \(user)")
                self.user_in = user
                self.user_in.email = user_name
                self.error = false
                self.complete = true
                
            }, error: {
                (value,user) -> Void in
                print("entra en error: \(value) , \(user)")
                if(value == 2){
                    self.txt_alert = "Usuario o Contraseña Inválidos"
                    
                }else if( value == 3){
                    self.txt_alert = "Usuario no registrado"
                    
                }else{
                    self.txt_alert = "Error.."
                }
                self.error = true
                self.complete = true
                print("sale en error: \(value) , \(user)")
            })
            
            repeat {
                //print("complete: \(complete) ,error \(error)")
                if complete{
                    if error{
                        print("entra en alerta")
                        self.showAlert();
                    }else{
                        print("entra navigate app")
                        self.dbase.insertUserLogin(user_in: self.user_in)
                        self.navigateToApp()
                    }
                }
            } while(!complete)
            
        }
    }
    
    @IBAction func resetPass(_ sender: Any) {
        txt_alert = " Recuperar Contraseña para usuario:" + user_txt.text!;
        self.showAlert();
        
    }
    @IBAction func register(_ sender: Any) {
        txt_alert = " Registrando usuario:";
        self.showAlert();
    }
    
    @IBAction func optionTwo(_ sender: Any) {
        
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "contactViewController") as! ContactViewController
        self.present(viewController, animated: true)
        
        //txt_alert = "Opcion 2";
        //self.showAlert();
    }
    
    @IBAction func optionFour(_ sender: Any) {
        txt_alert = "Opcion 4";
        self.showAlert();
    }
    
    
    
    
    
    
    //funcion que se ejcuta cuando no existe mucha memoria en el dispositivo
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //funcion para mostrar alerta
    func showAlert(){
        print("entra a alerta")
        let alert = UIAlertController(title: nil, message: self.txt_alert, preferredStyle: .alert);
        let btn_alert = UIAlertAction(title: "Reintentar", style: .default) { (UIAlertAction) in
            self.setValues()
            self.notificationPop()
        }
        alert.addAction(btn_alert);
        self.present(alert, animated: true, completion: nil);
    }
    
    func setValues(){
        self.pass_txt.text = "";
    }
    
    private func navigateToApp(){
        let mainTabViewController = self.storyboard?.instantiateViewController(withIdentifier: "mainTabViewController") as! MainTabViewController
        self.present(mainTabViewController, animated: true, completion: nil)
    }
    
    func notificationPop(){
        //se accede a la central de notificaciones
        let notificationCenter = UNUserNotificationCenter.current()
        //se crea el contenido de la notificacion
        let content = UNMutableNotificationContent()
        content.title = "Titulo de mi notificación"
        content.subtitle = "Subtitulo de la notificación"
        content.body = "Descripción de notificacion"
        
        /*Ahora debemos crear un Schedule de disparo de nuestra notificación. Para
         ello, usaremos UNTimeIntervalNotificationTrigger, el cual recibe un
         "timeInterval". Este parámetro indica cuantos segundos a partir de ser
         agregada nuestra notificación ésta será disparada. El siguiente parámetro
         "repeats" sirve para indicar si la notificación se repetirá después de
         su primer disparo.*/
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 2, repeats: false)
        
        /*Ahora crearemos una petición, la cual debe tener un "identifier" que
         puede ser el de nuestra preferencia, un "content" y un "trigger" que
         hemos generado lineas arriba.*/
        let request = UNNotificationRequest(identifier: "initNotification", content: content, trigger: trigger)
        
        /*El siguiente paso será agregar nuestra petición a la central
         de notificaciones de nuestra aplicación.*/
        notificationCenter.add(request) { (error) in
            
            if error == nil {
                print("Se agrego correctamente")
            }else{
                print("Se presento un problema")
            }
        }
    }
    
    
    func loadCore(){
        var places: [place] = []
        ws.loadAgencies(success: {
            
            (agencias) -> Void in
            places = agencias as! [place]
            print("se obtuvieron las agencias")
            
        }, error: {
            (agencies, message) -> Void in
            print(message)
        })
    }
    
    
    
    
}



