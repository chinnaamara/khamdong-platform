app.factory 'EditGrievanceFactory', ($firebase, BASEURI) ->
  grievanceByid = {}
  update = (data) ->
    updateRef = new Firebase BASEURI + 'grievances/' + data.referenceNum
    updateRef.child('name').set data.name
    updateRef.child('fatherName').set data.fatherName
    updateRef.child('dob').set data.dob
    updateRef.child('phoneNumber').set data.phoneNumber
    updateRef.child('address').set data.address
    updateRef.child('education').set data.education
    updateRef.child('gpu').set data.gpu
    updateRef.child('ward').set data.ward
    updateRef.child('constituency').set data.constituency
    updateRef.child('department').set data.department
    updateRef.child('grievanceType').set data.grievanceType
    updateRef.child('scheme').set data.scheme
    updateRef.child('requirement').set data.requirement
    updateRef.child('recommendedDoc').set data.recommendedDoc
    updateRef.child('coiDoc').set data.coiDoc
    updateRef.child('voterCard').set data.voterCard
    updateRef.child('sscCertificate').set data.sscCertificate
    updateRef.child('otherDoc').set data.otherDoc
    updateRef.child('note').set data.note
    updateRef.child('applicationDate').set data.applicationDate
    updateRef.child('respondedDate').set data.respondedDate
    updateRef.child('status').set data.status
    updateRef.child('message').set data.message
    updateRef.child('email').set data.email
    return 'true'

  return {
    retrieveGrievance: grievanceByid
    saveGrievance: update
  }

app.controller 'EditGrievanceController', ($scope, EditGrievanceFactory, $rootScope, $window) ->
  $scope.UserEmail = ''
  localData = localStorage.getItem('userEmail')
  console.log localData
  console.log 'root element: ' + $rootScope.token
  console.log 'user: ' + $rootScope.userName
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

  $(".date").datepicker autoclose: true
  data = EditGrievanceFactory.retrieveGrievance
  $scope.grievance = data
  $scope.recommendedDoc = data.recommendedDoc
  $scope.coiDoc = data.coiDoc
  $scope.voterCard = data.voterCard
  $scope.sscCertificate = data.sscCertificate
  $scope.otherDoc = data.otherDoc
#  console.log $scope.file
  currentYear = new Date().getFullYear()
  yearofBirth = new Date($scope.grievance.dob).getFullYear()
  $scope.age = currentYear - yearofBirth

  $scope.onFileSelect = ($files, fileName) ->
    file = $files[0]
    reader = new FileReader()
    reader.readAsArrayBuffer file
    reader.onload = (e) ->
      if fileName == 'recommended'
        $scope.recommendedDoc = arrayBufferToBase64 e.target.result
      else if fileName == 'coi'
        $scope.coiDoc = arrayBufferToBase64 e.target.result
      else if fileName == 'voter'
        $scope.voterCard = arrayBufferToBase64 e.target.result
      else if fileName == 'ssc'
        $scope.sscCertificate = arrayBufferToBase64 e.target.result
      else
        $scope.otherDoc = arrayBufferToBase64 e.target.result
      return
    return

  arrayBufferToBase64 = (arrayBuffer) ->
    binary = ''
    bytes = new Uint8Array arrayBuffer
    _.forEach(_.range(bytes.length),(e) ->
      binary += String.fromCharCode bytes[e]
    )
    window.btoa binary

  $scope.updateGrievance = ->
#    console.log $scope.file
    updateRecord = {
      id: $scope.grievance.id
      referenceNum: $scope.grievance.referenceNum
      name: $scope.grievance.name
      fatherName: $scope.grievance.fatherName
      dob: $scope.grievance.dob
      phoneNumber: $scope.grievance.phoneNumber
      address: $scope.grievance.address
      education: $scope.grievance.education
      gpu: $scope.grievance.gpu
      ward: $scope.grievance.ward
      constituency: $scope.grievance.constituency
      department: $scope.grievance.department
      grievanceType: $scope.grievance.grievanceType
      scheme: $scope.grievance.scheme
      requirement: $scope.grievance.requirement
      recommendedDoc: $scope.recommendedDoc
      coiDoc: $scope.coiDoc
      voterCard: $scope.voterCard
      sscCertificate: $scope.sscCertificate
      otherDoc: $scope.otherDoc
      note: $scope.grievance.note
      applicationDate: new Date().toLocaleString()
      respondedDate: "--/--/----"
      status: "Open"
      message: "Waiting"
      email: $scope.UserEmail
    }
    $scope.$watch(EditGrievanceFactory.saveGrievance(updateRecord), (res) ->
      if res
        console.log 'accepted/rejected success'
        $scope.error = true;
    )



  $scope.education = [
    {id: 1, name: 'SSC'}
    {id: 2, name: 'Intermediate'}
    {id: 3, name: 'UG'}
    {id: 4, name: 'PG'}
  ]
  $scope.constituencies = [
    {id: 1, name: 'Constituency 1'}
    {id: 2, name: 'Constituency 2'}
    {id: 3, name: 'Constituency 3'}
    {id: 4, name: 'Constituency 4'}
  ]
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
