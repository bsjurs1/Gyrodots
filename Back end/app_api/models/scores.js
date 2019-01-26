var mongoose = require('mongoose');

var scoreSchema = new mongoose.Schema({
	username : {type : String, required : true, unique : true},
	score : {type : Number, "default" : 0, required : true, min: 0}
});

mongoose.model('Score', scoreSchema);