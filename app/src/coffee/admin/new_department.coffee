app.factory 'DepartmentsFactory', ($firebase, BASEURI) ->
  ref = new Firebase(BASEURI + "departments")
  data = $firebase(ref)
  addDepartment = (departmentData) ->
    addRef = new Firebase(BASEURI + "departments/" + departmentData.id)
    addRef.child("id").set departmentData.id
    addRef.child("departmentName").set departmentData.departmentName
    addRef.child("departmentCode").set departmentData.departmentCode
    ref.setPriority(departmentData.departmentCode)
    return 'true'

#  addDepartment = (departmentData) ->
#    ref.child(departmentData.id).setPriority({
#      id: departmentData.id
#      departmentName: departmentData.departmentName
#      departmentCode: departmentData.departmentCode
#    }, departmentData.departmentCode)
#    return 'true'

  return {
    departments: data
    add: addDepartment
  }


app.controller "AddDepartmentController", ($scope, DepartmentsFactory, DataFactory, $rootScope, $window) ->
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
  $scope.success = false
  $scope.error = false
  $scope.addDept = ->
    $scope.success = false
    $scope.error = false
    newDept =
      id: DataFactory.uuid()
      departmentCode: $scope.dept.deptCode
      departmentName: $scope.dept.deptName
    console.log newDept
    $scope.$watch(DepartmentsFactory.add(newDept), (res) ->
      if res
        $scope.success = true
        $scope.messageText = 'Department added success!'
      else
        $scope.error = true
        $scope.messageText = 'Department not added! Try again'
    )
    return
  return