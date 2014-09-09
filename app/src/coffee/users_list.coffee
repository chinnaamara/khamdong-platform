app.factory 'UsersFacory', ($firebase, BASEURI, $http) ->
  getUsersRef = new Firebase BASEURI + 'users'
  usersList = $firebase getUsersRef

  sendSms = (message, mobile) ->
    $http
    .post('http://api.mVaayoo.com/mvaayooapi/MessageCompose?user=Dilip@cannybee.in:8686993306&senderID=TEST SMS&receipientno=' + mobile + '&msgtxt= ' + message + ' &state=4')
    .success((data, status, headers, config) ->
#      alert "Message sent success to your mobile number"
    )
    .error((status) ->
#      alert status.responseText
#      alert "Message sent to your mobile number"
    )


  return {
    usersRef: getUsersRef
    usersList: usersList
    sendSms: sendSms
  }

app.controller 'UsersController', ($scope, UsersFacory, $rootScope, $window, $filter, ngTableParams) ->
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
  $scope.loadDone = false
  $scope.loading = true

  $scope.userslist = ''
  getQuery = UsersFacory.usersRef
  getUsers = ->
    $scope.tableParams = new ngTableParams(
      page: 1
      count: 6
      sorting:
        role:'asc'
    ,
      counts: []
      total: 0
      getData: ($defer, params) ->
        filteredData = $filter("filter")($scope.userslist, $scope.filter)
        orderedData = (if params.sorting() then $filter("orderBy")(filteredData, params.orderBy()) else filteredData)
        params.total orderedData.length
        $defer.resolve orderedData.slice((params.page() - 1) * params.count(), params.page() * params.count())
        return

      $scope: $scope
    )
    return

  getQuery.on('value', (snapshot) ->
    $scope.userslist = _.values snapshot.val()
    $scope.loadDone = true
    $scope.loading = false
    getUsers()
  )
  $scope.$watch "filter.$", ->
    $scope.tableParams.reload()
    return

  $scope.cantSendMessage = true
  $scope.allUsersClicked = () ->
    newValue = ! $scope.allUsersMet()
    _.forEach($scope.userslist, (user) ->
      user.done = newValue
      return
    )
    return

  $scope.allUsersMet = ->
    usersMet = _.reduce($scope.userslist, (count, user) ->
      return count + user.done ? 1 : 0
    , 0)
    $scope.cantSendMessage = $scope.getUsers().length == 0
    return (usersMet == $scope.userslist.length)

  $scope.selectedUsers = []
  $scope.isUser = ->
    $scope.selectedUsers = $scope.getUsers()
#    console.log $scope.selectedUsers

  $scope.getUsers = ->
    users = []
    _.forEach($scope.userslist, (user) ->
      if user.done
        users.push Number user.mobileNumber
    )
    return users

  $scope.sendSms = ->
    _.forEach($scope.selectedUsers, (user) ->
      UsersFacory.sendSms($scope.messageText, user)
    )
    $scope.messageText = ' '
    $scope.successMessage = true
    return

  $scope.reset = ->
    $scope.messageText = ''
    $scope.successMessage = false
    return
