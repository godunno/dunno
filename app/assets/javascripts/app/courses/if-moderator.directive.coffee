# Avoid overriding ng-if using the following method:
# http://stackoverflow.com/a/29010910/2908285
ifModerator = (ngIfDirective) ->
  ngIf = ngIfDirective[0]

  link = (scope, element, attrs) ->
    isModerator = ->
      scope.course.user_role == 'teacher' ||
        scope.course.user_role == 'moderator'
    composeNgIf(isModerator, arguments...)

  composeNgIf = (predicate, scope, element, attrs, rest...) ->
    initialNgIf = attrs.ngIf
    ifEvaluator = predicate
    ifEvaluator = (-> scope.$eval(initialNgIf) && predicate()) if initialNgIf

    attrs.ngIf = ifEvaluator
    ngIf.link.call(ngIf, scope, element, attrs, rest...)

  link: link
  transclude: ngIf.transclude
  priority: ngIf.priority - 1
  terminal: ngIf.terminal
  restrict: ngIf.restrict

ifModerator.$inject = ['ngIfDirective']

angular
  .module('app.courses')
  .directive('ifModerator', ifModerator)
