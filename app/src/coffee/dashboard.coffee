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
    canvas1 = document.getElementById "recommendedDocCanvas"
    ctx1 = canvas1.getContext("2d")
    img1 = new Image()
    img1.onload = ->
      ctx1.drawImage(this, 0, 0, canvas1.width, canvas1.height)
    img1.src = "data:image/gif;base64," + data.recommendedDoc
    document.getElementById("downloadrecommendedDoc").href = "data:image/png;base64," + data.recommendedDoc
    document.getElementById("downloadrecommendedDoc").download = 'recommended_doc.png'

    canvas2 = document.getElementById "aadharCardCanvas"
    ctx2 = canvas2.getContext("2d")
    img2 = new Image()
    img2.onload = ->
      ctx2.drawImage(this, 0, 0, canvas2.width, canvas2.height)
    img2.src = "data:image/gif;base64," + data.aadharCard
    document.getElementById("downloadAadhar").href = "data:image/png;base64," + data.aadharCard
    document.getElementById("downloadAadhar").download = 'aadhar.png'

    canvas3 = document.getElementById "voterIdCanvas"
    ctx3 = canvas3.getContext("2d")
    img3 = new Image()
    img3.onload = ->
      ctx3.drawImage(this, 0, 0, canvas3.width, canvas3.height)
    img3.src = "data:image/gif;base64," + data.voterCard
    document.getElementById("downloadVoter").href = "data:image/png;base64," + data.voterCard
    document.getElementById("downloadVoter").download = 'voter.png'

    canvas4 = document.getElementById "sscCertificateCanvas"
    ctx4 = canvas4.getContext("2d")
    img4 = new Image()
    img4.onload = ->
      ctx4.drawImage(this, 0, 0, canvas4.width, canvas4.height)
    img4.src = "data:image/gif;base64," + data.sscCertificate
    document.getElementById("downloadSSC").href = "data:image/png;base64," + data.sscCertificate
    document.getElementById("downloadSSC").download = 'ssc.png'

    canvas5 = document.getElementById "otherDocCanvas"
    ctx5 = canvas5.getContext("2d")
    img5 = new Image()
    img5.onload = ->
      ctx5.drawImage(this, 0, 0, canvas5.width, canvas5.height)
    img5.src = "data:image/gif;base64," + data.otherDoc
    document.getElementById("downloadOther").href = "data:image/png;base64," + data.otherDoc
    document.getElementById("downloadOther").download = 'other_doc.png'
