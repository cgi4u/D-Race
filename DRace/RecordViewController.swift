//
//  DataController.swift
//  DRace
//
//  Created by sgcs on 2017. 11. 9..
//  Copyright © 2017년 sgcs. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth

class RecordViewController: UIViewController {
    @IBOutlet weak var exerciseValue: UILabel!
    @IBOutlet weak var beforeExerciseValue: UILabel!
    
    @IBOutlet weak var weightValue: UILabel!
    @IBOutlet weak var lossWeightValue: UILabel!
    
    //let userRef = Database.database().reference().child((Auth.auth().currentUser?.uid)!)
    
    override func viewDidLoad() {
        //Set notification token when default view is load
        userRef?.child("noti-token").setValue(Messaging.messaging().fcmToken)
        
        let date = CustomDateFormatter.getCurDate()
        let month = CustomDateFormatter.getCurMonth()
        
        userRef?.observe(.value) { (DataSnapshot) in
            //Part for exercise data for today
            if DataSnapshot.hasChild("exerciseList") == false || DataSnapshot.childSnapshot(forPath: "exerciseList").hasChild(date) == false{
                //If there is not exercise data for today
                self.exerciseValue.text = "미등록"
            }
            else{
                //If there is exercise data for today
                
                //Calculate hout/minute
                let minute = DataSnapshot.childSnapshot(forPath: "exerciseList").childSnapshot(forPath: date).value as! Int
                
                self.exerciseValue.text = CustomTimeFormatter.time(rawMinute: minute)
            }
            
            let yesterday = CustomDateFormatter.getDateByOffset(dayOffset: -1)
            //Part for exercise data for yesterday
            if DataSnapshot.hasChild("exerciseList") == false || DataSnapshot.childSnapshot(forPath: "exerciseList").hasChild(yesterday) == false{
                //If there is not exercise data for yesterday
                self.beforeExerciseValue.text = "미등록"
            }
            else{
                //If there is exercise data for yesterday
                
                //Calculate hout/minute
                let minute = DataSnapshot.childSnapshot(forPath: "exerciseList").childSnapshot(forPath:yesterday).value as! Int
                
                self.beforeExerciseValue.text = CustomTimeFormatter.time(rawMinute: minute)
            }
            
            //Part for weight data
            if let weightText = DataSnapshot.childSnapshot(forPath: "lastWeight").value{
                self.weightValue.text = weightText as! String + " kg"
            }
            
            //Part for lose weight data
            if DataSnapshot.hasChild("lossWeight") == false || DataSnapshot.childSnapshot(forPath: "lossWeight").hasChild(month) == false{
                //If there is not loss weight data for this month
                self.lossWeightValue.text = "미등록"
            }
            else{
                //Display loss weight data for this month
                let lossWeightText = DataSnapshot.childSnapshot(forPath: "lossWeight/" + month).value
                self.lossWeightValue.text = lossWeightText as! String + "kg"
            }
        }
        
        self.getMaxData()
    }
    
    
    @IBOutlet weak var exerciseMaxValue: UILabel!
    @IBOutlet weak var lossWeightMaxValue: UILabel!
    
    var group = 0
    func getMaxData(){
        exerciseRankRef?.observe(.value) { (DataSnapshot) in
            let exerciseRankingQuery = exerciseRankRef?.queryOrderedByValue()
            exerciseRankingQuery?.observeSingleEvent(of:.value, with:{ (DataSnapshot) in
                for child in DataSnapshot.children.reversed(){
                    let childString = "\(child)"
                    let childComponent = childString.components(separatedBy: " ")
                    self.exerciseMaxValue.text = CustomTimeFormatter.time(rawMinute: Int(childComponent[2])!)
                    break
                }
            })
        }
        
        lossRankRef?.observe(.value) { (DataSnapshot) in
            let lossRankingQuery = lossRankRef?.queryOrderedByValue()
            lossRankingQuery?.observeSingleEvent(of:.value, with:{ (DataSnapshot) in
                for child in DataSnapshot.children.reversed(){
                    let childString = "\(child)"
                    let childComponent = childString.components(separatedBy: " ")
                    self.lossWeightMaxValue.text = childComponent[2] + "kg"
                    break
                }
            })
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

