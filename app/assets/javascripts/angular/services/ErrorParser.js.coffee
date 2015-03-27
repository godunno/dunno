DunnoApp = angular.module('DunnoApp')
DunnoAppStudent = angular.module('DunnoAppStudent')

ErrorParser = ->
  @setErrors = (errors, form, scope)->
    for attribute, attributeErrors of errors
      # Due to Devise controller
      attributeErrors = attributeErrors.map (error)-> error.error || error
      for error in attributeErrors
        form[attribute].$setValidity(error, false)

      scope.$watch (->form[attribute].$viewValue), (oldValue, newValue)->
        if oldValue != newValue
          scope.hasError = false
          for error in attributeErrors
            form[attribute].$setValidity(error, true)

  @

DunnoApp.service 'ErrorParser', ErrorParser
DunnoAppStudent.service 'ErrorParser', ErrorParser
