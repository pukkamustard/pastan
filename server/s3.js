var tar = require('tar-fs');
var temp = require('temp').track();

var AWS = require('aws-sdk');
var s3 = new AWS.S3({
    params: {
        Bucket: process.env.PASTAN_S3_BUCKET
    }
});

function getDB(cb) {
    var params = {
        Key: 'db.tar'
    };
    return temp.mkdir("pastan", function(err, path) {
        return s3.getObject(params)
            .createReadStream()
            .pipe(tar.extract(path))
            .on('finish', function() {
                cb(null, path);
            })
            .on('error', function(error) {
                cb(error, null);
            });
    });
}

function url(item, cb) {
    var params = {
        Key: String(item.id)
    };
    return s3.getSignedUrl('getObject', params, cb);
}

module.exports = {
    getDB: getDB,
    url: url
};
