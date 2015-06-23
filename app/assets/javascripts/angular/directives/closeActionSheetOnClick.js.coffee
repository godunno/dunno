DunnoApp = angular.module('DunnoApp')

DunnoApp.directive 'closeActionSheetOnClick', ->
  require: '^zfActionSheet'
  restrict: 'A'
  link: (scope, element, attrs, actionSheet)->
    element.find('a').click -> actionSheet.hide()
