app = angular.module 'odata', [
  'ngResource'
  'ngRoute'
  'codefabriek.odata'
  'ngTouch'
  'ui.grid'
  'ui.grid.pagination'
]

app.config ['$httpProvider', '$odataProvider', ($httpProvider, $odataProvider) ->
  $odataProvider.routePrefix '/odata/'
  $httpProvider.interceptors.push 'odataInterceptor'
]
app.config ['$routeProvider', ($routeProvider)->
  $routeProvider
  .when '/list',
    templateUrl: '/partials/number_list'
    controller: 'NumberListController'
  .when '/list2',
    templateUrl: 'partials/number_list2'
    controller: 'NumberList2Controller'
  .when '/create',
    templateUrl: '/partials/number_create'
    controller: 'NumberCreateController'
  .when '/view/:numberId',
    templateUrl: '/partials/number_view',
    controller: 'NumberViewController'
  .otherwise
      redirectTo: '/list'
]

app.factory 'Number', ['$resource', ($resource) ->
  $resource '/odata/numbers/:id',
    id: '@_id'
  ,
    query:
      method: 'GET'
      isArray: false
      headers:
        Accept: "application/json; odata=verbose"
]

app.controller 'NumberListController', [
  'Number'
  '$scope'
  (Number, $scope)->
    $scope.numbers = []
    refreshNumbers = ()->
      Number.query
        $select: 'id,title,number'
      , (response)->
        $scope.numbers = response.value
    refreshNumbers()

    $scope.delete = (index)->
      Number.delete id: $scope.numbers[index].id
      , ()->
        refreshNumbers()
]

app.controller 'NumberList2Controller', [
  'Number'
  '$scope'
  (Number, $scope)->
    $scope.numbers = []
    $scope.gridOptions =
      paginationPageSize: 2
      columnDefs: [
        {name: 'Название', field: 'title'}
        {name: 'Номер', field: 'number'}
        {name: '#', field: 'id', cellTemplate: '<a class="btn btn-default" href="#/view/{{COL_FIELD}}">Просмотр</a>'}
        {name: '%', field: 'id', cellTemplate: '<a class="btn btn-danger">Удалить</a>'}
      ]

    refreshNumbers = ()->
      Number.query
        $select: 'id,title,number'
      , (response)->
        $scope.numbers = response.value
        $scope.gridOptions.data = response.value
    refreshNumbers()
]
app.controller 'NumberCreateController', [
  'Number'
  '$location'
  '$scope'
  (Number, $location, $scope)->
    $scope.number = new Number()
    $scope.save = ()->
      $scope.number.$save ()->
        $location.path '/list'
]
app.controller 'NumberViewController', [
  'Number'
  '$scope'
  '$routeParams'
  (Number, $scope, $routeParams)->
    $scope.number = Number.get id: $routeParams.numberId
]