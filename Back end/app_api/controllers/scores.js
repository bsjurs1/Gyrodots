var mongoose = require('mongoose');
var scoreModel = mongoose.model('Score');
var User = mongoose.model('User');

var sendJsonResponse = function(res, status, content) {
	res.status(status);
	res.json(content);
};

var getAuthor = function(req, res, callback) {
  console.log("Finding author with username " + req.body.username);
  if (req.body.username) {
    User
      .findOne({username: req.body.username})
      .exec(function(err, user) {
        if (!user) {
          sendJSONresponse(res, 404, {
            "message": "User not found"
          });
          return;
        } else if (err) {
          console.log(err);
          sendJSONresponse(res, 404, err);
          return;
        }
        console.log(user);
        callback(req, res, user.username);
      });

  } else {
    sendJSONresponse(res, 404, {
      "message": "User not found"
    });
    return;
  }
};

module.exports.scoresList = function(req, res){
	scoreModel
		.find()
		.exec(function(err, score){
			//If mongoose does´nt return a score, send 404 message, and exit function
			if(score.length == 0){
				sendJsonResponse(res, 404, {
					"message" : "no scores in database"
				});
				return;
			} else if(err){
				//See if mongoose returned an error
				sendJsonResponse(res, 404, err);
				return;
			}
			sendJsonResponse(res, 200, score);
		});
};

module.exports.scoresCreate = function(req, res){
	getAuthor(req, res, function(req, res, userName){
		scoreModel.create({
			username: req.body.username,
			score: req.body.score
		}, function(err, score){
		if (err) {
      		console.log(err);
      		sendJsonResponse(res, 400, err);
    	} else {
      		console.log(score);
      		sendJsonResponse(res, 201, score);
    	}
	});
	});
};

module.exports.scoresReadOne = function(req, res){
		//Error trap 1, check that userid exist in request parameters
		if(req.body.username){
			scoreModel
			.find({username : req.body.username})
			.exec(function(err, score){
				//If mongoose does´nt return a score, send 404 message, and exit function
				if(score.length == 0){
					sendJsonResponse(res, 404, {
						"message" : "userid not found"
					});
					return;
				} else if(err){
					//See if mongoose returned an error
					sendJsonResponse(res, 404, err);
					return;
				}
				sendJsonResponse(res, 200, score);
			});
		} else {
			sendJsonResponse(res, 404, {
				"message" : "No userid in request"
			});
		}
};

module.exports.scoresUpdateOne = function(req, res){
	getAuthor(req, res, function(req, res, username){
		if(!req.body.username){
			sendJsonResponse(res, 404, {
	      "message": "Not found, userid is required"
	    });
	    return;
		}

		scoreModel.findOne({'username':req.body.username})
			.exec(function(err, score){

				if(!score){
					sendJsonResponse(res, 404, {
	            	"message": "userid not found"
	          	});
	          		return;
				} else if(err){
					sendJsonResponse(res, 400, err);
					return;
				}

				score.score = req.body.score;

				score.save(function(err, score){
				if (err) {
	            	sendJsonResponse(res, 404, err);
	          	} else {
	            	sendJsonResponse(res, 200, score);
	          	}
				console.log(score);
			});
		});
	});
};

module.exports.scoresDeleteOne = function(req, res){
	getAuthor(req, res, function(req, res, username){
		var userid = req.body.username
		if(userid){
			scoreModel
				.findOne({"username":userid})
				.remove()
				.exec(
					function(err, location){
						if(err){
							console.log(err);
							sendJsonResponse(res, 404, err);
	            			return;
						}
						console.log("User id " + userid + " deleted");
	          			sendJsonResponse(res, 204, null);
					}
				)
		} else {
	    	sendJsonResponse(res, 404, {
	      	"message": "No locationid"
	    });
	  }
	});
};