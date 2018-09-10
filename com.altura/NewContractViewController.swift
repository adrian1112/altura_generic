//
//  NewContractViewController.swift
//  com.altura
//
//  Created by adrian aguilar on 4/7/18.
//  Copyright © 2018 Altura S.A. All rights reserved.
//

import UIKit
import SQLite

class NewContractViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let ws = WService()
    let dbase = DBase();
    var db: Connection!

    @IBOutlet weak var id: UITextField!
    @IBOutlet weak var number: UITextField!
    
    @IBOutlet weak var err_id: UILabel!
    @IBOutlet weak var err_number: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var aliasText: UITextField!
    
    
    @IBOutlet weak var view1: UIView!
    @IBOutlet weak var view2: UIView!
    
    
    @IBOutlet weak var spin: UIActivityIndicatorView!
    @IBOutlet weak var spinView: UIView!
    
    var user = User.init(id_user: 0, document: "", person: "", email: "", phone: "", sync_date: "", adress: "", status: 1, error: 1)
    
    var contratos = [detailContract]()
    
    var accounts = [account]()
    
    //var ok = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        let status = dbase.connect_db()
        if( status.value ){
            print("entra a buscar usuario")
            user = self.dbase.loadUsersDB()
            
            
        }
        
        self.spinView.isHidden = true
        
        /*
         funcion para eliminar cuenta
        self.ws.deleteService(id: user.id_user, service: "447732",
                         success: {
                            (message) -> Void in
                            print("eliminado \(message)")
                            
                            },error: {
                                (message) -> Void in
                                print("eliminado err \(message)")
                            })*/
        
        // Do any additional setup after loading the view.
    }

    @IBAction func Next(_ sender: UIButton) {
        print("next")
        self.view.endEditing(true)
        
        DispatchQueue.main.async {
            self.spin.startAnimating()
            self.spinView.isHidden = false
        }
        
        
        let cedula = self.id.text?.trimmingCharacters(in: .whitespaces)
        let contrato = self.number.text?.trimmingCharacters(in: .whitespaces)
        let  ok_ced = verificarCedula(cedula: cedula!)
        
        if cedula != "" && contrato != "" && ok_ced{
            
            if user.error == 0 {
                
                DispatchQueue.global(qos: .background).async
                    {
                        self.loadDataTable(cedula: cedula!, contrato: contrato!)
                }
                
            }
            
        }else{
            if cedula == ""{
                self.err_id.text = "Por favor igrese la cédula o RUC"
            }else if !ok_ced{
                self.err_id.text = "Por favor igrese un número de cédula o RUC correcto"
            }else{
                self.err_id.text = ""
            }
            if contrato == ""{
                self.err_number.text = "Por favor igrese el número de contrato"
            }else{
                self.err_number.text = ""
            }
            
        }
    }
    
    func loadDataTable(cedula: String, contrato: String){
        ws.searchService(user: "\(user.id_user)", id: cedula, service: contrato,
            success: {
            (status,list_contract,message) -> Void in
                print("ok service")
                if status == 1{
                    self.contratos = list_contract
                    self.tableView.reloadData()
    
                    self.view1.isHidden = true
                    self.view2.isHidden = false
    
                    self.err_number.text = ""
                    self.err_id.text = ""
    
                }else{
                //self.ok = false
                    print(message)
                }
            },
        error: {
            (message) -> Void in
            print("error service: \(message)")
    
            })
        
        DispatchQueue.main.async {
            self.spin.stopAnimating()
            self.spinView.isHidden = true
        }
    }
    
    @IBAction func exit(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    //HABILITA LA OPCION DE OCULTAR EL TECLADO CUANDO SE LE DA EN CUALQUIER PARTE DE LA PANTALLA
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func `return`(_ sender: Any) {
        self.view1.isHidden = false
        self.view2.isHidden = true
        
    }
    
    @IBAction func save(_ sender: Any) {
        print("accion guardar")
        
        var list_selected = [detailContract]()
        for item in contratos {
            if item.status {
                list_selected.append(item)
            }
        }
        if list_selected.count > 0{
            
            if aliasText.text?.trimmingCharacters(in: .whitespaces) != "" {
                
                for item in list_selected{
                    let id_usuario = self.user.id_user
                    let alias = aliasText.text?.trimmingCharacters(in: .whitespaces)
                    let documento = item.identificacion_benef
                    let num_contrato = item.id_contrato
                    //let now = getDate()
                    //verificar si se encuentra en la base
                    
                    self.spin.startAnimating()
                    self.spinView.isHidden = false
                    
                    self.accounts = self.dbase.getAccounts()
                    var update = false
                    for item_ac in self.accounts{
                        if item_ac.service == num_contrato{
                            update = true
                        }
                    }
                    
                    
                    if update{
                        print("entra en actualizar servicio")
                        let ok = self.dbase.updateAccount(account: num_contrato, alias: alias!)
                        self.ws.updateService(id: id_usuario, alias: alias!, service: num_contrato, success:{
                            (message) -> Void in
                            print(message)
                            
                            if ok{
                                let ok2 = self.dbase.deleteDetaillsAccount(account: num_contrato)
                                //vuelve a consultar los detalles de la cuenta actualizada
                                if ok2{
                                    
                                    let new_account = account.init(service: num_contrato, alias: alias!, document: documento, date_sync: message)
                                    
                                    self.ws.loadCore(id_user: String(describing: self.user.id_user), accounts: [new_account],
                                                     success: {
                                                        (notifications) -> Void in
                                                        print("ok load core")
                                                        
                                                        DispatchQueue.main.async {
                                                            self.spin.stopAnimating()
                                                            self.spinView.isHidden = true
                                                            
                                                            
                                                            let mainTabViewController = self.storyboard?.instantiateViewController(withIdentifier: "mainTabViewController") as! MainTabViewController
                                                            self.present(mainTabViewController, animated: true, completion: nil)
                                                        }
                                                        
                                                        
                                    },error: {
                                        (accounts,message) -> Void in
                                        print("error \(message)")
                                        
                                        self.spin.stopAnimating()
                                        self.spinView.isHidden = true
                                    })
                                }
                            }
                            
                 
                            
                        }, error:{
                            (message) -> Void in
                            print(message)
                            self.spin.stopAnimating()
                            self.spinView.isHidden = true
                        })
                        
                    }else{
                        print("entra en ingresar servicio")
                        ws.addService(id: id_usuario,document: documento, alias: alias!, service: num_contrato, success:{
                            (message) -> Void in
                            print(message)
                            
                            // agregar la sincronización del core
                            let new_account = account.init(service: num_contrato, alias: alias!, document: documento, date_sync: message)
                            
                            self.dbase.insertAccounts(accounts: [new_account] as! [account])
                            
                            self.ws.loadCore(id_user: String(describing: self.user.id_user), accounts: [new_account],
                                             success: {
                                                (notifications) -> Void in
                                                print("ok load core")
                                                
                                                DispatchQueue.main.async {
                                                    
                                                    self.spin.stopAnimating()
                                                    self.spinView.isHidden = true
                                                    
                                                    let mainTabViewController = self.storyboard?.instantiateViewController(withIdentifier: "mainTabViewController") as! MainTabViewController
                                                    self.present(mainTabViewController, animated: true, completion: nil)
                                                }

                            },error: {
                                (accounts,message) -> Void in
                                
                                print("error \(message)")
                                self.spin.stopAnimating()
                                self.spinView.isHidden = true
                            })
                            //self.syncAllDataCore(accounts: [new_account] as! [account])
                            
                            
                        }, error:{
                            (message) -> Void in
                            print(message)
                            self.spin.stopAnimating()
                            self.spinView.isHidden = true
                        })
                        
                    }
                    
                    print(item)
                    self.spin.stopAnimating()
                    self.spinView.isHidden = true
                    
                }
                
            }else{
                showAlert(message: "Por favor ingrese un Alias para el contrato")
            }
        }else{
            showAlert(message: "Por favor seleccione un contrato")
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.contratos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("customTableTableViewCell5", owner: self, options: nil)?.first as! customTableTableViewCell5
        
        cell.n_contrato.text = self.contratos[indexPath.row].id_contrato
        cell.usuario.text = self.contratos[indexPath.row].nombre_beneficiario
        cell.direccion.text = self.contratos[indexPath.row].direccion_tradicional
        
        if indexPath.row == 0{
            cell.accessoryType = UITableViewCellAccessoryType.checkmark
            contratos[indexPath.row].status = true
        }else{
            cell.accessoryType = UITableViewCellAccessoryType.none
            contratos[indexPath.row].status = false
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("selected", indexPath.row)
        
        if tableView.cellForRow(at: indexPath)?.accessoryType == UITableViewCellAccessoryType.checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCellAccessoryType.none
        }else{
            tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCellAccessoryType.checkmark
        }
        
        contratos[indexPath.row].status = !contratos[indexPath.row].status
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    //funcion para mostrar alerta
    func showAlert(message: String){
        print("entra a alerta")
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert);
        let btn_alert = UIAlertAction(title: "Aceptar", style: .default) { (UIAlertAction) in
            
        }
        
        alert.addAction(btn_alert);
        self.present(alert, animated: true, completion: nil);
    }
    
}
