courseCard = ->
  templateUrl: 'core/components/course-card.directive'
  restrict: 'E'

angular
  .module('app.core')
  .directive('courseCard', courseCard)
