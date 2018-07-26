//
//  FirstOptionViewController.swift
//  com.altura
//
//  Created by adrian aguilar on 21/5/18.
//  Copyright © 2018 Altura S.A. All rights reserved.
//

import UIKit

struct pagina{
    var img: UIImage
    var url: String
    
    init(img: UIImage, url: String){
        self.img = img
        self.url = url
    }
}

class FirstOptionViewController: UIViewController, UICollectionViewDataSource {

    @IBOutlet weak var collectionView: UICollectionView!
    
    let items = [pagina.init(img: #imageLiteral(resourceName: "redfacilito-1"), url: "https://www.switchorm.com/es/index.php/es/"),
                 pagina.init(img: #imageLiteral(resourceName: "westernunion"), url: "https://www.westernunion.com/ec/es/home.html"),
                 pagina.init(img: #imageLiteral(resourceName: "servipagos"), url: "http://www.servipagos.com/"),
                 pagina.init(img: #imageLiteral(resourceName: "bancopacifico"), url: "https://www.bancodelpacifico.com/"),
                 pagina.init(img: #imageLiteral(resourceName: "bancomachala"), url: "https://www.bancomachala.com/"),
                 pagina.init(img: #imageLiteral(resourceName: "bancoguayaquil"), url: "https://www.bancoguayaquil.com/"),
                 pagina.init(img: #imageLiteral(resourceName: "bancobolivariano"), url: "https://www.bolivariano.com/"),
                 pagina.init(img: #imageLiteral(resourceName: "bancopichincha"), url: "https://www.pichincha.com/portal/")]
    
    
    var selectItem = 0;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.hidesBarsOnSwipe = false
        //navigationController?.hidesBarsOnTap = true
        navigationController?.hidesBarsWhenKeyboardAppears = false
        
        collectionView.dataSource = self

        // Do any additional setup after loading the view.
    }
    
    @IBAction func Back(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
    
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return items.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "customCell", for: indexPath) as! CustomCollectionViewCell
        cell.buttonCell.setImage(self.items[indexPath.row].img , for: .normal)
        
        
        
        cell.buttonCell.addTarget(self, action: #selector(action_btn), for: UIControlEvents.touchUpInside)
        cell.buttonCell.tag = indexPath.row
        return cell
    }
    
    
    @objc func action_btn(sender:UIButton! ) {
        print("entra en funcion de boton")
        
        if Connectivity.isConnectedToInternet {
            print("Connected")
            let btnsendtag: UIButton = sender
            self.selectItem = btnsendtag.tag
            let viewController = self.storyboard?.instantiateViewController(withIdentifier: "customWebViewController") as! CustomWebViewController
            viewController.url_string = self.items[self.selectItem].url
            self.present(viewController, animated: true)
            
        } else {
            print("No Internet")
            let alert = UIAlertController(title: nil, message: "No tiene acceso a Internet", preferredStyle: .alert);
            let btn_alert = UIAlertAction(title: "Cerrar", style: .default) { (UIAlertAction) in
            }
            alert.addAction(btn_alert);
            self.present(alert, animated: true, completion: nil);
        }
        
        
        
    }
    
    /*//SE ELIMINO  EL SEGUE O CONEXION ENTRE ESTE VIEW Y EL VIEW PageUrlViewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showPageWebIni" {
            let paginaUrl = segue.destination as! PageUrlViewController
            let btnsendtag: UIButton = sender as! UIButton
            self.selectItem = btnsendtag.tag
            paginaUrl.url = self.items[self.selectItem].url
            
        }
    }*/



}
