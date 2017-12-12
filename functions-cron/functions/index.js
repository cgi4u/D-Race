// Copyright 2017 Google Inc. All rights reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
'use strict';

var functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp(functions.config().firebase);

exports.daily_job =
    functions.pubsub.topic('daily-tick').onPublish((event) => {
        console.log("This job is ran every day!")

	var db = admin.database();

    	var groupRef = db.ref("groups");
    	groupRef.once("value", function(groups){
      		groups.forEach(function(group){
			var i = 0;
        		group.child("exerciseRanking").ref.orderByValue().once("value", function(sorted){
				var childNum = sorted.numChildren();
				//console.log(childNum);
				sorted.forEach(function(userRec){
					group.ref.child("yesterdayRanking/" + userRec.key).set(childNum - i);
					if (childNum - i == 1){
						group.ref.child("yesterdayMax").set(userRec.val())
					}
					userRec.ref.set(null);
				
					i += 1;
				});
			});
      		});
    	});
    
    	/*var usersRef = db.ref("users/");
    	usersRef.once("value", function(users) {
      		users.forEach(function(user) {
        		console.log("User ID: " + user.key);
        		console.log("Notification token: " + user.child("noti-token").val());
      		});
    	});*/
  });

exports.daily_msg_job =
    functions.pubsub.topic('daily-tick-2').onPublish((event) => {
	console.log("This job is ran every day(num 2)!")

	var db = admin.database();

	var usersRef = db.ref("users/");
    	usersRef.once("value", function(users) {
      		users.forEach(function(user) {
			var notiToken = user.child("noti-token").val();
			var userId = user.key;
			var userRank = null;
			var groupMax = null;

			var userGroup = user.child("group").val();
			var userGroupRef = db.ref("groups/" + userGroup);
    			userGroupRef.once("value", function(group){
				if (group.child("yesterdayRanking").hasChild(userId)){
					userRank = group.child("yesterdayRanking").child(userId).val();
				}
				groupMax = group.child("yesterdayMax").val();

				var msgBody = ""
				if (userRank != null) {
					msgBody = "어제의 그룹 내 운동량 순위는 " +  userRank + "위입니다."
					if (userRank == 1) {
						msgBody += " 축하합니다!"
					} else {
						msgBody += " 오늘은 1위를 노려봅시다!"
					}
				}
				else{
					msgBody = "어제는 운동을 하지 않으셨네요. 좀더 분발합시다."
				}
				
				if (groupMax != null && userRank != 1){
					var hour = Math.floor(groupMax / 60);
					var minute = groupMax % 60;
					msgBody += " 어제의 최고기록은";
					if (hour != 0)
						msgBody += " " + hour + "시간";
					if (minute != 0)
 						msgBody += " " + minute + "분";
					msgBody += "입니다.";
				}

				var payload = {
      					notification: {
        					title: 'D-Race',
        					body: msgBody,
      					}
    				};
				admin.messaging().sendToDevice(notiToken, payload)
				.then(function(response) {
    					// See the MessagingDevicesResponse reference documentation for
    					// the contents of response.
      					console.log("Successfully sent message:", response);
    				})
    				.catch(function(error) {
      					console.log("Error sending message:", error);
    				});
			});
      		});
    	});
  });


exports.monthly_job =
  functions.pubsub.topic('monthly-tick').onPublish((event) => {
    console.log("This job is ran every month!")

    // This registration token comes from the client FCM SDKs.
    var registrationToken = "fJTvpgpTOuY:APA91bF_DhzTW3mv5tt46PH2oqEhCgGRBSa8o3mizFAKZ8hMhlohPPNgIaRP4SsTguzupfgAXBkeUl-eAWNDjwztjvPMe-n6OqlW0YizFlpBJilM3bJkB5lSVct-2KYaSoXh561rr9Da";

    // See the "Defining the message payload" section below for details
    // on how to define a message payload.
    var payload = {
      notification: {
        title: 'Test',
        body: `Every Month.`,
      }
    };

    // Send a message to the device corresponding to the provided
    // registration token.
    admin.messaging().sendToDevice(registrationToken, payload)
    .then(function(response) {
    // See the MessagingDevicesResponse reference documentation for
    // the contents of response.
      console.log("Successfully sent message:", response);
    })
    .catch(function(error) {
      console.log("Error sending message:", error);
    });
  });
