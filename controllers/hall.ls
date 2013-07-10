module.exports = (app) ->
  login = app.middlewares.user.login
  Hall = app.Hall
  Player = app.lib.player
  
  app.get '/', login, (req, res) ->
    res.render 'game/index'

  app.io.route 'hall:enter', (req) ->
    Hall.enter (new Player req)
    req.io.respond app.Hall.allRoom!
    # app.io.broadcast 'hall:enter'