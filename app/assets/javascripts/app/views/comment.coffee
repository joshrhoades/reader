class App.CommentView extends Backbone.View
  template: HandlebarsTemplates['comments/comment']
  initialize: ->
  render: ->
    ctx = this.model.toJSON()
    html = this.template ctx
    this.$el.append html