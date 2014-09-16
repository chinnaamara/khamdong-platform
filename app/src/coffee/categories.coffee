app.factory 'CategoriesFactory', ($firebase, BASEURI) ->

  categoriesRef = new Firebase BASEURI + 'categories/'

  getCategories = (count, callback) ->
    categoriesRef.startAt().limit(count).on('value', (res) ->
      callback _.values res.val()
    )

  pageNext = (id, noOfRecords, cb) ->
    categoriesRef.startAt(null, id).limit(noOfRecords).once('value', (snapshot) ->
      cb _.values snapshot.val()
    )

  pageBack = (id, noOfRecords, cb) ->
    categoriesRef.endAt(null, id).limit(noOfRecords).once('value', (snapshot) ->
      cb _.values snapshot.val()
    )

  createCategory = (category) ->
    addRef = new Firebase BASEURI + 'categories/' + category.categoryId
    addRef.child('id').set category.categoryId
    addRef.child('name').set category.categoryName
    addRef.child('createdDate').set category.createdDate
    addRef.child('updatedDate').set category.updatedDate
    return 'true'

  deleteCategory = (id) ->
    deleteRef = categoriesRef.child(id)
    deleteRef.remove()
    return 'true'

  return {
    getCategories: getCategories
    pageNext: pageNext
    pageBack: pageBack
    createCategory: createCategory
    delete: deleteCategory
  }

app.controller 'CategoriesController', ($scope, $rootScope, CategoriesFactory, $window) ->
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

  $scope.pageNumber = 0
  $scope.lastPageNumber = null
  bottomRecord = null
  $scope.noPrevious = true
  recordsPerPage = 10
  $scope.categories = []

  CategoriesFactory.getCategories(recordsPerPage, (res) ->
    $scope.categories = res
    bottomRecord = $scope.categories[$scope.categories.length - 1]
    if bottomRecord
      $scope.noNext = true
      CategoriesFactory.pageNext(bottomRecord.id, recordsPerPage + 1, (res) ->
        $scope.noNext = true
        if res
          $scope.noNext = res.length <= 1

      )
    else
      $scope.noNext = true
    return
  )

  $scope.pageNext = ->
    $scope.pageNumber++
    $scope.noPrevious = false
    bottomRecord = $scope.categories[$scope.categories.length - 1]
    CategoriesFactory.pageNext(bottomRecord.id, recordsPerPage + 1, (res) ->
      if res
        console.log 'replied...'
        console.log res
        res.shift()
        $scope.categories = res
        console.log $scope.categories
        bottomRecord = $scope.categories[$scope.categories.length - 1]
    )
    CategoriesFactory.pageNext(bottomRecord.id, recordsPerPage + 1, (res) ->
      if res
        $scope.noNext = res.length <= 1
    )

  $scope.pageBack = ->
    $scope.pageNumber--
    console.log $scope.pageNumber
    $scope.noNext = false
    topRecord = $scope.categories[0]
    console.log topRecord
    console.log topRecord.id
#    CategoriesFactory.pageBack(topRecord.id, recordsPerPage + 1, (res) ->
#      if res
#        res.pop()
#        $scope.categories = res
#        $scope.noPrevious = $scope.pageNumber is 0
#    )
    return

  catId = (cat) ->
    date = new Date()
    refID = date.getTime()
    str1 = cat.substring(0, 2).toUpperCase()
    refID + str1

  $scope.btnAdd = ->
    $scope.modelTitle = 'Add New Category'
    $scope.categoryName = ''
    $scope.buttonText = 'Add'

  $scope.addNewCategory = ->
    if $scope.buttonText == 'Add'
      category =
        categoryId: catId($scope.categoryName)
        categoryName: $scope.categoryName
        createdDate: new Date().toLocaleString()
        updatedDate: new Date().toLocaleString()
    else
      category =
        categoryId: $scope.categoryById.categoryId
        categoryName: $scope.categoryName
        createdDate: $scope.categoryById.createdDate
        updatedDate: new Date().toLocaleString()

    $scope.$watch(CategoriesFactory.createCategory(category), (res) ->
      if res
        console.log 'category added'
      else
        console.log 'category not added'
    )

    $scope.categoryName = ''

  $scope.categoryById = {}
  $scope.editCategory = (cat) ->
    console.log cat
    $scope.modelTitle = 'Edit Category'
    $scope.buttonText = 'Update'
    $scope.categoryById.categoryId = cat.id
    $scope.categoryName = cat.name
    $scope.categoryById.createdDate = cat.createdDate

  $scope.deleteCategory = (cat) ->
    $scope.$watch(CategoriesFactory.delete(cat.id), (res) ->
      if res
        console.log 'deleted success'
      else
        console.log 'not deleted'
    )
