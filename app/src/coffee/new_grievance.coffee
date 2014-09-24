app.factory 'NewGrievanceFactory', ['BASEURI', '$firebase', '$http', (BASEURI, $firebase, $http) ->
  getRef = new Firebase BASEURI + 'grievances/'
  grievances = ->
    getRef = new Firebase BASEURI + 'grievances/'
    data = $firebase getRef
    return data

  add = (data) ->
    addRef = new Firebase BASEURI + 'grievances/' + data.referenceNum
    addWithUserRef = new Firebase BASEURI + 'users/' + data.submittedUserId + '/grievances/' + data.referenceNum
    addWithWardRef = new Firebase BASEURI + 'wards/' + data.wardId + '/grievances/' + data.referenceNum
    addRef.child('referenceNum').set data.referenceNum
    addRef.child('name').set data.name
    addRef.child('fatherName').set data.fatherName
    addRef.child('dob').set data.dob
    addRef.child('phoneNumber').set data.phoneNumber
    addRef.child('address').set data.address
    addRef.child('education').set data.education
    addRef.child('gpu').set data.gpu
    addRef.child('ward').set data.ward
    addRef.child('wardId').set data.wardId
    addRef.child('constituency').set data.constituency
    addRef.child('department').set data.department
    addRef.child('scheme').set data.scheme
    addRef.child('requirement').set data.requirement
    addRef.child('grievanceType').set data.grievanceType
    addRef.child('note').set data.note
    addRef.child('recommendedDoc').set data.recommendedDoc
    addRef.child('coiDoc').set data.coiDoc
    addRef.child('voterCard').set data.voterCard
    addRef.child('casteCertificate').set data.casteCertificate
    addRef.child('otherDoc').set data.otherDoc
    addRef.child('applicationDate').set data.applicationDate
    addRef.child('respondedDate').set data.respondedDate
    addRef.child('status').set data.status
    addRef.child('message').set data.message
    addRef.child('email').set data.email
    addRef.child('submittedUserId').set data.submittedUserId

    addWithUserRef.child('referenceNum').set data.referenceNum
    addWithUserRef.child('name').set data.name
    addWithUserRef.child('fatherName').set data.fatherName
    addWithUserRef.child('dob').set data.dob
    addWithUserRef.child('phoneNumber').set data.phoneNumber
    addWithUserRef.child('address').set data.address
    addWithUserRef.child('education').set data.education
    addWithUserRef.child('gpu').set data.gpu
    addWithUserRef.child('ward').set data.ward
    addWithUserRef.child('wardId').set data.wardId
    addWithUserRef.child('constituency').set data.constituency
    addWithUserRef.child('department').set data.department
    addWithUserRef.child('scheme').set data.scheme
    addWithUserRef.child('requirement').set data.requirement
    addWithUserRef.child('grievanceType').set data.grievanceType
    addWithUserRef.child('note').set data.note
    addWithUserRef.child('recommendedDoc').set data.recommendedDoc
    addWithUserRef.child('coiDoc').set data.coiDoc
    addWithUserRef.child('voterCard').set data.voterCard
    addWithUserRef.child('casteCertificate').set data.casteCertificate
    addWithUserRef.child('otherDoc').set data.otherDoc
    addWithUserRef.child('applicationDate').set data.applicationDate
    addWithUserRef.child('respondedDate').set data.respondedDate
    addWithUserRef.child('status').set data.status
    addWithUserRef.child('message').set data.message
    addWithUserRef.child('email').set data.email
    addWithUserRef.child('submittedUserId').set data.submittedUserId

    addWithWardRef.child('referenceNum').set data.referenceNum
    addWithWardRef.child('name').set data.name
    addWithWardRef.child('fatherName').set data.fatherName
    addWithWardRef.child('dob').set data.dob
    addWithWardRef.child('phoneNumber').set data.phoneNumber
    addWithWardRef.child('address').set data.address
    addWithWardRef.child('education').set data.education
    addWithWardRef.child('gpu').set data.gpu
    addWithWardRef.child('ward').set data.ward
    addWithWardRef.child('wardId').set data.wardId
    addWithWardRef.child('constituency').set data.constituency
    addWithWardRef.child('department').set data.department
    addWithWardRef.child('scheme').set data.scheme
    addWithWardRef.child('requirement').set data.requirement
    addWithWardRef.child('grievanceType').set data.grievanceType
    addWithWardRef.child('note').set data.note
    addWithWardRef.child('recommendedDoc').set data.recommendedDoc
    addWithWardRef.child('coiDoc').set data.coiDoc
    addWithWardRef.child('voterCard').set data.voterCard
    addWithWardRef.child('casteCertificate').set data.casteCertificate
    addWithWardRef.child('otherDoc').set data.otherDoc
    addWithWardRef.child('applicationDate').set data.applicationDate
    addWithWardRef.child('respondedDate').set data.respondedDate
    addWithWardRef.child('status').set data.status
    addWithWardRef.child('message').set data.message
    addWithWardRef.child('email').set data.email
    addWithWardRef.child('submittedUserId').set data.submittedUserId

    return 'true'

  sendSms = (data) ->
    $http
#    .post('https://api.mVaayoo.com/mvaayooapi/MessageCompose?user=technorrp@gmail.com:Design_20&senderID=TEST SMS&receipientno=' + data.mobile + '&msgtxt= ' + data.message + ' API&state=4')
    .post('http://api.mVaayoo.com/mvaayooapi/MessageCompose?user=Dilip@cannybee.in:8686993306&senderID=TEST SMS&receipientno=' + data.mobile + '&msgtxt= ' + data.message + ' &state=4')
    .success((data, status, headers, config) ->
#      alert "Message sent success to your mobile number"
    )
    .error((status) ->
#      alert status.responseText
#      alert "Message sent to your mobile number"
    )

  return {
    addGrievance: add
    retrieveGrievances: grievances
    sendSms: sendSms
  }
]

app.controller 'NewGrievanceController', ($scope, $rootScope, $upload, NewGrievanceFactory, DataFactory, $window) ->
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

  $scope.userId = localStorage.getItem("userId")
  $scope.ward = localStorage.getItem('ward')
  $scope.UserEmail = localStorage.getItem('email')
  $scope.education = DataFactory.education
  $scope.constituencies = DataFactory.constituencies
  $scope.gpus = DataFactory.gpus
  $scope.wards = DataFactory.wards
  $scope.grievanceTypes = DataFactory.grievanceTypes
  $scope.departments = DataFactory.departments
  $scope.schemes = DataFactory.schemes

  grievanceReferenceNo = (ward) ->
    date = new Date()
    refID = date.getTime()
    str1 = ward.substring(0, 1).toUpperCase()
    str2 = ward.substring(6, 7).toUpperCase()
    str1 + str2 + refID

#  uuid = DataFactory.uuid()
  $scope.address = " "
  $scope.note = " "
  $scope.recommendedDoc = ""
  $scope.coiDoc = ""
  $scope.voterCard = ""
  $scope.casteCertificate = ""
  $scope.otherDoc = ""

  $scope.onFileSelect = ($files, fileName) ->
    file = $files[0]
    console.log file.name
    console.log file.type
    console.log file.size
    if file.size <= 1024 * 1024 * 2
      reader = new FileReader()
      reader.readAsArrayBuffer file
      reader.onload = (e) ->
        if fileName == 'recommended'
          $scope.recommendedDoc = arrayBufferToBase64 e.target.result
        else if fileName == 'coi'
          $scope.coiDoc = arrayBufferToBase64 e.target.result
  #      else if fileName == 'aadhar'
  #        $scope.aadharCard = arrayBufferToBase64 e.target.result
        else if fileName == 'voter'
          $scope.voterCard = arrayBufferToBase64 e.target.result
        else if fileName == 'caste'
          $scope.casteCertificate = arrayBufferToBase64 e.target.result
        else
          $scope.otherDoc = arrayBufferToBase64 e.target.result
        #      $scope.file = btoa(String.fromCharCode.apply(null, new Uint8Array(file.target.result)))
        return
    else
      console.log "Invalid file"
      $files.name = ''
    return

  arrayBufferToBase64 = (arrayBuffer) ->
     binary = ''
     bytes = new Uint8Array arrayBuffer
     _.forEach(_.range(bytes.length),(e) ->
       binary += String.fromCharCode bytes[e]
      )
     btoa binary

#  $scope.sendSms = () ->
#    $.ajax({
#      url: "http://api.mVaayoo.com/mvaayooapi/MessageCompose?user=technorrp@gmail.com:Design_20&senderID=TEST SMS&receipientno=9000991520&msgtxt= final message from chinna by mVaayoo API&state=4",
#      type: 'GET',
#      dataType: 'json',
#      success: () ->
#        alert 'successfully sent'
#      , error: (status) ->
#        alert status.responseText
#    })

  trimWard = (ward) ->
    ward.replace(RegExp(" +", "g"), "")
  $scope.reportButton = true
  $scope.createGrievance = () ->
    refId = grievanceReferenceNo $scope.ward
    newGrievance = {
#      id: uuid
      referenceNum: refId
      name: $scope.grievance.name
      fatherName: $scope.grievance.fatherName
      dob: $scope.grievance.dob
      phoneNumber: $scope.grievance.phoneNumber
      address: $scope.address
      education: $scope.grievance.education
      gpu: $scope.grievance.gpu
      ward: $scope.ward
      wardId: trimWard $scope.ward.toLowerCase()
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
      note: $scope.note
      applicationDate: new Date().toLocaleString()
      respondedDate: "--/--/----"
      status: "Open"
      message: "Waiting"
      email: $scope.UserEmail
      submittedUserId: $scope.userId
    }
    $scope.new_grievance = newGrievance
    smsData = {
      mobile: $scope.grievance.phoneNumber
      message: "Hi " + $scope.grievance.name + ", your grievance request is registered at Khamdong, by " + $scope.ward + " ward. Your reference number is " + refId + "."
    }

    $scope.$watch(NewGrievanceFactory.addGrievance(newGrievance), (res) ->
      if res
        $scope.reportButton = false
        $scope.successMessage = true;
        $scope.$watch(NewGrievanceFactory.sendSms(smsData), (status) ->
          if status
            console.log "sms sent to " + smsData.mobile
        )
    )

  $scope.calculateAgeOnDOB = () ->
    dob = $scope.grievance.dob
    date1 = new Date()
    date2 = new Date(dob)
    if dob
      y1 = date1.getFullYear()
      y2 = date2.getFullYear()
      $scope.grievance.age = y1 - y2 + " years"
      return
    else
      $scope.grievance.age = "Invalid Date"

  $scope.printPdf = ->
    printElement(document.getElementById 'printThis')
    window.print()

  printElement = (elem) ->
    domClone = elem.cloneNode true
    $printSection = document.getElementById 'printSection'
    unless $printSection
      $printSection = document.createElement 'div'
      $printSection.id = 'printSection'
      document.body.appendChild $printSection
    $printSection.innerHTML = ''
    $printSection.appendChild domClone
    return

  $scope.notRecommended = true
  $scope.checkboxEvent = (val) ->
    if val == true
      $scope.notRecommended = false
    else
      $scope.notRecommended = true

  $(".date").datepicker autoclose: true
#  $(".date").datepicker({
#    viewMode: 'years'
#    format: 'dd/mm/yyyy'
#    autoclose: true
#  })
