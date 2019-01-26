var express = require('express');
var router = express.Router();
var jwt = require('express-jwt');
var auth = jwt({
  secret: '',
  userProperty: ''
});

var ctrlScores = require('../controllers/scores');
var ctrlAuth = require('../controllers/authentication');

router.get('/scores', ctrlScores.scoresList); //Done
router.post('/scores', auth, ctrlScores.scoresCreate); //Done
router.post('/getScore', ctrlScores.scoresReadOne);
router.put('/scores', auth, ctrlScores.scoresUpdateOne); //Done
router.delete('/scores', auth, ctrlScores.scoresDeleteOne); //Done

router.post('/register', ctrlAuth.register); //Done
router.post('/login', ctrlAuth.login); //Done
router.delete('/deleteUser', ctrlAuth.deleteUser); //Done

module.exports = router;
