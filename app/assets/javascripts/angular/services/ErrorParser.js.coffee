DunnoApp = angular.module('DunnoApp')
DunnoAppStudent = angular.module('DunnoAppStudent')

ErrorParser = ->
  @setErrors = (errors, form, scope)->
    for attribute, attributeErrors of errors
      for error in attributeErrors
        form[attribute].$setValidity(error, false)
        scope.$watch (->form[attribute].$viewValue), (oldValue, newValue)->
          form[attribute].$setValidity(error, true) if oldValue != newValue

  @

DunnoApp.service 'ErrorParser', ErrorParser
DunnoAppStudent.service 'ErrorParser', ErrorParser
