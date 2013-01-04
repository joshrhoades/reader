options =
  trigger: "manual"
  html: true
  selector: "body"
  placement: "bottom"

$pop = null
$el = null
model = null
$dropdown = null

#$(document).on 'click', '.rename-subscription', (evt) ->
#  $dropdown = $(evt.target).closest('.dropdown')
#  options.title = "Rename Subscription"
#  $el = $(evt.target).closest('.li-subscription')
#  id = $el.find('.subscription-link').attr('data-stream-id')
#  model = App.subscriptions.get(id)
#
#  options.content = HandlebarsTemplates['rename_form']
#      value: model.label()
#
#  $pop = $el.popover(options)
#  $el.popover("show")
#  $('#rename_thing').focus()
#  $(document).on "click", popoverClick
#  $('#rename_thing').on "keydown.return keydown.esc", popoverReturnKey
#  evt.preventDefault()

#$(document).on 'click', '.rename-group', (evt) ->
#  options.title = "Rename Group"
#  $el = $(evt.target).closest('.li-group')
#  id = $el.find('.group-link').attr('data-stream-id')
#  model = App.groups.get(id)
#
#  options.content = HandlebarsTemplates['rename_form']
#    value: model.label()
#
#  $pop = $el.popover(options)
#  $el.popover("show")
#  $('#rename_thing').focus()
#  $(document).on "click", popoverClick
#  $('#rename_thing').on "keydown.return keydown.esc", popoverReturnKey
#  evt.preventDefault()

popoverReturnKey = (evt) ->
  if evt.keyCode == 27
    finishRenaming(false)
  else
    finishRenaming()

popoverClick = (evt) ->
  $tgt = $(evt.target)
  $popover = $tgt.closest('.popover')
  unless ($popover.length > 0)
    finishRenaming()

finishRenaming = (commit=true) ->
  $(document).off "click", popoverClick
  $(document).off "keydown.return keydown.esc", popoverReturnKey
  val = $('#rename_thing').val()
  $el.popover("hide")
  if commit == true
    model.label(val)
