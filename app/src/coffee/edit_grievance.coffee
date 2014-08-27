app.factory 'EditGrievanceFactory', ($firebase, BASEURI) ->
  grievanceByid = {}
  update = (data) ->
    updateRef = new Firebase BASEURI + 'grievances/' + data.id
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
    updateRef.child('file').set data.file
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

app.controller 'EditGrievanceController', ($scope, EditGrievanceFactory, $rootScope) ->
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
  $scope.file = data.file
#  console.log $scope.file
  currentYear = new Date().getFullYear()
  yearofBirth = new Date($scope.grievance.dob).getFullYear()
  $scope.age = currentYear - yearofBirth

  $scope.onFileSelect = ($files) ->
    file = $files[0]
    #    console.log file
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

  $scope.updateGrievance = ->
#    console.log $scope.file
    updateRecord = {
      id: $scope.grievance.id
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
      file: $scope.file
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
    {id: 1, name: ' MELLI DARA PAIYONG'}
  ]
  $scope.wards = [
    {id: 1, name: 'MELLI DARA'}
    {id: 2, name: 'MELLI GUMPA'}
    {id: 3, name: 'UPPER PAIYONG'}
    {id: 4, name: 'LOWER PAIYONG'}
    {id: 5, name: 'KERABARI'}
    {id: 6, name: 'MELLI BAZAAR'}
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
