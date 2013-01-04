App.popovers = []

class App.Popover
  $el: null
  $popover: null

  constructor: (options, el) ->
    this.$el = el
    this.options = options
    this.$popover = this.$el.popover(options)
    $(document).on "click", this.documentClickHandler
    this.$el.popover("show")
    App.popovers.push this

  close: ->
    $(document).off "click", this.documentClickHandler
    this.$el.popover("hide")

  documentClickHandler: (evt) ->
    $tgt = $(evt.target)
    $popovers = $tgt.closest(".popover")
    unless ($popovers.length > 0)
      _(App.popovers).each (pop) ->
        pop.close()
    return false

App.Popover.closeAll = ->
  _(App.popovers).each (popover) ->
    popover.close()