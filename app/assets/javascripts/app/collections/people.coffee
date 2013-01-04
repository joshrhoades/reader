class App.People extends Backbone.Collection
  initialize: () ->
    this.fetch
      success: _.bind(this.readyHandler, this)

  readyHandler: () ->

  model: App.Person
  url: '/people.json'

  comparator: (item) ->
    item.get('weight')

