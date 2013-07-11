(angular.module 'ghost.controllers', [
  # 'angular-underscore'
])
  # 大厅
  .controller 'HallCtrl', [
    '$scope'
    '$location'
    'Socket'
    ($scope, $location, Socket) ->
      $io = Socket $scope
      $io.on 'room:created', (room) ->
        $scope.rooms.push room
      $io.emit 'hall:enter', null, (data) ->
        $scope.rooms = data

      $scope.createRoom = ->
        $io.emit 'room:create', null, (room) ->
          $scope.enterRoom room
          
      $scope.enterRoom= (room) ->
        $location.path "/room/#{room.id}"
  ]
  .controller 'RoomCtrl', [
    '$scope'
    '$routeParams'
    'Socket'
    ($scope, $routeParams, Socket) ->
      id = $routeParams.id
      $io = Socket $scope
      $io.on 'room:join', (player) ->
        console.log 'player join'
        $scope.room.players.push player
      $io.on 'room:ready', (player) ->
        _.find($scope.room.players, (-> it.id is player.id)).isReady = true
      $io.emit 'room:join', {
        id: id
      }, (data) ->
        console.log data
        $scope.room = data.room
        $scope.me = data.me
      $scope.ready = ->
        $io.emit 'room:ready', {
          id: id
        }
      $scope.isCreator = (player) ->
        if not $scope.room
          false
        else
          player.id is $scope.room.creator.id
  ]
  .controller 'GameCtrl', [
    '$scope'
    'Socket'
    ($scope, Socket) ->
      $io = Socket $scope
      room = {id: ($ '#roomid').val!}
      $scope.msgs = []
      $scope.my_msg = ''
      $io.on 'game:vote', ->
        $scope.vote = true
      $io.on 'game:msg', (data) ->
        $scope.$apply ->
          $scope.msgs.push data
      $io.on 'game:sysmsg', (content)->
        $scope.$apply ->
          $scope.msgs.push {
            from: 'system'
            content: content
          }
      $io.emit 'room:join', room
      $scope.sendMsg = ->
        if $scope.my_msg is '' then return
        if $scope.vote
          $io.emit 'game:vote', $scope.my_msg
          $scope.vote = false
        else
          $io.emit 'game:msg', {
            content: $scope.my_msg
          }
        $scope.my_msg = ''
  ]