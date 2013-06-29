passportSocketIo = require('passport.socketio')
_ = require('underscore')
express = require('express.io')

module.exports = (app) ->
  app.io.configure ->
    app.io.enable 'browser client minification'
    app.io.enable 'browser client gzip'  
    app.io.set 'log level', 4
    app.io.set "authorization", passportSocketIo.authorize {
      cookieParser: express.cookieParser
      key: app.config.session.key
      secret: app.config.session.secret
      store: app.config.session.store
      success: (data, accept) ->
        accept null, true
      fail: (data, accept) ->
        accept null, false
    }
