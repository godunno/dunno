describe "weekday filter", ->
  weekday = null

  beforeEach module('DunnoApp')
  beforeEach ->
    inject ($filter) ->
      weekday = $filter('weekday')

  it "knows sunday", ->
    expect(weekday(0)).toEqual('dom')

  it "knows saturday", ->
    expect(weekday(6)).toEqual('sab')
