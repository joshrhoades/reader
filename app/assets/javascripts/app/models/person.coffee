class App.Person extends App.Stream
  streamType: "person"
  initialize: ->
    @.set('short_name', App.truncate(@.get('name'), 26, '...'))
    @.set('count', 0)
    @.render()
    @.on "change", @.render

  render: =>
    if @.renderer?
      @.renderer.render()
    else
      @.renderer = new App.PersonView
        model: @
        id: 'person-' + @.get('id')
      @.renderer.render()

  path: ->
    '/person/' + App.filter + '/' + this.id

  updateCount: () ->
    this.set('count', this.count())
    this.renderer.render()

  getStreamCollection: () =>
    App.people

  items_url: ->
    "/people/#{@.id}/#{App.filter}/items.json"

  renderer: null
