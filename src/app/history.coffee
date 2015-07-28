###
  app/history
  An example component for supporting undoing (and redoing) changes to app/state.
  It's likely that you will need to hack on this for your particular application.

  Because it doesn't make sense for every event to be undo-able, this component only
  allows you to undo events that have the "historical" property set in their event data.

  If a historical event is emitted, we make a deep copy of app/state and store it in our history.
  If undo(), undoAll(), redo(), or redoAll() are called, we reset the app/state to the stored value.
  Does not include history branching -- if you undo, and then make a change, you cannot redo what you undid.

  loadFromStorage()
    Loads any present history from localStorage

  undo()
  undoAll()
  redo()
  redoAll()
    What you would expect. Overwrites app/state.

  length()
    Returns the current number of history entries

  clear()
    Erases all history entries

###

clone           = require 'lodash.clone'
merge           = require 'lodash.merge'
State           = require './state.coffee'
Events          = require './events.coffee'
History         = module.exports = {}

maxHistory      = 25 # max. number of history entries to maintain (to avoid ballooning memory usage)
history         = [] # internal array of historical states
currentIndex    = -1 # indicates current state's location in history array

useLocalStorage = true # Flag to enable/disable saving history to localStorage
historyKey      = "{BD01A20A-EF1D-4D80-A3ED-344660125AFF}_History" # localStorage key for history array
indexKey        = "{BD01A20A-EF1D-4D80-A3ED-344660125AFF}_Index" # localStorage key for currentIndex

storeHistory = -> if useLocalStorage then window.localStorage.setItem historyKey, JSON.stringify(history)
storeIndex   = -> if useLocalStorage then window.localStorage.setItem indexKey, currentIndex

# Function which merges a given historical state into app/state
load = (index) ->
  currentIndex = index
  state = history[index]
  merge(State, state)
  storeIndex()

# History service will clone app/state into historical state array if the event is marked historical.
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

History.length = -> history.length
History.undo = -> if currentIndex > 0 then load(currentIndex - 1)
History.redo = -> if history.length > currentIndex + 1 then load(currentIndex + 1)
History.undoAll = -> if currentIndex > 0 then load(0)
History.redoAll = -> if history.length > currentIndex + 1 then load(history.length - 1)
History.clear = ->
  history = []
  currentIndex = -1