_ = require 'underscore'
module.exports = (app) ->
  app.io.route 'game:msg', (req) ->
    user = req.handshake.user
    info "Message from #{user.name}: #{req.data.content}"
    # 广播消息
    req.io.room req.session.room .broadcast 'game:msg', req.data