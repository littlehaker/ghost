uuid = (require 'node-uuid').v4
_ = require 'underscore'
  
module.exports = (app) ->
  class Room
    (opts) ->
      @creator = opts.creator
      @id = uuid!
      @players = []
      @name = '这是一个房间'
      # @join @creator
    format: ->
      id: @id
      name: @name
      creator: @creator.format!
      players: @players |> map (-> it.format!)
    join: (player) ->
      if not (@players |> find (-> it.id is player.id))
        @players.push player
        roomStr = "Room:#{@id}"
        app.io.room roomStr .broadcast 'room:join', player.format!
        player.io.join roomStr
    ready: (player) ->
      # 如果都准备了就开始?
      roomStr = "Room:#{@id}"
      app.io.room roomStr .broadcast 'room:ready', player.format!
    startGame: ->
      @game = new app.lib.game {
        id: @id
        players: @players
      }
      @game.start!
      roomStr = "Room:#{@id}"
      app.io.room roomStr .broadcast 'room:game:started'
      