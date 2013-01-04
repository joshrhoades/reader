$(document).on 'ajax:success', '#invite_form', (e, data, status, xhr) ->
  $("#invite_result").html(data.success)
  App.resetInviteForm()

App.resetInviteForm = ->
  $('#invite_email').val('')