var express = require('express');
var router = express.Router();

var locations = require('../tmp/locations/locations.json');

/* GET home page. */
router.get('/', function(req, res, next) {
    res.render('index', {
        title: 'Markers',
        locations: locations
    });
});

module.exports = router;