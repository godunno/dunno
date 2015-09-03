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

angular
  .module('app.core')
  .factory('LocalStorageWrapper', LocalStorageWrapper)
