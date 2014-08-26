#app.controller 'LoginController', ($scope, LoginFactory, $rootScope, AUTH_EVENTS, USER_ROLES) ->
#  $scope.login = (credentials) ->
#    AuthService.login(credentials).then((user) ->
#        $rootScope.$broadcast AUTH_EVENTS.loginSuccess
#        $scope.setCurrentUser user
#    , () ->
#      $rootScope.$broadcast AUTH_EVENTS.loginFailed
#    )

app.controller 'LoginController', ($scope, $firebase, BASEURI, $firebaseSimpleLogin, $window, $rootScope, AUTH_EVENTS, USER_ROLES) ->
  ref = new Firebase BASEURI
  auth = $firebaseSimpleLogin ref
  $rootScope.userName = null
  $rootScope.administrator = null

  $scope.credentials =
    username: ''
    password: ''

  $scope.signIn = (credentials) ->
    auth.$login('password', {
      email: credentials.username
      password: credentials.password
    }).then((user) ->
#      console.log user
      $rootScope.token = user.firebaseAuthToken
      $rootScope.userName = user.email
      $rootScope.$broadcast AUTH_EVENTS.loginSuccess
      if user.email == 'admin@technoidentity.com'
        $rootScope.administrator = 'Admin'
        $rootScope.userName = 'Admin'
      $window.localStorage["userEmail"] = JSON.stringify user.email
#      $scope.setCurrentUser user
      $window.location = '#/user/grievances'
      return
    , (error) ->
      $rootScope.$broadcast AUTH_EVENTS.loginFailed
      $scope.error = true
      $scope.errorMessage = error.code
#      console.log 'error: ' , error
      return
    )
    return

  $scope.logout = ->
    $rootScope.token = null
    $rootScope.userName = null
    $rootScope.administrator = null
    $window.localStorage.clear()
    $window.location = '#/logout'
