# Fuse.Firebase
[![license](https://img.shields.io/github/license/cbaggers/Fuse.Firebase.svg?maxAge=2592000)](https://github.com/cbaggers/Fuse.Firebase/blob/master/LICENSE)
[![Build Status](https://travis-ci.org/cbaggers/Fuse.Firebase.svg?branch=master)](https://travis-ci.org/cbaggers/Fuse.Firebase)

This project's goal to make full Firebase bindings for Fuse. Currently we have:

- Authentication using the Email, Google & Facebook providers.
- Basic Ad & Analytics support.

All are welcome to come hacking on this so we can flesh this out to cover the full gammut of features provided by Firebase! Whether it's as small as a typo fix or as large and a entire feature, please feel free to fork and summit pull requests.

## Docs

See [here for our documentation](docs/index.md)

## Requirements

- Fuse version >= 0.25: This is needed as a bunch of changes shipped in that version to make this all possible including appcompat7 Activity as super class for the app's activity
- Firebase account
- [Cocoapods](https://cocoapods.org/) (if working on OSX) It should be enough just to run `sudo gem install cocoapods`

For authentication you also need a Facebook developer account

## Disclaimer

I'm an employee at Fuse, however any views, opinions or swearing at apis found in this repo & wiki are my own and do not necessarily reflect the official views of Fuse or anyone else working there :)

## Obligatory Pic!

![wee](https://github.com/cbaggers/Fuse.Firebase/blob/master/docs/app.jpeg)

## HOWTO

### Create new record

```
var firebaseDb = require("Firebase/Database");
var path = 'users';
var data = {
    name: 'Pavel'
};

// this will insert new object to given path
firebaseDb.pushWithTimestamp(path, data);

// new object in database will have `timestamp` property set by Firebase server
{
    name: 'Pavel',
    timestamp: 1517459417719
}

// if you want to receive event when record was created, read below
// if you do not want timestamp property to be created by firebase server
// use `.push(path, data)` method instead
```

### Read Data

```
// firebaseDb.read(path) <Promise>

var firebaseDb = require("Firebase/Database");
var path = 'users/pavel';
firebaseDb.read(path)
            .then(function (json) {
                // here json is a JSON string
                console.log(JSON.parse(json));
            })
            .catch(function (reason) {
                console.log('Unable to read path: ' + path);
            });
```

### Listen for data event

* this event is fired when you change particular object.
* first you need to know the path to this object
* create listener
* subscribe to data event

```
var firebaseDb = require("Firebase/Database");
var path1 = 'users/pavel';
var path2 = 'users/mitul';
// create listeners for data event for 2 paths
firebaseDb.listen(path1);
firebaseDb.listen(path2);

// handle responses from Firebase
// you subscribe once, and will receive events for any path
// you're listening above
firebaseDb.on('data', function (eventPath, msg) {
        // msg here is a JSON string
        // track only given path
        if (eventPath === path1) {
            console.log(path1);
            console.log(msg);
            // convert JSON to object
            var user1 = JSON.parse(msg);
        }
        if (eventPath === path2) {
            console.log(path2);
            console.log(msg);
            // convert JSON to object
            var user2 = JSON.parse(msg);
        }
    });
```

### Listen for dataAdded events

```
var firebaseDb = require("Firebase/Database");
var usersPath = 'users';
var messagesPath = 'messages';

// create listener for given path
// 1 means that you will always receive last object from `path` after you call `.listenOnAdded`
// this doesn't means that this object was just added, it's just how firebase iOS/Android library works
// more on that: https://firebase.google.com/docs/database/ios/lists-of-data
// find FIRDataEventTypeChildAdded and read how it works. It's not our fault :)
// so you need to take care about that and do not insert same record twice
// it's not possible to set it to 0, so 1 is a safe default
// if you set it to 10 you'll get last 10 records from given `path`

firebaseDb.listenOnAdded(usersPath, 1);
firebaseDb.listenOnAdded(messagesPath, 1);

// now subscribe to `dataAdded` events
// you need to subscribe only once
// function below will be executed for any path
firebaseDb.on('dataAdded', function (eventPath, msg) {
        // msg here is a JSON string
        
        // track only given path
        if (eventPath === usersPath) {
            // new user record was added, usually by push method
            // if you created record using not .push method or 
            // pushWithTimestamp you will not receive event here
            console.log(eventPath);
            console.log(msg);
            var newUser = JSON.parse(msg);
        }
        
        if (eventPath === messagesPath) {
            // new message record was added, usually by push method
            // if you created record using not .push method or 
            // .pushWithTimestamp you will not receive event here
            console.log(eventPath);
            console.log(msg);
            var newMessage = JSON.parse(msg);
        }
    });

```

### Listen for dataRemoved events

```
var firebaseDb = require("Firebase/Database");
var usersPath = 'users';
var messagesPath = 'messages';

// create listener for given path
// 1 means that you will always receive last object from `path`
// it's not possible to set it to 0, so 1 is a safe default
// if you set it to 10 you'll get last 10 records from given `path`

firebaseDb.listenOnRemoved(usersPath, 1);
firebaseDb.listenOnRemoved(messagesPath, 1);

// now subscribe to `dataAdded` events
// you need to subscribe only once
// function below will be executed for any path
firebaseDb.on('dataRemoved', function (eventPath, msg) {
    // msg here is a JSON string
            
    // track only given path
    if (eventPath === usersPath) {
        // user record was removed
        console.log(eventPath);
        console.log(msg);
        var newUser = JSON.parse(msg);
    }
    
    if (eventPath === messagesPath) {
        // message record was removed
        console.log(eventPath);
        console.log(msg);
        var newMessage = JSON.parse(msg);
    }
});

```

### Query subset of records

* say you want to get old messages for particular user
* you want to get messages before particular timestamp

```
var chatMessagesPath = 'users/pavel/messages';
var oldestMessageTimestamp = 1517459417719;
var count = 20;

// we're going to query 20 messages before `oldestMessageTimestamp`

firebaseDb.readByQueryEndingAtValue(
    chatMessagesPath,
    'timestamp', // field we're comaring with
    oldestMessageTimestamp, // oldest message timestamp on our device
    count // how many records to get
);

// you need to do this only once in your code
// this event handler will be called for every firebaseDb.readByQueryEndingAtValue method
firebaseDb.on('readByQueryEndingAtValue', function (eventPath, newMessages) {
    // newMessages here is a JSON string
    if (eventPath === chatMessagesPath) {
        console.log(chatMesssagesPath);
        console.log(newMessages);
        var data = JSON.parse(newMessages);
    } else {
        // somebody requested data for other firebase path
    }
});
```
