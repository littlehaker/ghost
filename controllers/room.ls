module.exports = (app) ->
  login = app.middlewares.user.login
  app.get '/room/:id', login, (req, res) ->
    res.render 'game/index', {
      user: req.user
      roomid: req.params.id
    }
    
  app.io.route 'room:join', (req) ->
    user = req.handshake.user
    info "user #{user.name} joins room:#{req.data.id}"
    room = "room:#{req.data.id}"
    req.io.join room
    req.io.room room .broadcast 'room:join', {user: user}
    