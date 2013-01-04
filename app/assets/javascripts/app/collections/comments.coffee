class App.Comments extends Backbone.Collection
  initialize: (options) ->
#    this.fetch()

  model: App.Comment
  url: '/comments.json'

  comparator: (comment) ->
    comment.get('created_at')

