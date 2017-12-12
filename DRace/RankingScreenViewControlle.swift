//
//  ViewController.swift
//  RankingScreen
//
//  Created by Jayron Cena on 2017. 11. 15..
//  Copyright © 2017년 CodeWithJayron. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class RankingScreenViewController: UITableViewController{
    
    var userExerciseRanking: [String: Int] = [:]
    var sortedItems:[String] = []
    
    var mode = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getRankingData(rankRef:exerciseRankRef)
    }
    
    @IBOutlet weak var exerciseButton: UIBarButtonItem!
    @IBAction func exerciseRankingMode(_ sender: Any) {
        lossRankRef?.removeAllObservers()
        getRankingData(rankRef:exerciseRankRef)
        mode = 0
        
        exerciseButton.isEnabled = false
        lossWeightButton.isEnabled = true
    }
    
    @IBOutlet weak var lossWeightButton: UIBarButtonItem!
    @IBAction func lossWeightRankingMode(_ sender: Any) {
        exerciseRankRef?.removeAllObservers()
        getRankingData(rankRef: lossRankRef)
        mode = 1
        
        exerciseButton.isEnabled = true
        lossWeightButton.isEnabled = false
    }
    
    var userIdx = -1
    func getRankingData(rankRef:DatabaseReference?){
        rankRef?.observe(.value) { (DataSnapshot) in
            let RankingQuery = rankRef?.queryOrderedByValue()
            RankingQuery?.observeSingleEvent(of:.value, with:{ (DataSnapshot) in
                self.sortedItems.removeAll()
                
                var idx = 0
                for child in DataSnapshot.children.reversed(){
                    let childString = "\(child)"
                    let childComponent = childString.components(separatedBy: " ")
                    self.sortedItems.append(childComponent[2])
                    
                    if childComponent[1].components(separatedBy: CharacterSet(charactersIn: "()"))[1] == userID{
                        self.userIdx = idx
                    }
                    idx += 1
                }
                self.tableView.reloadData()
            })
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sortedItems.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RankingItem", for: indexPath) as! RankingItem
        
        cell.rankLabel?.text = "\(indexPath.row + 1)위"
        
        if (mode == 0){
            cell.valueLabel?.text = CustomTimeFormatter.time(rawMinuteS: sortedItems[indexPath.row])
        }
        else{
            cell.valueLabel?.text = sortedItems[indexPath.row] + " kg"
        }
        
        if (userIdx == indexPath.row){
            cell.messageLabel?.text = "당신의 순위입니다!"
        }
        else{
            cell.messageLabel?.text = ""
        }
        
        return cell
    }
}

class RankingItem:UITableViewCell{
    @IBOutlet weak var rankLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
}


