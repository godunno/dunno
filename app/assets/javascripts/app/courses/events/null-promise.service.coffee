NullPromise = ->
  nullPromise = ->
    @then     = -> @
    @catch    = -> @
    @notify   = -> @
    @progress = -> @
    @abort    = -> @

    @

angular
  .module('app.courses')
  .factory('NullPromise', NullPromise)
