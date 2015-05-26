DunnoApp = angular.module('DunnoApp')
DunnoAppStudent = angular.module('DunnoAppStudent')

Media = (RailsResource, $upload, $q, AWSCredentials, SessionManager, ROOT_API_PATH) ->
  class Media extends RailsResource
    @configure(
      url: "#{ROOT_API_PATH}/medias"
      name: 'media'
      idAttribute: 'uuid'
      updateMethod: 'patch'
    )

    preview: ->
      Media.$get("#{@$url()}/preview", url: @url)

    upload: ->
      deferred = $q.defer()
      original_filename = @file.name
      user_id = SessionManager.currentUser().id
      timestamp = new Date().getTime()
      path = "uploads/#{user_id}/#{timestamp}_#{original_filename}"

      # https://github.com/danialfarid/angular-file-upload#s3
      $upload.upload(
        url: AWSCredentials.baseUrl
        method: 'POST'
        data:
          key: path
          AWSAccessKeyId: AWSCredentials.accessKeyId
          acl: 'private'
          policy: AWSCredentials.policy
          signature: AWSCredentials.signature
          "Content-Type": if @file.type != '' then @file.type else 'application/octet-stream'
          filename: original_filename
        file: @file
      ).progress(->
        deferred.notify(arguments...)
      ).then(=>
        @original_filename = original_filename
        @file_url = path
        @create().then(->
          deferred.resolve(arguments...)
        ).catch(-> deferred.reject(arguments...))
      ).catch((response)->
        error = if /<Code>EntityTooLarge<\/Code>/.exec(response.data)
                  'too_large'
                else
                  'unknown'
        deferred.reject error: error
      )
      deferred.promise

    updateTagList: -> @tag_list = @tags.map((tag)-> tag.text)

    @search: (options)->
      deferred = $q.defer()
      Media.configure(fullResponse: true)
      @query(options).then((response)->
        deferred.resolve(
          medias: response.data
          previous_page: response.originalData.previous_page
          current_page: response.originalData.current_page
          next_page: response.originalData.next_page
        )
      , ->
        deferred.reject(arguments...)
      ).finally ->
        Media.configure(fullResponse: false)

      deferred.promise

  Media.interceptAfterResponse (response)->
    medias = if response.data? then response.data else [response]
    for media in medias
      media.tags = (media.tag_list || []).map (tag)-> { text: tag }
    response

  Media

Media.$inject = ['RailsResource', '$upload', '$q', 'AWSCredentials', 'SessionManager', 'ROOT_API_PATH']
DunnoApp.factory 'Media', Media
DunnoAppStudent.factory 'Media', Media
