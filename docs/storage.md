# Firebase Storage API

> Note: The Firebase Storage API is not yet completed. Help is more than welcomed.

### How To Add:

#### Step 1

As always, include the Firebase libraries in your `.unoproj`

```json
"Projects": [
    "../src/Firebase/Firebase.unoproj",
    "../src/Firebase.Database/Firebase.Database.unoproj"
]
```

#### Step 2

Add the storage library

```json
"Projects": [
    "../src/Firebase.Storage/Firebase.Storage.unoproj"
]
```

#### Step 3

Require it in your JS file

```js
var Storage = require("Firebase/Storage");
```


### How To Use:

Currently, you can upload an image and it will return the url

```js
var Storage = require("Firebase/Storage");
var CameraRoll = require("FuseJS/CameraRoll");

function uploadPicture(){
    CameraRoll.getImage()
        .then(function(image) {
            var path = "pictures/myPicture.jpg";
            var img = image.path;
            Storage.upload(path,img)
                .then(function(res){
                    console.log(res)
                }).catch(function(err){
                    console.log(err)
                })
        });
}
```
