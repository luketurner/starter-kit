###
  Example view. Defines an event handler and exports a render() function that returns a VTree.
###

h = require 'virtual-dom/h'
State = require '../app/state.coffee'
Events = require '../app/events.coffee'

Events.addHandler 'home:clicked', (ev) ->
  State.message = ev.message

module.exports = ->
  h 'div', [
    h 'h3', 'starter-kit'
    h 'p', State.message
    h 'button', { onclick: -> Events.emit type: "home:clicked", message: "Hello World" }, 'Click me']