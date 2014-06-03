DunnoApp = angular.module('DunnoApp')
DunnoApp.service 'Utils', ->
  @remove = (list, item)->
    index = list.indexOf(item)
    if index > -1
      list.splice(index, 1)
  @newItem = (list)-> list.push({})
  @
