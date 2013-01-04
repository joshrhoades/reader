
# Support for adding a group
$(document).on 'click', '.add-group-link', (evt) ->
  $('#group-modal').modal('show')

$(document).on 'ajax:success', 'form#group_form', (e, data, status, xhr) ->
  if data.error?
    $('#group-modal p.modal-errors').html(data.error)
  else
    group = new App.Group(data)
    App.groups.add group
    group.set("new", true)
    App.renderFeedList()
    $('#group-label').val('')
    $('#group-modal').modal('hide')

$(document).on 'click', '#group-modal-close-link-btn', (evt) ->
  $('#group-modal').modal('hide')

# Support for adding a feed
$(document).on 'click', '.add-subscription-link', (evt) ->
  $("#feed-modal-submit-link-btn").html('Add Feed')
  $("#modal-feed-choices .control-group").empty()
  $('#feed-modal').modal('show')

$(document).on 'ajax:success', 'form#modal_add_feed_form', (e, data, status, xhr) ->
  if data.error?
    $('#feed-modal p.modal-errors').html(data.error)
  else if data.feeds?
    $("#modal-feed-form").hide()
    $("#modal-feed-choices").show()
    $("#feed-modal-submit-link-btn").html('Add Feeds')
    _(data.feeds).each (feed) ->
      row = "<input name='feeds[]' type='checkbox' value='" + feed.url + "'> " + feed.title + "<br/>"
      $("#modal-feed-choices .control-group").append(row)
  else
    $('#feed-url').val('')
    $('#feed-modal').modal('hide')

$(document).on 'click', '#rerender', (evt) ->
  App.renderFeedList()


App.renderFeedList = ->
  App.people.each (person) ->
    person.updateCount()
  App.groups.each (grp) ->
    grp.render()
  App.subscriptions.each (sub) ->
    sub.render()

$(document).on 'show', 'a.filter-unread', (evt) ->
  App.showAllSubscriptions = false
  App.filterOnUnread()

$(document).on 'show', 'a.filter-all', (evt) ->
  App.showAllSubscriptions = true
  App.filterOnAll()

$(document).on 'show', 'a.filter-starred', (evt) ->
  App.showAllSubscriptions = false
  App.filterOnStarred()

$(document).on 'show', 'a.filter-shared', (evt) ->
  App.showAllSubscriptions = false
  App.filterOnShared()

$(document).on 'click', '.group-folder-icon', (evt) ->
  gid = $(evt.target).closest(".li-group").attr("data-id")
  group = App.groups.get(gid)
  $grp = $("li.li-group-list[data-id='#{gid}']")
  $grp.toggleClass("hide")

  group.set("open", (!$grp.hasClass("hide")))
  group.save()
