app.factory 'DetailsFactory', ($firebase, BASEURI, $http) ->
  grievanceByid = {}
  submitResponse = (data) ->
    responseRef = new Firebase BASEURI + 'grievances/' + data.referenceNum
    responseWithUserRef = new Firebase BASEURI + 'users/' + data.submittedUserId + '/grievances/' + data.referenceNum
    responseWithWardRef = new Firebase BASEURI + 'wards/' + data.wardId + '/grievances/' + data.referenceNum

    responseRef.child('grievanceType').set data.grievanceType
    responseRef.child('department').set data.department
    responseRef.child('scheme').set data.scheme
    responseRef.child('requirement').set data.requirement
    responseRef.child('respondedDate').set data.respondedDate
    responseRef.child('status').set data.status
    responseRef.child('message').set data.message

    responseWithUserRef.child('grievanceType').set data.grievanceType
    responseWithUserRef.child('department').set data.department
    responseWithUserRef.child('scheme').set data.scheme
    responseWithUserRef.child('requirement').set data.requirement
    responseWithUserRef.child('respondedDate').set data.respondedDate
    responseWithUserRef.child('status').set data.status
    responseWithUserRef.child('message').set data.message

    responseWithWardRef.child('grievanceType').set data.grievanceType
    responseWithWardRef.child('department').set data.department
    responseWithWardRef.child('scheme').set data.scheme
    responseWithWardRef.child('requirement').set data.requirement
    responseWithWardRef.child('respondedDate').set data.respondedDate
    responseWithWardRef.child('status').set data.status
    responseWithWardRef.child('message').set data.message
    return 'true'

  sendSms = (data) ->
    $http
    .post('http://api.mVaayoo.com/mvaayooapi/MessageCompose?user=Dilip@cannybee.in:8686993306&senderID=TEST SMS&receipientno=' + data.mobile + '&msgtxt= ' + data.message + ' &state=4')
    .success((data, status, headers, config) ->
#      alert 'success'
    )
    .error((status) ->
#      alert status.responseText
    )

  return {
    retrieveGrievance: grievanceByid
    post: submitResponse
    sendSms: sendSms
  }

app.controller 'DetailsController', ($scope, DetailsFactory, $rootScope, DataFactory) ->
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

  $scope.grievanceTypes = DataFactory.grievanceTypes
  $scope.departments = DataFactory.departments
  $scope.schemes = DataFactory.schemes

  statusMessage = " "
  $scope.accept = true
  $scope.reject = true
  $scope.status = " "
  $scope.message = " "
  $scope.smsText = " "
  $scope.newValue = (value) ->
    $scope.responce = false
    if value == 'Approve'
      $scope.accept = false
      $scope.reject = true
      statusMessage = "Approved"
      $scope.message = "Your grievance is approved."
      $scope.responceMessage = "Grievance Approved!"
      $scope.smsText = " is approved, please get more details from GPU."
    else if value == 'Reject'
      $scope.accept = true
      $scope.reject = false
      statusMessage = "Rejected"
      $scope.message = "Cancelled"
      $scope.responceMessage = "Grievance Rejected!"
      $scope.smsText = " is rejected, please get more details from GPU."

  $scope.grievance = DetailsFactory.retrieveGrievance
  currentYear = new Date().getFullYear()
  yearOfBirth = new Date($scope.grievance.dob).getFullYear()
  $scope.age = currentYear - yearOfBirth

  $scope.submit = ->
    smsData = {
      mobile: $scope.grievance.phoneNumber
      message: "Hi " + $scope.grievance.name + ", your grievance request with reference number " + $scope.grievance.referenceNum + $scope.smsText
    }
    resMessage = {
      referenceNum: $scope.grievance.referenceNum
      grievanceType: $scope.grievance.grievanceType
      department: $scope.grievance.department
      scheme: $scope.grievance.scheme
      requirement: $scope.grievance.requirement
      respondedDate: new Date().toLocaleString()
      status: statusMessage
      message: $scope.message
      wardId: $scope.grievance.wardId
      submittedUserId: $scope.grievance.submittedUserId
    }
    $scope.$watch(DetailsFactory.post(resMessage), (res) ->
      if res
        $scope.responce = true
        $scope.$watch(DetailsFactory.sendSms(smsData), (status) ->
          if status
            console.log "sms sent to " + smsData.mobile
        )
    )
