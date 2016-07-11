@module 'Common', ->
  @loadFormToModal = ->
    $('body').on 'click', 'a.open-modal-js', (e) ->
      e.preventDefault()
      $('#modals-form').modal('show')

      self = $(@)
      $($(@).data('remote-target')).load $(@).attr('href'), ->
        initDatepicker()

        task_name_field = self.closest(".create-task").find("#create_task_name")
        if task_name_field
          $(".modal-content #new_task #task_name").val(task_name_field.val())
        task_name_field.val("")

    $('#modals-form').on 'hidden.bs.modal', (e) ->
      $(@).find('.modal-content').empty()


    initDatepicker = ->
      $('.datepicker').datepicker
        format: 'dd/mm/yyyy'
        weekStart: 1
        clearBtn: true
        todayHighlight: true
