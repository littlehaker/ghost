mongoose = require 'mongoose'

schema = new mongoose.Schema {
  words: String
  random: {
    type: Number
    default: Math.random 
  }
}

schema.statics.random = (cb) ->
  rand = Math.random!
  err, word <~ @findOne {
    random: { $gte : rand }
  }
  if err then return cb err
  if word
    cb null, word
  else
    err, word <~ @findOne {
      random: { $lte : rand }
    }
    cb err, word

schema.statics.create = (word1, word2, cb) ->
  Word = this
  err, word <~ @findOne {
    $or: [
      {words: "#word1,#word2"}
      {words: "#word2,#word1"}
    ]
  }
  if err then return cb err
  if word
    cb new Error 'already exist'
  else
    word = new Word {
      words: "#word1,#word2"
    }
    word.save cb
    
users = module.exports = mongoose.model 'Word', schema
