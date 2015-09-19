validate = ($compile, ErrorsRepository) ->
  class Validate
    constructor: (scope, element, ngModelCtrl) ->
      throw new Error("Input must have a name.") unless element.attr('name')?

      form = $(element[0].form)
      throw new Error("Input must belong to a form.") unless form.length == 1
      throw new Error("Form must have a name.") unless form.attr('name')?

      @scope = scope
      @element = element
      @ngModelCtrl = ngModelCtrl

      @translationKey = "#{form.attr('name')}.#{element.attr('name')}"
      @setErrors([])

      @scope.$watch (=> @modelErrors().join()), @removeErrorsOnTyping
      @element.on 'blur', @setInvalidErrors
      form.on 'submit', @setAllErrors

    setErrors: (errors) =>
      ErrorsRepository.setErrorsFor(@translationKey, errors)

    getErrors: =>
      ErrorsRepository.getErrorsFor(@translationKey)

    setAllErrors: =>
      @setErrors(@modelErrors())
      @scope.$apply()

    setInvalidErrors: =>
      isRequired = @getErrors().indexOf('required') != -1
      errors = @remove(@modelErrors(), 'required')
      errors.push('required') if isRequired
      @setErrors(errors)
      @scope.$apply()

    removeErrorsOnTyping: =>
      removedErrors = @diff(@getErrors(), @modelErrors())
      @setErrors(@diff(@getErrors(), removedErrors))

    modelErrors: =>
      @mapKeys @ngModelCtrl.$error

    mapKeys: (hash) ->
      result = []
      angular.forEach hash, (_, key) ->
        result.push key
      result

    remove: (array, element) ->
      index = array.indexOf(element)
      array.splice(index, 1) if index != -1
      array

    diff: (a, b) ->
      result = []
      a.forEach (element) ->
        result.push(element) if b.indexOf(element) == -1
      result

  restrict: 'A'
  require: 'ngModel'
  link: (scope, element, attrs, ngModelCtrl) ->
    new Validate(scope, element, ngModelCtrl)

validate.$inject = ['$compile', 'ErrorsRepository']

angular
  .module('app.core')
  .directive 'validate', validate
