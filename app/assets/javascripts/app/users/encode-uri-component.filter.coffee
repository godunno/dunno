encodeURIComponent = ($window) -> $window.encodeURIComponent

encodeURIComponent.$inject = ['$window']

angular
  .module('app.users')
  .filter('encodeURIComponent', encodeURIComponent)
