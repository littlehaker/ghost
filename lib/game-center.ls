module.exports = (app) ->
  Game = (require './game') app
  
  class GameCenter
    ->
      @games = {}
    findGame: (id) ~>
      if @games[id]
        @games[id]
      else
        @createGame id
    createGame: (id) ~>
      game = new Game {
        id: id
      }
      @games[id] = game
    endGame: (game) ~>
      delete @games[game.id]
      game.end!