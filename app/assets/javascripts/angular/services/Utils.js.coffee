DunnoApp = angular.module('DunnoApp')
DunnoApp.service 'Utils', ->
  @remove = (list, item)->
    index = list.indexOf(item)
    if index > -1
      list.splice(index, 1)

  @destroy = (item)->
    item._destroy = true

  @newItem = (list, item)->
    item ?= {}
    list.push(item)

  @
