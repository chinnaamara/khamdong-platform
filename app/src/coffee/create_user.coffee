app.factory 'UsersFactory', ($firebase, BASEURI) ->
  addUser = (usersData) ->
    addRef = new Firebase(BASEURI + "users/" + usersData.username)
    addRef.child("username").set usersData.username
    addRef.child("password").set usersData.password
    addRef.child("email").set usersData.email
    addRef.child("role").set usersData.role
    return 'true'

  return {
    create: addUser
  }

app.controller 'CreateUserController', ($scope, UsersFactory) ->
  $scope.addUser = ->
    newUser =
      username: $scope.userName
      password: $scope.userPassword
      email: $scope.userEmail
      role: $scope.role

    $scope.$watch(UsersFactory.create(newUser), (res) ->
      if res
        $scope.error = true
        console.log 'created user successfully..'
    )
    return
  return

