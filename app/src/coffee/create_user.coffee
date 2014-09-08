app.factory 'UsersFactory',['$firebase', 'BASEURI', '$firebaseSimpleLogin', ($firebase, BASEURI, $firebaseSimpleLogin) ->
  addUserRef = new Firebase BASEURI + 'users'
  auth = $firebaseSimpleLogin addUserRef

  registerUser = (userData) ->
    addUserRef.child(userData.id).setWithPriority({
      id: userData.id
      name: userData.name
      email: userData.email
      mobileNumber: userData.mobileNumber
      ward: userData.ward
      role: userData.role
      createdDate: userData.createdDate
      updatedDate: userData.updatedDate
    }, userData.email)
    return 'true'

  removeUser = (id) ->
    removeUserRef = addUserRef.child(id)
    removeUserRef.remove()

  createUser = (data) ->
    auth.$createUser(data.email, data.password).then((user) ->
#      console.log 'User: ' , user
      return 'true'
    , (error) ->
#      console.log 'error: ' + error.code
      removeUser data.id
#      return error
    )
    return
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

  sendSms = (data) ->
    $http
    .post('http://api.mVaayoo.com/mvaayooapi/MessageCompose?user=Dilip@cannybee.in:8686993306&senderID=TEST SMS&receipientno=' + data.mobile + '&msgtxt= ' + data.message + ' &state=4')
    .success((data, status, headers, config) ->
#      alert "Message sent success to your mobile number"
    )
    .error((status) ->
#      alert status.responseText
    )

  return {
    create: createUser
    register: registerUser
    removeUser: removeUser
    sendSms: sendSms
  }
]


app.controller 'CreateUserController', ($scope, UsersFactory, $rootScope, $window, DataFactory, $firebase, BASEURI, $firebaseSimpleLogin) ->
  $scope.init = ->
    session = localStorage.getItem('firebaseSession')
    if ! session
      $window.location = '#/error'
    else
      $rootScope.userName = localStorage.getItem('name').toUpperCase()
      role = localStorage.getItem('role')
      $rootScope.administrator = role == 'Admin' ? true : false
      $rootScope.superUser = role == 'SuperUser' ? true : false

  $scope.init()

  $scope.userRoles = DataFactory.userRoles
  $scope.wards = DataFactory.wards

  userId = (ward) ->
    date = new Date()
    refID = date.getTime()
    str1 = ward.substring(0, 1).toUpperCase()
    str2 = ward.substring(6, 7).toUpperCase()
    str1 + str2 + refID

  addUserRef = new Firebase BASEURI + 'users'
  auth = $firebaseSimpleLogin addUserRef

  $scope.addUser = ->
    $scope.errorMessage = false
    $scope.successMessage = false
    newUser =
      id: userId $scope.user.ward
      name: $scope.user.name
      password: $scope.user.password
      email: $scope.user.email
      mobileNumber: $scope.user.mobileNumber
      ward: $scope.user.ward
      role: $scope.user.role
      createdDate: new Date().toLocaleString()
      updatedDate: new Date().toLocaleString()


    $scope.$watch(UsersFactory.register(newUser), (res_first) ->
      if res_first
        $scope.signUp(newUser)
      else
        $scope.errorMessage = true
        $scope.errorText = "User Not Created.!"

      )
    return
#        $scope.$watch(UsersFactory.create(newUser), (res) ->
#          console.log "Second Response: " +  res
#          if UsersFactory.responceMessage == 'true'
#            console.log res
#            console.log UsersFactory.responceMessage
#            $scope.successMessage = true
#            $scope.successText = "User created successfully.!"
#          else
#            console.log res
#            console.log UsersFactory.responceMessage
#            $scope.successMessage = true
#            $scope.successText = UsersFactory.responceMessage
#              $scope.$watch(UsersFactory.removeUser(newUser.id), (res) ->
#                $scope.successMessage = true
#                $scope.successText = res.code
#              )
#        )

#    )
#    return

  $scope.signUp = (data) ->
    smsData = {
      mobile: $scope.user.mobileNumber
      message: "Hi " + $scope.user.name + ", you are registered as represent at Khamdong, for " + $scope.user.ward + " ward. Login with email: " + $scope.user.email  + ", pwd: " + $scope.user.password
    }
    auth.$createUser(data.email, data.password).then((user) ->
#      console.log 'User: ' , user
      $scope.$watch(UsersFactory.sendSms(smsData), (status) ->
        if status
          console.log "sms sent to " + smsData.mobile
      )
      $scope.successMessage = true
      $scope.successText = "User created successfully.!"
      return
    , (error) ->
      console.log 'error: ' + error.code
      removeUser data.id
      $scope.errorMessage = true
      $scope.errorText = "Email already used.! Try another Email."
      return
    )
    return

  removeUser = (id) ->
    removeUserRef = addUserRef.child(id)
    removeUserRef.remove()

  return
