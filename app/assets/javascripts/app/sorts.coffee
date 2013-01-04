

App.sorters = {
  publishDate: (item) ->
    item.get('published_at')
  lastComment: (item) ->
    item.comments.last().get('created_at')
  updatedAt: (item) ->
    item.get('updated_at')
}

App.sorter = App.sorters.publishDate