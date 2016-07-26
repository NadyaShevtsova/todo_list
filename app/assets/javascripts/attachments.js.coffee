@module 'Attachments', ->
  @init =->
    initDeleteAttachment()

  @initFileupload = ->
    $('.js-attachment input:file').fileupload
      dataType: 'json'
      url: $(@).data('url')
      maxChunkSize: 10000000

      progress: (e, data) ->
        parent = $(e.target).closest('.js-attachment')
        $(@).addClass('hide')
        progress = parseInt(data.loaded / data.total * 100, 10)
        parent.find(".progress-animated .bar").css "width", progress + "%"
        parent.find('.percent').html("#{ progress }%")

      done: (e, data) ->
        parent = $(e.target).closest('.js-attachment')
        parent.find(".result").append JST['templates/attachment']({ attachment: data.result.attachment  })

        id = data.result.attachment.id
        parent.find('.result #attachment_' + id).append("<input type='hidden' name='comment[attachment_ids][]' value='" + id + "'>")

        parent.find(".progress-animated .bar").css "width",  "0%"
        parent.find('.percent').empty()
        $(@).removeClass('hide')


  initDeleteAttachment = ->
    $("#modals-form").on 'click', 'a.delete-attachment-js', (e) ->
      e.preventDefault()
      self = $(@)
      attachment_ids = self.closest('.form-group').find('#comment_attachment_ids')
      $.ajax
        method: 'DELETE'
        dataType: 'json'
        url: self.attr('href')
        success: (data) ->
          self.closest('.js-attachment').find('.result #attachment_' + data.id).remove()

$ ->
  Attachments.init() if $('#projects-index').length
