describe "DateUtils service", ->
  beforeEach module('DunnoApp')
  beforeEach teacherAppMockDefaultRoutes

  DateUtils = null
  date = "2014-10-13T14:13:00.000Z"
  beforeEach ->
    inject (_DateUtils_) ->
      DateUtils = _DateUtils_

  it "converts a string to Date", ->
    expect(DateUtils.asDate(date)).toEqual(new Date(date))

  it "formats the date", ->
    expect(DateUtils.formattedDate(new Date(date), 'dd/MM/yyyy')).toEqual('13/10/2014')

  it "knows if it's today", ->
    expect(DateUtils.isToday(new Date())).toBe(true)

  describe "#locationInTime", ->
    it "responds 'today'", ->
      today = new Date()
      expect(DateUtils.locationInTime(today)).toEqual('today')

    it "responds 'past'", ->
      yesterday = new Date(new Date().valueOf() - 1000 * 60 * 60 * 24)
      expect(DateUtils.locationInTime(yesterday)).toEqual('past')

    it "responds 'future'", ->
      tomorrow = new Date(new Date().valueOf() + 1000 * 60 * 60 * 24)
      expect(DateUtils.locationInTime(tomorrow)).toEqual('future')
