module.exports = (app) ->
  login = app.middlewares.user.login
  
  app.get '/', login, (req, res) ->
    res.render 'game/index'

  app.io.route 'hall:enter', (req) ->
    app.io.broadcast 'hall:enter'