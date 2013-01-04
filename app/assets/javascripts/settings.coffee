$(document).on 'click', '#opml_form a.btn.btn-primary', (evt) ->
  $('#opml_form').submit()

$(document).on 'ajax:success', '#opml_form', (e, data, status, xhr) ->
  $("#opml_result").html(data)
  App.resetOpmlForm()

$(document).on 'click', '#add_feed_form a.btn.btn-primary', (evt) ->
  $('#add_feed_form').submit()

$(document).on 'ajax:success', '#add_feed_form', (e, data, status, xhr) ->
  App.resetAddFeedForm()

  if data.error?
    $("#feed-url-field-control-group").addClass("error")
    $("#feed-url-field-control-group").find(".help-inline").html(data.error)
  else if data.subscriptions?
    App.resetAddFeedForm()
    $("#feed-url-field-control-group").addClass("success")
    _(data.subscriptions).each (sub) ->
      $("#feed-url-field-control-group").find(".help-inline").html("Feed subscription added - #{sub.name}")
      subscription = new App.Subscription(sub)
      App.subscriptions.add(sub)
    $('#your_feeds').load('/settings/your_feeds')
  else if data.feeds?
    $("#feed-url-field-control-group").hide()
    $("#feed-select-found-feed").show()
    $("#add-feed-btn").html('Add Feeds')
    _(data.feeds).each (feed) ->
      row = "<label class='checkbox'>"
      row += "<input name='feeds[]' type='checkbox' value='" + feed.url + "'> " + feed.title + ""
      row += "</label>"
      $("#feed-select-found-feed .controls").append(row)
  else
    App.resetAddFeedForm()
  App.renderFeedList()

App.resetOpmlForm = ->
  $('#opml_file').val('')

App.resetAddFeedForm = ->
  $("#feed-url-field-control-group").show()
  $("#feed-select-found-feed").hide()
  $("#feed-url-field-control-group").removeClass("error")
  $("#feed-url-field-control-group").removeClass("success")
  $("#feed-url-field-control-group").find(".help-inline").html("")
  $("#add-feed-btn").html('Add Feed')
  $('#feed_url').val('')

App.loadFollowerTables = ->
  $('#people-you-follow-container').load('/people/following')
  $('#people-following-you-container').load('/people/followers')
  $('#people-you-may-know-container').load('/people/may_know')


$(document).on 'ajax:complete', '.unsubscribe-link', (event, xhr, settings) ->
  $(this).closest('.subscription-table-row').remove()

$(document).on 'ajax:complete', '.subscribe-link', (event, xhr, settings) ->
  $(this).closest('.suggested-table-row').remove()
  $('#your_feeds').load('/settings/your_feeds')

$(document).on "click", ".follow-person-link", (evt) ->
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
  return false

$(document).on "click", ".unfollow-person-link", (evt) ->
  $link = $(evt.target)
  userid = $link.attr("data-id")
  username = $link.attr("data-name")
  options =
    title: "Stop following " + username + "?"
    trigger: "manual"
  options.content = HandlebarsTemplates["stop_following"]
    id: userid
    username: username
    userid: userid

  new App.Popover(options, $link)
  return false

$(document).on "click", ".block-person-link", (evt) ->
  $link = $(evt.target)
  userid = $link.attr("data-id")
  username = $link.attr("data-name")
  options =
    title: "Stop sharing with " + username + "?"
    trigger: "manual"
  options.content = HandlebarsTemplates["block"]
    id: userid
    username: username
    userid: userid

  new App.Popover(options, $link)
  return false

