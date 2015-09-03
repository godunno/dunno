courses = angular.module('app.courses')

courses.filter 'weekday', () ->
  (weekday_code)->
    weekdays = ['dom', 'seg', 'ter', 'qua', 'qui', 'sex', 'sáb']
    weekdays[weekday_code]

courses.filter 'weekdayLong', () ->
  (weekday_code) ->
    weekdays = ['domingo', 'segunda-feira', 'terça-feira', 'quarta-feira', 'quinta-feira', 'sexta-feira', 'sábado']
    weekdays[weekday_code]
