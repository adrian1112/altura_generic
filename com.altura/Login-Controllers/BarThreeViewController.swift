//
//  BarThreeViewController.swift
//  com.altura
//
//  Created by adrian aguilar on 10/6/18.
//  Copyright © 2018 Altura S.A. All rights reserved.
//

import UIKit
import SQLite

class BarThreeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    weak var activeField: UITextField?
    let dbase = DBase();
    var db: Connection!
    
    @IBOutlet weak var leftConstrain: NSLayoutConstraint!
    @IBOutlet weak var rigthConstrain: NSLayoutConstraint!
    @IBOutlet weak var blurView: UIVisualEffectView!
    @IBOutlet weak var leftView: UIView!
    
    
    let image_l = UIImage(named: "flecha_izq.png")
    let image_r = UIImage(named: "flecha_der.png")
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    @IBOutlet weak var tableView: UITableView!
    
    var data = [cellData]()
    var accounts_list = [detailAccount]()
    
    var width = 0;
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        
        navigationController?.hidesBarsOnSwipe = false
        //navigationController?.hidesBarsOnTap = true
        navigationController?.hidesBarsWhenKeyboardAppears = false
        //Menu
        blurView.layer.cornerRadius = 15
        leftView.layer.shadowColor = UIColor.black.cgColor
        leftView.layer.shadowOpacity = 0.8
        leftView.layer.shadowOffset = CGSize(width: 5, height: 0)
        
        width = Int(self.view.bounds.width)
        rigthConstrain.constant = 0
        
        let status = dbase.connect_db()
        if( status.value ){
            print("entra a buscar detalles de cuenta")
            accounts_list = self.dbase.getAllDetailsAccounts()
            
            for item in accounts_list{
                print(item)
                data.append(cellData.init(image: #imageLiteral(resourceName: "contrato-1"), message: "\(item.servicio) - \(item.direccion)", title: item.alias, date: "", service: item.servicio))
            }
        }
        //Tabla
        
        
        self.tableView.register(CustomTableViewCell2.self, forCellReuseIdentifier: "customCell")
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        self.hiddenMenu()
        
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
            
            self.dismiss(animated: true, completion: nil)
        }
        let btn_cancel = UIAlertAction(title: "Cancelar", style: .cancel) { (UIAlertAction) in
            
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
        
        let tabBarViewController = self.storyboard?.instantiateViewController(withIdentifier: "detaillsTabBarController") as! DetailsTabBarViewController
        tabBarViewController.contrato = data[indexPath.row].title!
        tabBarViewController.servicio = data[indexPath.row].service!
        tabBarViewController.detailtAccountItem = accounts_list[indexPath.row]
        self.present(tabBarViewController, animated: true)
        
        
    }
    
    @IBAction func NewContract(_ sender: Any) {
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "newContractViewController") as! NewContractViewController
        self.present(viewController, animated: true)
    }
    
    //HABILITA LA OPCION DE OCULTAR EL TECLADO CUANDO SE LE DA EN CUALQUIER PARTE DE LA PANTALLA Y PARA MOVER LA VIEW SI EL TECLADO OCULTA EL TEXTFIELD
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        self.hiddenMenu()
    }
    
}
