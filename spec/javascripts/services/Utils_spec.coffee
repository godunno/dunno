describe "Utils service", ->
  beforeEach module('DunnoApp')
  beforeEach teacherAppMockDefaultRoutes

  Utils = null
  beforeEach ->
    inject (_Utils_) ->
      Utils = _Utils_

  it "removes item", ->
    list = [1, 2, 3]
    Utils.remove(list, 2)
    expect(list).toEqual([1, 3])

  it "destroys item", ->
    item = {}
    Utils.destroy(item)
    expect(item._destroy).toBe(true)

  it "adds a new item to a list", ->
    item = {}
    list = []
    Utils.newItem(list, item)
    expect(list).toEqual([item])

  it "knows that the record is new", ->
    expect(Utils.newRecord({})).toBe(true)

  it "knows that the record isn't new", ->
    expect(Utils.newRecord({ uuid: "d1379743-3558-44d7-888d-a7c2e6ae1e9a" })).toBe(false)
