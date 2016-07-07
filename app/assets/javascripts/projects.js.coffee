@module 'Projects', ->
  @init =->
    Common.loadFormToModal()
    submitProjectForm()
    initDeleteProject()

    $('#modals-form').on 'hidden.bs.modal', (e) ->
      $(@).find('.modal-content').empty()

  submitProjectForm = ->
    $('#modals-form').on 'submit', 'form', (e) ->
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
          if self.attr('action') == "/projects"
            $(".projects-list").append JST['templates/projects']({ id: data.id, name: data.name })
          else
            console.log(".projects-list div#project_#{data.id}")
            $(".projects-list div#project_#{data.id}").find(".project-name").text(data.name)
        error: (xhr, ajaxOptions, thrownError) ->
            Forms.submitting(self)

            errors = $.parseJSON(xhr.responseText).errors
            errorMessage = []
            $.each errors, (key, val) ->
              $("#project_#{ key }").addClass('border-danger').before JST['templates/field_errors']({ errors: val.join(", ") })
              i = 0
              while i < val.length
                errorMessage.push( key.charAt(0).toUpperCase() + key.slice(1) + ": " + val[i] )
                i++
              return
            Notifications.error(errorMessage, '#error_explanation')

  initDeleteProject = ->
    $("body").on 'click', 'a.delete-project-js', (e) ->
      e.preventDefault()
      self = $(@)
      if confirm('Are you sure you want to delete this Project?')
        $.ajax
          method: 'DELETE'
          url: self.attr('href')
          success: (data) ->
            self.closest(".project-item").remove()
            $('#modals-form').modal('hide')
            Notifications.success(data.success)
            error: (xhr, ajaxOptions, thrownError) ->
              response = $parseJSON(xhr.responseText)
              Notifications.error(response.error)

$ ->
  Projects.init() if $('#projects-index').length

