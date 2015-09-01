DunnoApp = angular.module('DunnoApp')

DateUtils = ($filter)->
  @asDate = (value)->
    new Date(value)

  @isToday = (value)->
    format = 'yyyy-MM-dd'
    targetDate = $filter('date')(@asDate(value), format)
    todayDate  = $filter('date')(new Date(), format)
    targetDate == todayDate

  @formattedDate = (date, format)->
    $filter('date')(date, format)

  @locationInTime = (date)->
    if @isToday(date)
      'today'
    else if @asDate(date) < new Date()
      'past'
    else
      'future'

  @

DateUtils.$inject = ['$filter']
DunnoApp.service 'DateUtils', DateUtils