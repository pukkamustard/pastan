var levelup = require('levelup');
var sublevel = require('sublevelup');

var _ = require('lodash');
var levelQuery = require('level-queryengine');
var pastanEngine = require('./pastan-engine');


var tar = require('tar-fs');
var temp = require('temp').track();

var AWS = require('aws-sdk');
var s3 = new AWS.S3({
    params: {
        Bucket: process.env.PASTAN_S3_BUCKET
    }
});

function open(cb) {
    var params = {
        Key: 'db.tar'
    };
    return temp.mkdir("pastan", function(err, path) {
        return s3.getObject(params)
            .createReadStream()
            .pipe(tar.extract(path))
            .on('finish', function() {
                cb(null, prepare(path));
            })
            .on('error', function(error){
                cb(error, null);
            });
    });
}

function prepare(path) {
    var db = sublevel(levelup(path + '/db', {
        valueEncoding: 'json'
    }));

    db.items = levelQuery(db.sublevel('items'));

    // custom query engine
    db.items.query.use(pastanEngine());
    db.items.ensureIndex('sorted', function(key, value, emit) {
        fields = ['albumartist', 'original_year', 'album_id', 'track'];
        emit(_.map(fields, function(field) {
            return value[field];
        }));
    });

    return db;
}


function item(db, id, cb) {
    return db.items.get(id, cb);
}

function url(item, cb) {
    var params = {
        Key: String(item.id)
    };
    return s3.getSignedUrl('getObject', params, cb);
}

function items(db, query) {
    query = query || {};
    // console.log(query);
    return db.items.query(query)
        .on('stats', function(stats) {
            console.log(stats);
        });
}

// function album(db, id, cb) {
//     return db.sublevel('albums').get(id, {
//         valueEncoding: 'json'
//     }, cb);
// }
//
// function albums(db, query) {
//     query = query || {};
//     return db.sublevel('albums')
//         .createValueStream({
//             valueEncoding: 'json',
//         })
//         .pipe(jsonquery(query));
// }


module.exports = {
    items: items,
    item: item,
    url: url,
    // albums: albums,
    // album: album,
    prepare: prepare,
    open: open
};
