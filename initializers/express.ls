passport = require 'passport'
LocalStrategy = (require 'passport-local').Strategy
express = require 'express.io'
User = require '../models/user'
_ = require 'underscore'
passportSocketIo = require 'passport.socketio'
rack = require 'asset-rack'
LiveScriptAsset = require 'asset-rack-livescript'

formage = require 'formage-admin'
fs = require 'fs'
path = require 'path'

module.exports = (app) ->
  assets = new rack.Rack [
    new rack.DynamicAssets {
      type: rack.StylusAsset
      urlPrefix: '/css'
      dirname: "#{__dirname}/../assets/stylus/"
      options: { watch: true }
    }
    new rack.DynamicAssets {
      type: LiveScriptAsset
      urlPrefix: '/js'
      dirname: "#{__dirname}/../assets/ls/"
      options: { watch: true, compress: false }
    }
  ]
  app.configure 'all', ->
    app.set 'view engine', 'jade'
    app.set 'view options', {
      layout: true
      pretty: true
    }
    app.use express.bodyParser!
    app.use express.methodOverride!
    app.use express.cookieParser 'ghost'
    app.use express.static  __dirname + '/../assets'
    app.use express.session app.config.session
    app.use passport.initialize!
    app.use passport.session!
    app.use app.router

    # assets
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
    passport.deserializeUser (id, done) ->
      User.findById id, (err, user) ->
        done err, user
    models = []
    (fs.readdirSync "#{__dirname}/../models").forEach ((file) ->
      name = (file.replace '.js', '').replace '.ls', ''
      return  if /[#~]/.test file
      if name is 'index' then return 
      models[name] := require '../models/' + name)
    admin = formage.init app, express, models, {title: 'Formage-Admin Example'}

  app.configure 'development', -> app.use express.errorHandler!

  app.io.configure ->
    app.io.enable 'browser client minification'
    app.io.enable 'browser client gzip'  
    app.io.set 'log level', 4
    # app.io.use passportSocketIo.authorize {
    old_auth = app.io.get 'authorization'
    app.io.set "authorization", passportSocketIo.authorize {
      passport: passport
      cookieParser: express.cookieParser
      key: app.config.session.key
      secret: app.config.session.secret
      store: app.config.session.store
      success: (data, accept) ->
        old_auth data, accept
      #   accept null, true
      # fail: (data, accept) ->
      #   accept null, false
    }
