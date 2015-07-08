angular.module('DunnoApp')
.directive 'userAvatar', ->
  restrict: 'A'
  link: link

link = (scope, element, attr) ->
  names = attr.userAvatar.split(' ')
  initials = []
  for name in names
    initials.push name.substr(0, 1)
  element.initial(name: initials.join(''), charCount: 2)
