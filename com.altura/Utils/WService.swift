//
//  WService.swift
//  com.altura
//
//  Created by adrian aguilar on 6/6/18.
//  Copyright © 2018 Altura S.A. All rights reserved.
//

import Foundation

class WService {
    let url_master = "http://54.86.88.196/aclientAES/w?c&q=";
    var user_in = User(id_user: 0, document: "", person: "", email: "", phone: "", sync_date: "", adress: "", status: 0, error: "")
    
    let key = "Altura"
    let iv = "gqLOHUioQ0QjhuvI"
    
    //funcion para cargar todo mediante webservices json
    func loadUser(usr_id:String , pass: String, success: @escaping (_ value:Int, _ user:User) -> Void, error: @escaping (_ value:Int,_ user:User) -> Void ){
        print("entra en load user")
        let n_key = key.md5()
        
        user_in = User(id_user: 0, document: "", person: "", email: "", phone: "", sync_date: "", adress: "", status: 0, error: "")
        
        let url_part = "action=login&mail=\(usr_id)&pass=\(pass)&os=2&imei=111"
        //let url_part = "{\"sync_date\":\"2018-07-25 10:35:50\",\"phone\":\"\",\"person\":\"Mi Nombre\",\"document\":\"0000000000\",\"adress\":\"Mi dirección\",\"id_user\":22,\"status\":2}"
        let encode = try! url_part.aesEncrypt(key: n_key, iv: iv)
        
        print("codificado: \(encode)")
        let a_deco = "6Et4NJTliocEoSKYwBMxBA2IPrfkRA2GOypIbLLBDuNU28thbPFk8ewob/CdG7iQYoz7fBDFw3wxKFA9w9gXtTRp43ZRCJTmzJb5eqADRDA6fGf5YvzTbofF7SnSG1xS9CaIE868Ekhj54R3G73ZXYqzKaNALzepquuDHuAGMaYl2dHIsJ5JYQ84OqXXVMTq"
        let deco = try! a_deco.aesDecrypt(key: n_key, iv: iv)
        print("decodificado: \(deco)")
        let jsn_url = url_master + (encode.urlEncode() as String)
        
        print(jsn_url)
        
        guard let url = try? URL(string: jsn_url) else {
            error(4,self.user_in)
        }
        
        
        var req = 4;
        
        //con sem detengo toda la aplicacion hasta que  termine la funcion que contiene sem.signal() , esto no puede ser util si  se depende de internet ya que detendria todo y se quedara congelado
        //let sem = DispatchSemaphore(value: 0)
        
        
        URLSession.shared.dataTask(with: url!){ (data , response ,err ) in
                
                print("entra en shared")
                
                guard let data = data else {return error(4,self.user_in)}
                
                //print("datos: \(data.base64EncodedString())")
                // let dataAsString = String(data: data, encoding: .utf8)
                // print(dataAsString)
                
                do{
                    guard let data_received = String(data: data, encoding: .utf8) else{ return error(4,self.user_in) }
                    print("data received: \(data_received)")
                    
                    let data_text = "6Et4NJTliocEoSKYwBMxBA2IPrfkRA2GOypIbLLBDuNU28thbPFk8ewob/CdG7iQYoz7fBDFw3wxKFA9w9gXtTRp43ZRCJTmzJb5eqADRDA6fGf5YvzTbofF7SnSG1xS9CaIE868Ekhj54R3G73ZXYqzKaNALzepquuDHuAGMaYl2dHIsJ5JYQ84OqXXVMTq"
                    let data2 = try! data_text.aesDecrypt(key: n_key, iv: self.iv)
                    print("datos decript \(data2)")
                    let user =  try JSONDecoder().decode(User.self, from: data2.data(using: .utf8)!)
                    print("usuario en funcion: \(user)")
                    //print(user.person as Any)
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
    
}
