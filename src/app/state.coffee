###
  app/state
  Provides a globally accessible clearinghouse for all application data.
  In other words, it's a global object that you put stuff in!

  We could just use a global variable (i.e. a property on `window`), but
  I prefer using a module because it fits better into the webpack paradigm
  where everything is a module.
###

Immutable     = require 'immutable'
Cursor        = require 'immutable/contrib/cursor'

State         = module.exports = {}
internalState = Immutable.Map()

State.cursor  = (path) -> Cursor.from(internalState, path ? [], (x) -> internalState = x)