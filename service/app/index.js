var express = require('express');
var app = express();

var s3 = require('./s3');

var db;
s3.getDb().then(function(b) {
    db = b;
})


app.get('/', function(req, res) {
    res.send('Hello my name is Pastan!');
});


app.get('/items', function(req, res, next) {
    res.json(db.items)
})

app.get('/items/:id', function(req, res, next) {
    var id = req.params.id;
    res.json(db.items[id])
})

app.get('/items/:id/url', function(req, res, next) {
    var id = req.params.id;
    var item = db.items[id];
    return s3.getUrl(item)
        .then(function(url) {
            res.json({
                url: url
            })
        });
})

app.listen(8338, function() {
    console.log('Pastan listening on port 8338!');
})
