describe "validate directive", ->
  beforeEach module('app.core')

  scope             = null
  form              = null
  input             = null
  button            = null
  ErrorsRepository  = null

  beforeEach ->
    inject ($compile, $rootScope, _ErrorsRepository_) ->
      ErrorsRepository = _ErrorsRepository_
      scope = $rootScope.$new()
      form = angular.element('<form name="form" novalidate></form>')
      input = angular.element("""
        <input
          name="text"
          type="text"
          ng-minlength="2"
          required
          validate
          ng-model="text">
      """)
      form.append(input)
      button = angular.element('<button type="submit">Submit</button>')
      form.append(button)
      $compile(form)(scope)
      form.appendTo(document.body)

  afterEach ->
    form.remove()

  write = (value) ->
    input.val(value).trigger('input')
    scope.$apply()

  submit = ->
    button.click()

  errors = ->
    ErrorsRepository.getErrorsFor('form.text')

  it "starts without errors", ->
    scope.$apply()
    expect(errors()).toEqual([])

  it "shows required error on submit", ->
    submit()
    expect(errors()).toEqual(['required'])

  it "doesn't show length error on blur if not dirty", ->
    input.blur()
    expect(errors()).toEqual([])

  it "shows length error on blur if dirty", ->
    write('a')
    input.blur()
    expect(errors()).toEqual(['minlength'])

  it "hides required error on first typed character", ->
    submit()
    write('a')
    expect(errors()).toEqual([])

  it "hides length error on second typed character", ->
    write('a')
    input.blur()

    write('ab')
    expect(errors()).toEqual([])

  it "doesn't show required error after it was valid", ->
    submit()
    write('a')
    write('')
    expect(errors()).toEqual([])

  it "doesn't show length error after it was valid", ->
    write('a')
    input.blur()

    write('ab')
    write('a')
    expect(errors()).toEqual([])

  it "shows required error on submit again", ->
    submit()
    write('a')
    write('')
    submit()
    expect(errors()).toEqual(['required'])

  it "shows length error on blur again", ->
    write('a')
    input.blur()

    write('ab')
    write('a')
    input.blur()
    expect(errors()).toEqual(['minlength'])

  it "shows length error on submit", ->
    write('a')
    submit()
    expect(errors()).toEqual(['minlength'])

  it "throws exception when used in an input without name", ->
    inject ($compile, $rootScope) ->
      scope = $rootScope.$new()
      form = angular.element('<form name="form"></form>')
      input = angular.element("""
        <input
          type="text"
          ng-minlength="2"
          required
          validate
          ng-model="text">
        </input>
      """)
      form.append(input)

      error = new Error("Input must have a name.")
      expect(-> $compile(form)(scope)).toThrow(error)

  it "throws exception when used in an input which form has no name", ->
    inject ($compile, $rootScope) ->
      scope = $rootScope.$new()
      form = angular.element('<form></form>')
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

      error = new Error("Form must have a name.")
      expect(-> $compile(form)(scope)).toThrow(error)

  it "throws exception when used in an input without a form", ->
    inject ($compile, $rootScope) ->
      scope = $rootScope.$new()
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

      error = new Error("Input must belong to a form.")
      expect(-> $compile(input)(scope)).toThrow(error)
