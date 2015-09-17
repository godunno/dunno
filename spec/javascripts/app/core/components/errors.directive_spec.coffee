describe "validate directive", ->
  beforeEach module('app.core', ($translateProvider) ->
    $translateProvider.translations 'en',
      'form.text.required': 'This field is required'
      'form.text.minlength': 'This field should have at least 2 characters'
    $translateProvider.preferredLanguage('en')
    null
  )

  errors            = null
  scope             = null
  ErrorsSharedSpace = null

  beforeEach ->
    inject ($compile, $rootScope, $templateCache, _ErrorsSharedSpace_) ->
      ErrorsSharedSpace = _ErrorsSharedSpace_
      $templateCache.put '/assets/app/core/components/errors.directive.html', """
        <span class="message__error" ng-show="errors().length > 0">
          <span ng-repeat="error in errors()" class="error {{error}}-error">
            {{ translationKey + '.' + error | translate }}
          </span>
        </span>
      """

      scope = $rootScope.$new()
      errors = angular.element('<errors for="form.text">')
      errors.appendTo(document.body)
      $compile(errors)(scope)

  afterEach ->
    errors.remove()

  setErrors = (errors) ->
    ErrorsSharedSpace.setErrorsFor('form.text', errors)

  it "isn't visible when there's no errors", ->
    setErrors([])
    scope.$apply()

    expect(errors.is(':visible')).toBe(false)

  it "is visible when there's errors", ->
    setErrors(['required'])
    scope.$apply()

    expect(errors.is(':visible')).toBe(true)

  it "shows required error", ->
    setErrors(['required'])
    scope.$apply()

    errorMessage = errors.find('.error.required-error').text().trim()
    expect(errorMessage).toEqual('This field is required')

  it "shows minlength error", ->
    setErrors(['minlength'])
    scope.$apply()

    errorMessage = errors.find('.error.minlength-error').text().trim()
    expect(errorMessage).toEqual('This field should have at least 2 characters')

  it "shows more than one error", ->
    setErrors(['required', 'minlength'])
    scope.$apply()

    expect(errors.find('.error').length).toEqual(2)

  it "throws exception if it doesn't have a for attribute", ->
    inject ($compile, $rootScope) ->
      scope = $rootScope.$new()
      errors = angular.element('<errors>')

      error = new Error("Errors must have a for attribute.")
      expect ->
        $compile(errors)(scope)
        scope.$digest()
      .toThrow(error)

  it "doesn't conflicts with other directives", ->
    inject ($compile, $rootScope) ->
      newErrors = angular.element('<errors for="form.name">')
      $compile(newErrors)(scope)

      setErrors(['required'])
      scope.$apply()

      errorMessage = errors.find('.error.required-error').text().trim()
      expect(errorMessage).toEqual('This field is required')
