#$(document).on 'click', '#share-modal-submit-link-btn', (evt) ->
#  $('#share_form').submit()
$(document).on 'click', '#share-modal-close-link-btn', (evt) ->
  $('#share-modal').modal('hide')

$(document).on 'ajax:success', 'form#share_form', (e, data, status, xhr) ->
  if (data.errors)
    $('#user_share_box').prepend(data.errors.join('<br />'))
  else if(data)
    $('#share-modal').modal('hide')




