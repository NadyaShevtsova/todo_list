@module 'Forms', ->
  @submitting = (form_id)->
    form_id.find('input, textarea').removeClass('border-danger')
    form_id.find('small').remove()
