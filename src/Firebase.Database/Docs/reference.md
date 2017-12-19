# API Reference | Firebase Database

## Initialization
All the following firebase functions are accesible throught a firebase instance.
```js
var Database = require("Firebase/Database");

```

## Functions
* [`Push`](#push)
* [`Save`](#save)
* [`Listen`](#listen)
* [`OnData`](#ondata)
* [`Read`](#read)
* [`Delete`](#delete)


## Push
Adds a new child in the given path.

#### Parameters
* `reference` - Path where the new child will be added
* `child` - JSON to add

#### Return
This method returns the key of the new record.

#### Example
```js
var user = {
  name : "Joe Doe",
  email: 'joedoe@example.com'
}
Database.push("users", user);
```

## Save
If changes are made to data, then calling save() will push those changes to the server. It's the equivalent of native `setValue` method.

#### Parameters
* `reference` - Path of the object
* `object` - JSON to set

#### Example
```js
var user = {
  name : "Juan Perez",
  email: 'juanperez@example.com'
}
Database.save("users/customId", user);
```

## Listen
Set a path to listen when a change ocurrs in the database. The events will be catched by [`onData`](#ondata)

#### Parameters
* `reference` - Path to listen

#### Example
```js
Database.listen("users");
```

## OnData
Trigger a function with `path` and `msg` when there is any change in the specified path.

#### Example
```js
Database.listen("users");
Database.on("data", function(path, msg) {
    console.log(path); // users
    console.log(msg); // {"-L0hFqwnwiTrw2aE5bnV":{"name":"Joe Doe","email":"joedoe@example.com"} ... }
});
```

## Read
Read an object from the database on a specific path.

#### Parameters
* `reference` - Path where the object will be read out

#### Return
String representing the object. It could be `null` if the object does not exist in the given route.

#### Example
```js
Database.read("users")
    .then(function(result) {
        console.log(result); // {"-L0hFqwnwiTrw2aE5bnV":{"name":"Joe Doe","email":"joedoe@example.com"} ... }
    });
```

## Delete
Delete an object in the database on a specific path.

#### Parameters
* `reference` - Path of the object to be deleted

#### Example
```js
Database.delete("users/customId");
```
