
class App.StreamMenuView extends Backbone.View
  initialize: ->

  template: HandlebarsTemplates['stream_menu']
  render: ->
    ctx = {}
    ctx.subscription = (App.subscriptions.include(App.stream))
    ctx.stream = App.stream?
    if App.stream?
      ctx.id = App.stream.get('id')
    html = this.template ctx
    this.$el.html html
