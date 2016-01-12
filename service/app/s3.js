var Promise = require('bluebird');

var AWS = require('aws-sdk-promise');
var s3bucket = new AWS.S3({
    params: {
        Bucket: process.env.PASTAN_S3_BUCKET
    }
});

function getDb() {
    var params = {
        Key: 'db.json'
    };
    return s3bucket.getObject(params).promise()
        .then(function(req) {
            return JSON.parse(req.data.Body.toString());
        });
}

var getSignedUrl = Promise.promisify(function(params, cb) {
    s3bucket.getSignedUrl('getObject', params, cb);
});

function getUrl(item) {
    var params = {
        Key: String(item.id)
    };
    return getSignedUrl(params);
}

module.exports = {
    getDb: getDb,
    getUrl: getUrl
};
