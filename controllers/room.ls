module.exports = (app) ->
  login = app.middlewares.user.login
  app.get '/room/:id', login, (req, res) ->
    console.log req.session
    req.session.id = 'xxx'
    res.render 'game/index', {
      user: req.user
      roomid: req.params.id
    }
    
  app.io.route 'room:join', (req) ->
    user = req.handshake.user
    info "user #{user.name} joins room:#{req.data.id}"
    room = "room:#{req.data.id}"
    req.io.join room
    req.session.room = room
    req.io.room room .broadcast 'room:join', {user: user}

  app.io.route 'game:start', (req) ->
    user = req.handshake.user
    