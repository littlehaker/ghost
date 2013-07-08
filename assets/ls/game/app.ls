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
      .otherwise {
        redirectTo: '/hall'
      }
  ]