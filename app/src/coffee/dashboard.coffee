app.factory 'DashboardFactory', ($firebase, BASEURI) ->
  grievancesRef = new Firebase BASEURI + 'grievances'
  grievances = $firebase grievancesRef

  return {
    retrieveGrievances: grievances
  }

app.controller 'DashboardController', ($scope, DashboardFactory, $window, DetailsFactory, $rootScope) ->

  localData = localStorage.getItem('userEmail')
  if ! localData
    $window.location = '#/error'
  else if localData == '"admin@technoidentity.com"'
    $scope.UserEmail = "admin@technoidentity.com"
    $rootScope.userName = 'Admin'
    $rootScope.administrator = 'Admin'
  else
    user = localData.split('"')
    $scope.UserEmail = user[1]
    $rootScope.userName = $scope.UserEmail

  $scope.grievances = DashboardFactory.retrieveGrievances
#  console.log $scope.grievances
  $scope.predicate = '-applicationDate'
  $scope.showDetails = (details) ->
    DetailsFactory.retrieveGrievance = details
#    DetailsFactory.retrieveGrievance = {
#      name: details.name
#      fatherName: details.fatherName
#      dob: details.dob
#      phoneNumber: details.phoneNumber
#      address: details.address
#      education: details.education
#      gpu: details.gpu
#      ward: details.ward
#      constituency: details.constituency
#      department: details.department
#      grievanceType: details.grievanceType
#      note: details.note
#    }
    $window.location = '#/details'

  $scope.showDoc = (data) ->
    canvas = document.getElementById "document"
    ctx = canvas.getContext("2d")
    img = new Image()
    img.onload = ->
      ctx.drawImage(this, 0, 0, canvas.width, canvas.height)
#    img.src = pdfCanvas.toDataURL(data.file);
    img.src = "data:image/gif;base64," + data.file
