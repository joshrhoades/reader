class App.Router extends Backbone.Router
  routes:
    "settings":"settings"
    "settings/feeds":"settingsFeeds"
    "settings/friends":"settingsFriends"
    "subscription/:filter/:subscription_id":"viewSubscription"
    "group/:filter/:group_id":"viewGroup"
    "person/:filter/:group_id":"viewPerson"
    "unread":"viewUnread"
    "starred":"viewStarred"
    "shared":"viewShared"
    "share":"openShare"
    "commented":"commented"
    "show-unread":"filterOnUnread"
    "show-all":"filterOnAll"
    "show-starred":"filterOnStarred"
    "show-shared":"filterOnShared"
    "login":"openLogin"
    "register":"openRegister"
    '*actions': 'defaultAction'

  settings: ->
    if App.user.anonymous()
      App.router.navigate('/#login', {trigger:true})
    else
      App.showSettings()
      $(document).scrollTop(0)
      App.streamTitle.set('title', 'Settings')
      App.streamTitle.set('count', null)
      App.stream = null
      $('#your_feeds').load('/settings/your_feeds')
      $('#suggested_feeds').load('/settings/suggested_feeds')
      App.loadFollowerTables()

  settingsFeeds: ->
    this.settings()
    $('#feeds-tab').click()
  settingsFriends: ->
    this.settings()
    $('#friends-tab').click()


  commented: ->
    if App.user.anonymous()
      App.router.navigate('/#login', {trigger:true})
    else
      App.viewCommented()


  openShare: ->
    if App.user.anonymous()
      App.router.navigate('/#login', {trigger:true})
    else
      $('#share-modal').modal('show')

  viewSubscription: (filter, subscription_id) ->
    App.viewSubscription(filter, subscription_id)

  viewGroup: (filter, group_id) ->
    App.viewGroup(filter, group_id)
  viewPerson: (filter, id) ->
    App.viewPerson(filter, id)

  viewUnread: ->
    App.viewUnread()
  viewShared: ->
    if App.user.anonymous()
      App.router.navigate('/login', {trigger:true})
    else
      App.viewShared()
  viewStarred: ->
    if App.user.anonymous()
      App.router.navigate('/login', {trigger:true})
    else
      App.viewStarred()

  deleteSubscription: (key) ->
    App.subscriptions.destroySubscription(key)

  deleteGroup: (key) ->
    App.groups.destroyGroup(key)

  deleteModel: () ->
    if App.modelToDelete?
      App.modelToDelete.destroyConfirmed()
  cancelDelete: ->
    App.modelToDelete = null
    $('#destroy-alert').hide()

  filterOnUnread: ->
    App.filterOnUnread()
  filterOnAll: ->
    App.filterOnAll()
  filterOnStarred: ->
    App.filterOnStarred()
  filterOnShared: ->
    App.filterOnShared()

  openLogin: ->
    if App.user.anonymous()
      $("#login-modal").modal('show')
    else
      App.router.navigate('/', {trigger: true})


  openRegister: ->
    $("#login-modal").modal('hide')
    $("#register-modal").modal('show')

  defaultAction: ->
    App.showHome()
    App.showList()

$(document).on "click", "a[href^='/destroy-cancel']", (evt) ->
  App.router.cancelDelete()
  evt.preventDefault()

$(document).on "click", "a[href^='/destroy-confirmed']", (evt) ->
  App.router.deleteModel()
  evt.preventDefault()

$(document).on "click", "a[href^='/rmsubscription']", (evt) ->
  path = $(evt.currentTarget).attr("href")
  parts = path.split("/")
  App.subscriptions.destroySubscription(parts[2])
  evt.preventDefault()

$(document).on "click", "a[href='/settings']", (evt) ->
  $('#settings-login-dropdown-link').dropdown("toggle")
  App.router.navigate("/settings")
  App.router.settings()
  false

$(document).on "click", "a[href='/login']", (evt) ->
  evt.preventDefault()
  App.router.openLogin()
  App.router.navigate("/login")


$(document).on "click", "a[href='/all']", (evt) ->
  evt.preventDefault()
  App.viewAll()

$(document).on "click", "a[href='/unread']", (evt) ->
  App.viewUnread()
  false

$(document).on "click", "a[href='/starred']", (evt) ->
  App.viewStarred()
  false

$(document).on "click", "a[href='/shared']", (evt) ->
  App.viewShared()
  false

$(document).on "click", "a[href='/commented']", (evt) ->
  App.viewCommented()
  false

$(document).on "click", "a[href='/share']", (evt) ->
  App.router.openShare()
  false

$(document).on "click", ".subscription-link", (evt) ->
  path = $(evt.currentTarget).attr("href")
  parts = path.split("/")
  App.router.navigate(path)
  App.viewSubscription(parts[2], parts[3])
  false

$(document).on "click", ".group-link", (evt) ->
  path = $(evt.currentTarget).attr("href")
  parts = path.split("/")
  App.router.navigate(path)
  App.viewGroup(parts[2], parts[3])
  false

$(document).on "click", ".person-link", (evt) ->
  path = $(evt.currentTarget).attr("href")
  parts = path.split("/")
  App.router.navigate(path)
  App.viewPerson(parts[2], parts[3])
  false