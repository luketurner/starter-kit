###
	Fallback view used when no other matching view is found.
###
h = require 'virtual-dom/h'

module.exports = -> h "p", "Page not found"