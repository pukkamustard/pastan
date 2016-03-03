var express = require('express');
var cors = require('cors');
var app = express();

var pastan = require('./pastan');



// enable cors
app.use(cors());


// Morgan logger
var logger = require('morgan');
app.use(logger(':date[iso] :url :status :res[content-length] :response-time'));


app.get('/', function(req, res) {
    res.json({
        msg: 'Hello, my name is Pastan.'
    });
});

// Initialize db
pastan.open(function(err, db) {
    if (err)
        console.log("Error while opening db.");
    console.log("db ready.");
    app.set('db', db);
});

app.use(function(req, res, next) {
    if (!app.get('db')) {
        res.status = 503;
        res.json({
            message: "Database not ready."
        });
    } else {
        return next();
    }
});

var items = require('./routes/items');
app.use('/items', items);

// var albums = require('./routes/albums');
// app.use('/albums', albums);

// development error handler
// will print stacktrace
if (app.get('env') === 'development') {
    app.use(function(err, req, res, next) {
        res.status(err.status || 500);
        if (!err.status)
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
