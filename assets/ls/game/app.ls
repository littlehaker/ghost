# <- $
# socket = io.connect!
# socket.emit 'room:join', {id: ($ '#roomid').val!}
# socket.on 'room:join', -> alert \xxx
# socket.emit 'game:start'

angular.module 'ghost', [
  'ghost.controllers'
  'ghost.services'
]