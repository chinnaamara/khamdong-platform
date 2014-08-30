app.factory 'NewGrievanceFactory', ['BASEURI', '$firebase', '$http', (BASEURI, $firebase, $http) ->
  getRef = new Firebase BASEURI + 'grievances/'
  grievances = ->
    getRef = new Firebase BASEURI + 'grievances/'
    data = $firebase getRef
    console.log data
    return data

  add = (data) ->
    addRef = new Firebase BASEURI + 'grievances/' + data.id
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
    addRef.child('aadharCard').set data.aadharCard
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
    console.log 'sending'
    $http
#    .post('https://api.mVaayoo.com/mvaayooapi/MessageCompose?user=technorrp@gmail.com:Design_20&senderID=TEST SMS&receipientno=' + data.mobile + '&msgtxt= ' + data.message + ' API&state=4')
    .post('http://api.mVaayoo.com/mvaayooapi/MessageCompose?user=Dilip@cannybee.in:8686993306&senderID=TEST SMS&receipientno=' + data.mobile + '&msgtxt= ' + data.message + ' &state=4')
#    .post('http://api.mVaayoo.com/mvaayooapi/MessageCompose?user=technorrp@gmail.com:Design_20&senderID=TEST SMS&receipientno=9000991520&msgtxt= message at 11:18am from chinna by mVaayoo API&state=4')
    .success((data, status, headers, config) ->
      alert 'success'
    )
    .error((status) ->
      alert status.responseText
    )

  return {
    addGrievance: add
    retrieveGrievances: grievances
    sendSms: sendSms
  }
]

app.controller 'NewGrievanceController', ($scope, $rootScope, $upload, NewGrievanceFactory) ->
  $scope.UserEmail = ''
  localData = localStorage.getItem('userEmail')
  #  $rootScope.userName = localData['email']
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
    CHARS = "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ".split("")
    chars = CHARS
    refId = new Array(8)
    rand = 0
    r = undefined
    i = 0

    while i < 8
      rand = 0x2000000 + (Math.random() * 0x1000000) | 0  if rand <= 0x02
      r = rand & 0xf
      rand = rand >> 4
      refId[i] = chars[(if (i is 19) then (r & 0x3) | 0x8 else r)]
      i++
    refNum = refId.join ""
    str1 = ward.substring(0, 2).toUpperCase()
    str2 = ward.substring(5, 7).toUpperCase()
    str1 + str2 + refNum



  $scope.address = " "
  $scope.note = " "
  $scope.recommendedDoc = " "
  $scope.aadharCard = " "
  $scope.voterCard = " "
  $scope.sscCertificate = " "
  $scope.otherDoc = " "
  $scope.onFileSelect = ($files, fileName) ->
    file = $files[0]
    reader = new FileReader()
    reader.readAsArrayBuffer file
    reader.onload = (e) ->
      if fileName == 'recommended'
        $scope.recommendedDoc = arrayBufferToBase64 e.target.result
      else if fileName == 'aadhar'
        $scope.aadharCard = arrayBufferToBase64 e.target.result
      else if fileName == 'voter'
        $scope.voterCard = arrayBufferToBase64 e.target.result
      else if fileName == 'ssc'
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
      aadharCard: $scope.aadharCard
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
      message: "Hi " + $scope.grievance.name + ", your grievance request is registered with Khamdong. Your reference number is " + refId + "."
    }

    $scope.$watch(NewGrievanceFactory.addGrievance(newGrievance), (res) ->
      if res
        $scope.reportButton = false
#        console.log 'added success'
        $scope.error = true;
        $scope.$watch(NewGrievanceFactory.sendSms(smsData), (status) ->
#          console.log 'return'
          if status
            console.log "sms sent to " + smsData.mobile
#            console.log status
        )
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
    {id: 1, name: ' MELLI DARA PAIYONG'}
  ]
  $scope.wards = [
    {id: 1, name: 'MELLIDARA'}
    {id: 2, name: 'MELLIGUMPA'}
    {id: 3, name: 'UPPERPAIYONG'}
    {id: 4, name: 'LOWERPAIYONG'}
    {id: 5, name: 'KERABARI'}
    {id: 6, name: 'MELLIBAZAAR'}
  ]
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
