app.lessonPlan = angular.module('app.lessonPlan')

app.lessonPlan.directive 'ngFileModel', ->
  restrict: 'A'
  require:'ngModel'
  link: (scope, element, attrs, ngModelCtrl)->
    element.bind 'change', ->
      scope.$apply ->
        ngModelCtrl.$setViewValue(element.val())
        ngModelCtrl.$render()

    scope.$on 'file.clean', -> element.val(null)
