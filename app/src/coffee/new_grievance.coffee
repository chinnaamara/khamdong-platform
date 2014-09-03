app.factory 'NewGrievanceFactory', ['BASEURI', '$firebase', '$http', (BASEURI, $firebase, $http) ->
  getRef = new Firebase BASEURI + 'grievances/'
  grievances = ->
    getRef = new Firebase BASEURI + 'grievances/'
    data = $firebase getRef
    return data

  add = (data) ->
    addRef = new Firebase BASEURI + 'grievances/' + data.referenceNum
    addRef.child('id').set data.id
    addRef.child('referenceNum').set data.referenceNum
    addRef.child('name').set data.name
    addRef.child('fatherName').set data.fatherName
    addRef.child('dob').set data.dob
    addRef.child('phoneNumber').set data.phoneNumber
    addRef.child('address').set data.address
    addRef.child('education').set data.education
    addRef.child('gpu').set data.gpu
    addRef.child('ward').set data.ward
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

  grievanceReferenceNo = (ward) ->
    date = new Date()
    refID = date.getTime()
    str1 = ward.substring(0, 1).toUpperCase()
    str2 = ward.substring(5, 6).toUpperCase()
    str1 + str2 + refID

  uuid = DataFactory.uuid()
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

  $scope.reportButton = true
  $scope.createGrievance = () ->
    refId = grievanceReferenceNo $scope.grievance.ward
    newGrievance = {
      id: uuid
      referenceNum: refId
      name: $scope.grievance.name
      fatherName: $scope.grievance.fatherName
      dob: $scope.grievance.dob
      phoneNumber: $scope.grievance.phoneNumber
      address: $scope.address
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
      note: $scope.note
      applicationDate: new Date().toLocaleString()
      respondedDate: "--/--/----"
      status: "Open"
      message: "Waiting"
      email: $scope.UserEmail
    }
    $scope.new_grievance = newGrievance
    smsData = {
      mobile: $scope.grievance.phoneNumber
      message: "Hi " + $scope.grievance.name + ", your grievance request is registered at Khamdong, by " + $scope.grievance.ward + " ward. Your reference number is " + refId + "."
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
