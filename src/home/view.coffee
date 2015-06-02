h = require 'virtual-dom/h'
State = require '../app/state.coffee'
Events = require '../app/events.coffee'

Events.addHandler 'home:clicked', (ev) ->
  State.cursor('message').update ->"hello"

module.exports = () ->
  message = State.cursor 'message'
  h 'div', [
    h 'h1', 'starter-frame sample page'
    h 'p', message.deref()
    h 'button', onclick: (-> Events.emit type: "home:clicked", message: "hello"), 'Update']