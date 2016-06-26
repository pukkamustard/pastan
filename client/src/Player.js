module.exports = function(app) {
    var player = document.createElement("AUDIO");

    // player.src = "http://localhost:8338/api/items/8115/file";
    // player.play();

    app.ports.play.subscribe(function(src) {
        player.src = src;
        console.log(src);
        // player.load();
        player.play();
    });

    app.ports.pause.subscribe(function() {
        player.pause();
    });

    player.addEventListener("ended", function() {
        app.ports.ended.send(false);
    });

};
