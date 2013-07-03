module.exports = (app) ->
  class Game
    (opts) ->
      @id = opts.id
      @players = {}
      @player_count = 0
      @ghosts = {}
      @peasants = {}
      @order = []               #发言顺序
      @current_order = 0
    join: (player) ~>
      if not @players[player.user._id]
        @players[player.user._id] = player
        @player_count = @player_count + 1
        player.socket.join @id
        if @player_count is 3 then @start!
    broadcast: (msg, data) ~>
      app.io.room @id .broadcast msg, data
    start: ~>
      # @broadcast 'game:start'
      @broadcast 'game:sysmsg', '游戏开始！'
      @alloc!
    end: ~>
    onVote: (user, data) ~>
      player = @players[user._id]
      # 记票和判断投票结束并开始下一轮
    onMsg: (user, data) ~>
      player = @players[user._id]
      @broadcast 'game:msg', data
      if @order[@current_order] is user._id.toString!
        debug '是正在发言的人发言'
        @current_order = @current_order + 1
        @nextPlayer!
    # 分配身份
    alloc: ~>
      for key, player of @players
        @order.push key
        if player.user.name is 'a'
          player.role = 'ghost'
          @ghosts[key] = player
          player.socket.emit 'game:sysmsg', '你是鬼'
        else
          player.role = 'peasant'
          @peasants[key] = player
          player.socket.emit 'game:sysmsg', '你是平民'
          
      # 开始第一轮
      @nextPlayer!
    nextPlayer: ~>
      if @current_order is @order.length
        @broadcast 'game:sysmsg', '本轮发言结束，开始投票'
        @broadcast 'game:vote'
      else
        player = @players[@order[@current_order]]
        @broadcast 'game:sysmsg', "该#{player.user.name}发言"
    nextRound: (first)~>
      # @broadcast 'game:sysmsg', '该谁说'