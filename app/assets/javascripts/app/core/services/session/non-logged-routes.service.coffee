NonLoggedRoutes = ($window) ->
  ROUTES = [
    /^\/sign_in$/,
    /^\/sign_up$/,
    /^\/dashboard\/password(\/new)?$/,
    /^\/dashboard\/password\/edit$/,
    /^\/teaspoon.*/
  ]

  @isNonLoggedRoute = ->
    ROUTES.filter((route) -> route.exec($window.location.pathname)).length > 0

  @

NonLoggedRoutes.$inject = ['$window']

angular
  .module('app.core')
  .service('NonLoggedRoutes', NonLoggedRoutes)
