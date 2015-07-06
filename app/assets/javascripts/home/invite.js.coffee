$(document).on 'click', '.invitation__link', (e) ->
  id = $(this).attr('href')
  if $(id).length > 0
    e.preventDefault()
    $('#invitation__email').focus()
    if window.history and window.history.pushState
      history.pushState '', document.title, id

$('#invitation__form').submit (e) ->

  $el = $(this)
  url = $(this).prop('action')

  $.ajax
    type: 'POST'
    url: url
    data: $el.serialize()
  .always ->
    $el.hide()
    $('.success-message').show()

  e.preventDefault()
