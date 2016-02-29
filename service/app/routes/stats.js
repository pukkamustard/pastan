var express = require('express');
var router = express.Router();

router.route('/')
    .get(function(req, res, next) {
        var db = req.app.get('db');
        items = Object.keys(db.items).length;
        albums = Object.keys(db.albums).length;
        res.json({
            items: items,
            albums: albums
        });
    });

module.exports = router;
