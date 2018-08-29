//
//  DetaillFourViewController.swift
//  com.altura
//
//  Created by adrian aguilar on 2/7/18.
//  Copyright © 2018 Altura S.A. All rights reserved.
//

import UIKit
import SQLite

class DetailFourViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let dbase = DBase();
    var db: Connection!
    
    @IBOutlet weak var navigationBar: UINavigationItem!

    @IBOutlet weak var tableView: UITableView!
    
    
    var process_list : [Process] = [Process]()
    
    var contrato = ""
    var servicio = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let detailController = tabBarController as! DetailsTabBarViewController
        
        contrato = String(describing: detailController.contrato)
        servicio = String(describing: detailController.servicio)
        
        navigationBar.title = contrato
        
        let detailAccountItem = detailController.detailtAccountItem
        

        tableView.delegate = self
        tableView.dataSource = self
        
        let status = dbase.connect_db()
        if( status.value ){
            print("entra en buscar tramites")
            
            let list = self.dbase.getDetailsProcedures(service: detailAccountItem.servicio)
            for item in list{
                print(item)
                
                var title = ""
                var descripcion = ""
                var estado = ""
                var new_date_ini = ""
                var new_date_end = ""
                
                do{
                    if item.descripcion != ""{
                        title = try subStringProcess(text: item.descripcion, char: "-").uppercased()
                    }
                }catch{
                    print("error convirtiendo titulo")
                }
                do{
                    if item.descripcion3 != ""{
                        descripcion = subStringProcess(text: item.descripcion3, char: "-").uppercased()
                    }
                }catch{
                    print("error convirtiendo descripcion")
                }
                
                do{
                    if item.estado != ""{
                       estado = subStringProcess(text: item.estado, char: "-").uppercased()
                    }
                 
                }catch{
                    print("error convirtiendo estado")
                }
                
                do{
                    if item.fecha_inicio != ""{
                        new_date_ini = getLabelDate(date: item.fecha_inicio,3)
                    }
                }catch{
                    print("error convirtiendo fecha ini")
                }
                
                do{
                    if item.fecha_fin != ""{
                        new_date_end = getLabelDate(date: item.fecha_fin,3)
                    }
                }catch{
                    print("error convirtiendo fecha ini")
                }
                
                
                process_list.append(Process.init(title, descripcion, item.codigo, estado , new_date_ini, UIImage(named: "proceso")!, false, new_date_end , item.json))
                
            }
        }
        
        
        
        /*self.process_list = [Process.init("SUSPENSION POR NO PAGO", "REC-CORTE DEL SERVICIO (1/2''-3/4''-1)","13718514","ATENDIDO","11/10/1991",UIImage(named: "proceso")!, false),
        Process.init("VENTA DE SERVICIOS DE INGENIERIA", "PRUEBA DE GEOFONO","13718514","ATENDIDO","11/10/1991",UIImage(named: "proceso")!, false)
        ]*/
        
    }

    @IBAction func exit(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.process_list.count
        
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = Bundle.main.loadNibNamed("CustomTableViewCell4", owner: self, options: nil)?.first as! CustomTableViewCell4
        
        
        cell.titleView.text = process_list[indexPath.row].title
        cell.subtitleView.text = process_list[indexPath.row].subtitle
        cell.codeView.text = process_list[indexPath.row].code
        cell.statusView.text = process_list[indexPath.row].status
        cell.dateView.text = process_list[indexPath.row].date
        cell.imgView.image = process_list[indexPath.row].img
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "statusProcessViewController") as! StatusProcessViewController
        viewController.titleView = self.navigationBar.title!
        viewController.process = process_list[indexPath.row]
        self.present(viewController, animated: true)
    }
    
    @IBAction func NewProcess(_ sender: Any) {
        
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "optionsProcessViewController") as! OptionsProcessViewController
        viewController.contrato =  self.contrato
        viewController.servicio =  self.servicio
        self.present(viewController, animated: true)
        
    }
    
    
}
