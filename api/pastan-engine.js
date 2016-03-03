var jsonquery = require('jsonquery');

module.exports = pastanEngine;

function pastanEngine() {
    return {
        query: query,
        match: jsonquery.match,
        plans: {
            'property': null,
            'pairs': null
        }
    };
}

function match(objectToMatch, query) {
    return true;
}

function query(q) {
    var db = this;
    var idx = db.indexes['sorted'];
    if (idx) {
        return idx.createIndexStream();
    } else {
        return null;
    }
    // if (idx && idx.type in db.query.engine.plans) {
    // return db.query.engine.plans[idx.type].call(db, queryParts.prop, queryParts);
    // } else if ((idx = db.indexes['*']) && idx.type in db.query.engine.plans) {
    // return db.query.engine.plans[idx.type].call(db, '*', queryParts);
    // } else {
    // return null;
    // }
}
