jQuery(document).ready ->
  return if $('.js-stripe-checkout').length == 0

  Stripe.setPublishableKey($('#stripe-public-key').val())
  
  $('.js-stripe-checkout').click ->
    return false unless formValid()
    spinner('show')
    card =
      cardholder: "#{$('#first_name').val()} #{$('#last_name').val()}"
      number: $('#card_number').val()
      cvc: $('#cvc').val()
      expMonth: $('#expire_month').val()
      expYear: $('#expire_year').val()

    Stripe.createToken(card, (status, response) ->
      if status == 200
        $('#stripe-error').hide()
        $('#stripe_token').val(response.id)
        $('#new_subscription').submit()
      else
        spinner('hide')
        $('#stripe-error strong').html(response.error.message)
        $('#stripe-error').show()
    )
    return false

  formValid =->
    valid = true
    $('#new_subscription [required]').each ->
      if $(this).val() == ''
        $(this).addClass('with-error')
        valid = false
      else
        $(this).removeClass('with-error')

    unless valid
      $('#stripe-error strong').html('Please fill all required fields')
      $('#stripe-error').show()
      return false
    return true

  spinner =(action)->
    if action == 'show'
      $('.js-stripe-checkout .text').hide()
      $('.js-stripe-checkout .spinner').show()
    else if action == 'hide'
      $('.js-stripe-checkout .text').show()
      $('.js-stripe-checkout .spinner').hide()



