module.exports = (app) ->
  login = app.middlewares.user.login

  Hall = app.Hall
  Player = app.lib.player
  
  app.get '/room/:id', login, (req, res) ->
    res.render 'game/index', {
      user: req.user
      roomid: req.params.id
    }

  app.io.route 'room:create', (req) ->
    player = (new Player req)
    room = app.Hall.createRoom {
      creator: player
    }
    req.io.respond room
    Hall.leave player
        
  app.io.route 'room:join', (req) ->
    user = req.handshake.user
    player = (new Player req)
    roomId = req.data.id
    info "user #{user.name} joins room:#roomId"
    room = Hall.findRoom roomId
    if room
      room.join player
      req.io.respond {
        room: room.format!
        me: player.format!
      }
    else
      req.io.respond null
      
  app.io.route 'room:ready', (req) ->
    player = (new Player req)
    roomId = req.data.id
    info "user #{player.user.name} is ready!"
    room = Hall.findRoom roomId
    if room
      room.ready player
    # game = app.GameCenter.findGame req.data.id
    # game.join {
    #   user: user
    #   socket: req.io
    # }
    # req.session.room = game.id
    # info "user #{user.name} joins room:#{req.data.id}"
    # game.broadcast 'room:join', {user: user}

    # room = "room:#{req.data.id}"
    # req.io.join room
    # req.session.room = room
    # req.io.room room .broadcast 'room:join', {user: user}

  # app.io.route 'disconnect', (req) ->
  #   user = req.handshake.user
  #   info "user #{user.name} leaves #{req.session.room}"
  
  # app.io.route 'game:start', (req) ->
  #   user = req.handshake.user
    