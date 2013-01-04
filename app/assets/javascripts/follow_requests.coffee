$(document).on "click", ".btn-follow-reciprocate", (evt) ->
  $alert = $(evt.target).closest(".alert").first()
  id = $(evt.target).closest(".alert").attr("data-id")
  $.post "/user/reciprocate", {user_id: id}, App.followBtnSuccessHandler.bind($alert)

$(document).on "click", ".btn-follow-allow", (evt) ->
  $alert = $(evt.target).closest(".alert").first()
  id = $(evt.target).closest(".alert").attr("data-id")
  $.post "/user/allow", {user_id: id}, App.followBtnSuccessHandler.bind($alert)

$(document).on "click", ".btn-follow-reject", (evt) ->
  $alert = $(evt.target).closest(".alert").first()
  id = $(evt.target).closest(".alert").attr("data-id")
  $.post "/user/reject", {user_id: id}, App.followBtnSuccessHandler.bind($alert)

App.followBtnSuccessHandler = (data) ->
  this.alert('close')
  App.loadFollowerTables()
