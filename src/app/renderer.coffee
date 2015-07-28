###
  app/renderer
  Updates the DOM when the app state changes.

  Renderer is responsible for determining when and how we should render the view.
  We do not need to re-render every time the state changes, because those changes
  might be extremely rapid -- too rapid for the user to see. Instead, as a
  performance improvement, we use a requestAnimationFrame loop (which usually runs
  once every 16 ms). A renderer service will do an equality-check on the State after
  each event handler runs, and if there are any changes, we flag that rendering
  should happen on the next animation frame.

  render()
    Explicitly triggers a render event

  loop()
    starts the main renderer loop
###

# Require needed virtual-dom functions
diff            = require 'virtual-dom/diff'
patch           = require 'virtual-dom/patch'
createElement   = require 'virtual-dom/create-element'

# using our own `matches` implementation instead of `lodash.matches`
# see comments in util/matches.coffee for rationale.
matches         = require './util/matches.coffee' 

State           = require './state.coffee'
Log             = require './log.coffee'
Views           = require './views.coffee'
Events          = require './events.coffee'
Renderer        = module.exports = {}


renderScheduled = true # if set to `true`, we will re-render on next loop
oldVDom         = null # contains old dom for diffing purposes
parentNode      = null # points to a real DOM node

# Add service that will schedule a re-render if the event either:
#  1. changed app/state
#  2. has the `render` property set to `true` in event data
Events.addService (next) ->
  (data) ->
    match = matches(State)
    next(data)
    if data.render or not match(State) then renderScheduled = true

# Render function which calls into Views component for a VTree
# and then patches it onto the DOM. 
render = ->
  renderScheduled = false
  Log.debug "render triggered"
  newVDom = Views.render()
  if newVDom
    if parentNode?
      patch(parentNode, diff(oldVDom, newVDom))
    else
      parentNode = createElement newVDom
      document.body.appendChild(parentNode)
    oldVDom = newVDom
  else
    Log.error "renderer got empty view data"

# Renderer "main loop" basically throttles renders to only
# happen once per animation frame.
Renderer.loop = ->
  if renderScheduled
    render()
  requestAnimationFrame(Renderer.loop)