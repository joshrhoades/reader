
class App.GroupListView extends Backbone.View
  template: HandlebarsTemplates['groups/group_list']
  render: ->
    @$el.addClass("li-group-list")
    @$el.addClass('hide') unless @model.get("open")
    @ctx = @model.toJSON()
    html = @template @ctx
    @$el.html html
    @$el.attr('data-id', @model.id)
    App.setupDropTargets()
