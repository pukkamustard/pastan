var levelup = require('levelup');
var sublevel = require('sublevelup');

var jsonquery = require('jsonquery');
var hrq2mongoq = require('hrq2mongoq');

var OFFLINE_DB_PATH = '/tmp/pastan/';


function open() {
    return sublevel(levelup(OFFLINE_DB_PATH));
}


function item(db, id, cb) {
    return db.sublevel('items').get(id, {
        valueEncoding: 'json'
    }, cb);
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
    open: open
};
