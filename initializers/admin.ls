express = require 'express.io'
formage = require 'formage-admin'
fs = require 'fs'
path = require 'path'

module.exports = (app) ->
  # 管理后台
  models = []
  (fs.readdirSync "#{__dirname}/../models").forEach ((file) ->
    name = (file.replace '.js', '').replace '.ls', ''
    return  if /[#~]/.test file
    if name is 'index' then return 
    models[name] := require '../models/' + name)
  admin = formage.init app, express, models, {title: 'Formage-Admin Example'}
