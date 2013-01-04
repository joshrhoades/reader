
class App.StreamTitleView extends Backbone.View
  initialize: ->
    @.model.on 'change', @.render

  template: HandlebarsTemplates['stream_title']

  render: =>
    @.model.off 'change', @.render
    html = @.template @.model.toJSON()
    @.$el.html html
    @.model.on 'change', @.render
