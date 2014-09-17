app.factory 'UsersFactory', ($firebase, BASEURI, $http) ->
  getUsersRef = new Firebase BASEURI + 'superusers'
  categoriesRef = new Firebase BASEURI + 'categories'
#  getCatgeries = $firebase categoriesRef
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

  addUserRef = new Firebase BASEURI + 'superusers'
  addNewUser = (user) ->
#    ref = new Firebase BASEURI + 'categories/' + user.category + '/users/' + user.mobileNumber
#    ref.child('name').set user.name
#    ref.child('email').set user.email
#    ref.child('mobileNumber').set user.mobileNumber
#    ref.child('createdDate').set user.createdDate
#    ref.child('updatedDate').set user.updatedDate
    addUserRef.child(user.mobileNumber).setWithPriority({
      name: user.name
      email: user.email
      mobileNumber: user.mobileNumber
      category: user.category
      createdDate: user.createdDate
      updatedDate: user.updatedDate
    }, user.category)
    return 'true'

  getUsersByCategory = (category, cb) ->
    getUsersRef.startAt(category).endAt(category).on('value', (snapshot) ->
      cb _.values snapshot.val()
    )

  return {
    usersRef: getUsersRef
    usersList: usersList
    pageNext: pageNext
    pageBack: pageBack
    sendSms: sendSms
#    getCatgeries: getCatgeries
    addNewUser: addNewUser
    getUsersByCategory: getUsersByCategory
  }

app.controller 'UsersController', ($scope, UsersFactory, $rootScope, $window, CategoriesFactory) ->
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

  getQuery = UsersFactory.usersRef
  $scope.pageNumber = 0
  $scope.lastPageNumber = null
  recordsPerPage = 10
  bottomRecord = null
  $scope.noPrevious = true
  $scope.userslist = {}

  getQuery.startAt().limit(recordsPerPage).on('value', (snapshot) ->
    $scope.userslist = _.values snapshot.val()
    $scope.loadDone = true
    $scope.loading = false
    bottomRecord = $scope.userslist[$scope.userslist.length - 1]
    if bottomRecord
      UsersFactory.pageNext(bottomRecord.id, recordsPerPage + 1, (res) ->
        if res
          console.log res
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
    UsersFactory.pageNext(bottomRecord.id, recordsPerPage + 1, (res) ->
      if res
        res.shift()
        $scope.userslist = res
        bottomRecord = $scope.userslist[$scope.userslist.length - 1]
    )
    UsersFactory.pageNext(bottomRecord.id, recordsPerPage + 1, (res) ->
      if res
        $scope.noNext = res.length <= 1 ? true : false
    )

  $scope.pageBack = ->
    $scope.pageNumber--
    $scope.noNext = false
    topRecord = $scope.userslist[0]
    UsersFactory.pageBack(topRecord.id, recordsPerPage + 1, (res) ->
      if res
        res.pop()
        $scope.userslist = res
        $scope.noPrevious = $scope.pageNumber is 0 ? true : false
    )

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

  $scope.getUsers = ->
    users = []
    _.forEach($scope.userslist, (user) ->
      if user.done
        users.push Number user.mobileNumber
    )
    return users

  $scope.sendSms = ->
    _.forEach($scope.selectedUsers, (user) ->
      UsersFactory.sendSms($scope.messageText, user)
    )
    $scope.messageText = ''
#    $scope.successMessage = true
    return

#  $scope.reset = ->
#    $scope.messageText = ''
##    $scope.successMessage = false
#    return

  $scope.isNewUser = ->
    $scope.modelTitle = 'Add New User'
    $scope.buttonText = 'Add'
    $scope.newUserName = ""
    $scope.mobileNumber = ""
    $scope.email = ""
    $scope.successMessage = false
    $scope.category = ""

  CategoriesFactory.getCategories(100, (res) ->
    $scope.categories = res
  )

  $scope.addNewUser = ->
    newUser =
      category: $scope.category
      name: $scope.newUserName
      mobileNumber: $scope.mobileNumber
      email: $scope.email
      createdDate: new Date().toLocaleString()
      updatedDate: new Date().toLocaleString()
    console.log newUser
    $scope.$watch(UsersFactory.addNewUser(newUser), (res) ->
      if res
        $scope.successMessage = true
    )

  $scope.editUser = (user) ->
    $scope.modelTitle = 'Edit New User'
    $scope.buttonText = 'Update'
    $scope.newUserName = user.name
    $scope.mobileNumber = user.mobileNumber
    $scope.email = user.email
    $scope.successMessage = false
    $scope.category = user.category

  $scope.getCategoryUsers = ->
    console.log $scope.selectCategory
    UsersFactory.getUsersByCategory($scope.selectCategory, (res) ->
      if res
        $scope.userslist = res
    )

