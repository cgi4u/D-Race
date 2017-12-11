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

    // This registration token comes from the client FCM SDKs.
    var registrationToken = "fJTvpgpTOuY:APA91bF_DhzTW3mv5tt46PH2oqEhCgGRBSa8o3mizFAKZ8hMhlohPPNgIaRP4SsTguzupfgAXBkeUl-eAWNDjwztjvPMe-n6OqlW0YizFlpBJilM3bJkB5lSVct-2KYaSoXh561rr9Da";

    // See the "Defining the message payload" section below for details
    // on how to define a message payload.
    var payload = {
      notification: {
        title: 'Test',
        body: `Every Hour.`,
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

exports.daily_job =
  functions.pubsub.topic('daily-ㄴtick').onPublish((event) => {
    console.log("This job is ran every day!")

    // This registration token comes from the client FCM SDKs.
    var registrationToken = "fJTvpgpTOuY:APA91bF_DhzTW3mv5tt46PH2oqEhCgGRBSa8o3mizFAKZ8hMhlohPPNgIaRP4SsTguzupfgAXBkeUl-eAWNDjwztjvPMe-n6OqlW0YizFlpBJilM3bJkB5lSVct-2KYaSoXh561rr9Da";

    // See the "Defining the message payload" section below for details
    // on how to define a message payload.
    var payload = {
      notification: {
        title: 'Test',
        body: `Every Day.`,
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