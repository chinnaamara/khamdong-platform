app.factory 'DashboardFactory', ($firebase, BASEURI) ->
  grievancesRef = new Firebase BASEURI + 'grievances'
  grievances = $firebase grievancesRef
  pageNext = (name, numberOfItems, cb) ->
    grievancesRef.startAt(null, name).limit(numberOfItems).once('value', (snapshot) ->
      cb _.values snapshot.val()
    )
  pageBack = (name, numberOfItems, cb) ->
    grievancesRef.endAt(null, name).limit(numberOfItems).once('value', (snapshot) ->
      cb _.values snapshot.val()
    )

  return {
    retrieveGrievances: grievances
    grievancesRef: grievancesRef
    pageNext: pageNext
    pageBack: pageBack
  }

app.controller 'DashboardController', ($scope, DashboardFactory, $window, DetailsFactory, $rootScope) ->
  $scope.init = ->
    session = localStorage.getItem('firebaseSession')
    if ! session
      $window.location = '#/error'
    else
      userName = localStorage.getItem('name')
      user = userName.split('"')
      $rootScope.userName = user[1].toUpperCase()
      role = localStorage.getItem('role')
      role = role.split('"')[1]
      $rootScope.administrator = role == 'Admin' ? true : false

  $scope.init()

#  $scope.grievances = DashboardFactory.retrieveGrievances
  $scope.loadDone = false
  $scope.loading = true
  $scope.noPrevious = true
  pageNumber = 0
  recordsPerPage = 4
  bottomRecord = null

  getQuery = DashboardFactory.grievancesRef
  getQuery.startAt().limit(recordsPerPage).on('value', (snapshot) ->
    $scope.grievances = _.values snapshot.val()
    $scope.loadDone = true
    $scope.loading = false
    bottomRecord = $scope.grievances[$scope.grievances.length - 1]
    if bottomRecord
      DashboardFactory.pageNext(bottomRecord.referenceNum, recordsPerPage + 1, (res) ->
        if res
          $scope.noNext = res.length <= 1 ? true : false
      )
    else
      $scope.noNext = true
  )

  $scope.pageNext = ->
    pageNumber++
    $scope.noPrevious = false
    bottomRecord = $scope.grievances[$scope.grievances.length - 1]
    DashboardFactory.pageNext(bottomRecord.referenceNum, recordsPerPage + 1, (res) ->
      if res
        res.shift()
        $scope.grievances = res
        bottomRecord = $scope.grievances[$scope.grievances.length - 1]
    )
    DashboardFactory.pageNext(bottomRecord.referenceNum, recordsPerPage + 1, (res) ->
      if res
        $scope.noNext = res.length <= 1 ? true : false
    )

  $scope.pageBack = ->
    pageNumber--
    $scope.noNext = false
    topRecord = $scope.grievances[0]
    DashboardFactory.pageBack(topRecord.referenceNum, recordsPerPage + 1, (res) ->
      if res
        res.pop()
        $scope.grievances = res
        $scope.noPrevious = pageNumber is 0 ? true : false
    )

  $scope.predicate = '-applicationDate'
  $scope.showDetails = (details) ->
    DetailsFactory.retrieveGrievance = details
    $window.location = '#/details'

  $scope.showDocuments = (data) ->
    $scope.noDocs = false
    if data.recommendedDoc
      $scope.recommendedDoc = true
      canvas1 = document.getElementById "recommendedDocCanvas"
      ctx1 = canvas1.getContext("2d")
      img1 = new Image()
      img1.onload = ->
        ctx1.drawImage(this, 0, 0, canvas1.width, canvas1.height)
      img1.src = "data:image/gif;base64," + data.recommendedDoc
      document.getElementById("downloadrecommendedDoc").href = "data:image/png;base64," + data.recommendedDoc
      document.getElementById("downloadrecommendedDoc").download = 'recommended_doc.png'
    else
      $scope.recommendedDoc = false

    if data.coiDoc
      $scope.COIDoc = true
      canvas2 = document.getElementById "COIDocCanvas"
      ctx2 = canvas2.getContext("2d")
      img2 = new Image()
      img2.onload = ->
        ctx2.drawImage(this, 0, 0, canvas2.width, canvas2.height)
      img2.src = "data:image/gif;base64," + data.coiDoc
      document.getElementById("downloadCOIDoc").href = "data:image/png;base64," + data.coiDoc
      document.getElementById("downloadCOIDoc").download = 'coi.png'
    else
      $scope.COIDoc = false

    if data.voterCard
      $scope.voterDoc = true
      canvas3 = document.getElementById "voterIdCanvas"
      ctx3 = canvas3.getContext("2d")
      img3 = new Image()
      img3.onload = ->
        ctx3.drawImage(this, 0, 0, canvas3.width, canvas3.height)
      img3.src = "data:image/gif;base64," + data.voterCard
      document.getElementById("downloadVoter").href = "data:image/png;base64," + data.voterCard
      document.getElementById("downloadVoter").download = 'voter.png'
    else
      $scope.voterDoc = false

    if data.casteCertificate
      $scope.casteDoc = true
      canvas4 = document.getElementById "casteCertificateCanvas"
      ctx4 = canvas4.getContext("2d")
      img4 = new Image()
      img4.onload = ->
        ctx4.drawImage(this, 0, 0, canvas4.width, canvas4.height)
      img4.src = "data:image/gif;base64," + data.casteCertificate
      document.getElementById("downloadCasteCertificate").href = "data:image/png;base64," + data.casteCertificate
      document.getElementById("downloadCasteCertificate").download = 'caste.png'
    else
      $scope.casteDoc = false

    if data.otherDoc
      $scope.otherDoc = true
      canvas5 = document.getElementById "otherDocCanvas"
      ctx5 = canvas5.getContext("2d")
      img5 = new Image()
      img5.onload = ->
        ctx5.drawImage(this, 0, 0, canvas5.width, canvas5.height)
      img5.src = "data:image/gif;base64," + data.otherDoc
      document.getElementById("downloadOther").href = "data:image/png;base64," + data.otherDoc
      document.getElementById("downloadOther").download = 'other_doc.png'
    else
      $scope.otherDoc = false

    if ! data.recommendedDoc && ! data.aadharCard && ! data.voterCard && ! data.sscCertificate && ! data.otherDoc
      $scope.noDocs = true
