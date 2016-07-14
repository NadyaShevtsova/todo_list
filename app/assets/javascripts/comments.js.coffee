@module 'Comments', ->
  @init =->
    submitCommentForm()
    initDeleteComment()

  submitCommentForm = ->
    $('#modals-form').on 'submit', 'form.comment-form', (e) ->
      e.preventDefault()
      self = $(@)

      $.ajax
        url: self.attr('action')
        dataType: 'JSON'
        method: self.attr('method').toUpperCase()
        data: self.serialize()
        success: (data) ->
          $('#comment_comment').val("")
          $("#task-" + data.comment.commentable_id + "-comments").append JST['templates/comments']({ comment: data.comment })
        error: (xhr, ajaxOptions, thrownError) ->
            console.log("2")
            Forms.submitting(self)

            errors = $.parseJSON(xhr.responseText).errors
            errorMessage = []
            $.each errors, (key, val) ->
              $("#comment_#{ key }").addClass('border-danger').before JST['templates/field_errors']({ errors: val.join(", ") })
              i = 0
              while i < val.length
                errorMessage.push( key.charAt(0).toUpperCase() + key.slice(1) + ": " + val[i] )
                i++
              return

  initDeleteComment = ->
    $("body").on 'click', 'a.delete-comment-js', (e) ->
      e.preventDefault()
      self = $(@)
      if confirm('Are you sure you want to delete this Comment?')
        $.ajax
          method: 'DELETE'
          url: self.attr('href')
          success: (data) ->
            self.closest(".comment").closest("div").remove()
          error: (xhr, ajaxOptions, thrownError) ->
            response = $parseJSON(xhr.responseText)
            alert("You cann't remove this comment:" + response.error)

$ ->
  Comments.init() if $('#projects-index').length
