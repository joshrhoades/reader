class App.Subscription extends App.Stream
  streamType: "subscription"

  initialize: ->
    @.set('short_name', App.truncate(@.get('name'), 26, '...'))

    @.set('count', 0)
    @.render()
    @.on "change", @.render
    @.on "change", =>
      group = @.getGroup()
      group.updateCounts()
    @on "destroy", () =>
      App.subscriptions.remove(@)
      @renderer.$el.remove()


  render: =>
    if @.renderer?
      @.set('short_name', App.truncate(@.get('name'), 26, '...'))
      @.renderer.render()
    else
      @.renderer = new App.SubscriptionView
        model: @
        id: 'subscription-' + @.get('id')
      @.renderer.render()

  fastSave: () =>
    return if App.user.anonymous()
    data =
      id: @.get('id')
      group_id: @.get('group_id')
      weight: @.get('weight')
      name: @.get('name')
    $.ajax
      type: 'PUT',
      url: @.url(),
      data: JSON.stringify(data),
      dataType: 'json'
      contentType: 'application/json'
    .done () ->
      App.trigger('item:save')

  getStreamCollection: () =>
    App.subscriptions


  items_url: ->
    "/subscriptions/#{@.id}/#{App.filter}/items.json"

  url: ->
    '/subscriptions/' + @.id

  path: ->
    '/subscription/' + App.filter + '/' + @.id



  setupDrag: (container) ->
    $(container).draggable
        axis: 'y'

  getGroup: =>
    App.groups.get(@.get('group_id'))
  setGroup: (grp) ->
    if grp?
      @.set('group_id', grp.get('group_id'))

  renderer: null

  confirmDestroy: ->
    App.modelToDelete = @
    $('#destroy-message').html('Are you sure you wish to unsubscribe?')
    $('#destroy-alert').show()


  destroyConfirmed: ->
    if App.modelToDelete?
      App.modelToDelete.destroy()
      App.modelToDelete = null
      $('#destroy-alert').hide()
      @.renderer.$el.remove()

  label: (val=null) ->
    if val?
      @.set('name', val)
      @.set('short_name', App.truncate(@.get('name'), 30, '...'))
      @.save()
    else
      @.get('name')


