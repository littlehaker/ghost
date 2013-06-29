express = require 'express.io'

MongoStore = (require 'connect-mongo') express

module.exports = {
  key: 'connect.sess'
  secret: 'ghost'
  store: new MongoStore {db: 'ghost'}
}
