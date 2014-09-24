app.factory 'GrievancesFactory', ($firebase, BASEURI) ->
  grievancesRef = new Firebase BASEURI + 'grievances'
  grievances = $firebase grievancesRef

  pageNext = (filterKey, name, noOfRecords, cb) ->
    getRef = new Firebase BASEURI + filterKey
    getRef.startAt(null, name).limit(noOfRecords).once('value', (snapshot) ->
      cb _.values snapshot.val()
    )

  pageBack = (filterKey, name, noOfRecords, cb) ->
    getRef = new Firebase BASEURI + filterKey
    getRef.endAt(null, name).limit(noOfRecords).once('value', (snapshot) ->
      cb _.values snapshot.val()
    )

  return {
    retrieveGrievances: grievances
    grievancesRef: grievancesRef
    pageNext: pageNext
    pageBack: pageBack
  }

app.controller 'GrievancesController', ($scope, GrievancesFactory, EditGrievanceFactory, $rootScope, $window, $firebase, BASEURI) ->
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

#  $scope.grievances = GrievancesFactory.retrieveGrievances
  $scope.loadDone = false
  $scope.loading = true
  $scope.noPrevious = true
  pageNumber = 0
  recordsPerPage = 5
  bottomRecord = null
  $scope.grievances = {}

  userId = localStorage.getItem('userId')
  ward = localStorage.getItem('ward')
  trimWard = (ward) ->
    ward.replace(RegExp(" +", "g"), "")
  $scope.wardId = trimWard(ward).toLowerCase()
  filterKey = 'wards/' + $scope.wardId + '/grievances'

  getFirstPageData = ->
    getQuery = new Firebase BASEURI + filterKey
    getQuery.startAt().limit(recordsPerPage).on('value', (snapshot) ->
      $scope.grievances = _.values snapshot.val()
      $scope.loadDone = true
      $scope.loading = false
      bottomRecord = $scope.grievances[$scope.grievances.length - 1]
      if bottomRecord
        GrievancesFactory.pageNext(filterKey, bottomRecord.referenceNum, recordsPerPage + 1, (res) ->
          if res
            $scope.noNext = res.length <= 1
        )
      else
        $scope.noNext = true
    )
    return

  getFirstPageData()

  $scope.pageNext = ->
    pageNumber++
    $scope.noPrevious = false
    bottomRecord = $scope.grievances[$scope.grievances.length - 1]
    GrievancesFactory.pageNext(filterKey, bottomRecord.referenceNum, recordsPerPage + 1, (res) ->
      if res
        res.shift()
        $scope.grievances = res
        bottomRecord = $scope.grievances[$scope.grievances.length - 1]
    )
    GrievancesFactory.pageNext(filterKey, bottomRecord.referenceNum, recordsPerPage + 1, (res) ->
      if res
        $scope.noNext = res.length <= 1
    )

  $scope.pageBack = ->
    pageNumber--
    $scope.noNext = false
    topRecord = $scope.grievances[0]
    GrievancesFactory.pageBack(filterKey, topRecord.referenceNum, recordsPerPage + 1, (res) ->
      if res
        res.pop()
        $scope.grievances = res
        $scope.noPrevious = pageNumber is 0
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

  $scope.filterGrievances = ->
    if $scope.checked
      filterKey = 'users/' + userId + '/grievances'
    else
      filterKey = 'wards/' + $scope.wardId + '/grievances'
    console.log filterKey
    getFirstPageData()
    return
