_ = require 'underscore'

module.exports = (app) ->
  # Game = (require './game') app
  # Room = (require './room') app
  class Hall
    ->
      @rooms = []
    allRoom: ->
      @rooms
    enter: (player) ->
      player.io.join 'Hall'
    createRoom: (opts) ->
      room = (new app.lib.room opts).format!
      @rooms.push room
      app.io.room 'Hall' .broadcast 'room:created', room
      return room
    killRoom: ->
      
