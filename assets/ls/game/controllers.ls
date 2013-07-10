(angular.module 'ghost.controllers', [
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
        # $scope.enterRoom room.id
      $io.emit 'hall:enter', null, (data) ->
        $scope.rooms = data

      $scope.createRoom = ->
        $io.emit 'room:create', null, (data) ->
          console.log data
      $scope.enterRoom= (room) ->
        $location.path "/room/#{room.id}"
  ]
  .controller 'RoomCtrl', [
    ->
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