//
//  FirstOptionViewController.swift
//  com.altura
//
//  Created by adrian aguilar on 21/5/18.
//  Copyright © 2018 Altura S.A. All rights reserved.
//

import UIKit

class FirstOptionViewController: UIViewController, UICollectionViewDataSource {

    @IBOutlet weak var collectionView: UICollectionView!
    
    let items = ["item1","item2","item3","item4","item5","item6","item7","item8"]
    
    let urls = ["https://www.switchorm.com/es/index.php/es/","https://www.westernunion.com","https://www.switchorm.com/es/index.php/es/","https://www.westernunion.com","https://www.switchorm.com/es/index.php/es/","https://www.westernunion.com","https://www.switchorm.com/es/index.php/es/","https://www.westernunion.com"];
    
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
        cell.buttonCell.setImage(UIImage(named: "logo"), for: .normal)
        
        cell.buttonCell.addTarget(self, action: #selector(action_btn), for: UIControlEvents.touchUpInside)
        cell.buttonCell.tag = indexPath.row
        return cell
    }
    
    @IBAction func actionPage(_ sender: Any) {
        
    }
    
    @objc func action_btn(sender:UIButton! ) {
        print("entra en funcion de boton")
        let btnsendtag: UIButton = sender
        self.selectItem = btnsendtag.tag
        /*//abre la url en el navegador por defecto en est caso safari
        if let url = URL(string: self.urls[self.selectItem]) {
            UIApplication.shared.open(url, options: [:])
        }*/
        
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "customWebViewController") as! CustomWebViewController
        viewController.url_string = self.urls[self.selectItem]
        self.present(viewController, animated: true)
        
    }
    
    //SE ELIMINO  EL SEGUE O CONEXION ENTRE ESTE VIEW Y EL VIEW PageUrlViewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showPageWebIni" {
            let paginaUrl = segue.destination as! PageUrlViewController
            let btnsendtag: UIButton = sender as! UIButton
            self.selectItem = btnsendtag.tag
            paginaUrl.url = self.urls[self.selectItem]
            
        }
    }



}
