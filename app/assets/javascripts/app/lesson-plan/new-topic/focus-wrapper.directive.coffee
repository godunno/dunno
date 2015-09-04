link = (scope, element, attrs) ->
  element.on 'focus', ->
    element.parent().addClass('focus-wrapper')

  element.on 'blur', ->
    element.parent().removeClass('focus-wrapper')

focusWrapper = ->
  restricted: 'A'
  link: link

angular
  .module('app.lessonPlan')
  .directive('focusWrapper', focusWrapper)
