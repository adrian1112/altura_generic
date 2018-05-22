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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self

        // Do any additional setup after loading the view.
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
    
    @objc func action_btn(sender:UIButton! ) {
        print("entra en funcion de boton")
        let btnsendtag: UIButton = sender
        
        print("Button Clicked \(btnsendtag.tag)")
    }



}
