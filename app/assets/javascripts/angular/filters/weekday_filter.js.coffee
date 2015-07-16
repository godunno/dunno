DunnoApp = angular.module('DunnoApp')

DunnoApp.filter 'weekday', ()->
  (weekday_code)->
    weekdays = ['dom', 'seg', 'ter', 'qua', 'qui', 'sex', 'sáb']
    weekdays[weekday_code]

DunnoApp.filter 'weekday_long', ()->
  (weekday_code)->
    weekdays = ['domingo', 'segunda-feira', 'terça-feira', 'quarta-feira', 'quinta-feira', 'sexta-feira', 'sábado']
    weekdays[weekday_code]
