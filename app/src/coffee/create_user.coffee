app.factory 'UsersFactory',['$firebase', 'BASEURI', '$firebaseSimpleLogin', ($firebase, BASEURI, $firebaseSimpleLogin) ->
#  addUser = (usersData) ->
#    addRef = new Firebase(BASEURI + "users/" + usersData.username)
#    addRef.child("username").set usersData.username
#    addRef.child("password").set usersData.password
#    addRef.child("email").set usersData.email
#    addRef.child("role").set usersData.role
#    return 'true'

  ref = new Firebase BASEURI
  auth = $firebaseSimpleLogin ref

  createUser = (data) ->
    console.log 'creating user....'
#    auth.$createUser(data.email, data.password, (error, user) ->
#      console.log error
#      console.log user
#      if ! error
#        console.log 'User Created Successfully: ' + user
#        return 'true'
#      else
#        console.log 'Error in creating user: ' + error
#        return undefined
#    )
    auth.$createUser(data.email, data.password).then((user) ->
      console.log 'User created'
      console.log 'User: ' , user
      return true
    , (error) ->
      console.log 'error: ' + error
    )
    return

  return {
    create: createUser
  }
]


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

