describe "progressBar directive", ->
  beforeEach module('DunnoApp')
  beforeEach teacherAppDefaultMocks

  scope = null
  progress = null
  meter = null
  beforeEach ->
    inject ($compile, $rootScope) ->
      scope = $rootScope.$new()
      progress = $compile('<progress-bar></progress-bar>')(scope)
      meter = progress.find(".meter")
      progress.appendTo(document.body)

  afterEach ->
    progress.remove()

  it "should start hidden", ->
    expect(progress.is(':hidden')).toBe(true)

  it "should start with zero width", ->
    expect(meter.width()).toEqual(0)

  describe "started", ->
    beforeEach ->
      scope.$broadcast('progress.start')

    it "should be visible", ->
      expect(progress.is(':hidden')).toBe(false)

    #it "should change width when setting value", ->
    #  spyOn(meter, 'width')
    #  scope.$broadcast('progress.setValue', 1)
    #  expect(meter.width).toHaveBeenCalledWith(1)

    it "should hide when stopped", ->
      scope.$broadcast('progress.stop')
      expect(progress.is(':hidden')).toBe(true)
