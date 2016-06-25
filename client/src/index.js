require('./style/main.scss');

var Elm = require('./Main.elm');

var app = Elm.Main.fullscreen();

// Load Player
var player = require('./Player.js')(app);
