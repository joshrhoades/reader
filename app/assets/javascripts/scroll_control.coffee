$(document).on 'mouseenter', '#list', (evt) ->
  $(document).on 'mousewheel', 'body', App.lockStreamScroll

$(document).on 'mouseleave', '#list', (evt) ->
  $(document).off 'mousewheel', 'body', App.lockStreamScroll

App.lockStreamScroll = (evt) ->
  list = $('#list').first()
  total = $(window).innerHeight()
  total += -(parseInt($('#site-header').height()))
  total += -(parseInt($('#list').css('padding-top'))+parseInt(list.css('padding-bottom')))
  listContentHeight = $('#list-content').innerHeight()
  listScrollTop = list.scrollTop()
  listHeight = list.height()
  scrollAreaRemaining = listContentHeight - total - listScrollTop
  if scrollAreaRemaining <= 0 && App.getWheelDirection(evt) == 'down'
    return false
  if listScrollTop == 0 && App.getWheelDirection(evt) == 'up'
    return false

App.getWheelDirection = (evt) ->
  delta = evt.originalEvent.wheelDelta
  if (delta > 0)
    'up'
  else
    'down'



