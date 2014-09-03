app.factory 'GrievancesFactory', ($firebase, BASEURI) ->
  grievancesRef = new Firebase BASEURI + 'grievances'
  grievances = $firebase grievancesRef
#  grievances = (callback) ->
#    grievancesRef.on('value', ((snapshot) ->
#      callback _.values(snapshot.val())
#    ), (error) ->
#      error.code
#    )
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

app.controller 'GrievancesController', ($scope, GrievancesFactory, EditGrievanceFactory, $rootScope, $window) ->
  localData = localStorage.getItem('userEmail')
  if ! localData
    $window.location = '#/error'
  else if localData == '"admin@technoidentity.com"'
    $rootScope.userName = 'Admin'
    $rootScope.administrator = 'Admin'
  else
    user = localData.split('"')
    userName = user[1]
    $rootScope.userName = userName

#  $scope.grievances = GrievancesFactory.retrieveGrievances
  $scope.loadDone = false
  $scope.loading = true
  $scope.noPrevious = true
  pageNumber = 0
  recordsPerPage = 4
  bottomRecord = null

  getQuery = GrievancesFactory.grievancesRef
  getQuery.startAt().limit(recordsPerPage).on('value', (snapshot) ->
    $scope.grievances = _.values snapshot.val()
    $scope.loadDone = true
    $scope.loading = false
    bottomRecord = $scope.grievances[$scope.grievances.length - 1]
    GrievancesFactory.pageNext(bottomRecord.referenceNum, recordsPerPage + 1, (res) ->
      if res
        $scope.noNext = res.length <= 1 ? true : false
    )
  )

  $scope.pageNext = () ->
    pageNumber++
    $scope.noPrevious = false
    bottomRecord = $scope.grievances[$scope.grievances.length - 1]
    GrievancesFactory.pageNext(bottomRecord.referenceNum, recordsPerPage + 1, (res) ->
      if res
        res.shift()
        $scope.grievances = res
        bottomRecord = $scope.grievances[$scope.grievances.length - 1]
    )
    GrievancesFactory.pageNext(bottomRecord.referenceNum, recordsPerPage + 1, (res) ->
      if res
        $scope.noNext = res.length <= 1 ? true : false
    )

  $scope.pageBack = () ->
    pageNumber--
    $scope.noNext = false
    topRecord = $scope.grievances[0]
    GrievancesFactory.pageBack(topRecord.referenceNum, recordsPerPage + 1, (res) ->
      if res
        res.pop()
        $scope.grievances = res
        $scope.noPrevious = pageNumber is 0 ? true : false
    )



  $scope.predicate = '-respondedDate'

  $scope.showDetails = (data) ->
    $scope.grievanceById = data
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
    EditGrievanceFactory.retrieveGrievance = grievance
    $window.location = '#/grievance/edit'
    return
