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
    
    @IBOutlet weak var user_txt: UITextField!
    @IBOutlet weak var pass_txt: UITextField!
    @IBOutlet weak var btn_in: UIButton!
    @IBOutlet weak var btn_reg: UIButton!
    var txt_alert=""
    var user = UserDB(id: nil, name: nil, email: nil, identifier: nil, addresss: nil, telephone: nil, contract: nil, pass: nil )
    
    let status: Bool = false
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
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func fromRegisterView( segue: UIStoryboardSegue!){
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "login_register" {
            let login = segue.destination as! RegisterController
            login.db = self.db
        }
    }
    
    //se ejecuta despues de dibujar el view
    // print(string) -> imprime en consola el dato
    override func viewDidLoad() {
        super.viewDidLoad();
        btn_in.layer.cornerRadius = 20
        btn_in.clipsToBounds = true
        btn_reg.layer.cornerRadius = 20
        btn_reg.clipsToBounds = true
        btn_reg.layer.borderWidth = 1
        btn_reg.layer.borderColor = UIColor(red:28/255, green:81/255, blue:221/255, alpha: 1).cgColor
        // Do any additional setup after loading the view, typically from a nib.
        
        let status = self.connect_db()
        if( status ){
            let status_t = self.createTables()
            if(status_t){
                self.btn_in.isEnabled = true
                self.btn_reg.isEnabled = true
                self.printAllUsers()
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
    
    //creo conexion a la base
    func connect_db() -> Bool{
        do{
            let directoryBase = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let file_db = directoryBase.appendingPathComponent("altura").appendingPathExtension("sqlite3")
            
            let database = try Connection(file_db.path)
            self.db = database
            return true
        }catch{
            print(error)
            return false
        }
    }
    
    func createTables() -> Bool{
        var ok = true
        
        print("Creando tablas ..")
        let createTableUsers = self.usersT.create { (table) in
            table.column(self.id_usersT, primaryKey: .autoincrement)
            table.column(self.name_userT)
            table.column(self.email_user_T, unique: true)
            table.column(self.identifier_user_T)
            table.column(self.address_user_T)
            table.column(self.telephone_user_T)
            table.column(self.contract_user_T)
            table.column(self.password_user_T)
        }
        
        do{
            try self.db.run(createTableUsers)
            print("Tabla creada")
        }catch let Result.error(message, code, statement){
            if( code == 1){
                print("tabla ya existe")
            }else{
                ok = false
                print(" * constraint failed: \(message), in \(statement) , code \(code)")
            }
        }catch{
            ok = false
            print(error)
        }
        
        return ok
    }
    
    @IBAction func logIn(_ sender: Any) {
        let user_name = user_txt.text!
        let pass = pass_txt.text!
        if(user_name != "" && pass != ""){
            let ok = self.loadUsers(usr_id: user_name, pass: pass)
            //let ok = self.loadUsersDB(usr: user_name, pass: pass)
            if(ok == 2){
                txt_alert = "Usuario o Contraseña Inválidos"
                self.showAlert();
            }else if( ok == 3){
                txt_alert = "Usuario no registrado"
                self.showAlert();
            }else if( ok == 4){
                txt_alert = "Error.."
                self.showAlert();
            }else{
                // entra e la app
                navigateToApp()
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
    
    @IBAction func optionThree(_ sender: Any) {
        txt_alert = "Opcion 3";
        self.showAlert();
    }
    @IBAction func optionFour(_ sender: Any) {
        txt_alert = "Opcion 4";
        self.showAlert();
    }
    
    //Cargar usuario mediante DB
    func loadUsersDB(usr:String , pass:String) -> Int {
        
        let sql = self.usersT.select(id_usersT,name_userT,email_user_T,identifier_user_T,address_user_T,telephone_user_T,contract_user_T,password_user_T)
            .filter(email_user_T == usr)
        do{
            let request = Array(try self.db.prepare(sql))
            //print(request)
            if(request.count > 0){
                for us in request {
                    do {
                        print("name: \(try us.get(id_usersT))")
                        self.user.id = try us.get(id_usersT)
                        self.user.addresss = try us.get(address_user_T)
                        self.user.contract = try us.get(contract_user_T)
                        self.user.email = try us.get(email_user_T)
                        self.user.identifier = try us.get(identifier_user_T)
                        self.user.name = try us.get(name_userT)
                        self.user.telephone = try us.get(telephone_user_T)
                        self.user.pass = try us.get(password_user_T)
                        
                    } catch {
                        print(error)
                        return 4
                    }
                }
                if (self.user.pass == pass){
                    return 1 //usuario existe y esta correcto
                }else{
                    return 2 // contraseña incorrecta
                }
                
            }else{
                return 3 // usuario no existe
            }
            
        }catch{
            print(error)
        }
        
        return 1
    }
    
    
    //funcion para cargar todos los usuarios mediante webservices json
    func loadUsers(usr_id:String , pass: String) -> Int{
        print("entra en load user")
        
        let jsn_url = "http://54.86.88.196/aclientTest/e?q=action%3Dlogin%26mail%3D\(usr_id)%26pass%3D\(pass)%26os_type%3D1%26imei%3D111"
        
        
        guard let url = URL(string: jsn_url)
            else{return 4}
        print(url)
        
        var req = 4;
        
        //con sem detengo toda la aplicacion hasta que  termine la funcion que contiene sem.signal() , esto no puede ser util si  se depende de internet ya que detendria todo y se quedara congelado
        //let sem = DispatchSemaphore(value: 0)
        
        URLSession.shared.dataTask(with: url){ (data , response ,err ) in
            
            guard let data = data else {return}
            
            let dataAsString = String(data: data, encoding: .utf8)
            // print(dataAsString)
            
            do{
                let user =  try JSONDecoder().decode(User.self, from: data)
                print(user.person as Any)
                if((user.status) != nil && user.status! > 0){
                    
                    if(user.status == 1 ){
                        req = 2
                        //self.txt_alert = "Cuenta no validada mediante correo"
                    }else{
                        req = 1
                        //self.txt_alert = "usuario:"+user.person!
                    }
                    
                }else{
                    req = 3
                    //self.txt_alert = "El usuario no existe"
                }
                
                /*
                 // swift 2/3/objetice C
                 let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
                 print(json)
                 */
            }catch let errJson {
                print(errJson);
                req = 4
                //self.txt_alert = "El usuario no existe"
            }
            //sem.signal()
            
            }.resume()
        
        //sem.wait()
        
        sleep(4)
        return req
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
    
    
    //imprime todos los usuarios registrados
    func printAllUsers(){
        print("entra todos usuarios")
        do{
            for user in try db.prepare(usersT) {
                print("id: \(user[id_usersT]), email: \(user[email_user_T]), name: \(user[name_userT]),  pass: \(user[password_user_T])")
                // id: 1, email: alice@mac.com, name: Optional("Alice")
            }
        }catch{
            print("error whi")
            print(error)
        }
    }
    
    private func navigateToApp(){
        let mainNavigationController = self.storyboard?.instantiateViewController(withIdentifier: "mainNavigationController") as! MainNavigationController
        self.present(mainNavigationController, animated: true, completion: nil)
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

