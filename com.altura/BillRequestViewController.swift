//
//  BillRequestViewController.swift
//  com.altura
//
//  Created by adrian aguilar on 28/6/18.
//  Copyright © 2018 Altura S.A. All rights reserved.
//

import UIKit

class BillRequestViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITableViewDelegate, UITableViewDataSource {
    
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
    
    var bills : [Bill] = [Bill]() // list of options
    
    
    
    @IBOutlet weak var select1: UITextField!
    @IBOutlet weak var select2: UITextField!
    @IBOutlet weak var picture: UIImageView!
    
    @IBOutlet weak var textView: UITextView!
    
    @IBOutlet weak var textView_label: UITextView!
    
    @IBOutlet weak var tableBills: UITableView!
    @IBOutlet weak var obsText: UITextView!
    
    let options=["","Opcion1","Opcion2","Opcion3","Opcion4","Opcion5"]
    
    let options2=["","Falta de tapa de alcantarilla","Fuga de agua en cajetin de medidor","Fuga de agua en la guía","Limpieza de caja de alcantarillado"]
    
    let options3=["","Instalación de tapa de alcantarilla domiciliaria.","Se observa fuga en el interior del cajetín medidor.","Se observa fuga en la guía domiciliaria, usualmente ubicada después del medidor o en a vereda","Limpieza de la caja que se encuentra fuera del domicilio y que corresponde a aguas servidas."]
    
    let myBackgroundColor1 = UIColor(red: 121/255.0, green: 190/255.0, blue: 255/255.0, alpha: 1.0)
    
    let myBackgroundColor = UIColor(red: 235/255.0, green: 235/255.0, blue: 235/255.0, alpha: 1.0)
    
    var pickerView1 = UIPickerView()
    var pickerView2 = UIPickerView()

    @IBOutlet weak var tickButton: UIButton!
    
    let image_r = UIImage(named: "tick-2.png")
    var selectAll = false;
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.hidesBarsOnSwipe = false
        navigationController?.hidesBarsWhenKeyboardAppears = false
        
        
        pickerView1.delegate = self
        pickerView1.dataSource = self
        pickerView1.backgroundColor = myBackgroundColor
        pickerView2.delegate = self
        pickerView2.dataSource = self
        pickerView2.backgroundColor = myBackgroundColor
        select1.inputView = pickerView1
        select2.inputView = pickerView2
        
        tableBills.delegate = self
        tableBills.dataSource = self
        
        obsText.layer.borderWidth = 1
        obsText.layer.borderColor = UIColor.lightGray.cgColor
        
        
        
    }
    
    @IBAction func tickAction(_ sender: UIButton) {
        if selectAll {
            self.tickButton.setImage(nil, for: UIControlState.normal)
            self.selectAll = false
            if self.bills.count > 0{
                for index in 0...self.bills.count-1 {
                    self.bills[index].enabled = false
                }
                self.tableBills.reloadData()
            }
            
        }else{
            self.tickButton.setImage(self.image_r, for: UIControlState.normal)
            self.selectAll = true
            
            if self.bills.count > 0{
                for index in 0...self.bills.count-1 {
                    self.bills[index].enabled = true
                }
                self.tableBills.reloadData()
            }
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.bills.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("CustomTableViewCell3", owner: self, options: nil)?.first as! CustomTableViewCell3
        
        
        cell.title.text = bills[indexPath.row].name
        cell.accessoryType = bills[indexPath.row].enabled ? UITableViewCellAccessoryType.checkmark : UITableViewCellAccessoryType.none
        //cell.mainMessage.text = data[indexPath.row].message
        //cell.mainDate.text = ""
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("selected", indexPath.row)
        if tableView.cellForRow(at: indexPath)?.accessoryType == UITableViewCellAccessoryType.checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCellAccessoryType.none
        }else{
            tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCellAccessoryType.checkmark
        }
        
        // save the value in the array
        let index = (indexPath as NSIndexPath).row
        bills[index].enabled = !bills[index].enabled
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int{
        return 1
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        if pickerView == pickerView1 {
            return self.options.count
        } else if pickerView == pickerView2{
            return self.options2.count
        }else{
            return 0
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var pickerLabel: UILabel? = (view as? UILabel)
        if pickerLabel == nil {
            pickerLabel = UILabel()
            pickerLabel?.font = UIFont(name: "System", size: 12)
            pickerLabel?.textAlignment = .center
        }
        
        pickerLabel?.textColor = UIColor.blue
        //pickerLabel?.textColor = UIColor(red: 62/255.0, green: 160/255.0, blue: 230/255.0, alpha: 1.0)
        
        if pickerView == pickerView1 {
            pickerLabel?.text = self.options[row]
        } else if pickerView == pickerView2{
            pickerLabel?.text = self.options2[row]
        }
        
        return pickerLabel!
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return ""
        
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if pickerView == pickerView1 {
            self.select1.text = self.options[row]
            self.select1.resignFirstResponder()
        } else if pickerView == pickerView2{
            self.select2.text = self.options2[row]
            self.select2.resignFirstResponder()
            self.textView_label.text = self.options3[row]
            
            self.bills = [Bill.init("Factura1", false,1),Bill.init("Factura2", false,2),Bill.init("Factura3", false,3),Bill.init("Factura4", false,4)]
            self.tableBills.reloadData()
        }
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        self.picture.image = image
        picker.dismiss(animated: true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func takePhoto(_ sender: Any) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        
        let actionSheet = UIAlertController(title: "Origen de la foto", message: "Escoja una opción", preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Cámara", style: .default, handler: { (action: UIAlertAction) in
            
            if UIImagePickerController.isSourceTypeAvailable(.camera){
                imagePickerController.sourceType = .camera
                self.present(imagePickerController, animated: true, completion: nil)
            }else{
                print("camara no disponible")
                self.showAlert(txt_alert: "Cámara no disponible")
            }
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Galeria", style: .default, handler: { (action: UIAlertAction) in imagePickerController.sourceType = .photoLibrary
            self.present(imagePickerController, animated: true, completion: nil)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    @IBAction func Back(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
    
    @IBAction func Send(_ sender: UIButton) {
        print("Envia")
        dismiss(animated: true)
    }
    
    //HABILITA LA OPCION DE OCULTAR EL TECLADO CUANDO SE LE DA EN CUALQUIER PARTE DE LA PANTALLA Y PARA MOVER LA VIEW SI EL TECLADO OCULTA EL TEXTFIELD
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func showAlert(txt_alert: String){
        print("entra a alerta")
        let alert = UIAlertController(title: nil, message: txt_alert, preferredStyle: .alert);
        let btn_alert = UIAlertAction(title: "Cerrar", style: .cancel)
        alert.addAction(btn_alert);
        self.present(alert, animated: true, completion: nil);
    }

   

}
