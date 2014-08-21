app.factory 'GrievancesFactory', ($firebase, BASEURI) ->
  grievancesRef = new Firebase BASEURI + 'grievances'
  grievances = $firebase grievancesRef

  return {
    retrieveGrievances: grievances
  }

app.controller 'GrievancesController', ($scope, GrievancesFactory) ->
  $scope.grievances = GrievancesFactory.retrieveGrievances
  $scope.predicate = '-respondedDate'

  $scope.showDetails = (data) ->
    $scope.grievance = data
#    console.log data
    return

  $scope.viewPdf = ->
#    console.log 'From PdfFunction.........' +$scope.grievance
    $scope.printElement(document.getElementById("printThis"));
    modThis = document.querySelector("#printSection .modifyMe");
#    modThis.appendChild(document.createTextNode(" new"));
    window.print();

  $scope.printElement = (elem) ->
#    console.log 'from printElement function' + elem
    domClone = elem.cloneNode(true)
    $printSection = document.getElementById("printSection")
    unless $printSection
      $printSection = document.createElement("div")
      $printSection.id = "printSection"
      document.body.appendChild $printSection
    $printSection.innerHTML = ""
    $printSection.appendChild domClone
    return
