angular.module 'ghost', [
  'ghost.controllers'
  'ghost.services'
]
  .config ['$routeProvider', ($routeProvider) ->
    $routeProvider
      .when '/hall', {
        templateUrl: '/templates/hall.html'
        controller: 'HallCtrl'
      }
      .when '/game/:id', {
        templateUrl: '/templates/game.html'
        controller: 'GameCtrl'
      }
      .when '/room/:id', {
        templateUrl: '/templates/room.html'
        controller: 'RoomCtrl'
      }
      .otherwise {
        redirectTo: '/hall'
      }
  ]