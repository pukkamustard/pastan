var express = require('express');
var router = express.Router();
var JSONStream = require('JSONStream');

var pastan = require('../pastan');
var queryparser = require('../queryparser');

router.route('/')
    .get(queryparser, function(req, res, next) {
        var db = req.app.get('db');

        res.setHeader("content-type", "application/json");
        pastan
            .albums(db, req.mongoq)
            .pipe(JSONStream.stringify())
            .pipe(res);

    });

router.param('id', function(req, res, next, id) {
    var db = req.app.get('db');

    pastan.album(db, id, function(err, album) {
        if (err) {
            if (err.notFound) {
                err.status = 404;
                return next(err);
            }
            return next(err);
        }
        req.album = album;
        return next();
    });
});


router.route('/:id')
    .get(function(req, res, next) {
        res.json(req.album);
    });

module.exports = router;
