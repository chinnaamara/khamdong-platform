app = angular.module 'PTS', ['ui.router', 'firebase']
app.constant 'BASEURI', 'https://pts.firebaseio.com/'
app.config(($stateProvider)->
  $stateProvider
    .state("login", {
      url: ""
      views: {
        'viewA@': {templateUrl: "html/nav.html"}
        'viewB@': {templateUrl: "html/login.html", controller:"LoginController"}
      }
    })
)