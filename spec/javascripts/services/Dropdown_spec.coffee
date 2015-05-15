describe "Dropdown service", ->
  beforeEach module('DunnoApp')
  beforeEach teacherAppDefaultMocks

  Dropdown = null
  beforeEach ->
    inject (_Dropdown_) ->
      Dropdown = _Dropdown_

  it "calls the Foundation's close method", ->
    spyOn(Foundation.libs.dropdown, 'close')
    Dropdown.close(angular.element('<div></div>'))
    expect(Foundation.libs.dropdown.close).toHaveBeenCalled()
