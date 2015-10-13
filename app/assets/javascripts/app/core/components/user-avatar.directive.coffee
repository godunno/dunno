angular.module('app.core')
.directive 'userAvatar', ->
  restrict: 'A'
  scope:
    user: '=userAvatar'
  link: link

link = (scope, element, attrs) ->
  if scope.user
    setAvatar(scope.user, element, attrs)

  scope.$watch (-> scope.user), (updatedUser, oldUser) ->
    if updatedUser
      setAvatar(updatedUser, element, attrs)

setAvatar = (user, element, attrs) ->
  setNameAvatar(user.name, element)
  if user.avatar_url
    setPhotoAvatar(user.avatar_url, attrs)

setNameAvatar = (name, element) ->
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

setPhotoAvatar = (url, attrs) ->
  attrs.$set('src', url)

