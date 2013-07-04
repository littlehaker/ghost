Word = require '../models/word'

module.exports = (app) ->
  app.get '/words/create', (req, res) ->
    [word1, word2] = req.query.words.split ','
    err <- Word.create word1, word2
    if err
      res.send err.toString!
    else
      res.send {
        success: true
      }