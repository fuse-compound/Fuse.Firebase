# Firebase Database API

### Initialization
All the following firebase functions are accessible through a firebase instance.
```js
var Database = require("Firebase/Database");
```

### Functions
* [`Push`](#push)
* [`Save`](#save)
* [`Listen`](#listen)
* [`OnData`](#ondata)
* [`Read`](#read)
* [`Delete`](#delete)
* [`Query`](#query)

<br>
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
<br>

## Push with timestamp
This will insert new object to given path, it will have `timestamp` property set by Firebase server

#### Parameters
* `reference` - Path where the new child will be added
* `child` - JSON to add

#### Example

```js
Database.pushWithTimestamp(path, data);
```
<br>


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
<br>

## Listen
Set a path to listen when a change occurs in the database. The events will be caught by [`onData`](#ondata)

#### Parameters
* `reference` - Path to listen

#### Example
```js
Database.listen("users");
```
<br>

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
<br>

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
<br>

## Delete
Delete an object in the database on a specific path.

#### Parameters
* `reference` - Path of the object to be deleted

#### Example
```js
Database.delete("users/customId");
```
<br>

## Query
Search in the database by using specific key.

#### Parameters
* `path` - Path of the object to be deleted
* `key` - The key to search in
* `value` - The value to search

#### Example
```js
Database.readByQueryEqualToValue("users","name","Luis Rodriguez")
    .then(function (json) {
        console.log(json);
    }).catch(function (reason) {
        console.log('Unable to read -> ' +reason);
    });
```
<br>

### Query subset of records

Say you want to get old messages for particular user you want to get messages before particular timestamp

#### Example
```JavaScript
var chatMessagesPath = 'users/pavel/messages';
var oldestMessageTimestamp = 1517459417719;
var count = 20;

// We're going to query 20 messages before `oldestMessageTimestamp`

Database.readByQueryEndingAtValue(
    chatMessagesPath,
    'timestamp', // field we're comaring with
    oldestMessageTimestamp, // oldest message timestamp on our device
    count // how many records to get
);

// You need to do this only once in your code
// This event handler will be called for every Database.readByQueryEndingAtValue method
Database.on('readByQueryEndingAtValue', function (eventPath, newMessages) {
    // newMessages here is a JSON string
    if (eventPath === chatMessagesPath) {
        console.log(chatMesssagesPath);
        console.log(newMessages);
    }
});
```
