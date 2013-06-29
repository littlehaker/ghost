passport = require 'passport'
LocalStrategy = (require 'passport-local').Strategy
express = require 'express.io'
User = require '../models/user'

rack = require 'asset-rack'
LiveScriptAsset = require 'asset-rack-livescript'

module.exports = (app) ->
  assets = new rack.Rack [
    new rack.DynamicAssets {
      type: rack.StylusAsset
      urlPrefix: '/css'
      dirname: "#{__dirname}/../client/stylus/"
    }
    new rack.DynamicAssets {
      type: LiveScriptAsset
      urlPrefix: '/js'
      dirname: "#{__dirname}/../client/ls/"
    }
  ]
  console.log "#{__dirname}/../client/ls"
  console.log assets
  app.configure 'all', ->
    app.set 'view engine', 'jade'
    app.set 'view options', {
      layout: true
      pretty: true
    }
    app.use express.favicon!
    app.use express.bodyParser!
    app.use express.methodOverride!
    app.use express.cookieParser 'ghost'
    app.use express.static  __dirname + '/../public'
    app.use express.session app.config.session
    app.use passport.initialize!
    app.use passport.session!
    app.use app.router

    # assets
    # console.log rack
    app.use assets
    app.locals {
      assets: assets
    }
    passport.use new LocalStrategy {usernameField: 'name'}, (name, password, done) ->
      User.findOne {
        name: name
        password: User.encryptPassword password
      }, (err, user) -> if user then done err, user else done null, false, {message: '用户名或密码错误'}
    passport.serializeUser ((user, done) -> done null, user._id)
    passport.deserializeUser ((id, done) -> User.findById id, (err, user) -> done err, user)
  app.configure 'development', -> app.use express.errorHandler!