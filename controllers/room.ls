module.exports = (app) ->
  login = app.middlewares.user.login
  app.get '/room/:id', login, (req, res) ->
    res.render 'game/index', {
      user: req.user
      roomid: req.params.id
    }

  app.io.route 'room:create', (req) ->
    user = req.handshake.user
    room = app.Hall.createRoom {
      creator: (new app.lib.player req)
    }
    req.io.respond room
        
  app.io.route 'room:join', (req) ->
    user = req.handshake.user
    game = app.GameCenter.findGame req.data.id
    game.join {
      user: user
      socket: req.io
    }
    req.session.room = game.id
    info "user #{user.name} joins room:#{req.data.id}"
    game.broadcast 'room:join', {user: user}
    # room = "room:#{req.data.id}"
    # req.io.join room
    # req.session.room = room
    # req.io.room room .broadcast 'room:join', {user: user}

  app.io.route 'disconnect', (req) ->
    user = req.handshake.user
    info "user #{user.name} leaves #{req.session.room}"
  
  app.io.route 'game:start', (req) ->
    user = req.handshake.user
    