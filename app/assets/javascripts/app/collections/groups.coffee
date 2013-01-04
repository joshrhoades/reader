class App.Groups extends Backbone.Collection
  initialize: () ->
    this.fetch
      success: this.readyHandler
  readyHandler: () =>
    App.subscriptions = new App.Subscriptions
    this.ready = true
    App.trigger('ready')
    @.render()

  render: () =>
    @.each (group) ->
      group.render()

  model: App.Group
  url: '/groups.json'
  ready: false

  destroyGroup: (key) ->
    grp = this.where({key:key})
    if grp.length > 0
      grp = grp[0]
      grp.confirmDestroy()

  comparator: (item) ->
    item.get('weight')
