describe "S3Upload service", ->
  beforeEach module('app.core')

  credentials =
    access_key: 'access key id'
    policy: 'policy'
    signature: 'signature'
    base_url: 'base url'

  S3Upload = null
  Upload = null

  timestamp = 1234567890
  user =
    id: 1

  beforeEach ->
    inject ($injector, $httpBackend, _Upload_, SessionManager) ->
      $httpBackend.whenGET('/api/v1/utils/s3/credentials').respond 200, credentials
      $injector.get('AWSCredentials')
      $httpBackend.flush()

      spyOn(Date.prototype, 'getTime').and.returnValue(timestamp)

      Upload = _Upload_
      SessionManager.currentUser = -> user
      S3Upload = $injector.get('S3Upload')

  it "calls Upload service for file with type", ->
    spyOn(Upload, 'upload')

    file = { name: 'file.txt', type: 'image/jpg' }
    S3Upload.upload(file)
    expect(Upload.upload).toHaveBeenCalledWith
      url: credentials.base_url
      method: 'POST'
      data:
        key: "uploads/1/1234567890_file.txt"
        AWSAccessKeyId: credentials.access_key
        acl: 'private'
        policy: credentials.policy
        signature: credentials.signature
        "Content-Type": file.type
        filename: file.name
        file: file

  it "calls Upload service for file without type", ->
    spyOn(Upload, 'upload')

    file = { name: 'file', type: '' }
    S3Upload.upload(file)
    expect(Upload.upload).toHaveBeenCalledWith
      url: credentials.base_url
      method: 'POST'
      data:
        key: "uploads/1/1234567890_file"
        AWSAccessKeyId: credentials.access_key
        acl: 'private'
        policy: credentials.policy
        signature: credentials.signature
        "Content-Type": 'application/octet-stream'
        filename: file.name
        file: file
