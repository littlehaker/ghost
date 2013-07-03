module.exports = (app) ->
  GameCenter = (require '../lib/game-center') app

  app.GameCenter = new GameCenter