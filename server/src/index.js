var express = require('express');
var app = express();

// enable cors
var cors = require('cors');
app.use(cors());

// Morgan logger
var logger = require('morgan');
app.use(logger(':date[iso] :url :status :res[content-length] :response-time'));


// host static client
app.use(express.static(__dirname + '/../../client/build/'));


// Initialize db
var s3 = require('./s3');
var pastan = require('./pastan');
s3.getDB(function(err, db) {
  if (err)
    console.log("Error while opening db.");
  console.log("db downloaded.");
  app.set('db', pastan(db));
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

app.get('/api', function(req, res) {
    res.json({
        msg: 'Hello, my name is Pastan.'
    });
});


var items = require('./routes/items');
app.use('/api/items', items);

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

var port = process.env.PORT || 8338;
app.listen(port, function() {
  console.log('Pastan listening on port ' + port + '!');
});
