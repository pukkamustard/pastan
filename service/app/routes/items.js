var express = require('express');
var router = express.Router();
var JSONStream = require('JSONStream');

var pastandb = require('../pastandb');
var queryparser = require('../queryparser');
var s3 = require('../s3');

router.route('/')
    .get(queryparser, function(req, res, next) {
        var db = req.app.get('db');

        res.setHeader("content-type", "application/json");
        pastandb
            .items(db, req.mongoq)
            .pipe(JSONStream.stringify())
            .pipe(res);

    });

router.param('id', function(req, res, next, id) {
    var db = req.app.get('db');

    pastandb.item(db, id, function(err, item) {
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
        return s3.getUrl(req.item)
            .then(function(url) {
                return res.redirect(url);
            });
    });

module.exports = router;
