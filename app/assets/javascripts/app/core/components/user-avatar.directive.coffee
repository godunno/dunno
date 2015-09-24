angular.module('app.core')
.directive 'userAvatar', ->
  restrict: 'A'
  scope:
    name: '=userAvatar'
  link: link

link = (scope, element, attr) ->
  name = scope.name
  setAvatar(name, element)

  scope.$watch 'name', (newVal) ->
    if newVal
      setAvatar(newVal, element)

setAvatar = (name, element) ->
  names = name.split(' ')
  initials = []
  for name in names
    initials.push name.substr(0, 1)
  element.initial
    name: initials.join(''),
    charCount: 2,
    fontSize: 42,
    fontWeight: 300,
    fontFamily: 'Lato, sans-serif'
