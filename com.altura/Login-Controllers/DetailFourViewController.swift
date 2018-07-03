//
//  DetaillFourViewController.swift
//  com.altura
//
//  Created by adrian aguilar on 2/7/18.
//  Copyright © 2018 Altura S.A. All rights reserved.
//

import UIKit

class DetailFourViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var navigationBar: UINavigationItem!

    @IBOutlet weak var tableView: UITableView!
    
    struct Process {
        let title : String
        let subtitle : String
        let code: String
        let status: String
        let date: String
        let img: UIImage
        var enabled : Bool
        
        init(_ title : String, _ subtitle : String, _ code : String,_ status: String,_ date: String,_ img: UIImage,_ enabled: Bool) {
            self.title = title
            self.subtitle = subtitle
            self.code = code
            self.status = status
            self.date = date
            self.img = img
            self.enabled = enabled
            
        }
    }
    
    
    var process_list : [Process] = [Process]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let detailController = tabBarController as! DetailsTabBarViewController
        
        let titleView = String(describing: detailController.contrato)
        navigationBar.title = titleView

        tableView.delegate = self
        tableView.dataSource = self
        
        self.process_list = [Process.init("SUSPENSION POR NO PAGO", "REC-CORTE DEL SERVICIO (1/2''-3/4''-1)","13718514","ATENDIDO","11/10/1991",UIImage(named: "pago1_2")!, false),
        Process.init("VENTA DE SERVICIOS DE INGENIERIA", "PRUEBA DE GEOFONO","13718514","ATENDIDO","11/10/1991",UIImage(named: "pago1_2")!, false)
        ]
        
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

}
