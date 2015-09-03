# Avoiding recursive compilation using the following method:
# http://stackoverflow.com/a/19228302/2908285
ifTeacher = ($compile) ->
  link = (scope, element, attrs) ->
    element.removeAttr('if-teacher')
    element.attr('ng-if', "course.user_role == 'teacher'")
    $compile(element)(scope)

  restrict: 'A'
  link: link
  terminal: true
  priority: 9999

ifTeacher.$inject = ['$compile']

angular
  .module('DunnoApp')
  .directive('ifTeacher', ifTeacher)
