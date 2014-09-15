app.factory 'GrievancesFactory', ($firebase, BASEURI) ->
  grievancesRef = new Firebase BASEURI + 'grievances'
  grievances = $firebase grievancesRef
#  grievances = (callback) ->
#    grievancesRef.on('value', ((snapshot) ->
#      callback _.values(snapshot.val())
#    ), (error) ->
#      error.code
#    )
  pageNext = (name, noOfRecords, cb) ->
    grievancesRef.startAt(null, name).limit(noOfRecords).once('value', (snapshot) ->
      cb _.values snapshot.val()
    )
  pageBack = (name, noOfRecords, cb) ->
    grievancesRef.endAt(null, name).limit(noOfRecords).once('value', (snapshot) ->
      cb _.values snapshot.val()
    )

  return {
    retrieveGrievances: grievances
    grievancesRef: grievancesRef
    pageNext: pageNext
    pageBack: pageBack
  }

app.controller 'GrievancesController', ($scope, GrievancesFactory, EditGrievanceFactory, $rootScope, $window, $filter, ngTableParams) ->
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

  ward = localStorage.getItem('ward')
  $scope.loadDone = false
  $scope.loading = true
  $scope.noPrevious = true
  pageNumber = 0
  recordsPerPage = 4
  bottomRecord = null

  projectslist = undefined
  getQuery = GrievancesFactory.grievancesRef
  userWard = localStorage.getItem 'ward'
  projectsList = ->
    $scope.tableParams = new ngTableParams(
      page: 1
      count: 2
      sorting:
        respondedDate:'desc'
    ,
      counts: []
      total: 0
      getData: ($defer, params) ->
        filteredData = $filter("filter")($scope.projectslist, $scope.filter)
        orderedData = (if params.sorting() then $filter("orderBy")(filteredData, params.orderBy()) else filteredData)
        params.total orderedData.length
        $defer.resolve orderedData.slice((params.page() - 1) * params.count(), params.page() * params.count())
        return

      $scope: $scope
    )
    return

  getQuery.startAt(userWard).endAt(userWard).on('value', (snapshot) ->
    $scope.projectslist = _.values snapshot.val()
    $scope.loadDone = true
    $scope.loading = false
    projectsList()
  )
  $scope.$watch "filter.$", ->
    $scope.tableParams.reload()
    return

#  getQuery = GrievancesFactory.grievancesRef
#  getQuery.startAt(ward).endAt(ward).on('value', (snapshot) ->
#    $scope.grievances = _.values snapshot.val()
#    $scope.loadDone = true
#    $scope.loading = false
#    bottomRecord = $scope.grievances[$scope.grievances.length - 1]
#    if bottomRecord
#      GrievancesFactory.pageNext(bottomRecord.referenceNum, recordsPerPage + 1, (res) ->
#        if res
#          $scope.noNext = res.length <= 1 ? true : false
#      )
#    else
#      $scope.noNext = true
#  )
#
#  $scope.pageNext = ->
#    pageNumber++
#    $scope.noPrevious = false
#    bottomRecord = $scope.grievances[$scope.grievances.length - 1]
#    GrievancesFactory.pageNext(bottomRecord.referenceNum, recordsPerPage + 1, (res) ->
#      if res
#        res.shift()
#        $scope.grievances = res
#        bottomRecord = $scope.grievances[$scope.grievances.length - 1]
#    )
#    GrievancesFactory.pageNext(bottomRecord.referenceNum, recordsPerPage + 1, (res) ->
#      if res
#        $scope.noNext = res.length <= 1 ? true : false
#    )
#
#  $scope.pageBack = ->
#    pageNumber--
#    $scope.noNext = false
#    topRecord = $scope.grievances[0]
#    GrievancesFactory.pageBack(topRecord.referenceNum, recordsPerPage + 1, (res) ->
#      if res
#        res.pop()
#        $scope.grievances = res
#        $scope.noPrevious = pageNumber is 0 ? true : false
#    )

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
