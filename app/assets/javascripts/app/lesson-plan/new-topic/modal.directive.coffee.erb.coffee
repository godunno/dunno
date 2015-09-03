app.lessonPlan = angular.module('app.lessonPlan')

app.lessonPlan.directive 'modal', ->
  restrict: 'A'
  link: (scope, element, attr)->
    scope.dismiss = ->
      element.foundation('reveal', 'close')
      true
    scope.$on("modal.dismiss", scope.dismiss)
