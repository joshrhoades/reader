
$(document).on "ajax:complete", ".comment-form", (xhr, status) ->
  $(this).find(".comment-form-body").val("")

$(document).on "ajax:success", ".comment-form", (data, xhr, status) ->
  if xhr.id == null
    return
  item = App.items.get $(this).closest(".item").parent().attr("data-id")
  comment = new App.Comment xhr
  item.comments.add comment

$(document).on "click", ".comment-remove", (event) ->
  item = App.items.get $(this).closest(".item").parent().attr("data-id")
  comment = item.comments.get $(this).closest(".comment").attr("data-id")
  $.ajax
    type: "DELETE",
    url: comment.url,
    dataType: "json",
    contentType: "application/json",
  .done () ->
    item.comments.remove(comment)

  return false


body = ""
$(document).on "click", ".comment-edit", (event) ->
  item = App.items.get $(this).closest(".item").parent().attr("data-id")
  comment = item.comments.get $(this).closest(".comment").attr("data-id")
  $body = $(this).closest(".comment").find(".comment-body").first()
  body = $body.html()
  $body.load("/comment/" + comment.id + "/editor")
  return false

$(document).on "click", ".btn-comment-cancel", (event) ->
  $body = $(this).closest(".comment").find(".comment-body").first()
  $body.html(body)
  return false

$(document).on "ajax:success", ".edit_comment", (data, xhr, status) ->
  item = App.items.get $(this).closest(".item").parent().attr("data-id")
  comment = item.comments.get $(this).closest(".comment").attr("data-id")
  item.comments.remove(comment)
  item.comments.add(new App.Comment(xhr))
#  $body = $(this).closest(".comment").find(".comment-body").first()
#  $body.html(body)

$(document).on "click", ".comment-author-link", (evt) ->
  $link = $(evt.target)
  userid = $link.attr("data-id")
  username = $link.attr("data-name")
  options =
    title: "Follow " + username + "?"
    trigger: "manual"
  options.content = HandlebarsTemplates["request_follow"]
    id: userid
    username: username
    userid: userid

  new App.Popover(options, $link)

$(document).on "click", ".btn-request-follow", (evt) ->
  user_id = $(evt.target).attr("data-id")
  data = {user_id:user_id}
  $.ajax
    type: "POST",
    url: "/user/follow",
    data: JSON.stringify(data),
    dataType: "json"
    contentType: "application/json"
    success: (data, status, xhr) ->
      App.loadFollowerTables()
    error: (xhr, status, error) ->
  App.Popover.closeAll()

$(document).on "click", ".btn-stop-following", (evt) ->
  user_id = $(evt.target).attr("data-id")
  data = {user_id:user_id}
  $.ajax
    type: "POST",
    url: "/user/stop_following",
    data: JSON.stringify(data),
    dataType: "json"
    contentType: "application/json"
    success: (data, status, xhr) ->
      # TODO: Why is this success handler not getting called?
      alert "booyah"
      App.loadFollowerTables()
    error: (xhr, status, error) ->
  App.Popover.closeAll()


$(document).on "click", ".btn-block-follower", (evt) ->
  user_id = $(evt.target).attr("data-id")
  data = {user_id:user_id}
  $.ajax
    type: "POST",
    url: "/user/block_follower",
    data: JSON.stringify(data),
    dataType: "json"
    contentType: "application/json"
    success: (data, status, xhr) ->
      App.loadFollowerTables()
    error: (xhr, status, error) ->
  App.Popover.closeAll()