#App.unreadToolTipText = ->
#  console.log "hover"
#  if App.items
#    "#{App.items.unread().length} Unread Items"
#
#App.starredToolTipText = ->
#  console.log "hover"
#  if App.items
#    "#{App.items.starred().length} Starred Items"
#
#App.sharedToolTipText = ->
#  console.log "hover"
#  if App.items
#    "#{App.items.shared().length} Shared Items"
#
#App.commentedToolTipText = ->
#  console.log "hover"
#  if App.items
#    "#{App.items.commented().length} Items With Comments"
#
#App.updateTooltips = ->
#  $("#nav-unread-link").tooltip
#    placement: "right"
#    title: App.unreadToolTipText()
#
#  $("#nav-starred-link").tooltip
#    placement: "right"
#    title: App.starredToolTipText()
#
#  $("#nav-shared-link").tooltip
#    placement: "right"
#    title: App.sharedToolTipText()
#
#  $("#nav-comments-link").tooltip
#    placement: "right"
#    title: App.commentedToolTipText()