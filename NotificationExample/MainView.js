var Push = require("Firebase/Notifications");
var Observable = require("FuseJS/Observable");

var status = Observable("-");
var message = Observable("-no message yet-");

Push.onRegistrationSucceeded = function(regID) {
    console.log ("Reg Succeeded: " + regID);
    status.value = "onRegistrationSucceeded: " + regID;
};

Push.onRegistrationFailed = function(reason) {
    console.log ("Reg Failed: " + reason);
};

Push.onReceivedMessage = function(payload, fromNotificationBar) {
    console.log ("Recieved Push Notification: " + payload);
    console.log ("fromNotificationBar="+fromNotificationBar);
    message.value = payload;
};

var clearBadgeNumber = function() {
    Push.clearBadgeNumber();
}

var clearAllNotifications = function() {
    Push.clearAllNotifications();
}

module.exports = {
    clearBadgeNumber: clearBadgeNumber,
    clearAllNotifications: clearAllNotifications,
    message: message,
    status: status
};
