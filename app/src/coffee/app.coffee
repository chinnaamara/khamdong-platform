app = angular.module 'PTS', ['ui.router', 'firebase', 'angularFileUpload']
app.constant 'BASEURI', 'https://pts.firebaseio.com/'
app.constant 'AUTH_EVENTS', {
  loginSuccess: 'auth-login-success'
  loginFailed: 'auth-login-failed'
  logoutSuccess: 'auth-logout-success'
  sessionTimeout: 'auth-session-timeout'
  notAuthenticated: 'auth-not-authenticated'
  notAutherized: 'auth-not-autherized'
}
app.constant 'USER_ROLES', {
  all: '*'
  admin: 'admin'
  editor: 'editor'
  guest: 'guest'
}
app.config(($stateProvider) ->
  $stateProvider
  .state('login', {
      url: ''
      views: {
        'viewA@': {templateUrl: 'html/nav.html'}
        'viewB@': {templateUrl: 'html/login.html', controller: 'LoginController'}
      }
    })
  .state('newGrievance', {
      url: '/new/grievance'
      views: {
        'viewA@': {templateUrl: 'html/nav.html'}
        'viewB@': {templateUrl: 'html/new_grievance.html', controller: 'NewGrievanceController'}
      }
    })
  .state('admin', {
      url: '/admin'
      views: {
        'viewA@': {templateUrl: 'html/nav.html'}
        'viewB@': {templateUrl: 'html/dashboard.html', controller: 'DashboardController'}
      }
    })
  .state('details', {
      url: '/details'
      views: {
        'viewA@': {templateUrl: 'html/nav.html'}
        'viewB@': {templateUrl: 'html/details.html', controller: 'DetailsController'}
      }
    })
  .state('newDepartment', {
      url: '/new_department'
      views: {
        'viewA@': {templateUrl: 'html/nav.html'}
        'viewB@': {templateUrl: 'html/new_department.html', controller: 'AddDepartmentController'}
      }
    })
  .state('newScheme', {
      url: '/new_scheme'
      views: {
        'viewA@': {templateUrl: 'html/nav.html'}
        'viewB@': {templateUrl: 'html/new_scheme.html', controller: 'AddSchemeController'}
      }
    })
  .state('createUser', {
      url: '/new_user'
      views: {
        'viewA@': {templateUrl: 'html/nav.html'}
        'viewB@': {templateUrl: 'html/create_user.html', controller: 'CreateUserController'}
      }
    })
  .state('userDashboard', {
      url: '/user/grievances'
      views: {
        'viewA@': {templateUrl: 'html/nav.html'}
        'viewB@': {templateUrl: 'html/user_grievances.html', controller: 'GrievancesController'}
      }
    })
)
