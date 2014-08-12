app.factory 'DetailsFactory', ($firebase, BASEURI) ->
  grievanceByid = {}

  acceptResponse = (data) ->
    messageRef = new Firebase BASEURI + 'grievances/' + data.id
    messageRef.child('status').set data.status
    return 'true'

  rejectResponse = (data) ->
    messageRef = new Firebase BASEURI + 'grievances/' + data.id
    messageRef.child('status').set data.status
    return 'true'

  return {
    retrieveGrievance: grievanceByid
    accept: acceptResponse
    reject: rejectResponse
  }

app.controller 'DetailsController', ($scope, DetailsFactory) ->
  $scope.accept = true
  $scope.reject = true
#  $scope.status = 'accept'
  $scope.newValue = (value) ->
    if value == 'Accept'
      $scope.accept = false
      $scope.reject = true
    else if value == 'Reject'
      $scope.accept = true
      $scope.reject = false

  $scope.grievance = {}
  console.log DetailsFactory.retrieveGrievance
  data = DetailsFactory.retrieveGrievance
#  $scope.message = data.id
  $scope.grievance = data

  $scope.acceptGrievance = (data) ->
    console.log $scope.grievance.id
    data = {
      id: $scope.grievance.id
      status: 'accepted'
    }
    $scope.$watch(DetailsFactory.accept(data), (res) ->
      if res
        console.log 'accepted success'
#        $scope.error = true;
    )

  $scope.rejectGrievance = (data) ->
    console.log $scope.grievance.id
    console.log 'rejecting....'
    data = {
      id: $scope.grievance.id
      status: 'rejected'
    }
    $scope.$watch(DetailsFactory.reject(data), (res) ->
      if res
        console.log 'rejected success'
#        $scope.error = true;
    )

  $scope.grievanceTypes = [
    {id: 1, name: 'Grievance Type 1'}
    {id: 2, name: 'Grievance Type 2'}
    {id: 3, name: 'Grievance Type 3'}
    {id: 4, name: 'Grievance Type 4'}
  ]
  $scope.departments = [
    {id: 1, name: 'Department 1'}
    {id: 2, name: 'Department 2'}
    {id: 3, name: 'Department 3'}
    {id: 4, name: 'Department 4'}
  ]
  $scope.schemes = [
    {id: 1, name: 'Scheme 1'}
    {id: 2, name: 'Scheme 2'}
    {id: 3, name: 'Scheme 3'}
    {id: 4, name: 'Scheme 4'}
  ]
