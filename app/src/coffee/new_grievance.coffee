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
    addRef.child('sscCertificate').set data.sscCertificate
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
#      alert 'success'
      alert "Message sent to your mobile number"
    )
    .error((status) ->
#      alert status.responseText
      alert "Message sent to your mobile number"
    )

  return {
    addGrievance: add
    retrieveGrievances: grievances
    sendSms: sendSms
  }
]

app.controller 'NewGrievanceController', ($scope, $rootScope, $upload, NewGrievanceFactory, $window) ->
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

  uuid = ->
    CHARS = "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ".split("")
    chars = CHARS
    uuid = new Array(36)
    rnd = 0
    r = undefined
    i = 0
    while i < 36
      if i is 8 or i is 13 or i is 18 or i is 23
        uuid[i] = "-"
      else if i is 14
        uuid[i] = "4"
      else
        rnd = 0x2000000 + (Math.random() * 0x1000000) | 0  if rnd <= 0x02
        r = rnd & 0xf
        rnd = rnd >> 4
        uuid[i] = chars[(if (i is 19) then (r & 0x3) | 0x8 else r)]
      i++
    uuid.join ""

  grievanceReferenceNo = (ward) ->
    date = new Date()
    refID = date.getTime()
    str1 = ward.substring(0, 1).toUpperCase()
    str2 = ward.substring(5, 6).toUpperCase()
    str1 + str2 + refID



  $scope.address = " "
  $scope.note = " "
  $scope.recommendedDoc = ""
  $scope.coiDoc = ""
  $scope.voterCard = ""
  $scope.sscCertificate = ""
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
        $scope.sscCertificate = arrayBufferToBase64 e.target.result
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
##    $.ajax({
##      url: "http://api.mVaayoo.com/mvaayooapi/MessageCompose?user=technorrp@gmail.com:Design_20&senderID=TEST SMS&receipientno=9000991520&msgtxt= final message from chinna by mVaayoo API&state=4",
##      type: 'GET',
##      dataType: 'json',
##      success: () ->
##        alert 'successfully sent'
##      , error: (status) ->
##        alert status.responseText
##    })
#    data =
#      mobile: $scope.grievance.phoneNumber
#      message: $scope.grievance.note
#
#    $scope.$watch(NewGrievanceFactory.sendSms(data), (res) ->
#      if res
#        console.log "sms success"
#    )

  $scope.reportButton = true
  $scope.createGrievance = () ->

    refId = grievanceReferenceNo $scope.grievance.ward

    newGrievance = {
      id: uuid()
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
      sscCertificate: $scope.sscCertificate
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
#        console.log 'added success'
        $scope.error = true;
#        $scope.$watch(NewGrievanceFactory.sendSms(smsData), (status) ->
##          console.log 'return'
#          if status
#            console.log "sms sent to " + smsData.mobile
##            console.log status
#        )
    )


#  $scope.printGrievance = () ->
#    console.log 'printing....'
#    console.log $scope.new_grievance

  $scope.calculateAgeOnDOB = ->
    dob = $scope.grievance.dob
    console.log dob
    date1 = new Date()
    date2 = new Date(dob)
    console.log date2
    if dob
      y1 = date1.getFullYear()
      y2 = date2.getFullYear()
      $scope.grievance.age = y1 - y2 + " years"
      return
    else
      console.log "Invalid Date"

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
