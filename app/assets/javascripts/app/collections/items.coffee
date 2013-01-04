class App.Items extends Backbone.Collection
  initialize: (items) ->
    _(items).each @.addItem

  readyHandler: () ->
    this.ready = true
    this.loading = false
    App.trigger('ready')
    App.items.allItemsLoaded = true
    App.renderFeedList()


  addItems: (items) =>
    _(items).each @.addItem

  addItem: (item) =>
    @.add new App.Item(item)

  has_all_items: false
  model: App.Item
  url: '/items.json'
  unread_url: '/unread/items.json'
  all_items_url: '/all/items.json'
  ready: false
  allItemsLoaded: false

  unread: ->
    App.items.where({"unread":true})

  starred: ->
    App.items.where({"starred":true})

  shared: ->
    App.items.where({"shared":true})

  commented: ->
    App.items.where({"commented":true})

  ids: ->
    this.map (item) ->
      item.id

#  comparator: (item) ->
#    item.get('updated_at')

