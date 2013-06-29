User = require '../models/user'
require! 'passport'

module.exports = (app) ->
  # 注册
  app.get '/register', (req, res) -> res.render 'user/new'
  app.post '/register', (req, res) ->
    User.register req.body, (err, user) ->
      if err
        res.send '已经被注册了'
      else
        req.login user, ->
          res.redirect '/'
  # 登录
  app.get '/login', (req, res) ->
    res.render 'user/login'
  app.post '/login', (passport.authenticate 'local', {
    failureRedirect: '/login'
  }), (req, res) ->
    res.redirect req.session.redirect
    delete req.session.redirect
  # 退出
  app.get '/logout', (req, res) ->
    req.logout!
    res.redirect '/'