module.exports = (app) -> (require 'mongoose').connect app.config.db.mongo
