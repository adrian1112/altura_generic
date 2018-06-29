//
//  AboutViewController.swift
//  com.altura
//
//  Created by adrian aguilar on 22/6/18.
//  Copyright © 2018 Altura S.A. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController {

    @IBOutlet weak var popupView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var AceptButton: UIButton!
    @IBOutlet weak var labelVersion: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //popupView.layer.cornerRadius = 15
        //titleLabel.layer.cornerRadius = 15
        //AceptButton.layer.cornerRadius = 15
        popupView.layer.shadowColor = UIColor.black.cgColor
        //popupView.layer.shadowOpacity = 0.8
        //popupView.layer.shadowOffset = CGSize(width: 5, height: 0)
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            self.labelVersion.text = version
        }

        // Do any additional setup after loading the view.
    }

    
    @IBAction func CloseAbout(_ sender: UIButton) {
        
        dismiss(animated: true)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
