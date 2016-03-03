var hrq2mongoq = require("hrq2mongoq");

module.exports = function(req, res, next) {
    if (req.query.q) {
        try {
            req.mongoq = hrq2mongoq.parse(req.query.q);
            next();
        } catch(err) {
            var parseError = new Error("Invalid query.");
            parseError.parsingDetails = err;
            parseError.status = 400;
            return next(parseError);
        }
    } else {
        return next();
    }
};
