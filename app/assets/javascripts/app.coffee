$(window).unload () ->
  $(document).scrollTop(0)


$(document).on 'click', '#nav-list-link', (evt) ->
  evt.preventDefault()

$(document).on 'click', '.destroy-confirm-btn', (evt) ->
  App.destroyConfirmed()



window.App =
  ready: false
  itemRenderers: []

  showHome: ->
    App.hideAllSwapAreas()
    $('#stream-header').addClass('hide')
    $('#list').addClass('out')
    $('#home').removeClass('hide')
  showStream: ->
    App.hideAllSwapAreas()
    $('#stream-header').removeClass('hide')
    $('#stream').removeClass('hide')
  showSettings: ->
    App.hideAllSwapAreas()
    $("#list").removeClass("out")
    $('#stream-header').removeClass('hide')
    $('#settings').removeClass('hide')
  hideAllSwapAreas: ->
    $('.swap-view-area').addClass('hide')

  destroyConfirmed: =>
    if App.modelToDelete?
      App.modelToDelete.destroy
        success: ->
          App.modelToDelete = null
      $('#destroy-alert').hide()



