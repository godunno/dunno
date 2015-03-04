DunnoApp = angular.module('DunnoApp')
Media = (RailsResource, $upload, $q, AWSCredentials)->
  class Media extends RailsResource
    @configure(
      url: '/api/v1/teacher/medias'
      name: 'media'
      idAttribute: 'uuid'
      updateMethod: 'patch'
    )

    preview: ->
      Media.$get("#{@$url()}/preview", url: @url)

    upload: ->
      deferred = $q.defer()
      original_filename = @file.name
      path = "uploads/#{new Date().getTime()}_#{original_filename}"
      
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
      )
      deferred.promise

    update_tag_list: -> @tag_list = @tags.map((tag)-> tag.text)

    @search: (options)->
      deferred = $q.defer()
      Media.configure(fullResponse: true)
      @query(options).then((response)->
        Media.configure(fullResponse: false)
        deferred.resolve(
          medias: response.data
          previous_page: response.originalData.previous_page
          current_page: response.originalData.current_page
          next_page: response.originalData.next_page
        )
      , ->
        deferred.reject(arguments...)
      )
      deferred.promise

  Media.interceptAfterResponse (response)->
    medias = if response.data? then response.data else [response]
    for media in medias
      media.tags = (media.tag_list || []).map (tag)-> { text: tag }
    response

  Media

Media.$inject = ['RailsResource', '$upload', '$q', 'AWSCredentials']
DunnoApp.factory 'Media', Media
