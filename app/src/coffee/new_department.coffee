app.factory 'DepartmentsFactory', ($firebase, BASEURI) ->
  ref = new Firebase(BASEURI + "departments")
  data = $firebase(ref)
  addDepartment = (departmentData) ->
    addRef = new Firebase(BASEURI + "departments/" + departmentData.id)
    addRef.child("id").set departmentData.id
    addRef.child("departmentName").set departmentData.departmentName
    addRef.child("departmentCode").set departmentData.departmentCode
    return 'true'

  setUUID = ->
    CHARS = "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ".split("")
    chars = CHARS
    uuid = new Array(36)
    rnd = 0
    r = undefined
    i = 0
    while i < 36
      if i is 8 or i is 13 or i is 18 or i is 23
        uuid[i] = "-"
      else if i is 14
        uuid[i] = "4"
      else
        rnd = 0x2000000 + (Math.random() * 0x1000000) | 0  if rnd <= 0x02
        r = rnd & 0xf
        rnd = rnd >> 4
        uuid[i] = chars[(if (i is 19) then (r & 0x3) | 0x8 else r)]
      i++
    uuid.join ""

  return {
    data: data
    add: addDepartment
    UUID: setUUID
  }


app.controller "AddDepartmentController", ($scope, DepartmentsFactory, $rootScope) ->
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

  $scope.addDept = ->
    newDept =
      id: DepartmentsFactory.UUID()
      departmentCode: $scope.deptCode
      departmentName: $scope.deptName
    $scope.$watch(DepartmentsFactory.add(newDept), (res) ->
      if res
        console.log 'department added success..'
        $scope.error = true
    )
    return
  return