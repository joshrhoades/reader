App.all = new App.Stream({name: "All Items", items_url: "/items/all.json"})
App.all.count = ->
  App.counts.get("all_count")

App.unread = new App.Stream({name: "Unread", items_url: "/items/unread.json"})
App.unread.count = ->
  App.counts.get("unread_count")

App.starred = new App.Stream({name: "Starred", items_url: "/items/starred.json"})
App.starred.count = ->
  App.counts.get("starred_count")

App.shared = new App.Stream({name: "Shared", items_url: "/items/shared.json"})
App.shared.count = ->
  App.counts.get("shared_count")

App.commented = new App.Stream({name: "Commented", items_url: "/items/commented.json"})
App.commented.count = ->
  App.counts.get("commented_count")

#App.starred = new App.Stream
#App.starred.items = ->
#  App.items.filter (item)->
#    (item.get('starred') == true)
#
#App.shared = new App.Stream
#App.shared.items = ->
#  App.items.filter (item)->
#    (item.get('shared') == true)
#
#App.commented = new App.Stream
#App.commented.items = ->
#  App.items.filter (item)->
#    (item.get('commented') == true)
#
#App.friends = new App.Stream
#App.friends.items = ->
#  App.items.filter (item)->
#    (item.get('from_id') != null)
#
## Use this for a friends group
#App.friends.view = () ->
#  stream = $('#stream')
#  stream.empty()
#  $(document).scrollTop(0)
#  App.stream = this
#  App.viewStream(this.items, 'Items from your friends')