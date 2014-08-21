app.controller 'LoginController', ($scope, $rootScope, AUTH_EVENTS, USER_ROLES) ->
  $scope.credentials =
    username: ''
    password: ''

  $scope.login = (credentials) ->
    AuthService.login(credentials).then((user) ->
        $rootScope.$broadcast AUTH_EVENTS.loginSuccess
        $scope.setCurrentUser user
    , () ->
      $rootScope.$broadcast AUTH_EVENTS.loginFailed
    )

