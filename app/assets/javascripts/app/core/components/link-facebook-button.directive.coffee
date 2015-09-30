linkFacebookButton = ->
  linkFacebookButtonCtrl = (FacebookWrapper) ->
    @link = ->
      FacebookWrapper.login()

    @

  linkFacebookButtonCtrl.$inject = ['FacebookWrapper']

  templateUrl: 'core/components/link-facebook-button.directive'
  controller: linkFacebookButtonCtrl
  controllerAs: 'vm'
  scope: true

angular
  .module('app.core')
  .directive('linkFacebookButton', linkFacebookButton)
