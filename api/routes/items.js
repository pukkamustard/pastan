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
            .items(db, req.mongoq)
            .pipe(JSONStream.stringify())
            .pipe(res);

    });

router.param('id', function(req, res, next, id) {
    var db = req.app.get('db');

    pastan.item(db, id, function(err, item) {
        if (err) {
            if (err.notFound) {
                err.status = 404;
                return next(err);
            }
            return next(err);
        }
        req.item = item;
        return next();
    });
});


router.route('/:id')
    .get(function(req, res, next) {
        res.json(req.item);
    });

router.route('/:id/file')
    .get(function(req, res, next) {
        pastan.url(req.item, function(err, url) {
            if (err)
                next(err);
            return res.redirect(url);
        });
    });

module.exports = router;
