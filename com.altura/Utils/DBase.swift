//
//  DBase.swift
//  com.altura
//
//  Created by adrian aguilar on 6/6/18.
//  Copyright © 2018 Altura S.A. All rights reserved.
//

import Foundation
import SQLite

class DBase {
    
    //tabla Usuarios-----------------------------------------------
    let usersT = Table("usuarios")
    let id_usersT = Expression<Int>("id")
    let name_userT = Expression<String>("nombre")
    var email_user_T = Expression<String>("email")
    let identifier_user_T = Expression<String>("cedula")
    let address_user_T = Expression<String>("direccion")
    let telephone_user_T = Expression<String>("telefono")
    let contract_user_T = Expression<String>("contrato")
    let password_user_T = Expression<String>("contrasena")
    //tabla usuario logeados--------------------------------------
    let usersLoginT = Table("usuarios_logeados")
    let id_users_l_T = Expression<Int>("id")
    let person_l_T = Expression<String>("persona")
    var email_l_T = Expression<String>("email")
    let date_l_T = Expression<String>("fecha_ingreso")
    
    var db: Connection!
    
    //creo conexion a la base
    func connect_db() -> (value:Bool, conec:Connection){
        do{
            let directoryBase = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let file_db = directoryBase.appendingPathComponent("altura").appendingPathExtension("sqlite3")
            
            let database = try Connection(file_db.path)
            self.db = database
            return (true,db)
        }catch{
            print(error)
            return (false,db)
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
        
        let createTableUsersLogin = self.usersLoginT.create { (table) in
            table.column(self.id_users_l_T)
            table.column(self.person_l_T)
            table.column(self.email_l_T)
            table.column(self.date_l_T)
        }
        
        do{
            try self.db.run(createTableUsers)
            print("Tabla creada")
        }catch let Result.error(message, code, statement){
            if( code == 1){
                print("tabla ya existe")
            }else{
                ok = false
                print(" * constraint failed: \(message), in \(String(describing: statement)) , code \(code)")
            }
        }catch{
            ok = false
            print(error)
        }
        
        do{
            try self.db.run(createTableUsersLogin)
            print("Tabla creada")
        }catch let Result.error(message, code, statement){
            if( code == 1){
                print("tabla ya existe")
            }else{
                ok = false
                print(" * constraint failed: \(message), in \(String(describing: statement)) , code \(code)")
            }
        }catch{
            ok = false
            print(error)
        }
        
        return ok
    }
    
    //Cargar usuario mediante DB
    func loadUsersDB(usr:String , pass:String) -> Int {
        var user = UserDB();
        
        let sql = self.usersT.select(id_usersT,name_userT,email_user_T,identifier_user_T,address_user_T,telephone_user_T,contract_user_T,password_user_T)
            .filter(email_user_T == usr)
        do{
            let request = Array(try self.db.prepare(sql))
            //print(request)
            if(request.count > 0){
                for us in request {
                    do {
                        print("name: \(try us.get(id_usersT))")
                        user.id = try us.get(id_usersT)
                        user.addresss = try us.get(address_user_T)
                        user.contract = try us.get(contract_user_T)
                        user.email = try us.get(email_user_T)
                        user.identifier = try us.get(identifier_user_T)
                        user.name = try us.get(name_userT)
                        user.telephone = try us.get(telephone_user_T)
                        user.pass = try us.get(password_user_T)
                        
                    } catch {
                        print(error)
                        return 4
                    }
                }
                if (user.pass == pass){
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
    
    //inserta en base el usuario logeado
    func inserUserLogin(user_in:User){
        print("entra log")
        print("usuario: \(String(describing: user_in.id_user)) ,email: \(String(describing: user_in.email)), persona: \(String(describing: user_in.person)), fecha: \(String(describing: user_in.sync_date))")
        
        let insertUser_l = usersLoginT.insert(self.id_users_l_T <- user_in.id_user!,self.email_l_T <- user_in.email!, self.person_l_T <- user_in.person!, self.date_l_T <- user_in.sync_date!)
        do{
            try self.db.run(insertUser_l)
            print("Se ingreso el usuario log correctamente")
        }catch let Result.error(message, code, statement){
            print("mensaje: \(message), codigo: \(code), statment: \(String(describing: statement)) ")
        }catch {
            print(error)
        }
        
        
    }
    
    //imprime todos los usuarios registrados
    func printAllUsers(){
        print("muestra todos usuarios")
        do{
            for user in try db.prepare(usersT) {
                print("id: \(user[id_usersT]), email: \(user[email_user_T]), name: \(user[name_userT]),  pass: \(user[password_user_T])")
                // id: 1, email: alice@maVc.com, name: Optional("Alice")
            }
        }catch{
            print("error whi")
            print(error)
        }
        
        print("muestra todos logins")
        do{
            for user in try db.prepare(usersLoginT) {
                print("id: \(user[id_users_l_T]), email: \(user[email_l_T]), name: \(user[person_l_T]),  date: \(user[date_l_T])")
                // id: 1, email: alice@mac.com, name: Optional("Alice")
            }
        }catch{
            print("error whi")
            print(error)
        }
    }
    
}
