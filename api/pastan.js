var levelup = require('levelup');
var sublevel = require('sublevelup');

var bytewise = require('bytewise');

var levelQuery = require('level-queryengine');
var jsonqueryEngine = require('jsonquery-engine');


module.exports = function pastan(path) {

    // open db
    var cloud = sublevel(levelup(path + '/db', {
        valueEncoding: 'json'
    }));
    cloud.items = cloud.sublevel('items');

    var db = sublevel(levelup(path + '/db_read', {
        valueEncoding: 'json'
    }));
    db.items = levelQuery(db.sublevel('items'));

    // TODO: do this in batch
    cloud.items.createValueStream()
        .on('data', function(data) {
            var key = encode(data);
            db.items.put(key, data);
        });

    db.items.query.use(jsonqueryEngine());
    db.items.ensureIndex('artist');
    db.items.ensureIndex('id');

    console.log("db ready.");
    return db;
};

function encode(data) {
    fields = ['albumartist', 'original_year', 'album_id', 'track'];
    var a = fields.map(function(field) {
        return data[field];
    });
    return bytewise.encode(a);
}
