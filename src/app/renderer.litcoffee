## app/renderer

Updates the DOM when the app state changes.

This component is responsible for determining when and how we should render the view. We do not need to re-render
every time the state changes, because those changes might be extremely rapid -- too rapid for the user to see.
Instead, as a performance improvement, we use a requestAnimationFrame loop (which usually runs once every 16 ms).
A renderer middleware will do an equality-check on the State after each event handler runs, and if there are any
changes, we flag that rendering should happen on the next animation frame.

This component is also responsible for setting `path` on the `data` parameter which is passed to the view. For more
information about views, the `data` object, and how the `path` might be used, see the app/route component comments.
We set the path to the current value of the url #fragment. We also add a no-op event that will trigger a re-render
if the fragment is changed, which allows you to use regular links, like <a href="#contact">Contact</a>, to trigger
a re-render.

Only exposes one function, `Renderer.loop`, as described below:

*__loop__(rootView)*: starts the main renderer loop. Pass it a view function (something that you call to return
virtual DOM). Usually, this view function is something that you generated with the `defmulti` function in the
`app/route` component, but that does not need to be the case, especially for apps that have a fairly simple or
consistent view.

First, some `virtual-dom` requires (each function is exposed as a module):

    diff            = require 'virtual-dom/diff'
    patch           = require 'virtual-dom/patch'
    createElement   = require 'virtual-dom/create-element'

We are using our own `matches` implementation instead of `lodash.matches`, because the `lodash` version does not
detect when new properties are added to `app/state`, only when existing proeprties are changed or removed.

    matches         = require './util/matches.litcoffee'

Other required components:

    State           = require './state.litcoffee'
    Log             = require './log.litcoffee'
    Events          = require './events.litcoffee'

    Renderer        = module.exports = {}

Defining some private state:

    renderScheduled = true # if set to `true`, we will re-render on next loop
    oldVDom         = null # contains old dom for diffing purposes
    parentNode      = null # points to a real DOM node

Now, we add a middleware that will set `renderScheduled` whenever it encounters an event which has changed `app/state`.
In a well-designed `starter-kit` application, all view-related data is stored in `app/state`, so we only need to
re-render the virtual DOM if `app/state` changed. However, this behavior can be overridden to force a re-render without
updating `app/state`. Just set `render` to `true` in the event's data context.

    Events.addMiddleware (next) ->
      (data) ->
        match = matches(State)
        next(data)
        if data.render or not match(State) then renderScheduled = true

Add hashchange event which will trigger a re-render. Note that the handler is a no-op, which
is fine: a render will be triggered because we set the `render` flag in the event data.

    Events.addHandler "browser:hashchange", ->
    window.onhashchange = -> Events.emit type: "browser:hashchange", render: true

Helper rendering function which accepts a view function and calls it, "rendering" the view
into a `VTree`. Then, will `patch` the rendered `VTree` onto the DOM.

Passes `location.hash` as the `path` property in the view data. This property is used by the
`app/route` component.

    render = (view) ->
      renderScheduled = false
      Log.debug "render triggered"
      data =
        path: location.hash.slice(1)
      newVDom = view(data)
      if newVDom
        if parentNode?
          patch(parentNode, diff(oldVDom, newVDom))
        else
          parentNode = createElement newVDom
          document.body.appendChild(parentNode)
        oldVDom = newVDom
      else
        Log.error "renderer got empty view data"

Finally, it's the main renderer loop function described at the top of the file!
This kicks off a loop which will trigger a re-render if `renderScheduled` is set.

    Renderer.loop = (view) ->
      _loop = ->
        if renderScheduled
          render(view)
        requestAnimationFrame(_loop)
      requestAnimationFrame(_loop)