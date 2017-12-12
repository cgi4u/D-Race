//
//  RenewDataModel.swift
//  DRace
//
//  Created by 최광익 on 2017. 12. 3..
//  Copyright © 2017년 Jayron Cena. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase

class RenewDataModel {
    //Save exercise time from user input to the FireBase database
    func saveExercise(exerciseMin:Int){
        let curDate = CustomDateFormatter.getCurDate()
        
        userRef?.observeSingleEvent(of: .value, with: { (DataSnapshot) in
            //If the record of today dosen't exist, make new one
            if DataSnapshot.hasChild("exerciseList") == false
                || DataSnapshot.childSnapshot(forPath: "exerciseList").hasChild(curDate) == false {
                userRef?.child("exerciseList").child(curDate).setValue(exerciseMin)
                
                //Get group number
                exerciseRankRef?.child(userID!).setValue(exerciseMin)
            }
            else{   //If the record exists, add new value to it
                //Get current exercising time, and add new one to that
                let curExercise = DataSnapshot.childSnapshot(forPath: "exerciseList/" + curDate).value
                let newExercise = (curExercise as! Int) + exerciseMin
                
                //Save new exercising time
                userRef?.child("exerciseList/" + curDate).setValue(newExercise)
                
                //Get group number
                exerciseRankRef?.child(userID!).setValue(newExercise)
            }
            
            userRef?.child("currentUpdate").setValue(curDate)
        })
        
    }
    
    func saveWeight(weight:String){
        //Set weight value
        userRef?.child("lastWeight").setValue(weight)
        
        userRef?.observeSingleEvent(of: .value, with: { (DataSnapshot) in
            //Set lose weight value
            let sWeight = DataSnapshot.childSnapshot(forPath: "startingWeight").value as! NSString
            let lossWeight = sWeight.floatValue - (weight as NSString).floatValue
            let month = CustomDateFormatter.getCurMonth()
            userRef?.child("lossWeight/" + month).setValue("\(lossWeight)")
            
            lossRankRef?.child(userID!).setValue("\(lossWeight)")
            
        })
    }
    
    func registerNewUser(weight:String){
        userRef?.child("startingWeight").setValue(weight)
        userRef?.child("lastWeight").setValue(weight)
        
        if let dWeight = Double(weight) {
            for i in 1...15 {
                if dWeight >= Double(i-1) * 10.0 && dWeight < Double(i) * 10.0 {
                    userRef?.child("group").setValue(i)
                    groupRef = Database.database().reference().child("groups/\(i)")
                    break
                }
            }
        }
        
        //userRef?.child("noti-token").setValue(Messaging.messaging().fcmToken)
    }
}
