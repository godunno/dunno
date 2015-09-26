describe "weekday filter", ->
  beforeEach module('app.courses')

  weekday = null
  beforeEach ->
    inject ($filter) ->
      weekday = $filter('weekday')

  describe "valid cases", ->
    it "knows sunday", ->
      expect(weekday(0)).toEqual('dom')

    it "knows saturday", ->
      expect(weekday(6)).toEqual('sáb')

  describe "invalid cases", ->
    it "doesn't know days less than zero", ->
      expect(weekday(-1)).toBeUndefined

    it "doesn't know days greater than 6", ->
      expect(weekday(7)).toBeUndefined

    it "doesn't respond to invalid indexes", ->
      expect(weekday("sunday")).toBeUndefined
