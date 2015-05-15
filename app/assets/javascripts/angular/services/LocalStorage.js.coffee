DunnoApp = angular.module('DunnoApp')
DunnoAppStudent = angular.module('DunnoAppStudent')

LocalStorage = ->
  set: (key, item) ->
    localStorage.setItem(key, angular.toJson(item))

  remove: (key) ->
    localStorage.remove(key)

  get: (key) ->
    angular.fromJson(localStorage.getItem(key))

  {
    set: set
    remove: remove
    get: get
  }

DunnoApp.factory "LocalStorage", LocalStorage
DunnoAppStudent.factory "LocalStorage", LocalStorage
