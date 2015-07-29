###
  Example view for About component.
###

h = require 'virtual-dom/h'

module.exports = ->
  h 'div', [
    h 'h3', 'About'
    h 'p', 'Imagine that content was here.']
