_ = require 'underscore'
module.exports = (app) ->
  app.io.route 'game:msg', (req) ->
    user = req.handshake.user
    info "Message from #{user.name}: #{req.data.content}"
    # 广播消息
    # app.io.room req.session.room .broadcast 'game:msg', req.data
    game = app.GameCenter.findGame req.session.room
    game.onMsg user, req.data
    # game.broadcast 'game:msg', req.data

  app.io.route 'game:vote', (req) ->
    user = req.handshake.user
    info "#{user.name} vote for #{req.data}"
    game.onVote user, req.data