mongoose = require 'mongoose'

schema = new mongoose.Schema {
  words: String
}

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
