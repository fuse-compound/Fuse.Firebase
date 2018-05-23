var Environment = require("FuseJS/Environment");
var PushiOS = require("FuseJS/Push");
var PushAndroid = require("Firebase/Notifications");
var Observable = require("FuseJS/Observable");
var Nots = require("TokenModule");

var Push;
if(Environment.ios){
    Push = PushiOS;
} else {
    Push = PushAndroid;
}

var status = Observable("-");
var message = Observable("-no message yet-");

Push.onRegistrationSucceeded = function(regID) {
    console.log ("Reg Succeeded: " + regID);
    Nots.GetFBToken()
        .then(function(response) {
            console.log("Firebase Token: " + response)
            status.value = "Success! Check your console";
        });
};

Push.onRegistrationFailed = function(reason) {
    console.log ("Reg Failed: " + reason);
};

Push.onReceivedMessage = function(payload, fromNotificationBar) {
    console.log ("Recieved Push Notification: " + payload);
    console.log ("fromNotificationBar="+fromNotificationBar);
    message.value = payload;
};

function getToken(){
    Nots.GetFBToken()
        .then(function(response) {
            console.log("Firebase Token: " + response)
            status.value = "Success! Check your console";
        });
}

module.exports = {
    message: message,
    status: status,
    getToken
};
