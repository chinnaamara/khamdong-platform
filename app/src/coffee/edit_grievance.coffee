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
    updateRef.child('casteCertificate').set data.casteCertificate
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

app.controller 'EditGrievanceController', ($scope, EditGrievanceFactory, DataFactory, $rootScope, $window) ->
  $scope.UserEmail = ''
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

  $scope.education = DataFactory.education
  $scope.constituencies = DataFactory.constituencies
  $scope.gpus = DataFactory.gpus
  $scope.wards = DataFactory.wards
  $scope.grievanceTypes = DataFactory.grievanceTypes
  $scope.departments = DataFactory.departments
  $scope.schemes = DataFactory.schemes

  $(".date").datepicker autoclose: true
  data = EditGrievanceFactory.retrieveGrievance
  $scope.grievance = data
  $scope.recommendedDoc = data.recommendedDoc
  $scope.coiDoc = data.coiDoc
  $scope.voterCard = data.voterCard
  $scope.casteCertificate = data.casteCertificate
  $scope.otherDoc = data.otherDoc
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
      else if fileName == 'caste'
        $scope.casteCertificate = arrayBufferToBase64 e.target.result
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
    btoa binary

  $scope.updateGrievance = ->
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
      casteCertificate: $scope.casteCertificate
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
        $scope.successMessage = true;
    )
