class App.Stream extends Backbone.Model
  constructor: () ->
    super

  count: () ->
    @.get("#{App.filter}_count")

  view: =>
    App.items = null
    @.loadItems (items) =>
      App.items = new App.Items(items)
      App.stream = @

      stream = $('#stream')
      stream.empty()
      $(window).scrollTop(0)
      App.viewStream(@.get('name'), @.get('site_url'))

  loadItems: (cb) =>
    $.post @.items_url(), {ids: @.ids()}, (data, status, xhr) ->
      cb(data)

  ids: =>
    App.items?.pluck("id")

  items_url: =>
    @.get("items_url")

  count_url: =>
    "#{@.get("items_url")}?count=true"

  prev: () =>
    links = $(".#{@streamType}-link")
    link = $(".#{@streamType}-link[data-stream-id='" + @.get("id") + "']")
    index = links.index(link) - 1
    return if index < 0
    if links.length > index
      id = $(links[index]).attr("data-stream-id")
      n = @getStreamCollection().get(id)
      if n.count() > 0
        return n
      else
        return n.prev()

  next: () =>
    links = $(".#{@streamType}-link")
    link = $(".#{@streamType}-link[data-stream-id='" + @.get("id") + "']")
    nextIndex = links.index(link) + 1
    if links.length > nextIndex
      nextID = $(links[nextIndex]).attr("data-stream-id")
      n = @getStreamCollection().get(nextID)
      if n.count() > 0
        return n
      else
        return n.next()