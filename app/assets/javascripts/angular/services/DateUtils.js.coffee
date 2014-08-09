DunnoApp = angular.module('DunnoApp')

DateUtils = ($filter)->
  @asDate = (value)->
    new Date(Number(value) * 1000)

  @today = (value)->
    format = 'yyyy-MM-dd'
    targetDate = $filter('date')(@asDate(value), format)
    todayDate  = $filter('date')(new Date()    , format)
    targetDate == todayDate

  @formattedDate = (date, format)->
    $filter('date')(date, format)

  @

DateUtils.$inject = ['$filter']
DunnoApp.service 'DateUtils', DateUtils
