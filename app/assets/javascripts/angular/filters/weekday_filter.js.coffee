DunnoApp = angular.module('DunnoApp')

DunnoApp.filter 'weekday', ()->
  (weekday_code)->
    weekdays = ['dom', 'seg', 'ter', 'qua', 'qui', 'sex', 'sab']
    weekdays[weekday_code]
