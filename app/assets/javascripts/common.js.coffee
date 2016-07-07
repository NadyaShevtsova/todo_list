@module 'Common', ->
  @loadFormToModal = ->
    $('body').on 'click', 'a.open-modal-js', (e) ->
      e.preventDefault()
      $('#modals-form').modal('show')
      $($(@).data('remote-target')).load $(@).attr('href')

    $('#modals-form').on 'hidden.bs.modal', (e) ->
      $(@).find('.modal-content').empty()
