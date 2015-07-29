###
  Example view for Home component.
  Defines an event handler and exports a function that returns a VTree.
###

h = require 'virtual-dom/h'

# Export a render function that returns a VTree (virtual DOM object)
# This can be called by the Views component to render the view.
# Add DOM event listeners that directly call `Events.emit` to raise
# events that you have defined using Events.addHandler.
# The function is registered as a view in `index.coffee`
module.exports = ->
  h 'div', [
    h 'h3', 'About'
    h 'p', 'Imagine that content was here.']
