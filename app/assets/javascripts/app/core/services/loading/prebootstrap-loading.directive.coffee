prebootstrapLoading = ->
  restrict: 'A'
  link: (scope, element, attrs) ->
    element.fadeOut(500, element.remove)

angular
  .module('app.core')
  .directive('prebootstrapLoading', prebootstrapLoading)
