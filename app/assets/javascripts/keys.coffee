


$(document).ready () ->
  App.toggleList = () ->
    $('#list').toggleClass('out')
#    App.updateKeyBindingsForList()

  App.hideList = () ->
    $('#list').removeClass('out')
#    App.updateKeyBindingsForList()

  App.showList = () ->
    $('#list').addClass('out')
#    App.updateKeyBindingsForList()

  App.nextItem = ->
    nextItem = $('.focused').parent().next()
    if nextItem.length == 0 && $('.focused').length == 0
      nextItem = $(".item").first().parent().next()
    if nextItem? && nextItem.length > 0
      st = nextItem.offset().top - 95
      App.$doc.scrollTop(st)
    else
      if App.streamItems.length > 0
        App.viewMore()
      else
        App.focusedItemView.markRead()
        App.viewNextStream()

  App.prevItem = ->
    prevItem = $('.focused').parent().prev()
    if prevItem.length == 0
      prevItem = $('.item').first()
    if prevItem? && prevItem.length > 0
      st = prevItem.offset().top - 95
      App.$doc.scrollTop(st)
    else
      App.$doc.scrollTop(App.$doc.height())


  App.nextListItem = (evt) ->
    $(document).scrollTop(0)
    App.viewNextStream()
    return false

  App.prevListItem = (evt) ->
    $(document).scrollTop(0)
    App.viewPreviousStream()
    return false


  App.scrollDownSome = ->
    st = $(document).scrollTop()
    $(document).scrollTop(200 + st)
  App.scrollUpSome = ->
    st = $(document).scrollTop()
    $(document).scrollTop(st - 200)



  App.toggleStar = ->
    if App.focusedItemView?
      App.focusedItemView.toggleStar()

  App.toggleShare = ->
    if App.focusedItemView?
      App.focusedItemView.toggleShare()

  App.browseItem = ->
    if App.focusedItem?
      url = App.focusedItem.get('url')
      if url?
        window.open(url, "_blank");



  $(document).on('click', ".go-item-next", App.nextItem)
  $(document).on('click', ".go-item-previous", App.prevItem)
  $(document).on('click', ".go-mark-all-read", App.markStreamAsRead)

  $(document).on('keypress.n', App.nextListItem)
  $(document).on('keypress.m', App.prevListItem)
  $(document).on('keypress.j', App.nextItem)
  $(document).on('keypress.shift_j', App.scrollDownSome)
  $(document).on('keypress.k', App.prevItem)
  $(document).on('keypress.shift_k', App.scrollUpSome)

  $(document).on('keypress.h', App.toggleList)
  $(document).on('keypress.s', App.toggleStar)
  $(document).on('keypress.shift_s', App.toggleShare)
  $(document).on('keypress.shift_a', App.markStreamAsRead)

  $(document).on('keypress.b', App.browseItem)
