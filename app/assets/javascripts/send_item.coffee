$(document).on 'click', '.send-item-email-menu-item', (evt) ->
  $('#send-item-modal').modal('show')
  id = $(evt.target).closest(".item").parent().attr("data-id")
  $("#send-item-modal .form-container").load("/items/"+id+"/email")
  return false

$(document).on 'click', '.send-item-instapaper-menu-item', (evt) ->


$(document).on 'ajax:success', 'form#email-item-form', (e, data, status, xhr) ->
  if (data.errors)
    $('#user_share_box').prepend(data.errors.join('<br />'))
  else if(data)
    $('#send-item-modal').modal('hide')
