class App.Group extends App.Stream
  streamType: "group"
  initialize: ->
    this.set('short_name', App.truncate(this.get('label'), 30, '...'))
    this.set('name', this.get('label'))
    this.set('count', 0)
    this.url = "/groups/#{@id}"
    @on "destroy", () =>
      App.groups.remove(@)
      @groupView.$el.remove()
      @listView.$el.remove()
  

  updateCounts: =>
    count = 0
    _(@.subscriptions()).each (sub) =>
      count += sub.count()
    @.set("#{App.filter}_count", count)

  render: =>
    if (@.groupView?)
      this.set('short_name', App.truncate(this.get('label'), 30, '...'))
      @.groupView.render()
      return

    container = document.createElement('li')
    listContainer = document.createElement('li')

    listContainer.className = 'hide' unless this.get('open')

    groupContainer = document.createElement('div')

    $('#list-content > ul').append(groupContainer)
    $(container).addClass('li-group')
    $(groupContainer).append(container)
    $(groupContainer).append(listContainer)
    _view = new App.GroupView
      model: this
      id: 'group-' + this.get('key')
      el: container

    _listView = new App.GroupListView
        model: this
        id: 'group-list-' + this.get('key')
        el: listContainer

    _label = this.get('label')
    this.renderer = _view
    this.groupView = _view
    this.listView = _listView

    this.groupView.render()
    this.listView.render()

  getStreamCollection: () =>
    App.groups



  items_url: ->
    "/groups/#{@.get("key")}/#{App.filter}/items.json"

  subscriptions: =>
    App.subscriptions.filter (sub) =>
      sub.get("group_id") == @.get("id")

  items: ->
    roll = []
    res = this.subscriptions().reduce((roll, memo) ->
      _(memo.items()).each (item) ->
        roll.push(item)
      roll
    , roll)
    res

  count: =>
    _count = 0
    _(@.subscriptions()).each (sub) =>
      _count += sub.get("#{App.filter}_count")
    @.set("#{App.filter}_count", _count)
    @.get("#{App.filter}_count")

  renderer: null
  groupView: null
  listView: null

  confirmDestroy: ->
    App.modelToDelete = this
    $('#destroy-message').html('This will also delete all the subscriptions this group contains. Are you sure?')
    $('#destroy-alert').show()




  label: (val=null) ->
    if val?
      this.set('label', val)
      this.set('short_name', App.truncate(this.get('label'), 30, '...'))
      this.save()
    else
      this.get('label')
