//
//  BarSixTableViewController.swift
//  com.altura
//
//  Created by adrian aguilar on 11/6/18.
//  Copyright © 2018 Altura S.A. All rights reserved.
//

import UIKit

struct cellData1 {
    let image : UIImage?
    let message : String?
    let title : String?
}

class BarSixTableViewController: UITableViewController {

    var data = [cellData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        data = [ cellData.init(image: #imageLiteral(resourceName: "tramite"), message: "tramite numero 23 detallado asd asd asd asd asd asd asd a ramite numero 23 detallado asd asd asd asd asd asd asd a", title: "tramite 23"),cellData.init(image: #imageLiteral(resourceName: "tramite"), message: "tramite numero 2ramite numero 23 detallado asd asd asd asd asd asd asd a ramite numero 23 detallado asd asd asd asd asd asd asd a ramite numero 23 detallado asd asd asd asd asd asd asd a2 detallado", title: "tramite 22")]

        self.tableView.register(CustomTableViewCell2.self, forCellReuseIdentifier: "customCell")
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return data.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("CustomTableViewCell2", owner: self, options: nil)?.first as! CustomTableViewCell2
        
        //let cell1  = self.tableView.dequeueReusableCell(withIdentifier: "customCell") as! CustomTableViewCell2
        cell.mainImage.image = data[indexPath.row].image
        cell.mainTitle.text = data[indexPath.row].title
        cell.mainMessage.text = data[indexPath.row].message
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
