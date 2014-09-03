app.factory 'DetailsFactory', ($firebase, BASEURI, $http) ->
  grievanceByid = {}
  submitResponse = (data) ->
    messageRef = new Firebase BASEURI + 'grievances/' + data.referenceNum
    messageRef.child('grievanceType').set data.grievanceType
    messageRef.child('department').set data.department
    messageRef.child('scheme').set data.scheme
    messageRef.child('requirement').set data.requirement
    messageRef.child('respondedDate').set data.respondedDate
    messageRef.child('status').set data.status
    messageRef.child('message').set data.message
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
      id: $scope.grievance.id
      referenceNum: $scope.grievance.referenceNum
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
        $scope.responce = true
        $scope.$watch(DetailsFactory.sendSms(smsData), (status) ->
          if status
            console.log "sms sent to " + smsData.mobile
        )
    )
