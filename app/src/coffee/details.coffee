app.factory 'DetailsFactory', ($firebase, BASEURI, $http) ->
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

  sendSms = (data) ->
    console.log 'sending'
    $http
    .post('http://api.mVaayoo.com/mvaayooapi/MessageCompose?user=Dilip@cannybee.in:8686993306&senderID=TEST SMS&receipientno=' + data.mobile + '&msgtxt= ' + data.message + ' &state=4')
    .success((data, status, headers, config) ->
      alert 'success'
    )
    .error((status) ->
#      alert status.responseText
    )

  return {
    retrieveGrievance: grievanceByid
    post: submitResponse
    sendSms: sendSms
  }

app.controller 'DetailsController', ($scope, DetailsFactory, $rootScope) ->
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

  statusMessage = " "
  $scope.accept = true
  $scope.reject = true
  $scope.status = " "
  $scope.message = " "
  $scope.smsText = " "
  $scope.newValue = (value) ->
    $scope.responce = false
    if value == 'Accept'
      $scope.accept = false
      $scope.reject = true
      statusMessage = "Accepted"
      $scope.message = "Approved"
      $scope.responceMessage = "Grievance Approved Successfully!"
      $scope.smsText = "is approved, check more details in website."
    else if value == 'Reject'
      $scope.accept = true
      $scope.reject = false
      statusMessage = "Rejected"
      $scope.message = "Cancelled"
      $scope.responceMessage = "Grievance Rejected Successfully!"
      $scope.smsText = " is rejected, please get details from GPU."



  $scope.grievance = {}
#  console.log DetailsFactory.retrieveGrievance
  data = DetailsFactory.retrieveGrievance
  $scope.grievance = data
  currentYear = new Date().getFullYear()
  yearofBirth = new Date($scope.grievance.dob).getFullYear()
  $scope.age = currentYear - yearofBirth

  $scope.submit = (data) ->
    smsData = {
      mobile: $scope.grievance.phoneNumber
      message: "Hi " + $scope.grievance.name + ", your grievance request with reference number " + $scope.grievance.referenceNum + $scope.smsText
    }
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
#        console.log 'accepted/rejected success'
        $scope.responce = true
        $scope.$watch(DetailsFactory.sendSms(smsData), (status) ->
          if status
            console.log "sms sent to " + smsData.mobile
        )
#        $scope.error = true;
    )

  $scope.grievanceTypes = [
    {id: 1, name: 'Grievance Type 1'}
    {id: 2, name: 'Grievance Type 2'}
    {id: 3, name: 'Grievance Type 3'}
    {id: 4, name: 'Grievance Type 4'}
  ]
  $scope.departments = [
    {id: 1, name: 'SOCIAL JUSTICE AND WELFARE DEPARTMENT'}
    {id: 2, name: 'HORTICULTURE AND CASH CROP DEVELOPMENT DEPARTMENT'}
    {id: 3, name: 'BACKWARD REGION GRANT FUND'}
    {id: 4, name: 'RURAL MANAGEMENT AND DEVELOPMENT DEPARTMENT'}
    {id: 5, name: 'ANIMAL HUSBANDRY LIVESTOCK FISHERIES AND VETERINARY SERVICES'}
    {id: 6, name: 'HUMAN RESOURCE DEVELOPMENT DEPARTMENT'}
    {id: 7, name: 'HEALTHCARE HUMAN SERVICES AND FAMILY WELFARE DEPARTMENT'}
    {id: 8, name: 'FOOD SECURITY CIVIL SUPPLIES AND CONSUMER AFFAIRS DEPARTMENT'}
    {id: 9, name: 'AGRICULTURE AND FOOD SECURITY DEVELOPMENT DEPARTMENT'}
    {id: 10, name: 'MAHATMA GANDHI NATIONAL RURAL EMPLOYMENT GURANTEE ACT'}
  ]
  $scope.schemes = [
    {id: 1, name: 'GREEN HOUSE'}
    {id: 2, name: 'OLD AGE PENSION'}
    {id: 3, name: 'INDIRA AWAS YOGNA'}
    {id: 4, name: 'WIDOW PENSION'}
    {id: 5, name: 'SUBSISTENCE ALLOWANCE'}
    {id: 6, name: 'PRE MATRIC SCHOLARSHIP'}
    {id: 7, name: 'POST MATRIC SCHOLARSHIP'}
    {id: 8, name: 'COW'}
    {id: 9, name: 'HOUSE UPGRADATION'}
    {id: 10, name: 'CMRHM'}
    {id: 11, name: 'GOAT'}
    {id: 12, name: 'PLASTIC TANK'}
    {id: 13, name: 'COW DUNG PIT'}
    {id: 14, name: 'RURAL HOUSING SCHEME'}
    {id: 15, name: 'LPG COOKING GAS CONNECTION'}
    {id: 16, name: 'BPL RICE'}
    {id: 17, name: 'EDUCATION SCHOLARSHIP'}
    {id: 18, name: 'GCI SHEET'}
  ]
