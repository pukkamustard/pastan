var express = require('express');
var router = express.Router();

var s3 = require('../s3');

router.route('/')
    .get(function(req, res, next) {
        var db = req.app.get('db');
        res.json(db.albums);
    });

router.param('id', function(req, res, next, id) {
    var albums = req.app.get('db').albums;

    if (id in albums) {
        req.album = albums[id];
        return next();
    } else {
        var err = new Error('Album not found.');
        err.status = 404;
        return next(err);
    }
});


router.route('/:id')
    .get(function(req, res, next) {
        res.json(req.album);
    });

module.exports = router;
