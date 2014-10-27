DunnoApp = angular.module('DunnoApp')

DunnoApp.service 'Dropdown', ->
  @close = (e)-> Foundation.libs.dropdown.close(e)
  @
