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
import UserNotifications
import FirebaseDatabase
import FirebaseAuth

class RecordViewController: UIViewController, UNUserNotificationCenterDelegate {
    
    @IBOutlet weak var exerdata: UITextView!
    @IBOutlet weak var weightdata: UITextView!
    
    // lastex에 마지막 운동량 집어넣음
    let lastex = 200
    let user = Auth.auth().currentUser
    
    func messaging(_ messaging: Messaging, didRefreshRegistrationToken fcmToken: String) {
        print("Firebase registration token: \(fcmToken)")
    }
    
    
    // 푸시알림. 로컬로 담당.
    func setnoti(){
        let content = UNMutableNotificationContent()
        content.title = "Noti Title"
        content.body = "어제의 운동량은 총 \(lastex/60)시간 \(lastex%60)분입니다!"
        
        var dateComponents = DateComponents()
        // 시간 분 입력. 매일. 반복됨
        dateComponents.hour = 1
        dateComponents.minute = 24
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: "time", content: content, trigger: trigger)
        let center = UNUserNotificationCenter.current()
        center.add(request) { (error) in
            print(error?.localizedDescription ?? "")
        }
    }
    
    override func viewDidLoad() {
        let token = Messaging.messaging().fcmToken
        print("FCM token: \(token ?? "")")
        exerdata.text = "오늘의 운동량은 10km입니다."
        exerdata.backgroundColor = UIColor(red: 255, green: 195, blue: 190, alpha: 1)
        weightdata.text = "현재 몸무게 10kg입니다."
        weightdata.backgroundColor = UIColor(red: 255, green: 195, blue: 190, alpha: 1)
        setnoti()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

