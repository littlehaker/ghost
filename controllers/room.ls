module.exports = (app) ->
  login = app.middlewares.user.login
  app.get '/room/:id', login, (req, res) ->
    res.render 'game/index', {
      user: req.user
    }
    
  app.io.route 'join:room', (req) ->
    req.io.join
    