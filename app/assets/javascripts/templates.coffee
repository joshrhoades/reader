App.createTemplates = () ->

  App.streamTitle = new App.StreamTitle
    title: ""
    count: 0
    link: null

  App.streamTitleView = new App.StreamTitleView
    model: App.streamTitle
    el: $('#stream-title-container').first()

