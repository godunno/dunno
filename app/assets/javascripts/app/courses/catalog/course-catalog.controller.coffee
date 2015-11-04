CourseCatalogCtrl = ($scope, MediaSearcher) ->
  MediaSearcher.extend($scope)
  $scope.fetch()

CourseCatalogCtrl.$inject = ['$scope', 'MediaSearcher']

angular
  .module('app.courses')
  .controller('CourseCatalogCtrl', CourseCatalogCtrl)
