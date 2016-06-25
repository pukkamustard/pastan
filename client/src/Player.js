module.exports = function(app) {
    // Fix up prefixing
    window.AudioContext = window.AudioContext || window.webkitAudioContext;
    var audioCtx = new AudioContext();

    var loadedBuffers = {};
    var source;

    app.ports.load.subscribe(function(item) {
        var url = item.url;
        var id = item.id;
        console.log('load: ', item);

        var request = new XMLHttpRequest();
        request.open('GET', url, true);
        request.responseType = 'arraybuffer';

        request.onload = function() {
            audioCtx.decodeAudioData(request.response, function(buffer) {
                console.log("Loaded sound", url);
                app.ports.loaded.send(id);
                loadedBuffers[id] = buffer;
            }, function(err) {
                console.log("Failed to load " + url, err);
            });
        };
        request.send();
    });

    app.ports.stop.subscribe(function() {
        if (source) {
            source.stop();
            source = undefined;
        }
    });

    app.ports.play.subscribe(function(id) {
        if (source) {
            source.stop();
        }
        var buffer = loadedBuffers[id];
        if (buffer) {
            console.log("Playing buffer", id);
            source = audioCtx.createBufferSource();
            source.connect(audioCtx.destination);
            source.buffer = buffer;
            source.onended = function() {
                app.ports.ended.send(true);
            }
            source.start(0);
        }
    });
};
