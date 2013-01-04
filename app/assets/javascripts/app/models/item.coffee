class App.Item extends Backbone.Model
  keep: false

  initialize: ->
    @.on('item:change', @.fastSave)
    @.comments = new App.Comments

    _(@.get('comments')).each (c) =>
      comment = new App.Comment(c)
      @.comments.add(comment)


  updateParentContainers: ->
    _(this.streams()).each (strm) ->
      strm.updateCount()

  url: ->
    "/items/#{this.id}.json"

  fastSave: ->
    that = this
    return if App.user.anonymous()
    data =
      id: this.get('id')
      unread: this.get('unread')
      shared: this.get('shared')
      starred: this.get('starred')
      has_new_comments: this.get('has_new_comments')
    $.ajax
      type: 'PUT',
      url: this.url(),
      data: JSON.stringify(data),
      dataType: 'json'
      contentType: 'application/json'
      success: (data, status, xhr) ->
        item = App.items.get(data.id)
        item.set("updated_at", data.updated_at)
    .done () ->
      App.trigger('item:save', that)

    mixpanel.track("item fastSave");


  markRead: ->
    unless this.keep == true
      this.set('unread', false)
      this.set('has_new_comments', false)
      this.fastSave()
      _(this.streams()).each (strm) ->
        strm.set("unread_count", strm.get("unread_count")-1)


  person: ->
    fid = this.get('from_id')
    if fid?
      App.people.get(fid)

  subscription: ->
    sid = this.get('subscription_id')
    if sid?
      App.subscriptions.get(sid)

  streams: ->
    rv = []
    sub = this.subscription()
    if sub?
      rv.push sub
    person = this.person()
    if person?
      rv.push person
    rv


