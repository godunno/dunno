link = (scope, element, attrs, ngModelCtrl) ->
  element.bind 'change', ->
    scope.$apply ->
      ngModelCtrl.$setViewValue(element.val())
      ngModelCtrl.$render()

  scope.$on 'file.clean', -> element.val(null)

ngFileModel = ->
  restrict: 'A'
  require: 'ngModel'
  link: link

angular
  .module('app.lessonPlan')
  .directive('ngFileModel', ngFileModel)
