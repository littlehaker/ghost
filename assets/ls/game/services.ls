(angular.module 'ghost.services', [
])
  .service '$io', ->
    io.connect!
