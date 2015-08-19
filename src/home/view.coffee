###
  Example view for Home component.
  Defines an event handler and exports a function that returns a VTree.
###

h = require 'virtual-dom/h'
State = require '../app/state.coffee'
Events = require '../app/events.litcoffee'

# Example event handler definition.
# If you update app/state in an event handler, 
# the view will automatically be re-rendered by the Renderer.
Events.addHandler 'home:clicked', (ev) ->
  State.message = ev.message

# Export a render function that returns a VTree (virtual DOM object)
# This can be called by the Views component to render the view.
# Add DOM event listeners that directly call `Events.emit` to raise
# events that you have defined using Events.addHandler.
module.exports = ->
  h 'div', [
    h 'h3', 'Home'
    h 'p', State.message
    h 'button', { onclick: -> Events.emit type: "home:clicked", message: "Hello World" }, 'Click me']