//
//  WeightController.swift
//  DRace
//
//  Created by sgcs on 2017. 11. 9..
//  Copyright © 2017년 sgcs. All rights reserved.
//

import Foundation
import UIKit
import FirebaseDatabase
import FirebaseAuth

var weightList = [String]()


class WeightRecordController: UITableViewController {
    /*
    //make connection to the firebase database
    let user = Auth.auth().currentUser
    
    @IBAction func back(){
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        weightList.removeAll()
        
        //sync with database
        
        ref = Database.database().reference()
        
        handle = ref?.child("\(user?.uid)").child("weightList").observe(.childAdded, with: { (snapshot) in
            if let item = snapshot.value as? String? {
                //weightList.append(item!)
                weightList.append("\(snapshot.key)" + " | " + item!)
                self.tableView.reloadData()
                ref?.keepSynced(true)
            }
        })
        
        
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weightList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "weightCell", for: indexPath)
        
        var todo : String = weightList[indexPath.row]
        
        cell.textLabel?.text = todo
        
        return cell
    }
    */
}

