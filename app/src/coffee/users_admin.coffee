app.factory 'AdminUsersFactory', ($firebase, BASEURI, $http) ->
  getUsersRef = new Firebase BASEURI + 'users'
  usersList = $firebase getUsersRef

  pageNext = (id, noOfRecords, cb) ->
    getUsersRef.startAt(null, id).limit(noOfRecords).once('value', (snapshot) ->
      cb _.values snapshot.val()
    )

  pageBack = (id, noOfRecords, cb) ->
    getUsersRef.endAt(null, id).limit(noOfRecords).once('value', (snapshot) ->
      cb _.values snapshot.val()
    )

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

  userById = {}

  return {
    usersRef: getUsersRef
    usersList: usersList
    pageNext: pageNext
    pageBack: pageBack
    sendSms: sendSms
    userById: userById
  }

app.controller 'AdminUsersController', ($scope, AdminUsersFactory, $rootScope, $window, DataFactory) ->
  $scope.init = ->
    session = localStorage.getItem('firebaseSession')
    if ! session
      $window.location = '#/error'
    else
      $rootScope.userName = localStorage.getItem('name').toUpperCase()
      role = localStorage.getItem('role')
      $rootScope.administrator = role == 'Admin'
      $rootScope.superUser = role == 'SuperUser'

  $scope.init()

  $scope.loadDone = false
  $scope.loading = true

  getQuery = AdminUsersFactory.usersRef
  $scope.pageNumber = 0
  $scope.lastPageNumber = null
  recordsPerPage = 20
  bottomRecord = null
  $scope.noPrevious = true
  $scope.userslist = {}

  getQuery.startAt(null).limit(recordsPerPage).on('value', (snapshot) ->
    $scope.userslist = _.values snapshot.val()
    $scope.loadDone = true
    $scope.loading = false
    bottomRecord = $scope.userslist[$scope.userslist.length - 1]
    if bottomRecord
      AdminUsersFactory.pageNext(bottomRecord.id, recordsPerPage + 1, (res) ->
        if res
          $scope.noNext = res.length <= 1 ? true : false
      )
    else
      $scope.noNext = true
    return
  )


  $scope.pageNext = ->
    $scope.pageNumber++
    $scope.noPrevious = false
    bottomRecord = $scope.userslist[$scope.userslist.length - 1]
    AdminUsersFactory.pageNext(bottomRecord.id, recordsPerPage + 1, (res) ->
      if res
        res.shift()
        $scope.userslist = res
        bottomRecord = $scope.userslist[$scope.userslist.length - 1]
    )
    AdminUsersFactory.pageNext(bottomRecord.id, recordsPerPage + 1, (res) ->
      if res
        $scope.noNext = res.length <= 1 ? true : false
    )

  $scope.pageBack = ->
    $scope.pageNumber--
    $scope.noNext = false
    topRecord = $scope.userslist[0]
    AdminUsersFactory.pageBack(topRecord.id, recordsPerPage + 1, (res) ->
      if res
        res.pop()
        $scope.userslist = res
        $scope.noPrevious = $scope.pageNumber is 0 ? true : false
    )

  $scope.manageUser = (user) ->
    AdminUsersFactory.userById = user
    $window.location = '#/admin/users/manage'
