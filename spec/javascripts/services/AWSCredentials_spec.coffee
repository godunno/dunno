describe "AWSCredentials service", ->
  beforeEach module('DunnoApp')

  credentials =
    access_key: 'access key id'
    policy: 'policy'
    signature: 'signature'
    base_url: 'base url'

  AWSCredentials = null
  $httpBackend = null
  beforeEach ->
    inject ($injector) ->
      $httpBackend = $injector.get('$httpBackend')
      window.h = $httpBackend
      $httpBackend.whenGET('/api/v1/utils/s3/credentials').respond 200, credentials

      # TODO: Find from where the hell are comming these requests
      $httpBackend.whenGET('/assets/teacher/courses/index.html').respond 200, "pindamanhangaba"
      $httpBackend.whenGET('/api/v1/teacher/courses').respond 200, "ugabuga"

      AWSCredentials = $injector.get('AWSCredentials')
      $httpBackend.flush()

  afterEach ->
    $httpBackend.verifyNoOutstandingExpectation()
    $httpBackend.verifyNoOutstandingRequest()

  it "sets the accessKeyId", ->
    expect(AWSCredentials.accessKeyId).toEqual(credentials.access_key)

  it "sets the policy", ->
    expect(AWSCredentials.policy).toEqual(credentials.policy)

  it "sets the signature", ->
    expect(AWSCredentials.signature).toEqual(credentials.signature)

  it "sets the baseUrl", ->
    expect(AWSCredentials.baseUrl).toEqual(credentials.base_url)
