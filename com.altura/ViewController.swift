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


struct User: Decodable {
    let id_user: Int?
    let document: String?
    let person: String?
    let email: String?
    let phone: String?
    let sync_date: String?
    let adress: String?
    let status: Int?
    let error: String?
    
}

struct UserLogin {
    let id_user: Int?
    let email: String?
}

struct UserDB {
    var id: Int?
    var name: String?
    var email: String?
    var identifier: String?
    var addresss: String?
    var telephone: String?
    var contract: String?
    var pass: String?
}

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
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { (granted, error) in
                if granted == true {
                    self.notificationPop()
                    print("Se autorizó las notificaciones")
                }else{
                    print("Se denegaron los permisos para recibir notificaciones")
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
        if(user_name != "" && pass != ""){
            let usr_encrypt = user_name;
            let pass_encrypt = pass;
            
            let key = "Altura" // length == 32
            let n_key = key.md5()
            print(n_key)
            let iv = "gqLOHUioQ0QjhuvI" // length == 16
            //let iv = n_key;
            let s = "action=login&mail=\(usr_encrypt)&pass=\(pass_encrypt)&os=2&imei=111"
            let enc = try! usr_encrypt.aesEncrypt(key: n_key, iv: iv)
            let enc2 = try! enc.aesDecrypt(key: n_key, iv: iv)
            let s2 = try! s.aesEncrypt(key: n_key, iv: iv)
            let s3 = try! s2.aesDecrypt(key: n_key, iv: iv)
            
            
            
            print(enc,enc2)
            print(s2,s3)
            //print(s4, s5)
            
            
            let ok = ws.loadUser(usr_id: user_name, pass: pass)
            //let ok = self.loadUsersDB(usr: user_name, pass: pass)
            if(ok.value == 2){
                txt_alert = "Usuario o Contraseña Inválidos"
                self.showAlert();
            }else if( ok.value == 3){
                txt_alert = "Usuario no registrado"
                self.showAlert();
            }else if( ok.value == 5){
                txt_alert = "Error.."
                self.showAlert();
            }else{
                // entra e la app
                self.user_in = ok.user;
                dbase.inserUserLogin(user_in: self.user_in)
                self.navigateToApp()
            }
            
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
        let number = "0997396690"
        Utils.call(number: number)
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
        let btn_alert = UIAlertAction(title: "Reintentar", style: .default) { (UIAlertAction) in  self.setValues();
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
    
    private func notificationPop(){
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
        let notofi = UNNotificationRequest.init(identifier: "initNotification", content: content, trigger: trigger)
        
        /*El siguiente paso será agregar nuestra petición a la central
         de notificaciones de nuestra aplicación.*/
        notificationCenter.add(notofi) { (error) in
            
            if error == nil {
                print("Se agrego correctamente")
            }else{
                print("Se presento un problema")
            }
        }
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

