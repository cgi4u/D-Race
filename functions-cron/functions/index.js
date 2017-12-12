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

exports.hourly_job =
    functions.pubsub.topic('hourly-tick').onPublish((event) => {
        console.log("This job is ran every hour!")
    });

exports.daily_job =
    functions.pubsub.topic('daily-tick').onPublish((event) => {
        console.log("This job is ran every day!")
                                                   
        var db = admin.database();

    	var groupRef = db.ref("groups");
    	exerRankRef.once("value", function(snapshot){
      		snapshot.forEach(function(group){
        		exerRankRef.child(group.key).orderByValue().once("value", function(max){
          		max.forEach( function(maxOne) { 
	    			exerRankRef.child("yesterdayMax/" + group.key).set(maxOne.val()); 
            			exerRankRef.child(group.key).set({});
	  		});
		});
		//exerRankRef.child(group.key).set({});
      	});
    	});
    

    var usersRef = db.ref("users/");
    usersRef.once("value", function(users) {
      users.forEach(function(user) {
        console.log("User ID: " + user.key);
        console.log("Notification token: " + user.child("noti-token").val());
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
