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
    addRef.child('file').set data.file
    addRef.child('applicationDate').set data.applicationDate
    addRef.child('respondedDate').set data.respondedDate
    addRef.child('status').set data.status
    addRef.child('message').set data.message
    return 'true'
  sendSms = (data) ->
    console.log 'sending'
    $http
    .post('https://api.mVaayoo.com/mvaayooapi/MessageCompose?user=technorrp@gmail.com:Design_20&senderID=TEST SMS&receipientno=' + data.mobile + '&msgtxt= ' + data.message + ' API&state=4')
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

app.controller 'NewGrievanceController', ($scope, $upload, NewGrievanceFactory) ->
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

#  id = uuid()
#  console.log id
  $scope.address = " "
  $scope.note = " "
  $scope.file = " "
  $scope.onFileSelect = ($files) ->
    file = $files[0]
    console.log file
    reader=new FileReader()
    reader.readAsArrayBuffer(file)
    reader.onload=(e)->
#      $scope.file=btoa(String.fromCharCode.apply(null, new Uint8Array(file.target.result)))
      $scope.file = arrayBufferToBase64 e.target.result
      return
    return

  arrayBufferToBase64 = (arrayBuffer) ->
     binary = ''
     bytes = new Uint8Array arrayBuffer
     _.forEach(_.range(bytes.length),(e) ->
       binary += String.fromCharCode bytes[e]
      )
     window.btoa binary
#  $scope.sendSms = () ->
#    console.log $scope.grievance.phoneNumber
#    console.log $scope.grievance.note
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
#      console.log 'return'
#      if res
#        console.log "sms success"
#        console.log res
#    )

  $scope.reportButton = true
  $scope.createGrievance = () ->
    newGrievance = {
      id: uuid()
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
      file: $scope.file
      note: $scope.note
      applicationDate: new Date().toLocaleString()
      respondedDate: "--/--/----"
      status: "Open"
      message: "Waiting"
    }

    smsData = {
      mobile: $scope.grievance.phoneNumber
      message: "Dear " + $scope.grievance.name + " your req for " +  $scope.grievance.requirement + " is registered."
    }

    $scope.$watch(NewGrievanceFactory.addGrievance(newGrievance), (res) ->
      if res
        $scope.reportButton = false
        console.log 'added success'
        $scope.error = true;
        $scope.$watch(NewGrievanceFactory.sendSms(smsData), (status) ->
          console.log 'return'
          if status
            console.log "sms success"
            console.log status
        )
    )


  $scope.printGrievance = ->
    console.log 'printing....'

  $scope.calculateAgeOnDOB = ->
    dob = $scope.grievance.dob
    date1 = new Date()
    date2 = new Date($scope.grievance.dob)
    if dob
      y1 = date1.getFullYear()
      y2 = date2.getFullYear()
      $scope.grievance.age = y1 - y2 + " years"
      return
    else
      console.log "Invalid Date"

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
    {id: 1, name: 'GPU 1'}
    {id: 2, name: 'GPU 2'}
    {id: 3, name: 'GPU 3'}
    {id: 4, name: 'GPU 4'}
  ]
  $scope.wards = [
    {id: 1, name: 'Ward 1'}
    {id: 2, name: 'Ward 2'}
    {id: 3, name: 'Ward 3'}
    {id: 4, name: 'Ward 4'}
  ]
  $scope.grievanceTypes = [
    {id: 1, name: 'Grievance Type 1'}
    {id: 2, name: 'Grievance Type 2'}
    {id: 3, name: 'Grievance Type 3'}
    {id: 4, name: 'Grievance Type 4'}
  ]
  $scope.departments = [
    {id: 1, name: 'Department 1'}
    {id: 2, name: 'Department 2'}
    {id: 3, name: 'Department 3'}
    {id: 4, name: 'Department 4'}
  ]
  $scope.schemes = [
    {id: 1, name: 'Scheme 1'}
    {id: 2, name: 'Scheme 2'}
    {id: 3, name: 'Scheme 3'}
    {id: 4, name: 'Scheme 4'}
  ]

