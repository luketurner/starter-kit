###
  View renderer.
  Purpose is to loop forever and update DOM if state changes.

  Renderer is responsible for determining if, when, and how we should render the view.
  We do not need to re-render every time the state changes, because those changes might be extremely rapid -- too rapid
  for the user to see. Instead, as a performance improvement, we use a requestAnimationFrame loop (which usually runs
  once every 16 ms). A renderer service (for use with our Events component) will do an equality-check on the State after
  the event handler runs, and if there are any changes, we flag that rendering should happen on the next animation frame.

  loop()
    starts the main renderer loop (async)

    Renderer.loop()

  service()
    Service that detects state changes in events

    Events.addService(Renderer.service)

###

diff            = require 'virtual-dom/diff'
patch           = require 'virtual-dom/patch'
createElement   = require 'virtual-dom/create-element'

State           = require './state.coffee'
Log             = require './log.coffee'
Views           = require './views.coffee'
Renderer        = module.exports = {}

renderScheduled = true
oldVDom         = null
parentNode      = null

Renderer.service = (next) ->
  (data) ->
    oldState = State.cursor().deref()
    next(data)
    newState = State.cursor().deref()
    renderScheduled = true unless oldState.equals newState

Renderer.loop = ->
  if renderScheduled
    renderScheduled = false
    Log.debug "render triggered"
    newVDom = Views.getView()?()
    if newVDom
      if parentNode?
        patch(parentNode, diff(oldVDom, newVDom))
      else
        parentNode = createElement newVDom
        document.body.appendChild(parentNode)
        oldVDom = newVDom
    else
      Log.error "renderer got empty view data"
  requestAnimationFrame(Renderer.loop)