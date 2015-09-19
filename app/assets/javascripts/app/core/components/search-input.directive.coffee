searchInput = ->
  link = (scope, element, attributes) ->
    searchOnEvent(scope, element)

  searchOnEvent = (scope, element) ->
    element.on 'search', (e) ->
      value = e.target.value
      if value == ""
        scope.clearSearch()
      else
        scope.performSearch()(e.target.value)

  link: link
  restrict: 'E'
  templateUrl: 'core/components/search-input.directive'
  replace: true
  scope:
    performSearch: '&'
    clearSearch: '&'

angular
  .module('app.core')
  .directive('searchInput', searchInput)
