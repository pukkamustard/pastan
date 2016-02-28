var express = require('express');
var cors = require('cors');
var app = express();

var s3 = require('./s3');

s3.getDb().then(function(db) {
    app.set('db', db);
}).catch(function(error) {
    console.error(error);
});

// enable cors
app.use(cors());

app.get('/', function(req, res) {
    res.send('Hello my name is Pastan!');
});

var items = require('./routes/items');
app.use('/items', items);

var items = require('./routes/albums');
app.use('/albums', items);

// development error handler
// will print stacktrace
if (app.get('env') === 'development') {
    app.use(function(err, req, res, next) {
        res.status(err.status || 500);
        console.log(err.stack);
        res.json({
            message: err.message,
            error: err
        });
    });
}

// production error handler
// no stacktraces leaked to user
app.use(function(err, req, res, next) {
    res.status(err.status || 500);
    res.json({
        message: err.message,
    });
});


module.exports = app;

app.listen(8338, function() {
    console.log('Pastan listening on port 8338!');
});
