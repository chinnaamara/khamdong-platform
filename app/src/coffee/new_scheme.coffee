app.factory 'SchemesFactory', ($firebase, BASEURI) ->
  addScheme = (schemeData) ->
    addRef = new Firebase(BASEURI + "departments/" + schemeData.deptCode + "/schemes/" + schemeData.id)
    addRef.child("id").set schemeData.id
    addRef.child("schemeName").set schemeData.schemeName
    addRef.child("schemeCode").set schemeData.schemeCode
    return 'true'
  return {
    add: addScheme
  }

app.controller "AddSchemeController", ($scope, DepartmentsFactory, SchemesFactory) ->
  $scope.departments = DepartmentsFactory.data
  $scope.addScheme = ->
    newScheme =
      id: DepartmentsFactory.UUID()
      deptCode: $scope.dept
      schemeCode: $scope.schemeCode
      schemeName: $scope.schemeName
    $scope.$watch(SchemesFactory.add(newScheme), (res) ->
      if res
        console.log 'Scheme added success..'
        $scope.error = true
    )
    return
  return