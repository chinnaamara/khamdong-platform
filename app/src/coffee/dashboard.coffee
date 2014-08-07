app.factory 'DashboardFactory', ($firebase, BASEURI) ->
  grievancesRef = new Firebase BASEURI + 'grievances'
  grievances = $firebase grievancesRef

  return {
    retrieveGrievances: grievances
  }

app.controller 'DashboardController', ($scope, DashboardFactory) ->
  console.log 'DashboardController.....'
  $scope.grievances = DashboardFactory.retrieveGrievances
  console.log $scope.grievances

  $scope.showDetails = (details) ->
    $scope.grievance = {
      name: details.name
      fatherName: details.fatherName
      dob: details.dob
      phoneNumber: details.phoneNumber
      address: details.address
      education: details.education
      gpu: details.gpu
      ward: details.ward
      constituency: details.constituency
      department: details.department
      grievanceType: details.grievanceType
      note: details.note
    }

  $scope.showDoc = (data) ->
    canvas = document.getElementById "document"
    ctx = canvas.getContext("2d")
    img = new Image()
    img.onload = ->
      ctx.drawImage(this, 0, 0, canvas.width, canvas.height)
#    img.src = pdfCanvas.toDataURL(data.file);
    img.src = "data:image/gif;base64," + data.file
