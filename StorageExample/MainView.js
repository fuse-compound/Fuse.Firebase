var Observable = require("FuseJS/Observable");
var CameraRoll = require("FuseJS/CameraRoll");
var Storage = require("Firebase/Storage");

var url = Observable("Upload a picture...");

function upload(){
    CameraRoll.getImage()
    .then(function(image) {
        var path = "myPicture.jpg";
        var img = image.path;
        url.value = "Uploading... Please wait";
        Storage.upload(path,img)
            .then(function(res){
                url.value = res;
            }).catch(function(err){
                url.value = err;
            })
    }, function(error) {
        url.value = error;
    });
}

module.exports = {
    upload,url
};
