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

  $scope.gpus = [
    {id: 1, name: ' MelliDara Paiyong'}
  ]
  $scope.wards = [
    {id: 1, name: 'MelliDara'}
    {id: 2, name: 'MelliGumpa'}
    {id: 3, name: 'UpperPaiyong'}
    {id: 4, name: 'LowerPaiyong'}
    {id: 5, name: 'Kerabari'}
    {id: 6, name: 'MelliBazaar'}
  ]
  $scope.grievanceTypes = [
    {id: 1, name: 'Grievance Type 1'}
    {id: 2, name: 'Grievance Type 2'}
    {id: 3, name: 'Grievance Type 3'}
    {id: 4, name: 'Grievance Type 4'}
  ]
  $scope.departments = [
    {id: 1, name: 'Social Justice & Welfare'}
    {id: 2, name: 'Horticulture & Cash Crop Development'}
    {id: 3, name: 'Backward Region Grant Fund'}
    {id: 4, name: 'Rural Management & Development'}
    {id: 5, name: 'Animal Husbandry & Veterinary Services'}
    {id: 6, name: 'Livestock & Fisheries'}
    {id: 7, name: 'Human Resource Development'}
    {id: 8, name: 'Health care Human Services & Family Welfare'}
    {id: 9, name: 'Civil Supplies & Consumer Affairs'}
    {id: 10, name: 'Agriculture & Food Security Development'}
  ]
  $scope.schemes = [
    {id: 1, name: 'Green House'}
    {id: 2, name: 'Old Age Pension'}
    {id: 3, name: 'Indira Awas Yogna'}
    {id: 4, name: 'Widow Pension'}
    {id: 5, name: 'Subsistence Allowance'}
    {id: 6, name: 'Pre Metric Scholarship'}
    {id: 7, name: 'Post Metric Scholarship'}
    {id: 8, name: 'House Upgradation'}
    {id: 9, name: 'CMRHM'}
    {id: 10, name: 'Plastic Tasnk'}
    {id: 11, name: 'Cow Dung Pit'}
    {id: 12, name: 'Rural Housing Scheme'}
    {id: 13, name: 'LPG Cooking Gas Connection'}
    {id: 14, name: 'BPL Rice'}
    {id: 15, name: 'Education Scholarship'}
    {id: 16, name: 'GCI Sheet'}
  ]
