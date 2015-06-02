###
  View handler.
  Purpose is to decide what needs to be rendered.

  add(regex matcher, fn viewFunction)
    Adds a new view function, which matches when the provided regex matches the fragment.

    Views.add /^home$/ , require './home/view.coffee'
    Views.add /^about$/, require './about/view.coffee'
    ... etc

  getView()
  getView(hash)
    Returns the view that matches the given hash. If no hash is provided, uses location.hash.
    Since the view is a function, this function returns a function.

    vdomForView = View.getView()?()

###

Log           = require './log.coffee'
Views         = module.exports = {}

viewRegistry  = []
viewPath      = ["app", "views"]

Views.add = (re, fn) ->
  viewRegistry.push re: re, fn: fn

Views.getView = (hash) ->
  if not hash then hash = location.hash.slice(1)
  for { re, fn } in viewRegistry
    if re.test hash
      return fn
  Log.error "no view defined for #{hash}"
  null