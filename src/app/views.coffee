###
  app/views
  Decides which view to render, based on url #fragment

  Similar to a client-side routing handler, except that we don't really embrace
  the url-based structure that arose from server-side MVC. Instead, each view
  is allowed to use a regex to indicate when it should be active. The regex is
  compared with the URL fragment, and the first match will be used to decide
  what view should be rendered.

  This is both more generic, because you are not limited to the /path/segment/pattern,
  and less feature-rich, because it does not do any kind of variable extraction.

  To change the current view, you only need to make the user click on a link
  with a different fragment, for example:

  <a href="#about">About</a>

  This is possible because have a listener on the "hashchange" event.

  add(regex matcher, fn viewFunction)
    Adds a new view function, which is used when the provided regex matches.

    Views.add /^home$/ , require './home/view.coffee'
    Views.add /^about$/, require './about/view.coffee'
    ... etc

  render()
  render(hash)
    Calls the view that matches the given hash.
    If no hash is provided, uses location.hash.
    View function is passed the matching URL fragment as a parameter, 
    and the function's result is returned to the caller.
###

Log           = require './log.coffee'
Events        = require './events.coffee'
Views         = module.exports = {}

viewRegistry  = [] # array of {re, fn} view objects

# Add hashchange event which will trigger a re-render.
# Note that the handler is a no-op, which is fine -- because
# we set the `render` flag in the event data, a render will be triggered.
Events.addHandler "browser:hashchange", ->
window.onhashchange = -> Events.emit type: "browser:hashchange", render: true


Views.add = (re, fn) ->
  if not re instanceof RegExp
    Log.error "Views.add expects RegExp for 1st arg, got", re
    return
  if typeof fn isnt "function"
    Log.error "Views.add expects function for 2nd arg, got", fn
    return
  viewRegistry.push re: re, fn: fn

Views.render = (hash) ->
  if not hash then hash = location.hash.slice(1)
  for { re, fn } in viewRegistry
    if re.test hash
      return fn hash
  Log.error "no view defined for hash \"#{hash}\""
  null