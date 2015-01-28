DunnoApp = angular.module('DunnoApp')

DunnoApp.service 'ErrorParser', ->
  @setErrors = (errors, form)->
    for attribute, attributeErrors of errors
      for error in attributeErrors
        form[attribute].$setValidity(error, false)

  @
