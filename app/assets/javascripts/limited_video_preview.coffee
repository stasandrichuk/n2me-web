jQuery(document).ready ->
  return if $('.is-guest-user').length == 0

  setTimeout(
    ()->
      try
        $('#purchase-modal').modal 'show'
      catch ex
    30000
  )

  $('#purchase-modal').on('hidden.bs.modal', ->
    document.location.href = $('.subscribe-btn').attr('href')
  )