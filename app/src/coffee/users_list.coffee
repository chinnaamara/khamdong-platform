app.factory 'UsersFacory', ($firebase, BASEURI) ->
  getUsersRef = new Firebase BASEURI + 'users'
  usersList = $firebase getUsersRef

  return {
    usersRef: getUsersRef
    usersList: usersList
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

  userslist = undefined
  getQuery = UsersFacory.usersRef
  getUsers = ->
    $scope.tableParams = new ngTableParams(
      page: 1
      count: 3
      sorting:
        ward:'desc'
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