ErrorParser = ->
  @setErrors = (errors, form, scope) ->
    for attribute, attributeErrors of errors
      # Due to Devise controller
      attributeErrors = attributeErrors.map (error) -> error.error || error
      for error in attributeErrors
        form[attribute].$setValidity(error, false)

      scope.$watch (-> form[attribute].$viewValue), (oldValue, newValue) ->
        if oldValue != newValue
          scope.hasError = false
          for error in attributeErrors
            form[attribute].$setValidity(error, true)

  @

angular
  .module('app.core')
  .service('ErrorParser', ErrorParser)
