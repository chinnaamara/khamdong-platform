app.factory 'SchemesFactory', ($firebase, BASEURI) ->
#  ref = new Firebase(BASEURI + 'departments')
  addScheme = (schemeData) ->
    addRef = new Firebase(BASEURI + 'departments/' + schemeData.deptCode + '/schemes/' + schemeData.id)
    addRef.child("id").set schemeData.id
    addRef.child("schemeName").set schemeData.schemeName
    addRef.child("schemeCode").set schemeData.schemeCode
    return 'true'

  return {
    add: addScheme
  }

app.controller "AddSchemeController", ($scope, DataFactory, DepartmentsFactory, SchemesFactory, $rootScope, $window) ->
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
  $scope.departments = DepartmentsFactory.departments
  $scope.success = false
  $scope.error = false
  $scope.addScheme = ->
    $scope.success = false
    $scope.error = false
    newScheme =
      id: DataFactory.uuid()
      deptCode: $scope.scheme.dept
      schemeCode: $scope.scheme.schemeCode
      schemeName: $scope.scheme.schemeName
    $scope.$watch(SchemesFactory.add(newScheme), (res) ->
      if res
        $scope.success = true
        $scope.statusText = 'Scheme added success.!'
      else
        $scope.error = true
        $scope.statusText = 'Scheme not added, Tru again.!'
    )
    return
  return