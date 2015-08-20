## app/history

An example component for supporting undoing (and redoing) changes to app/state.
It's likely that you will need to hack on this for your particular application.

History is not enabled by default. To use it, you must `require` it from at least
one other component. For example, in `/src/index.coffee`, you could add:

>     History = require './app/history.litcoffee'

Because it doesn't make sense for every event to be undo-able, this component only
allows you to undo events that have the "historical" property set in their event data.

If a historical event is emitted, we make a deep copy of app/state and store it in our history.
If undo(), undoAll(), redo(), or redoAll() are called, we reset the app/state to the stored value.
Does not include history branching -- if you undo, and then make a change, you cannot redo what you undid.

Dependencies:

    clone           = require 'lodash.clone'
    merge           = require 'lodash.merge'
    State           = require './state.litcoffee'
    Events          = require './events.litcoffee'
    History         = module.exports = {}


Private variables:

    maxHistory      = 25 # max. number of history entries to maintain (to avoid ballooning memory usage)
    history         = [] # internal array of historical states
    currentIndex    = -1 # indicates current state's location in history array

    useLocalStorage = true # Flag to enable/disable saving history to localStorage
    historyKey      = "{BD01A20A-EF1D-4D80-A3ED-344660125AFF}_History" # localStorage key for history array
    indexKey        = "{BD01A20A-EF1D-4D80-A3ED-344660125AFF}_Index" # localStorage key for currentIndex


Private utility functions:

    storeHistory = -> if useLocalStorage then window.localStorage.setItem historyKey, JSON.stringify(history)
    storeIndex   = -> if useLocalStorage then window.localStorage.setItem indexKey, currentIndex


This private utility function merges the object at given history index back into the `app/state`:

    load = (index) ->
      currentIndex = index
      state = history[index]
      merge(State, state)
      storeIndex()

*__length__()*: Returns number of past states currently stored

    History.length = -> history.length


*__undo()__*: Updates `app/state` to the previous historical state.

    History.undo = -> if currentIndex > 0 then load(currentIndex - 1)


*__redo()__*: Updates `app/state` to the next historical state, effectively re-doing a change that was undone before.

    History.redo = -> if history.length > currentIndex + 1 then load(currentIndex + 1)


*__undoAll()__*: Updates `app/state` to the first (i.e. oldest) historical state.

    History.undoAll = -> if currentIndex > 0 then load(0)


*__redoAll()__*: Updates `app/state` to the most recent (i.e. newest) historical state. Like reod(), has no effect
  unless `undo` or `undoAll` were called immediately beforehand.

    History.redoAll = -> if history.length > currentIndex + 1 then load(history.length - 1)


*__clear()__*: Erases history.

    History.clear = ->
      history = []
      currentIndex = -1

*__loadFromStorage__()*: Attempts to load history data from localStorage into the component's internal fields.
Will overwrite any existing history. Returns `true` if loading was successful, `false` if it failed.

    History.loadFromStorage = ->
      index = window.localStorage.getItem(indexKey)
      arrayString = window.localStorage.getItem(historyKey)
      if index is null or arrayString is null then return false
      try
        history = JSON.parse(arrayString)
        load(parseInt(index, 10))
        true
      catch
        false

The history service clones `app/state` into our `history` array if the event data's `historical` property is truthy.
This is what actually accumulates the undo history, and it's active automatically, but only if you set the `historical`
property on your event data (for example, in your call to `Event.emit`).

    Events.addService (next) ->
      (data) ->
        next(data)
        if data.historical
          if currentIndex + 1 < history.length then history = history.slice(0, currentIndex + 1) # discard redo() states
          if history.length > maxHistory then history.shift() # discard oldest states
          history.push clone State
          currentIndex = history.length - 1
          storeHistory()
          storeIndex()