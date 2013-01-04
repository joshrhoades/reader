class App.Comment extends Backbone.Model

  initialize: ->
    comment = this.get("comment")
    if comment?
      this.set("body", comment.body)
      this.set("html", comment.html)
      this.set("id", comment.id)
      this.set("item_id", comment.item_id)
      this.set("name", comment.name)
      this.set("created_at", comment.created_at)
      this.set("user_id", comment.user_id)

    this.set('short_name', App.truncate(this.get('name'), 18, '...'))
    this.url = '/comment/' + this.get('id')
    if App.user.id == this.get('user_id')
      this.set('my_comment', true)
    App.comments.add(this)
    this.item_id = this.get("item_id")


