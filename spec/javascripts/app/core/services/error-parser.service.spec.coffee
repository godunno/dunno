describe "ErrorParser service", ->
  beforeEach module('app.core')

  ErrorParser = null
  scope = null
  form = null
  errors = attribute: [error: "invalid"]
  beforeEach ->
    inject (_ErrorParser_, $rootScope, $compile) ->
      ErrorParser = _ErrorParser_
      scope = $rootScope.$new()
      html = """
        <form name="form">
          <input type="text" name="attribute" ng-model="value">
        </form>
      """
      $compile(html)(scope)
      form = scope.form

  it "sets the errors", ->
    ErrorParser.setErrors(errors, form, scope)
    expect(form.attribute.$valid).toBe(false)
    expect(form.attribute.$error).toEqual(invalid: true)

  it "removes the error after editing the field", ->
    ErrorParser.setErrors(errors, form, scope)
    scope.$apply()
    form.attribute.$setViewValue('something')
    scope.$apply()
    expect(form.attribute.$valid).toBe(true)
    expect(form.attribute.$error).toEqual({})
