
class App.SubscriptionView extends Backbone.View
  tagName: "li"
  template: HandlebarsTemplates['subscriptions/subscription']

  events:
    "click .rename-subscription": "renameSubscription"
    "click .delete-subscription": "deleteSubscription"

  deleteSubscription: () =>
    @.model.confirmDestroy()

  renameSubscription: () =>
    @.$el.find(".stream-name").html(@model.get("name"))
    @.$el.find('.stream-name').trigger("subscription:rename")


  html: null
  render: ->
    count = this.model.count()
    short_name = this.model.get("short_name")
    id    = this.model.id
    show = ((count > 0) || App.showAllSubscriptions)
    this.ctx = this.model.toJSON()
    this.ctx.count = count
    if this.html?
      this.$el.find(".stream-name").first().html("#{short_name}")
      this.$el.find(".count").first().html("(#{count})")
      this.$el.find(".subscription-link").first().attr("href", "/subscription/#{App.filter}/#{id}")
    else
      this.$el.addClass('li-subscription')
      this.html = this.template this.ctx
      this.$el.html this.html
      this.$el.attr('data-id', this.model.id)
      this.$group = $('#list-content #group-list-' + this.model.get('group_id'))
      this.$group.append(this.$el)

    if show
      this.$el.removeClass('hide')
    else
      this.$el.addClass('hide')


    @.$el.find('.stream-name').editable @.afterEdit,
      event:  "subscription:rename"
      style:  'display: inline'
      width:  230
      height: 20


  afterEdit: (value, settings) =>
    @.model.set("name", value)
    @.model.save
      success: =>
        App.renderFeedList()
        @model.get("short_name")