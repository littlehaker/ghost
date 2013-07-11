_ = require 'underscore'

module.exports = (app) ->
  # Game = (require './game') app
  # Room = (require './room') app
  class Hall
    ->
      @rooms = []
    allRoom: ->
      @rooms |> map (-> it.format!)
    enter: (player) ->
      player.io.join 'Hall'
    findRoom: (id) ->
      @rooms |> find (-> it.id is id)
    createRoom: (opts) ->
      # room = (new app.lib.room opts).format!
      room = (new app.lib.room opts)
      @rooms.push room
      roomInfo = room.format!
      app.io.room 'Hall' .broadcast 'room:created', roomInfo
      return roomInfo
    killRoom: ->
    leave: (player) ->
      player.io.leave 'Hall'
