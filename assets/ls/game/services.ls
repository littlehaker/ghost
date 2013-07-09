ScopedSocket = (socket, $rootScope) ->
  @socket = socket
  @$rootScope = $rootScope
  # @listeners = []
  return

ScopedSocket::removeAllListeners = ->
  @socket.removeAllListeners!
  # i = 0
  # while i < @listeners.length
  #   details = @listeners[i]
  #   @socket.removeListener details.event, details.fn
  #   delete @listeners[i]
  #   i++

ScopedSocket::on = (event, callback) ->
  socket = @socket
  $rootScope = @$rootScope
  # @listeners.push {
  #   event: event
  #   fn: callback
  # }
  socket.on event, ->
    args = arguments
    $rootScope.$apply (-> callback.apply socket, args)

ScopedSocket::emit = (event, data, callback) ->
  socket = @socket
  $rootScope = @$rootScope
  socket.emit event, data, ->
    args = arguments
    $rootScope.$apply (-> callback.apply socket, args if callback)

(angular.module 'ghost.services', [
])
  .factory 'Socket', [
    '$rootScope'
    ($rootScope) ->
      socket = io.connect!
      console.log 'factory'
      (scope) ->
        scopedSocket = new ScopedSocket socket, $rootScope
        scope.$on '$destroy', ->
          console.log 'destroy'
          scopedSocket.removeAllListeners!
        scopedSocket
  ]