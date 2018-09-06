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
    
    var user = User.init(id_user: 0, document: "", person: "", email: "", phone: "", sync_date: "", adress: "", status: 1, error: 1)
    
    var contratos = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        let status = dbase.connect_db()
        if( status.value ){
            print("entra a buscar usuario")
            user = self.dbase.loadUsersDB()
        }
        
        // Do any additional setup after loading the view.
    }

    @IBAction func Next(_ sender: UIButton) {
        
        let cedula = self.id.text?.trimmingCharacters(in: .whitespaces)
        let contrato = self.number.text?.trimmingCharacters(in: .whitespaces)
        let  ok = verificarCedula(cedula: cedula!)
        
        if cedula != "" && contrato != "" && ok{
            
            if user.error == 0 {
                ws.searchService(user: "\(user.id_user)", id: cedula!, service: contrato!, success: {
                    (status,message) -> Void in
                    print("ok service")
                    if status == 1{
                        
                    }else{
                        print(message)
                    }
                }, error: {
                    (message) -> Void in
                    print("error service: \(message)")
                })
            }
            
        }else{
            if cedula == ""{
                self.err_id.text = "Por favor igrese la cédula o RUC"
            }else if !ok{
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
        
        self.view1.isHidden = true
        self.view2.isHidden = false
        
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
        dismiss(animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1 //self.contratos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("customTableTableViewCell5", owner: self, options: nil)?.first as! customTableTableViewCell5
        
        cell.n_contrato.text = "asd"
        cell.usuario.text = "asdd"
        cell.direccion.text = "asddd"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("selected", indexPath.row)
        
        if tableView.cellForRow(at: indexPath)?.accessoryType == UITableViewCellAccessoryType.checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCellAccessoryType.none
        }else{
            tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCellAccessoryType.checkmark
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
}
