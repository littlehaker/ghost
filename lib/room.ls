uuid = (require 'node-uuid').v4
_ = require 'underscore'
  
module.exports = (app) ->
  class Room
    (opts) ->
      @creator = opts.creator
      @id = uuid!
      @players = []
    format: ->
      id: @id
      name: @name
      creator: @creator.format!