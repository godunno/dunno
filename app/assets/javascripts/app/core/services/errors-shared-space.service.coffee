ErrorsRepository = ->
  space = {}

  setErrorsFor = (translationKey, errors) ->
    space[translationKey] = errors

  getErrorsFor = (translationKey) ->
    space[translationKey]

  setErrorsFor: setErrorsFor
  getErrorsFor: getErrorsFor

angular
  .module('app.core')
  .factory('ErrorsRepository', ErrorsRepository)
