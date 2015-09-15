validate = ($compile) ->
  class ErrorsContainer
    constructor: (errors, scope) ->
      @errors = errors
      @scope = scope

    compile: =>
      errorsContainer = @buildContainer()

      angular.forEach @errors, (error) =>
        errorsContainer.append @buildError(error)

      $compile(errorsContainer)(@scope)

      errorsContainer

    buildContainer: -> $('<span class="errors" ng-show="anyErrors()"></span>')

    buildError: (error) ->
      "<span class=\"error #{error}\" ng-if=\"showError('#{error}')\">#{error}</span>"

  class Validate
    constructor: (scope, element, ngModelCtrl) ->
      @scope = scope
      @element = element
      @ngModelCtrl = ngModelCtrl

      @blurred = false
      @submitted = false

      @setSubmitCallbacks()
      @setBlurCallbacks()

    setSubmitCallbacks: =>
      $(@element[0].form).on 'submit', =>
        @submitted = true
        @scope.$apply()

      @scope.$watch (=> @errors().indexOf('required')), (index) =>
        @submitted = false if index == -1

    setBlurCallbacks: =>
      @element.on 'blur', =>
        @blurred = true
        @scope.$apply()

      @scope.$watch (=> @onBlurErrors().length > 0), (empty) =>
        @blurred = false if empty

    mapKeys: (hash) ->
      result = []
      angular.forEach hash, (_, key) ->
        result.push key
      result

    errors: =>
      @ngModelCtrl.$commitViewValue()
      @mapKeys @ngModelCtrl.$error

    onBlurErrors: =>
      remove = (array, element) ->
        index = array.indexOf(element)
        array.splice(index, 1) if index != -1
        array

      remove(@errors(), 'required')

    showError: (error) =>
      return false if @errors().indexOf(error) == -1
      if error == 'required'
        @submitted
      else
        @blurred

    anyErrors: =>
      @errors().some (error) => @showError(error)

    errorsScope: =>
      newScope = @scope.$new()
      newScope.errors = @errors
      newScope.showError = @showError
      newScope.anyErrors = @anyErrors
      newScope

    validators: =>
      @mapKeys @ngModelCtrl.$validators

    compileErrorsContainer: =>
      errorsContainer = new ErrorsContainer(@validators(), @errorsScope())
      @element.after errorsContainer.compile()

  restrict: 'A'
  require: 'ngModel'
  priority: 1 # WTF
  link: (scope, element, attrs, ngModelCtrl) ->
    new Validate(scope, element, ngModelCtrl).compileErrorsContainer()


validate.$inject = ['$compile']

angular
  .module('app.core')
  .directive 'validate', validate
