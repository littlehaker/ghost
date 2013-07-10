module.exports = (app) ->
  class Player
    (opts) ->
      @user = opts.handshake.user
      @io = opts.io
    format: ->
      name: @user.name
