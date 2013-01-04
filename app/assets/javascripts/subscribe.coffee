
$(document).on 'click', "#feed-subscribe-link-btn", () ->
  $('#add_feed_form').submit()

$(document).on 'ajax:success', 'form#alert_add_feed_form', (e, data, status, xhr) ->
  $("#feeds-alert").alert('close')

$(document).on 'ajax:error', 'form#alert_add_feed_form', (e, data, status, xhr) ->
