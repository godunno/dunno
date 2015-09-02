EventHelper = ->
  translatedStatus = (event) ->
    if isCanceled(event)
      'Cancelada'
    else if isPublished(event)
      'Publicada'
    else if isDraft(event)
      'Rascunho'

  isCanceled = (event) ->
    event.formatted_status == 'canceled'

  isPublished = (event) ->
    event.formatted_status == 'published' ||
    event.formatted_status == 'happened'

  isDraft = (event) ->
    event.formatted_status == 'draft' ||
    event.formatted_status == 'empty'

  return {
    translatedStatus: translatedStatus
    isCanceled: isCanceled
    isPublished: isPublished
    isDraft: isDraft
  }

angular
  .module('DunnoApp')
  .factory('EventHelper', EventHelper)
