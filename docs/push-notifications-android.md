# Push Notifications on Android

## Setting up the client side

### Step 1.

Include the Firebase libraries in your `.unoproj`

```json
"Projects": [
    "../src/Firebase/Firebase.unoproj",
    "../src/Firebase.Database/Firebase.Database.unoproj"
]
```

### Step 2.

Include the Fuse push notification library by adding the following to your `.unoproj` file

```json
"Projects": [
    "../src/Firebase.Notifications.Android/Firebase.Notifications.Android.unoproj"
]
```

Also add the following to a file called `AndroidImpl.uxl` in the same directory as your `unoproj`

```xml
<Extensions Backend="CPlusPlus" Condition="Android">
    <CopyFile Condition="Android" Name="google-services.json" TargetName="app/google-services.json" />
</Extensions>
```

Finally add you `google-services.json` file from firebase to the same directory as your `unoproj`

## How this behaves in your app

Referencing `Firebase.Notifications.Android` will do the the following:

- You get a callback telling you if the registration succeeded or failed.
- The succeeded callback will contain your unique registration id
- All future received push notifications will fire a callback containing the JSON of the notification.

All three callbacks mentioned are available in JavaScript and Uno.

## Using the API from JavaScript

Integrating with notifications from JavaScript is simple. Here is an example that just logs when the callbacks fire:

```js
<JavaScript>
    var push = require("FuseJS/Push");

    push.on("registrationSucceeded", function(regID) {
        console.log("Reg Succeeded: " + regID);
    });

    push.on("error", function(reason) {
        console.log("Reg Failed: " + reason);
    });

    push.on("receivedMessage", function(payload) {
        console.log("Recieved Push Notification: " + payload);
    });
</JavaScript>
```

Here we're using the @EventEmitter `on` method to register our functions with the different events.
In a real app we should send our `registration ID` to our server when `registrationSucceeded` is triggered.

`registrationSucceeded` may be called multiple times during the lifetime of an app as the registration ID may be updated by Google's backend.

## Server Side

When we have our client all set up and ready to go we move on to the backend.

### Registering the Android app

To enable Firebase Cloud Messaging, you need to register an Android app with your Firebase project.
If you haven't already registered an Android app, follow these steps:

- From the settings page, click the button to add a new Android app to the project
- A dialog will pop up, prompting you for a package name (the other fields are optional). By default, this will be `com.apps.<yourappnameinlowercase>`. However, it is recommended to set your own:

```json
"Android": {
    "Package": "com.mycompany.myapp",
}
```

- After adding the Android app, you will be prompted to download a `google-services.json` file.
    This can be ignored, as it's not needed for push notifications and can always be downloaded later if needed.

### Sending notifications

After rebuilding your project with the new settings, you should be ready to send and receive push notifications.

> **Note:** Fuse currently only supports `data` type messages. See [here for details on messages types](https://firebase.google.com/docs/cloud-messaging/concept-options#data_messages) & [this forum post](https://www.fusetools.com/community/forums/howto_discussions/push_notificacions_with_google_firebase_notificati?page=1&highlight=22e21e83-bbf1-44c9-acc7-0cc9eb00edc9#post-22e21e83-bbf1-44c9-acc7-0cc9eb00edc9) for more information on how we will fix this in future.
> Sadly this means you currently can't use the Firebase Console to send test notifications (they will appear in the notification bar but will fail to reach JS).
> See the example below for an example of how to send messages to a Fuse app.

When your app starts, the `registrationSucceeded` event will be triggered and you will be given the `regID`
This, along with your FCM Server key, are the details that is needed to send that app a notification.

Your server key can be found under the "Cloud Messaging" tab of the Project Settings page (where you obtained your Sender ID).

Here some example Fuse code for sending your app a notification.

```js
<JavaScript>
    var API_ACCESS_KEY = '----HARDCODED API KEY----';
    var regID = '----HARDCODED REG ID FROM THE APP YOU ARE SENDING TO----';

    module.exports.send = function() {
        fetch('https://android.googleapis.com/gcm/send', {
            method: 'post',
            headers: {
                'Authorization': 'key=' + API_ACCESS_KEY,
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({
                registration_ids: [regID],
                data: {
                    title: 'Well would ya look at that!',
                    body: 'Hello from some other app',
                    whatever: 'anything you like'
                }
            })
        }).then(function(response) {
            console.log(JSON.stringify(response));
        }, function(error) {
            console.log(error);
        });
    }
</JavaScript>
```

Whilst hardcoding the RegID is clearly not a good idea, it serves the purpose for this simple test.

## The Notification

Firebase has [two kinds of messages](https://firebase.google.com/docs/cloud-messaging/concept-options) `notification` messages and `data` messages. `Notification` messages are delivered to the notification tray when the app is inactive, `data` messages are delivered to the app (even when in the background or closed).

`notification` messages have this structure:

```json
{
    "notification" : {
        "body" : "great match!",
        "title" : "Portugal vs. Denmark",
        "icon" : "myicon"
    }
}
```

`data` messages have this structure:

```json
{
    "data" : {
        "title": "Well would ya look at!",
        "body": "Hello from some app",
        "icon": "assets/thing.png"
    }
}
```

### Data Messages

Fuse.Firebase provides the following behavior:

- If the app is in the background or closed we make a notification in the notification tray. We use data in the message to customize your notification (sound, title, body, etc)
- If the app is in the foreground we deliver the message straight to JS with nothing in the tray

This gives us behavior on Android that matches [Fuse.APNS](https://github.com/fuse-compound/Fuse.APNS), which we feel is valuable for app similicity.

### 'Notification' Messages

Fuse.Firebase provides the following behavior:

- If the app is in the foreground we deliver the message straight to JS with nothing in the tray
- If the app is in the background or closed we don't get informed by Android. Android will make the notification and we will get informed when the app is next opened.

If you send a notification message you must set the `click_action` to `"fuseFirebaseBackgroundNotify"`. The `click_action` is mandatory and not currently configurable. It is needed to tell Fuse which internal system needed the intent.

Here is an example message using the click action

```json
{
    "registration_ids": ["reg-id"],
    "notification" : {
        "body" : "great match!",
        "title" : "Portugal vs. Denmark",
        "icon" : "myicon",
        "click_action": "fuseFirebaseBackgroundNotify"
    }
}
```

## Message size limits

Google limits the message size to 4096 bytes.

## Notification Bar Icons

On Android you have a few extra options around customizing your notifications. Below we can see how they are set in the `unoproj`

```json
"Android": {
    "NotificationIcon": {
        "LDPI": "NotifIcon.png",
        "MDPI": "NotifIcon.png",
        "HDPI": "NotifIcon.png",
        "XHDPI": "NotifIcon.png",
        "XXHDPI": "NotifIcon.png",
        "XXXHDPI": "NotifIcon.png",
        "Color": "FF00FF"
    }
}
```

Under `NotificationIcon` you can specify the primary icon to use in the notification bar. It [must be monochrome](https://material.io/guidelines/patterns/notifications.html#guidelines) otherwise Android will draw it as a large white square. However you are then allowed to control the color using the `Color` parameter above. It must be specified as hex and must not start with `0x` or similar.

Besides this you are also allowed to specify a 'Large Icon' which `reinforce[s] the notification in a meaningful way`. This icon can be in color and is specified by the notification itself. For example:

```json
"data": {
    "notification": {
        "alert": {
            "title": "Well would ya look at that!",
            "body": "Hello from some other app",
            "icon": "assets/largeIcon0.png:Bundle"
        }
    },
    "payload": "anything you like"
}
```

On receiving this message, `Firebase.Notifications.Android` will attempt to load the icon from the android [R](https://developer.android.com/reference/android/R.html) class or as a `BundledFile`. If this fails it will log the issue but will not throw an exception, this is so that your user won't get a spurious error message when your app isn't running. To include an icon for the above message you add something like the following to your `unoproj`:

```json
"Includes": [
    "*",
    "assets/largeIcon0.png:Bundle"
]
```
