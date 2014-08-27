app.factory 'GrievancesFactory', ($firebase, BASEURI) ->
  grievancesRef = new Firebase BASEURI + 'grievances'
  grievances = $firebase grievancesRef

  return {
    retrieveGrievances: grievances
  }

app.controller 'GrievancesController', ($scope, GrievancesFactory, EditGrievanceFactory, $rootScope, $window) ->
  localData = localStorage.getItem('userEmail')
#  $rootScope.userName = localData['email']
  console.log localData
  console.log 'root element: ' + $rootScope.token
  console.log 'user: ' + $rootScope.userName
  if ! localData
    $window.location = '#/error'
  else if localData == '"admin@technoidentity.com"'
    $rootScope.userName = 'Admin'
    $rootScope.administrator = 'Admin'
  else
    user = localData.split('"')
    userName = user[1]
    $rootScope.userName = userName

  $scope.grievances = GrievancesFactory.retrieveGrievances
  $scope.predicate = '-respondedDate'

  $scope.showDetails = (data) ->
    $scope.grievance = data
#    console.log data
    return

  $scope.viewPdf = ->
    printElement(document.getElementById 'printThis')
    window.print()

  printElement = (elem) ->
    domClone = elem.cloneNode true
    printSection = document.getElementById 'printSection'
    unless printSection
      printSection = document.createElement 'div'
      printSection.id = 'printSection'
      document.body.appendChild printSection
    printSection.innerHTML = ''
    printSection.appendChild domClone
    return

  $scope.editDetails = (grievance) ->
    console.log grievance
    EditGrievanceFactory.retrieveGrievance = grievance
    $window.location = '#/grievance/edit'
    return
