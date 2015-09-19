#= require support/bind-poly
#= require application
#= require angular-mocks/angular-mocks
window.teacherAppMockDefaultRoutes = ->
  inject ($httpBackend) ->
    $httpBackend.whenGET('/assets/courses/index.html').respond 200, ''
    $httpBackend.whenGET('/api/v1/courses').respond 200, []
