app.factory 'EditGrievanceFactory', ($firebase, BASEURI) ->
  grievanceByid = {}
  update = (data) ->
    updateRef = new Firebase BASEURI + 'grievances/' + data.referenceNum
    updateWithUserRef = new Firebase BASEURI + 'users/' + data.submittedUserId + '/grievances/' + data.referenceNum
    updateWithWardRef = new Firebase BASEURI + 'wards/' + data.wardId + '/grievances/' + data.referenceNum
    updateRef.child('name').set data.name
    updateRef.child('fatherName').set data.fatherName
    updateRef.child('dob').set data.dob
    updateRef.child('phoneNumber').set data.phoneNumber
    updateRef.child('address').set data.address
    updateRef.child('education').set data.education
    updateRef.child('gpu').set data.gpu
    updateRef.child('ward').set data.ward
    updateRef.child('wardId').set data.wardId
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
    updateRef.child('submittedUserId').set data.submittedUserId

    updateWithUserRef.child('name').set data.name
    updateWithUserRef.child('fatherName').set data.fatherName
    updateWithUserRef.child('dob').set data.dob
    updateWithUserRef.child('phoneNumber').set data.phoneNumber
    updateWithUserRef.child('address').set data.address
    updateWithUserRef.child('education').set data.education
    updateWithUserRef.child('gpu').set data.gpu
    updateWithUserRef.child('ward').set data.ward
    updateWithUserRef.child('wardId').set data.wardId
    updateWithUserRef.child('constituency').set data.constituency
    updateWithUserRef.child('department').set data.department
    updateWithUserRef.child('grievanceType').set data.grievanceType
    updateWithUserRef.child('scheme').set data.scheme
    updateWithUserRef.child('requirement').set data.requirement
    updateWithUserRef.child('recommendedDoc').set data.recommendedDoc
    updateWithUserRef.child('coiDoc').set data.coiDoc
    updateWithUserRef.child('voterCard').set data.voterCard
    updateWithUserRef.child('casteCertificate').set data.casteCertificate
    updateWithUserRef.child('otherDoc').set data.otherDoc
    updateWithUserRef.child('note').set data.note
    updateWithUserRef.child('applicationDate').set data.applicationDate
    updateWithUserRef.child('respondedDate').set data.respondedDate
    updateWithUserRef.child('status').set data.status
    updateWithUserRef.child('message').set data.message
    updateWithUserRef.child('email').set data.email
    updateWithUserRef.child('submittedUserId').set data.submittedUserId

    updateWithWardRef.child('name').set data.name
    updateWithWardRef.child('fatherName').set data.fatherName
    updateWithWardRef.child('dob').set data.dob
    updateWithWardRef.child('phoneNumber').set data.phoneNumber
    updateWithWardRef.child('address').set data.address
    updateWithWardRef.child('education').set data.education
    updateWithWardRef.child('gpu').set data.gpu
    updateWithWardRef.child('ward').set data.ward
    updateWithWardRef.child('wardId').set data.wardId
    updateWithWardRef.child('constituency').set data.constituency
    updateWithWardRef.child('department').set data.department
    updateWithWardRef.child('grievanceType').set data.grievanceType
    updateWithWardRef.child('scheme').set data.scheme
    updateWithWardRef.child('requirement').set data.requirement
    updateWithWardRef.child('recommendedDoc').set data.recommendedDoc
    updateWithWardRef.child('coiDoc').set data.coiDoc
    updateWithWardRef.child('voterCard').set data.voterCard
    updateWithWardRef.child('casteCertificate').set data.casteCertificate
    updateWithWardRef.child('otherDoc').set data.otherDoc
    updateWithWardRef.child('note').set data.note
    updateWithWardRef.child('applicationDate').set data.applicationDate
    updateWithWardRef.child('respondedDate').set data.respondedDate
    updateWithWardRef.child('status').set data.status
    updateWithWardRef.child('message').set data.message
    updateWithWardRef.child('email').set data.email
    updateWithWardRef.child('submittedUserId').set data.submittedUserId
    return 'true'

  return {
    retrieveGrievance: grievanceByid
    saveGrievance: update
  }

app.controller 'EditGrievanceController', ($scope, EditGrievanceFactory, DataFactory, $rootScope, $window) ->
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

  $scope.UserEmail = localStorage.getItem('email')
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
      referenceNum: $scope.grievance.referenceNum
      name: $scope.grievance.name
      fatherName: $scope.grievance.fatherName
      dob: $scope.grievance.dob
      phoneNumber: $scope.grievance.phoneNumber
      address: $scope.grievance.address
      education: $scope.grievance.education
      gpu: $scope.grievance.gpu
      ward: $scope.grievance.ward
      wardId: $scope.grievance.wardId
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
      submittedUserId: $scope.grievance.submittedUserId
    }
    $scope.$watch(EditGrievanceFactory.saveGrievance(updateRecord), (res) ->
      if res
        $scope.successMessage = true;
    )
