
class App.GroupView extends Backbone.View
  initialize: ->
    @.model.on "change", @.render
  template: HandlebarsTemplates['groups/group']

  events:
    "click .rename-group": "renameGroup"
    "click .delete-group": "deleteGroup"

  deleteGroup: () =>
    @.model.confirmDestroy()

  renameGroup: () =>
    @.$el.find(".stream-name").attr("editable",true)
    @.$el.find('.stream-name').trigger("group:rename")

  html: null
  render: =>
    count = @.model.count() || 0
    subs = @.model.subscriptions().length
    short_name = @.model.get("short_name")
    id    = @.model.id
    show = ((count > 0) || App.showAllSubscriptions)

    @.ctx = @.model.toJSON()
    @.ctx.count = count
    key = @.model.get("key")
    if @.html?
      @.$el.find(".stream-name").first().html("#{short_name}")
      @.$el.find(".count").first().html("(#{count})")
      @.$el.find(".group-link").first().attr("href", "/group/#{App.filter}/#{key}")
    else
      @.html = @.template @.ctx
      @.$el.html @.html
      @.$el.attr('data-id', @.model.id)

    show = true if @model.get("new") == true
    if show
      @.$el.parent().removeClass('hide')
    else
      @.$el.parent().addClass('hide')


    @.$el.addClass('hide') if @.model.get("label") == ""


    @.$el.attr('data-id', @.model.id)
    @.$el.find('.stream-name').editable @.afterEdit,
      event: "group:rename"
      style: 'display: inline'
      width:  230
      height: 20

  afterEdit: (value, settings) =>
    @.model.set("label", value)
    @.model.save
      success: =>
        App.renderFeedList()
        @model.get("short_name")



