
class App.Receiver
  startPrivatePubSub: () =>
    $.get("/pps", @.insertPPS)

  insertPPS: (data, status, xhr) ->
    $("body").append(data)

  addComment: (comment_json) =>
    items = @.findItems(comment_json)
    comment = new App.Comment(comment_json)
    _(items).each (item) ->
      item.set("has_new_comments", true)
      item.comments.add(comment)
    App.items.checkForNewComments()

  removeComment: (id) =>
    comment = @.findComment(id)
    items = @.findItems(comment)
    _(items).each (item) ->
      item.comments.remove(comment)

  updateComment: (comment_json) =>
    @.removeComment(comment_json)
    @.addComment(comment_json)
    App.items.checkForNewComments()

  findItems: (comment_json) =>
    items = App.items.filter (item) ->
      (item.get('parent_id') == comment_json.item_id || item.get('id') == comment_json.item_id)
    items

  findSub: (sub_json) =>
    sub = App.subscriptions.get(sub_json.id)

  findComment: (id) =>
    App.comments.get(id)

  addSubscription: (sub_json) =>
    sub = @.findSub(sub_json)
    if sub
      sub.set sub_json
    else
      sub = App.Subscription(sub_json)
      App.subscriptions.add(sub)

#  addItem: (item_json) =>
#    item = new App.Item(item_json)
#    App.items.add(item)
#    item.updateParentContainers()
#    App.items.checkForNewComments()
#
#  removeItem: (id) =>
#    item = App.items.get(id)
#    App.items.remove(item)
#    item.updateParentContainers()

$(document).ready ->
  App.receiver = new App.Receiver()
  App.receiver.startPrivatePubSub()