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
    var db: Connection!
    
    @IBOutlet weak var user_txt: UITextField!
    @IBOutlet weak var pass_txt: UITextField!
    @IBOutlet weak var btn_in: UIButton!
    @IBOutlet weak var btn_reg: UIButton!
    
    //indicador de proceso
    @IBOutlet weak var indicadorView: UIView!
    @IBOutlet weak var spin: UIActivityIndicatorView!
    @IBOutlet weak var text_spin: UILabel!
    
    var txt_alert=""
    
    var re_confirm = false
    let status: Bool = false
    
    
    var complete = false
    var error = true
    
    
    
    var user_in = User(id_user: 0, document: "", person: "", email: "", phone: "", sync_date: "", adress: "", status: 1, error: 0)
    
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
        /*UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge,  .sound]) { (success, error) in
                if error != nil {
                    print("Se denegaron los permisos para recibir notificaciones")
                }else{
                    //self.notificationPop()
                    print("Se autorizó las notificaciones")
                }
            }*/
        
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
                
                let user_temp = dbase.loadUsersDB()
                
                if user_temp.error == 1 {
                    
                    ws.loadAgencies(success: {
                        (agencies) -> Void in
                        
                        do{
                            try self.db.execute("DELETE FROM agencias;")
                            try self.db.execute("DELETE FROM notificaciones;")
                            try self.db.execute("DELETE FROM cuentas;")
                            try self.db.execute("DELETE FROM cuenta_detalle;")
                            try self.db.execute("DELETE FROM facturas;")
                            try self.db.execute("DELETE FROM deudas;")
                            try self.db.execute("DELETE FROM tramites;")
                            try self.db.execute("DELETE FROM pagos;")
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
                    
                    self.navigateToApp()
                }
                
    
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
        
        
        indicadorView.isHidden = true
        //self.db = nil
        
        
    }
    
       
    
    
    @IBAction func logIn(_ sender: Any) {
        
        self.view.endEditing(true)
        let user_name = user_txt.text!.trimmingCharacters(in: .whitespaces)
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
            self.indicadorView.isHidden = false
            self.spin.startAnimating();
            //let usr_encrypt = user_name;
            //let pass_encrypt = pass;
            
            print("usuario: \(user_name) , contraseña: \(pass)")
            
            
            self.user_txt.text = ""
            //self.pass_txt.text = ""
            
            self.complete = false
            self.error = true
            
            ws.loadUser(usr_id: user_name, pass: pass, success: {
                (value,user) -> Void in
                DispatchQueue.main.async {
                    print("entra en success: \(value) , \(user)")
                    self.user_in = user
                    self.user_in.email = user_name
                    //Autentica usuario en firebase
                    /*Auth.auth().signIn(withEmail: user_name, password: pass) { (user, error) in
                        // ...
                    }
                    //Crea usuario en firebase
                    Auth.auth().createUser(withEmail: user_name, password: pass) { (authResult, error) in */
                    //Autentica usuario en firebase
                    //Auth.auth().signIn(withEmail: user_name, password: pass) { (user_r, error) in
                    
                    /*Auth.auth().signIn(withEmail: user_name, password: pass) { (user_r, error) in
                        if error != nil{
                            print("Error generado al autenticar usuario en firebase: \(error)")
                        }else{
                            print("Usuario logoneado en firebase: \(user_r?.user.uid)")
                        }
                    }*/
                    self.syncAllDataInit()
                }
            }, error: {
                (value,user) -> Void in
                DispatchQueue.main.async {
                    self.spin.stopAnimating()
                    self.indicadorView.isHidden = true
                    
                    print("entra en error: \(value) , \(user)")
                    if(value == 2){
                        self.txt_alert = "Falta de confirmar su cuenta de correo electrónico, desea reenviar el correo de confirmación?"
                        self.re_confirm = true
                        
                    }else if( value == 3){
                        self.txt_alert = "Usuario no registrado"
                        self.re_confirm = false
                    }else{
                        self.txt_alert = "Usuario o Contraseña Inválidos"
                        self.re_confirm = false
                    }
                    //self.error = true
                    //self.complete = true
                    print("sale en error: \(value) , \(user)")
                    print("entra en alerta")
                    self.showAlert()
                }
                
            })
            
        }
    }
    
    
    func syncAllDataInit(){
        
        self.ws.loadNotifications(id_user: String(describing: self.user_in.id_user), date: self.user_in.sync_date,
                            success: {
                                (notifications) -> Void in
                                print("ok notificacion")
                                self.text_spin.text = " Procesando Datos: Notificaciones"
                                DispatchQueue.main.async {
                                    self.dbase.insertNotifications(notificationsList: notifications as! [notification])
                                    }
                            },error: {
                                (accounts,message) -> Void in
                                self.txt_alert = message;
                                self.showAlert();
                            })
        
        self.ws.loadAcounts(id_user: String(describing: self.user_in.id_user), date: self.user_in.sync_date,
                            success: {
                                (accounts) -> Void in
                                DispatchQueue.main.async {
                                    self.text_spin.text = " Procesando Datos: Cuentas"
                                    self.dbase.insertAccounts(accounts: accounts as! [account])
                                    self.syncAllDataCore(accounts: accounts as! [account])
                                }
                                
                            },error: {
                                (accounts,message) -> Void in
                                self.spin.stopAnimating()
                                self.indicadorView.isHidden = true
                                self.txt_alert = message;
                                self.showAlert();
                            })
        
    }
    
    func syncAllDataCore( accounts: [account]){
        for item in accounts{
            self.text_spin.text = " Procesando Datos: Cuentas - \(item.alias)"
        }
        self.ws.loadCore(id_user: String(describing: self.user_in.id_user), accounts: accounts,
                                  success: {
                                    (notifications) -> Void in
                                    print("ok load core")
                                    self.spin.stopAnimating()
                                    self.indicadorView.isHidden = true
                                    
                                    self.dbase.insertUserLogin(user_in: self.user_in)
                                    
                                    DispatchQueue.main.async {
                                        self.navigateToApp()
                                    }
                                    
                                    
        },error: {
            (accounts,message) -> Void in
            self.spin.stopAnimating()
            self.indicadorView.isHidden = true
            
            self.txt_alert = message;
            
            do{
                try self.db.execute("DELETE FROM usuarios_logeados;")
                try self.db.execute("DELETE FROM notificaciones;")
                try self.db.execute("DELETE FROM cuentas;")
                try self.db.execute("DELETE FROM cuenta_detalle;")
                try self.db.execute("DELETE FROM facturas;")
                try self.db.execute("DELETE FROM deudas;")
                try self.db.execute("DELETE FROM tramites;")
                try self.db.execute("DELETE FROM pagos;")
                print("Se vacio la tabla agenicas correctamente")
            }catch let Result.error(message, code, statement){
                print("mensaje: \(message), codigo: \(code), statment: \(String(describing: statement)) ")
            }catch {
                print(error)
            }
            
            self.showAlert();
            
        })
        
    }
    
    
    @IBAction func resetPass(_ sender: Any) {
        txt_alert = " Recuperar Contraseña para usuario:" + user_txt.text!;
        self.showAlert();
        notificationPop(title: "Recuperar Contraseña", subtitle: "sbtitulo", body: "prueba de notificacion")
        
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
        }
        let btn_acept = UIAlertAction(title: "Aceptar", style: .default) { (UIAlertAction) in
            
            self.ws.reSendEmail(email: self.user_txt.text!,
                             success: {
                                (message) -> Void in
                                print(message)
                                notificationPop(title: "INTERAGUA", subtitle: "Cofirmación de Email", body: "Se reenvio el correo de confirmación. Por favor ingrese a su correo y active su cuenta para tener acceso a la aplicación")
                                self.setValues()
                            },error: {
                                (message) -> Void in
                                print(message)
                                self.setValues()
                            })
            
            print("reenvio de correo")
        }
        let btn_cancel = UIAlertAction(title: "Cancelar", style: .destructive) { (UIAlertAction) in
            self.setValues()
        }
        
        if re_confirm {
            alert.addAction(btn_cancel);
            alert.addAction(btn_acept);
        }else{
            alert.addAction(btn_alert);
        }
        
        self.present(alert, animated: true, completion: nil);
    }
    
    func setValues(){
        self.pass_txt.text = ""
    }
    
    private func navigateToApp(){
        let mainTabViewController = self.storyboard?.instantiateViewController(withIdentifier: "mainTabViewController") as! MainTabViewController
        self.present(mainTabViewController, animated: true, completion: nil)
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



