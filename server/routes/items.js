var express = require('express');
var router = express.Router();
var JSONStream = require('JSONStream');

var s3 = require('../s3');
var queryparser = require('../queryparser');

router.route('/')
    .get(queryparser, function(req, res, next) {
        var db = req.app.get('db');

        res.setHeader("content-type", "application/json");

        req.mongoq = req.mongoq || {};
        db.items.query(req.mongoq)
            .pipe(JSONStream.stringify())
            .pipe(res);

    });

router.param('id', function(req, res, next, id) {
    var db = req.app.get('db');

    var query = {
        id: parseInt(id)
    };
    stream = db.items.query(query)
        .on('data', function(data) {
            stream.pause();
            req.item = data;
            return next();
        })
        .on('end', function() {
            var err = new Error('Item not found.');
            err.status = 404;
            return next(err);
        })
        .on('error', function(err) {
            return next(err);
        });
});

router.route('/:id')
    .get(function(req, res, next) {
        if (req.item)
            res.json(req.item);
        else
            return next();
    });

router.route('/:id/file')
    .get(function(req, res, next) {
        s3.url(req.item, function(err, url) {
            if (err)
                next(err);
            return res.redirect(url);
        });
    });

module.exports = router;
