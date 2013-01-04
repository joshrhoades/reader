class App.StreamTitle extends Backbone.Model
  initialize: ->
    App.on "set:stream", =>
      @.setCount(App.stream.count())
      App.stream.on "change", =>
        @.setCount(App.stream.count())

  setCount: (count) =>
    @.set("count", count)


