//
//  DetaillTwoViewController.swift
//  com.altura
//
//  Created by adrian aguilar on 2/7/18.
//  Copyright © 2018 Altura S.A. All rights reserved.
//

import UIKit
import SQLite

class DetailTwoViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let dbase = DBase();
    var db: Connection!
    
    
    @IBOutlet weak var navigationBar: UINavigationItem!
    
    @IBOutlet weak var tableBills: UITableView!
    
    var bills : [Bill] = [Bill]() // list of options
    var payments : [Bill] = [Bill]() // list of options
    
    var money = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let detailController = tabBarController as! DetailsTabBarViewController
        
        let titleView = String(describing: detailController.contrato)
        navigationBar.title = titleView
        let detailAccountItem = detailController.detailtAccountItem

        tableBills.delegate = self
        tableBills.dataSource = self
        
        //getDetailPaymentT
        //getBillsAccount
        
        let status = dbase.connect_db()
        if( status.value ){
            print("entra a buscar detalles faturas y pagos")
            let detail_payment_list = self.dbase.getDetailPaymentT(service: detailAccountItem.servicio)
            
            let bills_list = self.dbase.getBillsAccount(service: detailAccountItem.servicio)
            var i = 0
            for item in detail_payment_list{
                //let name = getMonthString(item.fecha_pago)
                //print( getMonthString(date: item.fecha_pago,1) )
                self.payments.append(Bill.init(name: getMonthString(date: item.fecha_pago,1), enabled: false, index: i, date_ini: getLabelDate(date: item.fecha_pago,1), date_end: "", value: item.monto_pago, type: ""))
                
                i += 1
            }
            
            i = 0
            for item in bills_list{
                //let name = getMonthString(item.fecha_pago)
                //print(getMonthString(date: item.fecha_emision,2) )
                self.bills.append(Bill.init(name: getMonthString(date: item.fecha_emision,2), enabled: false, index: i, date_ini: getLabelDate(date: item.fecha_emision,2), date_end: getLabelDate(date: item.fecha_vencimiento,2), value: item.monto_factura, type: item.estado_factura))
                
                i += 1
            }
        }
        
        
        //self.bills = [Bill.init("Factura1", false,1),Bill.init("Factura2", false,2),Bill.init("Factura3", false,3),Bill.init("Factura4", false,4)]
        
        //self.bills_money = [Bill.init("Pago1", false,1),Bill.init("Pago2", false,2),Bill.init("Pago3", false,3),Bill.init("Pago4", false,4)]
        
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if money{
            return self.payments.count
        }else{
            return self.bills.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if !money{
            let cell = Bundle.main.loadNibNamed("CustomTableViewCell3", owner: self, options: nil)?.first as! CustomTableViewCell3
            
            
            cell.title.text = bills[indexPath.row].name
            cell.label_cost.text = bills[indexPath.row].type
            cell.cost.text = bills[indexPath.row].value
            //cell.label_date_first.text = bills[indexPath.row].date_ini
            //cell.label_date_second.text = bills[indexPath.row].date_end
            cell.date_first.text = bills[indexPath.row].date_ini
            cell.date_second.text = bills[indexPath.row].date_end
            
            //cell.accessoryType = bills[indexPath.row].enabled ? UITableViewCellAccessoryType.checkmark : UITableViewCellAccessoryType.none
            //cell.mainMessage.text = data[indexPath.row].message
            //cell.mainDate.text = ""
            return cell
        }else{
            let cell = Bundle.main.loadNibNamed("CustomTableViewCell3", owner: self, options: nil)?.first as! CustomTableViewCell3
            
            
            cell.title.text = payments[indexPath.row].name
            cell.label_cost.text = payments[indexPath.row].date_ini
            cell.cost.text = payments[indexPath.row].value
            cell.label_date_first.text = ""
            cell.label_date_second.text = ""
            cell.date_first.text = ""
            cell.date_second.text = ""
            cell.img.image = UIImage(named: "pago_2")  //pago1_2
            //cell.accessoryType = bills[indexPath.row].enabled ? UITableViewCellAccessoryType.checkmark : UITableViewCellAccessoryType.none
            //cell.mainMessage.text = data[indexPath.row].message
            //cell.mainDate.text = ""
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if money{
            return 50
        }else{
            return 60
        }
        
    }
    
    @IBAction func exit(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
    
    @IBAction func ChangeType(_ sender: UISegmentedControl) {
        if money{
            money = false
            tableBills.reloadData()
        }else{
            money = true
            tableBills.reloadData()
        }
    }
    
    
}
