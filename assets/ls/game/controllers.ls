(angular.module 'ghost.controllers', [
])
  # 大厅
  .controller 'HallCtrl', [
    '$scope'
    '$io'
    ($scope, $io) ->
      $io.emit 'hall:enter'
      $io.on 'hall:enter', ->
        alert 'hall enter'
  ]
  .controller 'GameCtrl', [
    '$scope'
    '$io'
    ($scope, $io) ->
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