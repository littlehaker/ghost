Word = require '../models/word'
  
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
      @round = 0
      @max_vote = 0
    join: (player) ~>
      if not @players[player.user._id]
        player.vote = 0
        @players[player.user._id] = player
        @player_count = @player_count + 1
        player.socket.join @id
        if @player_count is 3 then @start!
    broadcastSysMsg: (data) ~>
      @broadcast 'game:sysmsg', data
    broadcast: (msg, data) ~>
      app.io.room @id .broadcast msg, data
    start: ~>
      # @broadcast 'game:start'
      @broadcast 'game:sysmsg', '游戏开始！'
      @alloc!
    end: ~>
    onVote: (user, data) ~>
      player = @players[user._id]
      # 记票
      each (p) ~>
        if p.user.name is data
          p.vote += 1
          if p.vote > @max_vote
            @max_vote = p.vote
      , @players
    onMsg: (user, data) ~>
      player = @players[user.id]
      data.from = user.name
      @broadcast 'game:msg', data
      if @order[@current_order] is user._id.toString!
        @current_order = @current_order + 1
        @nextPlayer!
    # 分配身份
    alloc: ~>
      err, word <~ Word.random
      @word = word
      debug err, word
      [word1, word2] = word.words.split ','
      for key, player of @players
        @order.push key
        if player.user.name is 'a'
          player.role = 'ghost'
          player.word = word1
          @ghosts[key] = player
          # player.socket.emit 'game:sysmsg', '你是鬼'
        else
          player.role = 'peasant'
          player.word = word2
          @peasants[key] = player
          # player.socket.emit 'game:sysmsg', '你是平民'
        player.socket.emit 'game:sysmsg', "你的词语是#{player.word}"
      # 开始第一轮
      @nextRound!
    endVote: ~>
      each (p) ~>
        @broadcastSysMsg "#{p.user.name}得票#{p.vote}"
      , @players
      dead = filter (~> it.vote is @max_vote), @players
      dead_keys = keys dead
      if dead_keys.length > 1 then
        # 平票
        @broadcastSysMsg '平票，重投'
        @startVote!
      else
        p = @players[dead_keys[0]]
        @kill p
    kill: (player) ~>
      @broadcastSysMsg "#{player.user.name}出局了"
      delete @ghosts[player.user.id]
      delete @peasants[player.user.id]
      # @ghosts = @ghosts |> (filter -> it isnt player.user.id)
      # @peasants = @peasants |> (filter -> it isnt player.user.id)
      console.log @ghosts, @peasants, player.user.id, (keys @ghosts).length, (keys @peasants).length
      if (keys @ghosts).length is 0
        @broadcastSysMsg "鬼死了，游戏结束"
        return
      if (keys @ghosts).length >= (keys @peasants).length
        @broadcastSysMsg "鬼赢了，游戏结束"
        return
      @order = @order |> (filter -> it isnt player.user.id) |> reverse
      @nextRound!
    startVote: ~>
      @broadcast 'game:vote'
      setTimeout ~>
        @endVote!
      , 10000 
    nextPlayer: ~>
      if @current_order is @order.length
        @broadcast 'game:sysmsg', '本轮发言结束，开始投票，投票将在10秒内结束'
        @startVote!
      else
        player = @players[@order[@current_order]]
        @broadcast 'game:sysmsg', "该#{player.user.name}发言"
    nextRound: ~>
      @round += 1
      @current_order = 0
      @broadcast 'game:sysmsg', "第#{@round}轮"
      @nextPlayer!