var Observable = require("FuseJS/Observable");
var Database = require("Firebase/Database");

var input = Observable("");
var data = Observable("-");

function search(){

	// readByQueryEqualToValue
	// Returns items equal to the specified key or value, depending on the order-by method chosen.
	//
	// This query accepts three parameters:
	// The path, the child it will search and the search itself
	// Since we are not using Auth here, make sure your rules are set to public.
	//
	// More info here:
	// https://firebase.google.com/docs/database/web/lists-of-data#filtering_data

	data.value = "Searching...";
	Database.readByQueryEqualToValue("users","email",input.value)
	.then(function(res){
		console.log(res)
		if (res == null){
			data.value = "We got nothing...";
		} else {
			data.value = res;
		}
	})
}

module.exports = {
	input, search, data
};
