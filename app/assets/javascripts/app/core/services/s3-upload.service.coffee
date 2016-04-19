S3Upload = (Upload, SessionManager) ->
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

  upload = (file, course) ->
    credentials = course.s3_credentials
    promise = Upload.upload
      url: credentials.base_url
      method: 'POST'
      data:
        key: pathFor(file)
        AWSAccessKeyId: credentials.access_key
        acl: 'private'
        policy: credentials.encoded_policy
        signature: credentials.signature
        "Content-Type": typeFor(file)
        filename: file.name
        file: file

  {
    upload: upload
  }

S3Upload.$inject = ['Upload', 'SessionManager']
angular
  .module('app.core')
  .factory('S3Upload', S3Upload)
