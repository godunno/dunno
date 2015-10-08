# https://gist.github.com/thomseddon/3511330

bytes = ->
  (bytes, precision) ->
    return '-' if isNaN(parseFloat(bytes)) || !isFinite(bytes)

    precision = 1 unless precision?
    units = ['bytes', 'kB', 'MB', 'GB', 'TB', 'PB']

    number = Math.floor(Math.log(bytes) / Math.log(1024))

    formattedNumber = (bytes / Math.pow(1024, Math.floor(number))).toFixed(precision)
    unit = units[number]

    "#{formattedNumber} #{unit}"

angular
  .module('app.courses')
  .filter('bytes', bytes)
