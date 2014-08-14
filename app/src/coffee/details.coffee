app.factory 'DetailsFactory', ($firebase, BASEURI) ->
  grievanceByid = {}
  submitResponse = (data) ->
    messageRef = new Firebase BASEURI + 'grievances/' + data.id
    messageRef.child('grievanceType').set data.grievanceType
    messageRef.child('department').set data.department
    messageRef.child('scheme').set data.scheme
    messageRef.child('requirement').set data.requirement
    messageRef.child('respondedDate').set data.respondedDate
    messageRef.child('status').set data.status
    messageRef.child('message').set data.message
    return 'true'

#  rejectResponse = (data) ->
#    messageRef = new Firebase BASEURI + 'grievances/' + data.id
#    messageRef.child('status').set data.status
#    return 'true'

  return {
    retrieveGrievance: grievanceByid
    post: submitResponse
  }

app.controller 'DetailsController', ($scope, DetailsFactory) ->
  statusMessage = " "
  $scope.accept = true
  $scope.reject = true
  $scope.status = " "
  $scope.message = " "
  $scope.newValue = (value) ->
    if value == 'Accept'
      $scope.accept = false
      $scope.reject = true
      statusMessage = "Accepted"
      $scope.message = "Approved"
    else if value == 'Reject'
      $scope.accept = true
      $scope.reject = false
      statusMessage = "Rejected"
      $scope.message = "Cancelled"

  $scope.grievance = {}
  console.log DetailsFactory.retrieveGrievance
  data = DetailsFactory.retrieveGrievance
  $scope.grievance = data
  currentYear = new Date().getFullYear()
  yearofBirth = new Date($scope.grievance.dob).getFullYear()
  $scope.age = currentYear - yearofBirth
  $scope.submit = (data) ->
    console.log $scope.grievance.id
    resMessage = {
      id: $scope.grievance.id
      grievanceType: $scope.grievance.grievanceType
      department: $scope.grievance.department
      scheme: $scope.grievance.scheme
      requirement: $scope.grievance.requirement
      respondedDate: new Date().toLocaleString()
      status: statusMessage
      message: $scope.message
    }
    $scope.$watch(DetailsFactory.post(resMessage), (res) ->
      if res
        console.log 'accepted/rejected success'
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
