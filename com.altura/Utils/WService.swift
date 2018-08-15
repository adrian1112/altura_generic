//
//  WService.swift
//  com.altura
//
//  Created by adrian aguilar on 6/6/18.
//  Copyright © 2018 Altura S.A. All rights reserved.
//

import Foundation
import GoogleMaps

class WService {
    let url_master = "http://54.86.88.196/aclientAES2/w?c&q="
    var user_in = User(id_user: 0, document: "", person: "", email: "", phone: "", sync_date: "", adress: "", status: 0, error: "")
    
    let key = "Altura"
    let iv = "gqLOHUioQ0QjhuvI"
    
    //funcion para cargar todo mediante webservices json
    func loadUser(usr_id:String , pass: String, success: @escaping (_ value:Int, _ user:User) -> Void, error: @escaping (_ value:Int,_ user:User) -> Void ){
        print("entra en load user")
        let n_key = key.md5()
        
        user_in = User(id_user: 0, document: "", person: "", email: "", phone: "", sync_date: "", adress: "", status: 0, error: "")
        
        let url_part = "action=login&mail=\(usr_id)&pass=\(pass)&os=2&imei=111"
        let encode = try! url_part.aesEncrypt(key: n_key, iv: iv)
        
        print("codificado: \(encode)")
        
        let jsn_url = url_master + (encode.urlEncode() as String)
        
        print(jsn_url)
        
        guard let url = try? URL(string: jsn_url) else {
            error(4,self.user_in)
        }
        
        
        var req = 4;

        URLSession.shared.dataTask(with: url!){ (data , response ,err ) in
                
                print("entra en shared")
                
                guard let data = data else {return error(4,self.user_in)}
                
                do{
                    guard let data_received = String(data: data, encoding: .utf8) else{ return error(4,self.user_in) }
                    print("data received: \(data_received)")
                    
                    let data2 = try! data_received.aesDecrypt(key: n_key, iv: self.iv)
                    print("datos decript \(data2)")
                    let user =  try JSONDecoder().decode(User.self, from: data2.data(using: .utf8)!)
                    print("usuario en funcion: \(user)")
                    if( user.status > 0){
                        self.user_in = user
                        print("usuario en funcion despues de if: \(user)")
                        if(user.status == 1 ){
                            req = 2
                            print("retorna error")
                            error(req,self.user_in)
                            //self.txt_alert = "Cuenta no validada mediante correo"
                        }else{
                            req = 1
                            print("retorna success")
                            success(req,self.user_in)
                            //self.txt_alert = "usuario:"+user.person!
                        }
                        
                    }else{
                        req = 3
                        print("retorna error")
                        error(req,self.user_in)
                        //self.txt_alert = "El usuario no existe"
                    }
                    
                    /*
                     // swift 2/3/objetice C
                     let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
                     print(json)
                     */
                }catch let errJson {
                    print(errJson)
                    req = 4
                    print("retorna error catch")
                    error(req,self.user_in)
                    //self.txt_alert = "El usuario no existe"
                }
                //sem.signal()
                
                }.resume()
    
        
        //sem.wait()
        
        //sleep(4)
    }
    
    func loadAcounts(id_user: String, date: String, success: @escaping (_ list: Array<Any>) -> Void, error: @escaping (_ list: Array<Any>, _ message: String) -> Void) {
        let n_key = key.md5()
        let url_part = "action=query&id_query=43&id_user=\(id_user)&fecha=\(date)"
        let encode = try! url_part.aesEncrypt(key: n_key, iv: iv)
        
        var ok = false
        var accounts:[account] = []
        
        print("codificado: \(encode)")
        
        let jsn_url = url_master + (encode.urlEncode() as String)
        print(jsn_url)
        
        guard var url = try? URLRequest(url: NSURL(string: jsn_url) as! URL) else {
            print("error")
            error( accounts,"Error al generar la url")
            
        }
        
        //var request = URLRequest(url: url1)
        //url.httpBody = body
        url.httpMethod = "POST"
        let (data, response, err) = URLSession.shared.synchronousDataTask(urlrequest: url)
        if let error2 = err {
            print("Synchronous task ended with error: \(error)")
            error( accounts,"Error al obtener data: \(error2)")
        }
        else {
            print("Synchronous task ended without errors.")
            //print(data)
            guard let data = data else { return error( accounts,"Error al obtener la data") }
            
            do{
                guard let data_received = String(data: data, encoding: .utf8) else{ return error( accounts,"Error encodign utf8") }
                print("data received: \(data_received)")
                
                let data2 = try! data_received.aesDecrypt(key: n_key, iv: self.iv)
                print("datos decript cuentas \(data2)")
                
                let dictionary: Dictionary<NSObject, AnyObject> = try JSONSerialization.jsonObject(with: data2.data(using: .utf8)!, options: JSONSerialization.ReadingOptions.mutableContainers) as! Dictionary<NSObject, AnyObject>
                
                var date_sync = ""
                var list: NSArray = []
                for (key,value) in dictionary {
                    if key as! String == "sync_date" {
                        date_sync = value as! String
                    }
                    if key as! String == "row"{
                        list = value as! NSArray
                        
                    }
                }
                
                for value in list {
                    let val = value as! NSArray
                    
                    let account_temp = account.init(service: val[0] as! String, alias: val[1] as! String, document: val[2] as! String, date_sync: date_sync )
                    accounts.append(account_temp)
                }
                
                success(accounts)
                
            }catch let errJson {
                print(errJson)
                error( accounts,"Error \(errJson)")
            }
            
        }
        
        
    }
    
    func loadCore(id_user: String, accounts: [account], success: @escaping (_ status: Bool) -> Void, error: @escaping (_ status: Bool, _ message: String) -> Void) {
        let n_key = key.md5()
        
        for accountItem in accounts{
            
            let url_part = "action=querys&id_query=2,3,5,9,48&id_user=\(id_user)&ID_USER=\(id_user)&CONTRATO=\(accountItem.service)&NS=\(accountItem.service)&ID=\(accountItem.document)&os=2"
            let encode = try! url_part.aesEncrypt(key: n_key, iv: iv)
            
            var accounts:[account] = []
            
            print("codificado: \(encode)")
            
            let jsn_url = url_master + (encode.urlEncode() as String)
            print(jsn_url)
            
            guard var url = try? URLRequest(url: NSURL(string: jsn_url) as! URL) else {
                print("error")
                error( false,"Error al generar la url")
                
            }
            
            //var request = URLRequest(url: url1)
            //url.httpBody = body
            url.httpMethod = "POST"
            let (data, response, err) = URLSession.shared.synchronousDataTask(urlrequest: url)
            if let error2 = err {
                print("Synchronous task ended with error: \(error)")
                error( false,"Error al obtener data: \(error2)")
            }else {
                print("Synchronous task ended without errors.")
                //print(data)
                guard let data = data else { return error( false,"Error al obtener la data") }
                
                do{
                    guard let data_received = String(data: data, encoding: .utf8) else{ return error( false,"Error encodign utf8") }
                    print("data received: \(data_received)")
                    
                    let data2 = try! data_received.aesDecrypt(key: n_key, iv: self.iv)
                    print("datos decript cuentas \(data2)")
                    
                    let dictionary: Dictionary<NSObject, AnyObject> = try JSONSerialization.jsonObject(with: data2.data(using: .utf8)!, options: JSONSerialization.ReadingOptions.mutableContainers) as! Dictionary<NSObject, AnyObject>
                    for (keyT,valueT) in dictionary {
                        // query 2  detalles de contratos
                        if keyT as! String == "2" {
                            let data_temp = valueT as! Dictionary<NSObject, AnyObject>
                            var date_sync = ""
                            var list: NSArray = []
                            for (key,value) in data_temp {
                                if key as! String == "sync_date" {
                                    date_sync = value as! String
                                }
                                if key as! String == "row"{
                                    list = value as! NSArray
                                }
                            }
                            for value in list {
                                let val = value as! NSArray
                                let account_temp = account.init(service: val[0] as! String, alias: val[1] as! String, document: val[2] as! String, date_sync: date_sync )
                                //accounts.append(account_temp)
                            }
                            
                            //enviar a guardar el detalle de contratos en la base
                        }
                        // query 3  facturas del contrato
                        if keyT as! String == "3" {}
                        // query 5  detalle de deuda
                        if keyT as! String == "5" {}
                        // query 9  tramites realizados
                        if keyT as! String == "9" {}
                        // query 48  lista de pagos
                        if keyT as! String == "48" {}
                        
                    }
                    var date_sync = ""
                    var list: NSArray = []
                    for (key,value) in dictionary {
                        if key as! String == "sync_date" {
                            date_sync = value as! String
                        }
                        if key as! String == "row"{
                            list = value as! NSArray
                            
                        }
                    }
                    
                    for value in list {
                        let val = value as! NSArray
                        
                        let account_temp = account.init(service: val[0] as! String, alias: val[1] as! String, document: val[2] as! String, date_sync: date_sync )
                        accounts.append(account_temp)
                    }
                    
                    
                    
                }catch let errJson {
                    print(errJson)
                    error( false,"Error \(errJson)")
                }
                
            }
            
            
        }//end for
        
        success(true)
        
        
        
        
        
        
        
        
    }
    
    func loadNotifications(id_user: String, date: String, success: @escaping (_ list: Array<Any>) -> Void, error: @escaping (_ list: Array<Any>, _ message: String) -> Void) {
        let n_key = key.md5()
        
        let url_part = "action=query&id_query=65&id_user=\(id_user)&ID_USER=\(id_user)&FECHA=\(date)"
        let encode = try! url_part.aesEncrypt(key: n_key, iv: iv)
        //2,3,5,9,48
        var notificationsList:[notification] = []
        
        print("codificado: \(encode)")
        
        let jsn_url = url_master + (encode.urlEncode() as String)
        print(jsn_url)
        
        guard var url = try? URLRequest(url: NSURL(string: jsn_url) as! URL) else {
            print("error Notificaciones")
            error( [],"Error al generar la url Notificaciones")
            
        }
        
        //var request = URLRequest(url: url1)
        //url.httpBody = body
        url.httpMethod = "POST"
        let (data, response, err) = URLSession.shared.synchronousDataTask(urlrequest: url)
        if let error2 = err {
            print("Synchronous task ended with error: \(error)")
            error( [],"Error al obtener data: \(error2)")
        }
        else {
            print("Synchronous task ended without errors.")
            //print(data)
            guard let data = data else { return error( [],"Error al obtener la data") }
            
            do{
                guard let data_received = String(data: data, encoding: .utf8) else{ return error( [],"Error encodign utf8") }
                print("data received: \(data_received)")
                
                let data2 = try! data_received.aesDecrypt(key: n_key, iv: self.iv)
                print("datos decript notificaciones \(data2)")
                
                let dictionary: Dictionary<NSObject, AnyObject> = try JSONSerialization.jsonObject(with: data2.data(using: .utf8)!, options: JSONSerialization.ReadingOptions.mutableContainers) as! Dictionary<NSObject, AnyObject>
                
                var date_sync = ""
                var list: NSArray = []
                for (key,value) in dictionary {
                    if key as! String == "sync_date" {
                        date_sync = value as! String
                    }
                    if key as! String == "row"{
                        list = value as! NSArray
                        
                    }
                }
                
                for value in list {
                    let val = value as! NSArray
                    
                    let notification_temp = notification.init(contract: val[0] as! String, type: val[1] as! String, document_code: val[2] as! String, message: val[3] as! String, date_gen: val[4] as! String, date_sync: date_sync)
                    notificationsList.append(notification_temp)
                }
                
                success(notificationsList)
                
            }catch let errJson {
                print(errJson)
                error( [],"Error \(errJson)")
            }
            
        }
        
        
    }
    
    
    func loadAgencies( success: @escaping (_ list: Array<Any>) -> Void, error: @escaping (_ list: Array<Any>, _ message: String) -> Void){
        print("entra en loadagencies")
        let n_key = key.md5()
        
        var places: [place] = []
        
        let url_part="action=query&id_query=60"
        let encode = try! url_part.aesEncrypt(key: n_key, iv: iv)
        
        print("codificado: \(encode)")
        
        let jsn_url = url_master + (encode.urlEncode() as String)
        print(jsn_url)
        
        guard let url = try? URL(string: jsn_url) else {
            error(places, "Error al general la url")
        }
        
        URLSession.shared.dataTask(with: url!){ (data , response ,err ) in
            
            print("entra en shared")
            
            guard let data = data else {return error(places, "data recibida invalida")}
            
            do{
                guard let data_received = String(data: data, encoding: .utf8) else{ return error(places, "data recibida invalida") }
                print("data received: \(data_received)")
                
                let data2 = try! data_received.aesDecrypt(key: n_key, iv: self.iv)
                print("datos decript agencias \(data2)")
                
                //let user =  try JSONDecoder().decode(User.self, from: data2.data(using: .utf8)!)
                let dictionary: Dictionary<NSObject, AnyObject> = try JSONSerialization.jsonObject(with: data2.data(using: .utf8)!, options: JSONSerialization.ReadingOptions.mutableContainers) as! Dictionary<NSObject, AnyObject>
                
                var date_sync = ""
                var list: NSArray = []
                for (key,value) in dictionary {
                    if key as! String == "sync_date" {
                        date_sync = value as! String
                    }
                    if key as! String == "row"{
                        list = value as! NSArray
                    }
                }
                
                print(date_sync)
                
                for value in list {
                    let val = value as! NSArray
                    if val[4] as! String != "-"{
                        
                        let place_temp = place.init(name: val[1] as! String, street: val[2] as! String, attention: val[6] as! String, coordinate: CLLocationCoordinate2D(latitude: Double(val[4] as! String)!, longitude: Double(val[5] as! String)!), selected: false, date_sync: date_sync)
                        
                        places.append(place_temp)
                    }
                }
                
                success(places)
                
            }catch let errJson {
                print(errJson)
                error(places, "data recibida invalida")
                //self.txt_alert = "El usuario no existe"
            }
        }.resume()
        
    }
    
}
