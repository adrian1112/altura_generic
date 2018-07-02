//
//  DetaillTwoViewController.swift
//  com.altura
//
//  Created by adrian aguilar on 2/7/18.
//  Copyright © 2018 Altura S.A. All rights reserved.
//

import UIKit

class DetailTwoViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    struct Bill {
        let name : String
        let index : Int
        var enabled : Bool
        
        init(_ name : String, _ enabled : Bool, _ index : Int) {
            self.name = name
            self.enabled = enabled
            self.index = index
        }
    }
    
    @IBOutlet weak var tableBills: UITableView!
    
    var bills : [Bill] = [Bill]() // list of options
    var bills_money : [Bill] = [Bill]() // list of options
    
    var money = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableBills.delegate = self
        tableBills.dataSource = self
        
        
        self.bills = [Bill.init("Factura1", false,1),Bill.init("Factura2", false,2),Bill.init("Factura3", false,3),Bill.init("Factura4", false,4)]
        
        self.bills_money = [Bill.init("Factura1", false,1),Bill.init("Factura2", false,2),Bill.init("Factura3", false,3),Bill.init("Factura4", false,4)]
        
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if money{
            return self.bills_money.count
        }else{
            return self.bills.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if money{
            let cell = Bundle.main.loadNibNamed("CustomTableViewCell3", owner: self, options: nil)?.first as! CustomTableViewCell3
            
            
            cell.title.text = bills[indexPath.row].name
            cell.label_cost.text = "fecha"
            cell.label_date_first.text = ""
            cell.label_date_second.text = ""
            cell.date_first.text = ""
            cell.date_second.text = ""
            cell.img.image = UIImage(named: "pago1_2")
            //cell.accessoryType = bills[indexPath.row].enabled ? UITableViewCellAccessoryType.checkmark : UITableViewCellAccessoryType.none
            //cell.mainMessage.text = data[indexPath.row].message
            //cell.mainDate.text = ""
            return cell
        }else{
            let cell = Bundle.main.loadNibNamed("CustomTableViewCell3", owner: self, options: nil)?.first as! CustomTableViewCell3
            
            
            cell.title.text = bills[indexPath.row].name
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
