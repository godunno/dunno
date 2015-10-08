S3Upload = (Upload, SessionManager, AWSCredentials) ->
  timestamp = ->
    new Date().getTime()

  userId = ->
    SessionManager.currentUser().id

  pathFor = (file) ->
    "uploads/#{userId()}/#{timestamp()}_#{file.name}"

  typeFor = (file) ->
    if file.type != ''
      file.type
    else
      'application/octet-stream'

  upload = (file) ->
    Upload.upload
      url: AWSCredentials.baseUrl
      method: 'POST'
      data:
        key: pathFor(file)
        AWSAccessKeyId: AWSCredentials.accessKeyId
        acl: 'private'
        policy: AWSCredentials.policy
        signature: AWSCredentials.signature
        "Content-Type": typeFor(file)
        filename: file.name
        file: file

  {
    upload: upload
  }

S3Upload.$inject = ['Upload', 'SessionManager', 'AWSCredentials']
angular
  .module('app.core')
  .factory('S3Upload', S3Upload)
