$(document).on 'click', '.invitation__link', (e) ->
  id = $(this).attr('href')
  if $(id).length > 0
    e.preventDefault()
    $('#invitation__email').focus()
    if window.history and window.history.pushState
      history.pushState '', document.title, id
