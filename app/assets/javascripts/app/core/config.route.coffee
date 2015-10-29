setAppRoutes = ($stateProvider) ->
  $stateProvider
    .state 'app',
      url: ''
      abstract: true
      template: '<ui-view/>'
      sticky: true

    .state 'panel',
      abstract: true
      views:
        "panel":
          controller: 'PanelCtrl as vm'
          templateUrl: 'core/components/panel'
      onEnter: ['FoundationPanel', (FoundationPanel) ->
        FoundationPanel.activate('panel')
      ]
      onExit: ['FoundationPanel', (FoundationPanel) ->
        FoundationPanel.deactivate('panel')
      ]

setAppRoutes.$inject = ['$stateProvider']

angular
  .module('app.core')
  .config(setAppRoutes)
