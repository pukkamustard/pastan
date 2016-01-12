var express = require('express');
var app = express();

var s3 = require('./s3');

app.get('/', function(req, res) {
    res.send('Hello World!');
});

// app.listen(3000, function() {
//     console.log('Example app listening on port 3000!');
// })


var db;
s3.getDb().then(function(b) {
    db = b;
    console.log(db)
})
