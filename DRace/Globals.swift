//
//  Globals.swift
//  DRace
//
//  Created by 최광익 on 2017. 12. 9..
//  Copyright © 2017년 Jayron Cena. All rights reserved.
//

import Foundation
import FirebaseDatabase

var userRef:DatabaseReference?
var groupRef:DatabaseReference?{
    didSet{
        exerciseRankRef = groupRef?.child("exerciseRanking")
        lossRankRef = groupRef?.child("lossWeightRanking")
    }
}
var exerciseRankRef:DatabaseReference?
var lossRankRef:DatabaseReference?
var userID:String?
