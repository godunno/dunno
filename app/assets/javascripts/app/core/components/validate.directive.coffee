validate = ($compile) ->
  class Validate
    constructor: (scope, element, ngModelCtrl) ->
      throw new Error("Input must have a name.") unless element.attr('name')?

      form = $(element[0].form)
      throw new Error("Input must belong to a form.") unless form.length == 1
      throw new Error("Form must have a name.") unless form.attr('name')?

      @scope = scope
      @element = element
      @ngModelCtrl = ngModelCtrl

      @namespace = "#{form.attr('name')}.#{element.attr('name')}"

      @scope.$watch (=> @modelErrors().join()), @removeErrorsOnTyping
      @element.on 'blur', @setInvalidErrors
      form.on 'submit', @setAllErrors

    setAllErrors: =>
      @errors = @modelErrors()
      @scope.$apply()

    setInvalidErrors: =>
      isRequired = @errors.indexOf('required') != -1
      errors = @remove(@modelErrors(), 'required')
      errors.push('required') if isRequired
      @errors = errors
      @scope.$apply()

    removeErrorsOnTyping: =>
      removedErrors = @diff(@errors, @modelErrors())
      @errors = @diff(@errors, removedErrors)

    modelErrors: =>
      @mapKeys @ngModelCtrl.$error

    errors: []

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

    errorsScope: =>
      newScope = @scope.$new()
      newScope.errors = => @errors
      newScope

    compileErrorsContainer: =>
      errorsContainer = $("""
        <span class="errors" ng-show="errors().length > 0">
          <span ng-repeat="error in errors()" class="error" ng-class="error">
            {{ '#{@namespace}.' + error | translate }}
          </span>
        </span>
      """)
      $compile(errorsContainer)(@errorsScope())
      @element.after errorsContainer

  restrict: 'A'
  require: 'ngModel'
  link: (scope, element, attrs, ngModelCtrl) ->
    new Validate(scope, element, ngModelCtrl).compileErrorsContainer()

validate.$inject = ['$compile']

angular
  .module('app.core')
  .directive 'validate', validate
