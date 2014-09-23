app.factory 'WardsFactory', ($firebase, BASEURI) ->

  wardsRef = new Firebase BASEURI + 'wards/'
  wards = $firebase wardsRef

  getWards = (count, callback) ->
    wardsRef.startAt().limit(count).on('value', (res) ->
      callback _.values res.val()
    )

  createWard = (ward) ->
    addRef = new Firebase BASEURI + 'wards/' + ward.wardId
    addRef.child('id').set ward.wardId
    addRef.child('name').set ward.wardName
    addRef.child('createdDate').set ward.createdDate
    addRef.child('updatedDate').set ward.updatedDate
    return 'true'

  deleteWard = (id) ->
    deleteRef = wardsRef.child(id)
    deleteRef.remove()
    return 'true'

  return {
  wards: wards
  getWards: getWards
  wardsRef: wardsRef
  createWard: createWard
  delete: deleteWard
  }

app.controller 'WardsController', ($scope, $rootScope, WardsFactory, $window) ->
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

  $scope.wards = WardsFactory.wards

  UID = (ward) ->
    ward.replace(RegExp(" +", "g"), "")
#    date = new Date()
#    refID = date.getTime()
#    str1 = ward.substring(0, 2).toUpperCase()
#    refID + str1

  $scope.btnAdd = ->
    $scope.modelTitle = 'Add New Ward'
    $scope.wardName = ''
    $scope.buttonText = 'Add'

  $scope.addNewWard = ->
    if $scope.buttonText == 'Add'
      ward =
        wardId: UID $scope.wardName.toLowerCase()
        wardName: $scope.wardName
        createdDate: new Date().toLocaleString()
        updatedDate: new Date().toLocaleString()
    else
      ward =
        wardId: $scope.wardById.wardId
        wardName: $scope.wardName
        createdDate: $scope.wardById.createdDate
        updatedDate: new Date().toLocaleString()

    $scope.$watch(WardsFactory.createWard(ward), (res) ->
      if res
        console.log 'ward added'
      else
        console.log 'ward not added'
    )

  $scope.wardName = ''
  $scope.wardById = {}
  $scope.editWard = (ward) ->
    console.log ward
    $scope.modelTitle = 'Edit Category'
    $scope.buttonText = 'Update'
    $scope.wardById.wardId = ward.id
    $scope.wardName = ward.name
    $scope.wardById.createdDate = ward.createdDate

  $scope.deleteWard = (ward) ->
    $scope.$watch(WardsFactory.delete(ward.id), (res) ->
      if res
        console.log 'deleted success'
      else
        console.log 'not deleted'
    )
