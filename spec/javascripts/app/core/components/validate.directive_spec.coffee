describe "validate directive", ->
  beforeEach module('app.core', ($translateProvider) ->
    $translateProvider.translations 'en',
      'form.text.required': 'This field is required'
      'form.text.minlength': 'This field should have at least 2 characters'
    $translateProvider.preferredLanguage('en')
    null
  )

  scope           = null
  form            = null
  input           = null
  button          = null
  errorsContainer = null

  beforeEach ->
    inject ($compile, $rootScope) ->
      scope = $rootScope.$new()
      form = angular.element('<form name="form"></form>')
      input = angular.element("""
        <input
          name="text"
          type="text"
          ng-minlength="2"
          required
          validate
          ng-model="text">
        </input>
      """)
      form.append(input)
      button = angular.element('<button type="submit">Submit</button>')
      form.append(button)
      $compile(form)(scope)
      errorsContainer = input.next('.errors')
      form.appendTo(document.body)

  afterEach ->
    form.remove()

  write = (value) ->
    input.val(value).trigger('input')
    scope.$apply()

  submit = ->
    button.click()

  it "starts without errors", ->
    scope.$apply()
    expect(errorsContainer.find('.error').length).toEqual(0)

  it "starts with hidden errors container", ->
    scope.$apply()
    expect(errorsContainer.is(':visible')).toEqual(false)

  it "shows required error on submit", ->
    submit()
    expect(errorsContainer.find('.error.required').length).toEqual(1)

  it "doesn't show length error on blur if not dirty", ->
    input.blur()
    expect(errorsContainer.find('.error').length).toEqual(0)

  it "shows length error on blur if dirty", ->
    write('a')
    input.blur()
    expect(errorsContainer.find('.error.minlength').length).toEqual(1)

  it "hides required error on first typed character", ->
    submit()
    write('a')
    expect(errorsContainer.find('.error.required').length).toEqual(0)

  it "hides length error on second typed character", ->
    write('a')
    input.blur()

    write('ab')
    expect(errorsContainer.find('.error.minlength').length).toEqual(0)

  it "doesn't show required error after it was valid", ->
    submit()
    write('a')
    write('')
    expect(errorsContainer.find('.error.required').length).toEqual(0)

  it "doesn't show length error after it was valid", ->
    write('a')
    input.blur()

    write('ab')
    write('a')
    expect(errorsContainer.find('.error.minlength').length).toEqual(0)

  it "shows required error on submit again", ->
    submit()
    write('a')
    write('')
    submit()
    expect(errorsContainer.find('.error.required').length).toEqual(1)

  it "shows length error on blur again", ->
    write('a')
    input.blur()

    write('ab')
    write('a')
    input.blur()
    expect(errorsContainer.find('.error.minlength').length).toEqual(1)

  it "shows length error on submit", ->
    write('a')
    submit()
    expect(errorsContainer.find('.error.minlength').length).toEqual(1)

  it "shows the correct error message for required", ->
    submit()

    errorMessage = errorsContainer.find('.error.required').text().trim()
    expect(errorMessage).toEqual('This field is required')

  it "shows the correct error message for length", ->
    write('a')
    input.blur()

    errorMessage = errorsContainer.find('.error.minlength').text().trim()
    expect(errorMessage).toEqual('This field should have at least 2 characters')
