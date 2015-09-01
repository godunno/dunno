DunnoApp = angular.module('DunnoApp')

LocalStorageWrapper = ->
  set = (key, item) ->
    localStorage.setItem(key, angular.toJson(item))

  remove = (key) ->
    localStorage.removeItem(key)

  get = (key) ->
    angular.fromJson(localStorage.getItem(key))

  {
    set: set
    remove: remove
    get: get
  }

DunnoApp.factory "LocalStorageWrapper", LocalStorageWrapper
