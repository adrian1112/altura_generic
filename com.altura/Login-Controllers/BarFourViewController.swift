//
//  BarFourViewController.swift
//  com.altura
//
//  Created by adrian aguilar on 10/6/18.
//  Copyright © 2018 Altura S.A. All rights reserved.
//

import UIKit
import SQLite
import FirebaseCore
import FirebaseAuth
import FirebaseDatabase

class BarFourViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    weak var activeField: UITextField?
    let dbase = DBase();
    var db: Connection!
    
    //firebase
    //var ref_fb: DatabaseReference!
    
    
    @IBOutlet weak var leftConstrain: NSLayoutConstraint!
    @IBOutlet weak var rigthConstrain: NSLayoutConstraint!
    @IBOutlet weak var blurView: UIVisualEffectView!
    @IBOutlet weak var leftView: UIView!
    
    
    let image_l = UIImage(named: "flecha_izq.png")
    let image_r = UIImage(named: "flecha_der.png")
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    @IBOutlet weak var tableView: UITableView!
    
    var data = [cellData]()
    var notificationsList = [notification]()
    
    var width = 0;
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        
        navigationController?.hidesBarsOnSwipe = false
        //navigationController?.hidesBarsOnTap = true
        navigationController?.hidesBarsWhenKeyboardAppears = false
        
        //setea el contador de badge de notificaciones
        UIApplication.shared.applicationIconBadgeNumber = 0
        
        //Menu
        blurView.layer.cornerRadius = 15
        leftView.layer.shadowColor = UIColor.black.cgColor
        leftView.layer.shadowOpacity = 0.8
        leftView.layer.shadowOffset = CGSize(width: 5, height: 0)
        
        width = Int(self.view.bounds.width)
        rigthConstrain.constant = 0
        
        //self.hiddenMenu()
        
        let status = dbase.connect_db()
        if( status.value ){
            print("entra a buscar detalles de cuenta")
            notificationsList = self.dbase.getNotifications()
            
            var i = 0
            for item in notificationsList{
                print(item)
                i += 1
                var img = UIImage(named: "alerta_mensaje_2"  )
                if(item.type == "1"){
                    img = UIImage(named: "alerta_mensaje_2" )
                }else{
                    img = UIImage(named: "info_mensaje_2" )
                }
                
                data.append(cellData.init(image: img, message: item.message, title: "titulo", date: item.date_gen, service: item.contract))
            }
            if 1>0{
                data = [ cellData.init(image: #imageLiteral(resourceName: "alerta_mensaje"), message: "Interrupción Programada del servicio: A partir del 01/01/1991 se realizarán trabajos en RECINTO POSORJA por trabajo programado. Agradecemos si compresion", title: "INTERRUPCIÓN PROGRAMADA DE SERVICIO", date: "29 Jun", service: ""),cellData.init(image: #imageLiteral(resourceName: "info_mensaje_2"), message: "INTERAGUA,informa que se ha generado en su contrato No.111 -222-3333333 por el valor de USD 15.26 correspondiente a JUNIO de 2018 con fecha de vencimiento 01/01/1991", title: "EMISIÓN DE FACTURA", date: "29 Jun", service: "")]
            }
        }
        
        self.tableView.register(CustomTableViewCell2.self, forCellReuseIdentifier: "customCell")
        self.tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("aparecio las notificaciones")
        hiddenMenu()
        let status = dbase.connect_db()
        if( status.value ){
            print("entra a buscar detalles de cuenta")
            data = []
            notificationsList = self.dbase.getNotifications()
            
            var i = 0
            for item in notificationsList{
                print(item)
                i += 1
                var img = UIImage(named: "alerta_mensaje_2"  )
                if(item.type == "1"){
                    img = UIImage(named: "alerta_mensaje_2" )
                }else{
                    img = UIImage(named: "info_mensaje_2" )
                }
                
                data.append(cellData.init(image: img, message: item.message, title: "titulo", date: item.date_gen, service: item.contract))
            }
            if 1>0{
                data = [ cellData.init(image: #imageLiteral(resourceName: "alerta_mensaje"), message: "Interrupción Programada del servicio: A partir del 01/01/1991 se realizarán trabajos en RECINTO POSORJA por trabajo programado. Agradecemos si compresion", title: "INTERRUPCIÓN PROGRAMADA DE SERVICIO", date: "29 Jun", service: ""),cellData.init(image: #imageLiteral(resourceName: "info_mensaje_2"), message: "INTERAGUA,informa que se ha generado en su contrato No.111 -222-3333333 por el valor de USD 15.26 correspondiente a JUNIO de 2018 con fecha de vencimiento 01/01/1991", title: "EMISIÓN DE FACTURA", date: "29 Jun", service: "")]
            }
            
            self.tableView.reloadData()
        }
    }
    
    @IBAction func menuActions(_ sender: Any) {
        
        if(self.rigthConstrain.constant == 0){
            self.showMenu()
        }else{
            self.hiddenMenu()
        }
        
    }
    
    @IBAction func puntosRecaudo(_ sender: Any) {
        self.hiddenMenu()
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "firstOptionController") as! FirstOptionViewController
        self.present(viewController, animated: true)
    }
    
    @IBAction func callCenter(_ sender: UIButton) {
        self.hiddenMenu()
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "contactViewController") as! ContactViewController
        self.present(viewController, animated: true)
    }
    
    @IBAction func ubicarAgencias(_ sender: Any) {
        self.hiddenMenu()
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "customMap2ViewController") as! CustomMap2ViewController
        self.present(viewController, animated: true)
    }
    
    @IBAction func yoReporto(_ sender: Any) {
        self.hiddenMenu()
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "thirdViewController") as! ThirdViewController
        self.present(viewController, animated: true)
    }
    
    @IBAction func sugerencias(_ sender: Any) {
        self.hiddenMenu()
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "SuggestionViewController") as! SuggestionViewController
        self.present(viewController, animated: true)
    }
    
    @IBAction func acercaDe(_ sender: Any) {
        self.hiddenMenu()
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "aboutViewController") as! AboutViewController
        self.present(viewController, animated: true)
    }
    
    func showMenu(){
        
        UIView.animate(withDuration: 0.2) {
            self.rigthConstrain.constant = CGFloat(self.width)
            self.view.layoutIfNeeded()
            self.menuButton.image = self.image_l
        }
    }
    
    func hiddenMenu(){
        
        UIView.animate(withDuration: 0.2) {
            self.rigthConstrain.constant = 0
            self.view.layoutIfNeeded()
            self.menuButton.image = self.image_r
        }
    }

    @IBAction func Logout(_ sender: Any) {
        
        let alert = UIAlertController(title: nil, message: "Seguro que desea Cerrar Sesión?", preferredStyle: .alert);
        let btn_alert = UIAlertAction(title: "Aceptar", style: .default) { (UIAlertAction) in
        
            let status = self.dbase.encerarTables()
            if status{ print("ok")}else{print("error encerando")}
            /*do{
                try Auth.auth().signOut()
            }catch let LogoutError{
                print("LogoutError : \(LogoutError)")
            }*/
            
            //self.dismiss(animated: true, completion: nil)
            let viewController = self.storyboard?.instantiateInitialViewController()
            self.present(viewController!, animated: true)
            
        }
        let btn_cancel = UIAlertAction(title: "Cancelar", style: .destructive) { (UIAlertAction) in
            
        }
        alert.addAction(btn_alert);
        alert.addAction(btn_cancel);
        self.present(alert, animated: true, completion: nil);
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("CustomTableViewCell2", owner: self, options: nil)?.first as! CustomTableViewCell2
        
        //let cell1  = self.tableView.dequeueReusableCell(withIdentifier: "customCell") as! CustomTableViewCell2
        cell.mainImage.image = data[indexPath.row].image
        cell.mainTitle.text = data[indexPath.row].title
        cell.mainMessage.text = data[indexPath.row].message
        cell.mainDate.text = data[indexPath.row].date
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("selected", indexPath.row)
        hiddenMenu()
        
        let title_string = data[indexPath.row].title
        let body_string = data[indexPath.row].message
        let image_string =  data[indexPath.row].image
        
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "popUpCustomViewController") as! PopUpCustomViewController
        viewController.title_string = title_string!
        viewController.image = image_string
        viewController.body_string = body_string!
        self.present(viewController, animated: true, completion: nil)
    }
    
    //HABILITA LA OPCION DE OCULTAR EL TECLADO CUANDO SE LE DA EN CUALQUIER PARTE DE LA PANTALLA Y PARA MOVER LA VIEW SI EL TECLADO OCULTA EL TEXTFIELD
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        self.hiddenMenu()
    }

}
