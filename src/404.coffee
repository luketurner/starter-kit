###
	Fallback view used when no other matching view is found.
###
h = require 'virtual-dom/h'

module.exports = ->
  h "div", [
    h "h3", "404"
    h "p", "Page not found!"]