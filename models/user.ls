mongoose = require 'mongoose'
Types = mongoose.Schema.Types
md5 = (require 'md5').digest_s

schema = new mongoose.Schema {
  name: {
    type: String
    required: true
    label: '姓名'
  }
  password: {
    type: String
    require: true
    label: '密码'
  }
}


# 用户认证相关函数
schema.methods.makeSalt = -> (Math.round (new Date).valueOf! * Math.random!) + ''
schema.statics.encryptPassword = (password) ->
  md5 password
schema.statics.register = (spec, cb) ->
  User = this
  @findOne {
    name: spec.name
  }, (err, user) ~>
    if err then return cb err
    if user
      cb new Error 'already registered'
    else
      user = new User spec
      user.password = @encryptPassword user.password
      user.save cb
  
schema.methods.toString = -> @name
schema.virtual 'id' .get ->
  @_id.toString!
users = module.exports = mongoose.model 'User', schema
