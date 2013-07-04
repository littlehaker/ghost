(angular.module 'ghost.controllers', [
])
  .controller 'ChatCtrl', [
    '$scope'
    '$io'
    ($scope, $io)->
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