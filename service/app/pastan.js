var levelup = require('levelup');
var sublevel = require('sublevelup');

var jsonquery = require('jsonquery');
var hrq2mongoq = require('hrq2mongoq');

var OFFLINE_DB_PATH = '/tmp/pastan/db/';

var AWS = require('aws-sdk');

var s3 = new AWS.S3({
    params: {
        Bucket: process.env.PASTAN_S3_BUCKET
    }
});


function open() {
    return sublevel(levelup(OFFLINE_DB_PATH));
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

module.exports = {
    items: items,
    item: item,
    url: url,
    open: open
};
