//
//  BarSixViewController.swift
//  com.altura
//
//  Created by adrian aguilar on 25/6/18.
//  Copyright © 2018 Altura S.A. All rights reserved.
//

import UIKit

struct cellData {
    let image : UIImage?
    let message : String?
    let title : String?
}

class BarSixViewController: UIViewController, UITableViewDataSource, UITableViewDelegate  {

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var leftConstrain: NSLayoutConstraint!
    @IBOutlet weak var blurView: UIVisualEffectView!
    @IBOutlet weak var leftView: UIView!
    
    let image_l = UIImage(named: "flecha_izq.png")
    let image_r = UIImage(named: "flecha_der.png")
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    var data = [cellData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self

        data = [ cellData.init(image: #imageLiteral(resourceName: "tramite"), message: "tramite numero 23 detallado asd asd asd asd asd asd asd a ramite numero 23 detallado asd asd asd asd asd asd asd a", title: "tramite 23"),cellData.init(image: #imageLiteral(resourceName: "tramite"), message: "tramite numero 2ramite numero 23 detallado asd asd asd asd asd asd asd a ramite numero 23 detallado asd asd asd asd asd asd asd a ramite numero 23 detallado asd asd asd asd asd asd asd a2 detallado", title: "tramite 22")]
        
        self.tableView.register(CustomTableViewCell2.self, forCellReuseIdentifier: "customCell")
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        navigationController?.hidesBarsOnSwipe = false
        //navigationController?.hidesBarsOnTap = true
        navigationController?.hidesBarsWhenKeyboardAppears = false
        
        //Menu
        blurView.layer.cornerRadius = 15
        leftView.layer.shadowColor = UIColor.black.cgColor
        leftView.layer.shadowOpacity = 0.8
        leftView.layer.shadowOffset = CGSize(width: 5, height: 0)
        
        leftConstrain.constant = -80
        
        self.hiddenMenu()
        
    }
    
    @IBAction func menuActions(_ sender: Any) {
        
        if(self.leftConstrain.constant == -80){
            self.showMenu()
        }else{
            self.hiddenMenu()
        }
        
    }
    
    @IBAction func callCenter(_ sender: UIButton) {
        let number = "0997396690"
        Utils.call(number: number)
    }
    
    func showMenu(){
        
        UIView.animate(withDuration: 0.2) {
            self.leftConstrain.constant = 0
            self.view.layoutIfNeeded()
            self.menuButton.image = self.image_l
        }
    }
    
    func hiddenMenu(){
        
        UIView.animate(withDuration: 0.2) {
            self.leftConstrain.constant = -80
            self.view.layoutIfNeeded()
            self.menuButton.image = self.image_r
        }
    }
    

    @IBAction func Logout(_ sender: Any) {
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "initController") as! InitController
        self.present(viewController, animated: true)
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
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("selected", indexPath.row)
    }
    
    //HABILITA LA OPCION DE OCULTAR EL TECLADO CUANDO SE LE DA EN CUALQUIER PARTE DE LA PANTALLA Y PARA MOVER LA VIEW SI EL TECLADO OCULTA EL TEXTFIELD
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        self.hiddenMenu()
    }

}
