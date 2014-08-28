app.factory 'GrievancesFactory', ($firebase, BASEURI) ->
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

#  $scope.grievances = GrievancesFactory.retrieveGrievances

  $("#prev").prop "disabled", true
  pageNumber = 0
  limitCount = 2
  lastPageNumber = null
  postsRef = GrievancesFactory.grievancesRef
  postsQuery = postsRef.startAt().limit(limitCount)
  postsQuery.on('value', (snapshot) ->
    console.log 'snapshot', snapshot.val()
    $scope.grievances = _.values snapshot.val()
    lastPageNumber = $scope.grievances[$scope.grievances.length - 1]
    console.log lastPageNumber.id
    GrievancesFactory.pageNext(lastPageNumber.id, limitCount + 1, (res) ->
      if res
        console.log res
        $("#next").prop "disabled", res.length <= 1
    )
  )
  $scope.pageNext = () ->
    pageNumber++
    $("#prev").prop "disabled", false
    lastItem = $scope.grievances[$scope.grievances.length - 1]
    GrievancesFactory.pageNext(lastItem.id, limitCount + 1, (res) ->
      if res
        res.shift()
        $scope.grievances = res
        lastPageNumber = $scope.grievances[$scope.grievances.length - 1]
    )
    GrievancesFactory.pageNext(lastPageNumber.id, limitCount + 1, (res) ->
      if res
        $("#next").prop "disabled", res.length < limitCount
    )
  $scope.pageBack = () ->
    pageNumber--
    $("#next").prop "disabled", false
    firstItem = $scope.grievances[0]
    GrievancesFactory.pageBack(firstItem.id, limitCount + 1, (res) ->
      if res
        res.pop()
        $scope.grievances = res
        $("#prev").prop "disabled", pageNumber is 0
    )



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
