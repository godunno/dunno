EventsIndexCtrl = ($scope, $stateParams, events, DateUtils)->
  angular.extend($scope, DateUtils)
  $scope.events = events

EventsIndexCtrl.$inject = ['$scope', '$stateParams', 'events', 'DateUtils']

angular
  .module('app.agenda')
  .controller('EventsIndexCtrl', EventsIndexCtrl)
