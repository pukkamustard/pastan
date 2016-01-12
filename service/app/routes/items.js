var express = require('express');
var router = express.Router();

var s3 = require('../s3');

router.route('/')
    .get(function(req, res, next) {
        var db = req.app.get('db');
        res.json(db.items);
    });

router.param('id', function(req, res, next, id) {
    var items = req.app.get('db').items;

    if (id in items) {
        req.item = items[id];
        return next();
    } else {
        var err = new Error('Item not found.');
        err.status = 404;
        return next(err);
    }
});


router.route('/:id')
    .get(function(req, res, next) {
        res.json(req.item);
    });

router.route('/:id/url')
    .get(function(req, res, next) {
        return s3.getUrl(req.item)
            .then(function(url) {
                res.json({
                    url: url
                });
            });
    });

module.exports = router;
