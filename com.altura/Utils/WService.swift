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
                    if((user.status) != nil && user.status! > 0){
                        self.user_in = user
                        print("usuario en funcion despues de if: \(user)")
                        if(user.status == 1 ){
                            req = 2
                            error(req,self.user_in)
                            //self.txt_alert = "Cuenta no validada mediante correo"
                        }else{
                            req = 1
                            success(req,self.user_in)
                            //self.txt_alert = "usuario:"+user.person!
                        }
                        
                    }else{
                        req = 3
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
                    error(req,self.user_in)
                    //self.txt_alert = "El usuario no existe"
                }
                //sem.signal()
                
                }.resume()
    
        
        //sem.wait()
        
        //sleep(4)
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
                        
                        let place_temp = place.init(name: val[1] as! String, street: val[2] as! String, attention: val[6] as! String, coordinate: CLLocationCoordinate2D(latitude: Double(val[4] as! String)!, longitude: Double(val[5] as! String)!), selected: false)
                        
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
