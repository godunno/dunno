ErrorParser = ->
  toCamelCase = (name) ->
    name.replace /_(\w)/g, (match) -> match[1].toUpperCase()

  @setErrors = (errors, form, scope) ->
    for attribute, attributeErrors of errors
      attribute = toCamelCase(attribute)

      # Due to Devise controller
      attributeErrors = attributeErrors.map (error) -> error.error || error

      setError = (error) ->
        form[attribute].$setValidity(error, false)

      unsetErrors = (oldValue, newValue) ->
        if oldValue != newValue
          scope.hasError = false
          for error in attributeErrors
            form[attribute].$setValidity(error, true)

      attributeErrors.forEach(setError)
      scope.$watch (-> form[attribute].$viewValue), unsetErrors

    scope.$broadcast 'updatedErrors'

  @

angular
  .module('app.core')
  .service('ErrorParser', ErrorParser)
