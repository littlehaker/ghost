module.exports = (app) ->
  class Player
    (opts) ->
      @user = opts.handshake.user
      @id = @user._id.toString!
      @io = opts.io
    format: ->
      id: @id
      name: @user.name
      isReady: @isReady
