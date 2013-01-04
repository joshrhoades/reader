
class App.PersonView extends Backbone.View
  template: HandlebarsTemplates['people/person']
  html: null
  render: ->
    count = this.model.count()
    id    = this.model.id
    show = ((count > 0) || App.showAllSubscriptions)
    this.ctx = this.model.toJSON()
    this.ctx.count = count
    if this.html?
      this.$el.find(".count").first().html("(#{count})")
      this.$el.find(".person-link").first().attr("href", "/person/#{App.filter}/#{id}")
    else
      this.$el = $(document.createElement('li'))
      this.$el.addClass('li-person')
      this.html = this.template this.ctx
      this.$el.html this.html
      this.$el.attr('data-id', this.model.id)

      $('#person-list').append(this.$el)

    if show
      this.$el.removeClass('hide')
    else
      this.$el.addClass('hide')