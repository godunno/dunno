DunnoApp = angular.module('DunnoApp')

leadingZeros = ->
  (number, length)->
    numberStr = number.toString()
    if numberStr.length > length
      number
    else
      new Array(length - (numberStr).length + 1).join('0') + number

DunnoApp.filter 'leadingZeros', leadingZeros
