_ = require 'underscore'
module.exports = (app) ->
  Hall = app.Hall
  
  app.io.route 'game:msg', (req) ->
    user = req.handshake.user
    roomId = req.session.roomId
    info "Message from #{user.name}: #{req.data.content}"
    # 广播消息
    # app.io.room req.session.room .broadcast 'game:msg', req.data
    room = Hall.findRoom roomId
    room.game.onMsg user, req.data
    # game.broadcast 'game:msg', req.data

  app.io.route 'game:vote', (req) ->
    roomId = req.session.roomId
    room = Hall.findRoom roomId
    user = req.handshake.user
    info "#{user.name} vote for #{req.data}"
    room.game.onVote user, req.data.content