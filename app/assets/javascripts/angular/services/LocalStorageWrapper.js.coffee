DunnoApp = angular.module('DunnoApp')
DunnoAppStudent = angular.module('DunnoAppStudent')

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
DunnoAppStudent.factory "LocalStorageWrapper", LocalStorageWrapper
