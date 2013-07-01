(angular.module 'ghost.controllers', [
])
  .controller 'ChatCtrl', [
    '$scope'
    '$io'
    ($scope, $io)->
      room = {id: ($ '#roomid').val!}
      $scope.msgs = []
      $scope.my_msg = ''
      $io.on 'game:msg', (data) ->
        $scope.$apply ->
          $scope.msgs.push data
      $io.emit 'room:join', room
      $scope.sendMsg = ->
        if $scope.my_msg is '' then return
        $scope.msgs.push {
          content: $scope.my_msg
        }
        $io.emit 'game:msg', {
          content: $scope.my_msg
        }
        $scope.my_msg = ''
  ]