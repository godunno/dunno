validate = ($compile) ->
  restrict: 'A'
  require: 'ngModel'
  priority: 9999
  link: (scope, element, attrs, ngModelCtrl) ->
    hasValidator = (validator) -> ngModelCtrl.$error[validator]?

    validateOn = (errorsContainer, validators) ->
      ngModelCtrl.$commitViewValue()
      show = validators.some(hasValidator)
      errorsContainer.toggle(show)

    assembleErrorsContainer = (validators) ->
      errorsContainer = $('<span class="error" ng-messages="errors()"></span>')
      validators.forEach (error) ->
        errorsContainer.append($("<span ng-message=\"#{error}\">#{error}</span>"))

      newScope = scope.$new()

      newScope.errors = ->
        validators.filter(hasValidator).reduce(((acc, el) -> acc[el] = true; acc), {})

      newScope.hasErrors = ->
        ngModelCtrl.$commitViewValue()
        validators.some(hasValidator)

      $compile(errorsContainer)(newScope)

      element.on('focus', -> errorsContainer.hide())
      errorsContainer.hide().insertAfter(element)

    onBlurValidators = []
    angular.forEach ngModelCtrl.$validators, (_, validator) ->
      if validator != 'required'
        onBlurValidators.push validator

    onBlurContainer = assembleErrorsContainer(onBlurValidators)
    element.on('blur', -> validateOn(onBlurContainer, onBlurValidators))

    if ngModelCtrl.$validators.required?
      onSubmitContainer = assembleErrorsContainer(['required'])
      angular.element(element[0].form).on('submit', -> validateOn(onSubmitContainer, ['required']))

validate.$inject = ['$compile']

angular
  .module('app.core')
  .directive 'validate', validate
