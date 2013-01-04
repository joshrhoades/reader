class App.CommentsView extends Backbone.View
  initialize: ->
    this.comments = this.collection
    this.comments.on('add', this.render, this)
    this.comments.on('remove', this.render, this)
  template: HandlebarsTemplates['comments/comments']
  render: ->
    that = this
    html = this.template()

    this.$el.html html

    this.comments.each (comment) ->
      commentView = new App.CommentView
        model: comment
        el: that.$el.find('.comments').first()
      commentView.render()
