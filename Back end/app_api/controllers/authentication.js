var passport = require('passport');
var mongoose = require('mongoose');
var User = mongoose.model('User');

var sendJSONresponse = function(res, status, content) {
  res.status(status);
  res.json(content);
};

module.exports.register = function(req, res) {
  if(!req.body.username || !req.body.password) {
    sendJSONresponse(res, 400, {
      "message": "All fields required"
    });
    return;
  }

  var user = new User();

  user.username = req.body.username;
  user.setPassword(req.body.password);

  user.save(function(err) {
    var token;
    if (err) {
      sendJSONresponse(res, 404, err);
    } else {
      token = user.generateJwt();
      sendJSONresponse(res, 200, {
        "token" : token
      });
    }
  });
};

module.exports.login = function(req, res) {
  if(!req.body.username || !req.body.password) {
    sendJSONresponse(res, 400, {
      "message": "All fields required"
    });
    return;
  }

  passport.authenticate('local', function(err, user, info){
    var token;
    if (err) {
      sendJSONresponse(res, 404, err);
      return;
    }
    if(user){
      token = user.generateJwt();
      sendJSONresponse(res, 200, {
        "token" : token
      });
    } else {
      sendJSONresponse(res, 401, info);
    }
  })(req, res);

};

module.exports.deleteUser = function(req, res){
    if(!req.body.username || !req.body.password) {
    sendJSONresponse(res, 400, {
      "message": "All fields required"
    });
    return;
  }

  passport.authenticate('local', function(err, user, info){
    var token;
    if (err) {
      sendJSONresponse(res, 404, err);
      return;
    }
    if(user){
      var userid = req.body.username
      User
        .findOne({"username":user.username})
        .remove()
        .exec(
          function(err, location){
            if(err){
              console.log(err);
              sendJSONresponse(res, 404, err);
                    return;
            }
            console.log("User id " + userid + " deleted");
                  sendJSONresponse(res, 204, null);
          }
        )
    } else {
      sendJSONresponse(res, 401, info);
    }
  })(req, res);
};