DunnoApp = angular.module('DunnoApp')
DunnoAppStudent = angular.module('DunnoAppStudent')

leadingZeros = ->
  (number, length)->
    numberStr = number.toString()
    if numberStr.length > length
      number
    else
      new Array(length - (numberStr).length + 1).join('0') + number

DunnoApp.filter 'leadingZeros', leadingZeros
DunnoAppStudent.filter 'leadingZeros', leadingZeros
