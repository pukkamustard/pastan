var levelup = require('levelup');
var sublevel = require('sublevelup');

var tar = require('tar-fs');
var temp = require('temp').track();

var jsonquery = require('jsonquery');
var hrq2mongoq = require('hrq2mongoq');

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
                cb(null, sublevel(levelup(path + '/db')));
            });
    });
}


function item(db, id, cb) {
    return db.sublevel('items').get(id, {
        valueEncoding: 'json'
    }, cb);
}

function url(item, cb) {
    var params = {
        Key: String(item.id)
    };
    return s3.getSignedUrl('getObject', params, cb);
}

function items(db, query) {
    query = query || {};
    return db.sublevel('items')
        .createValueStream({
            valueEncoding: 'json',
        })
        .pipe(jsonquery(query));
}

function album(db, id, cb) {
    return db.sublevel('albums').get(id, {
        valueEncoding: 'json'
    }, cb);
}

function albums(db, query) {
    query = query || {};
    return db.sublevel('albums')
        .createValueStream({
            valueEncoding: 'json',
        })
        .pipe(jsonquery(query));
}


module.exports = {
    items: items,
    item: item,
    url: url,
    albums: albums,
    album: album,
    open: open
};
