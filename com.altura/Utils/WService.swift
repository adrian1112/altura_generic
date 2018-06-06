//
//  WService.swift
//  com.altura
//
//  Created by adrian aguilar on 6/6/18.
//  Copyright © 2018 Altura S.A. All rights reserved.
//

import Foundation

class WService {
    let url_master = "http://54.86.88.196/";
    var user_in = User(id_user: 0, document: "", person: "", email: "", phone: "", sync_date: "", adress: "", status: 0, error: "")
    
    //funcion para cargar todo mediante webservices json
    func loadUser(usr_id:String , pass: String) -> (value:Int, user:User){
        print("entra en load user")
        
        let jsn_url = "\(url_master)aclientTest/e?q=action%3Dlogin%26mail%3D\(usr_id)%26pass%3D\(pass)%26os_type%3D1%26imei%3D111"
        
        print(jsn_url)
        
        guard let url = URL(string: jsn_url)
            else{return (5,self.user_in)}
        
        var req = 4;
        
        //con sem detengo toda la aplicacion hasta que  termine la funcion que contiene sem.signal() , esto no puede ser util si  se depende de internet ya que detendria todo y se quedara congelado
        //let sem = DispatchSemaphore(value: 0)
        
        URLSession.shared.dataTask(with: url){ (data , response ,err ) in
            
            guard let data = data else {return}
            
            // let dataAsString = String(data: data, encoding: .utf8)
            // print(dataAsString)
            
            do{
                let user =  try JSONDecoder().decode(User.self, from: data)
                //print(user.person as Any)
                if((user.status) != nil && user.status! > 0){
                    self.user_in = user
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
        
        //sleep(4)
        print(req)
        return (req,self.user_in)
    }
    
}
