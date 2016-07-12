@module 'Tasks', ->
  @init =->
    submitTaskForm()
    initDeleteTask()
    initSortable()
    initUpdateMark()

  submitTaskForm = ->
    $('#modals-form').on 'submit', 'form.task-form', (e) ->
      e.preventDefault()
      self = $(@)

      $.ajax
        url: self.attr('action')
        dataType: 'JSON'
        method: self.attr('method').toUpperCase()
        data: self.serialize()
        success: (data) ->
          $('#modals-form').modal('hide')
          Notifications.success(data.success)
          if self.attr('action') == "/projects/" + data.task.project_id + "/tasks"
            $(".list_" + data.task.project_id + " .tasks-list").append JST['templates/tasks']({ task: data.task })
          else
            $("#task_#{data.task.id}").find(".task-done input[type=checkbox]").prop('checked', data.task.mark_as_done)
            $("#task_#{data.task.id}").find(".task-name").text(data.task.name)
        error: (xhr, ajaxOptions, thrownError) ->
            Forms.submitting(self)

            errors = $.parseJSON(xhr.responseText).errors
            errorMessage = []
            $.each errors, (key, val) ->
              $("#task_#{ key }").addClass('border-danger').before JST['templates/field_errors']({ errors: val.join(", ") })
              i = 0
              while i < val.length
                errorMessage.push( key.charAt(0).toUpperCase() + key.slice(1) + ": " + val[i] )
                i++
              return
            Notifications.error(errorMessage, '#error_explanation')

  initDeleteTask = ->
    $("body").on 'click', 'a.delete-task-js', (e) ->
      e.preventDefault()
      self = $(@)
      if confirm('Are you sure you want to delete this Task?')
        $.ajax
          method: 'DELETE'
          url: self.attr('href')
          success: (data) ->
            self.closest(".task").remove()
            $('#modals-form').modal('hide')
            Notifications.success(data.success)
            error: (xhr, ajaxOptions, thrownError) ->
              response = $parseJSON(xhr.responseText)
              Notifications.error(response.error)

  initSortable = ->
    $('.sortable').sortable
      cursor: "move"
      handle: '.move'
      placeholder: 'highlight'
      start: (event, ui) ->
        ui.item.toggleClass 'highlight'
        return
      stop: (event, ui) ->
        ui.item.toggleClass 'highlight'
        return
      update: ->
        $.post($(this).data('update-url'), $(this).sortable('serialize'))
    $('.sortable').disableSelection()

  initUpdateMark = ->
    $(".projects-list").on 'change', "input[type='checkbox']", (e) ->
      project_id = $(@).closest(".todo-list").attr("class").match(/\d+/)[0]
      task_id = $(@).attr("id").match(/\d+/)[0]
      mark_as_done = if $(@).attr("checked") then false else true

      $.ajax
        method: 'PATCH'
        data:
          only_message: true
          task:
            mark_as_done: mark_as_done
        url: "/projects/" + project_id + "/tasks/" + task_id
        success: (data) ->
          Notifications.success(data.success)
          error: (xhr, ajaxOptions, thrownError) ->
            response = $parseJSON(xhr.responseText)
            Notifications.error(response.error)

$ ->
  Tasks.init() if $('#projects-index').length
