# TODO: Isn't working, find out why.
#describe "focusOn directive", ->
#  beforeEach module('DunnoApp')
#
#  element = null
#  scope = null
#  beforeEach ->
#    inject ($compile, $rootScope) ->
#      scope = $rootScope.$new()
#      element = $compile('<input type="text" focus-on="test"></input>')($rootScope)
#
#  it "isn't focused", ->
#    scope.test = false
#    scope.$digest()
#    expect(element.is(':focus')).toBe(false)
#
#  it "is focused", ->
#    scope.test = true
#    scope.$digest()
#    expect(element.is(':focus')).toBe(true)
