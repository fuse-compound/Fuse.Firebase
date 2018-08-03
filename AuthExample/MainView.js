var Observable = require("FuseJS/Observable");
var FirebaseUser = require("Firebase/Authentication/User");
var EAuth = require("Firebase/Authentication/Email");
var FAuth = require("Firebase/Authentication/Facebook");
var GAuth = require("Firebase/Authentication/Google");
//---

var defaultStatusMessage = "Status OK";
var signedInStatusText = Observable(defaultStatusMessage);
var lobbyStatusText = Observable(defaultStatusMessage);

var userName = Observable("-");
var userEmail = Observable("-");
var userPhotoUrl = Observable("-");
var isEmailVerified = Observable(false);

//---

var mainPage = {title: "Lobby", handle: "lobbyPage"};

var currentPage = Observable(mainPage);

var currentPageHandle = currentPage.map(function(x) {
    return x.handle;
});

var currentPageTitle = currentPage.map(function(x) {
    return x.title;
});

function signedIn() {
    signedInStatusText.value = defaultStatusMessage;
    currentPage.value = {title: "Logged In Page", handle: "loggedInPage"};
    updateUserDetailsUI();
}

function signedOut() {
    currentPage.value = mainPage;
    updateUserDetailsUI();
}

//---

var updateUserDetailsUI = function() {
    if (FirebaseUser.isSignedIn) {
        userName.value = FirebaseUser.name;
        userEmail.value = FirebaseUser.email;
        userPhotoUrl.value = FirebaseUser.photoUrl;
        isEmailVerified.value = FirebaseUser.isEmailVerified;
    } else {
        userName.value = "-";
        userEmail.value = "-";
        userPhotoUrl.value = "-";
        isEmailVerified.value = false;
    }
};

FirebaseUser.onError = function(errorMsg, errorCode) {
    console.log("ERROR(" + errorCode + "): " + errorMsg);
    lobbyStatusText.value = "Error: " + errorMsg;
};

FirebaseUser.signedInStateChanged = function() {
    if (FirebaseUser.isSignedIn)
        signedIn();
    else
        signedOut();
};

//---

var userEmailInput = Observable("");
var userPasswordInput = Observable("");

var createUser = function() {
    var email = userEmailInput.value;
    var password = userPasswordInput.value;
    EAuth.createWithEmailAndPassword(email, password).then(function(user) {
        signedIn();
    }).catch(function(e) {
        console.log("Signup failed: " + e);
        FirebaseUser.onError(e, -1);
    });
};

var signInWithEmail = function() {
    var email = userEmailInput.value;
    var password = userPasswordInput.value;
    EAuth.signInWithEmailAndPassword(email, password).then(function(user) {
        signedIn();
    }).catch(function(e) {
        console.log("SignIn failed: " + e);
        FirebaseUser.onError(e, -1);
    });
};

//---

var reauthenticate = function() {
    FirebaseUser.reauthenticate().then(function(message) {
        console.log("reauthenticated");
    }).catch(function(e) {
        console.log("reauthentication failed:" + e);
    });
};

var signOutNow = function() {
    FirebaseUser.signOut();
};

var sendVerificationEmail = function() {
    EAuth.sendVerificationEmail()
    .then(function(response){
        console.log("Success! "+response)
    }).catch(function(error){
        console.log("There has been an error: "+error)
    });
};

var newEmail = Observable("");
var changeEmail = function() {
    EAuth.updateEmail(newEmail.value)
    .then(function(response){
        console.log("Success! "+response)
    }).catch(function(error){
        console.log("There has been an error: "+error)
    });
};

var newPassword = Observable("");
var changePassword = function() {
    EAuth.updatePassword(newPassword.value)
    .then(function(response){
        console.log("Success! "+response)
    }).catch(function(error){
        console.log("There has been an error: "+error)
    });
};

var checkEmailVerification = function() {
    reauthenticate();
    console.log(FirebaseUser.isEmailVerified);
    isEmailVerified.value = FirebaseUser.isEmailVerified;
};

var sendPasswordResetEmail = function() {
    EAuth.sendPasswordResetEmail(userEmail.value)
    .then(function(response) {
        console.log("Success! " + response);
    }).catch(function(error) {
        console.log("Error: " + error);
    });
}

module.exports = {
    currentPage: currentPage,
    currentPageHandle: currentPageHandle,
    currentPageTitle: currentPageTitle,
    lobbyStatusText: lobbyStatusText,

    userEmailInput: userEmailInput,
    userPasswordInput: userPasswordInput,
    createUser: createUser,
    signInWithEmail: signInWithEmail,

    signedInStatusText: signedInStatusText,
    userName: userName,
    userEmail: userEmail,
    userPhotoUrl: userPhotoUrl,
    reauthenticate: reauthenticate,
    signOutNow: signOutNow,
    sendVerificationEmail: sendVerificationEmail,
    newEmail: newEmail,
    changeEmail: changeEmail,
    newPassword: newPassword,
    changePassword: changePassword,
    isEmailVerified: isEmailVerified,
    checkEmailVerification: checkEmailVerification,
    sendPasswordResetEmail: sendPasswordResetEmail
};
