app = angular.module 'PTS', ['ui.router', 'firebase', 'angularFileUpload']
app.constant 'BASEURI', 'https://pts.firebaseio.com/'
#app.config(($stateProvider, $uploadProvidor)->
app.config(($stateProvider)->
  $stateProvider
    .state('login', {
      url: ''
      views: {
        'viewA@': {templateUrl: 'html/nav.html'}
        'viewB@': {templateUrl: 'html/login.html', controller: 'LoginController'}
      }
    })
    .state('newGrievance', {
      url: 'new/grievance'
      views: {
        'viewA@': {templateUrl: 'html/nav.html'}
        'viewB@': {templateUrl: 'html/new_grievance.html', controller: 'NewGrievanceController'}
      }
    })
)