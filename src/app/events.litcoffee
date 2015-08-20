## app/events
#### Unit tests: [`/test/events.litcoffee`](../../test/events.litcoffee)

A singleton event emitter which supports middlewares. The event emitter is the backbone of the framework, so it's kept
lightweight and generic.

In simplest form, an event emitter is just a kind of dispatch table, where you add handlers to the table and then the
`emit()` call looks up the handler for the specified event and calls it.

This implementation also adds support for middlewares, which are just functions that use the following format:

>     middlewareFunction = (next) ->
>       (data) ->
>         # pre-execute stuff
>         next(data)
>         # post-execute stuff

These are very similar to the middlewares in Express, message handlers in ASP.NET, etc. They give us more power than
"global event handlers" like Backbone offers, because we can execute our own logic before and after the other handler
executes.

### Module declarations

    Log          = require './log.litcoffee'
    Events       = module.exports = {}

### Public Functions

*__addHandler__(eventType, handlerFunc)*: adds a handler for a new event type.
Only one handler is permitted per event type.

>     Events.addHandler "app:sampleevent", (eventData) -> ...

    Events.addHandler = (type, handler) ->
      if type of handlers then Log.error "overwriting existing handler for type '#{type}'"
      handlers[type] = handler


*__addMiddleware__(middlewareFunc)*: adds a middleware handler, which is composed with every event handler. You are able
to add your own code to execute both before and after the event, and even abort the event completely.

>     Events.addMiddleware (next) ->
>       (data) ->
>         # pre-execute stuff
>         next(data)
>         # post-execute stuff

    Events.addMiddleware = (m) ->
      if m in middlewares then Log.warn "duplicate middleware added"
      middlewares.push(m)

*__emit__(eventData)*: emits an event. The "type" property of the eventData object must indicate the event type.
Attempts to emit an event with no handler will fail. Handlers are passed the whole object passed into emit, so use it to
send context or data.

>     Events.emit type: "app:sampleevent", value: "a value"

    Events.emit = (data) ->
      if not data.type
        Log.error "no type property in event data", data
        return
      if data.type not of handlers
        Log.error "no handlers for event type", data
        return
      Log.debug "emitted #{data.type}"
      try
        withMiddlewares(handlers[data.type])(data)
      catch error
        Log.error "exception while handling event. Event data:", data, " Ex:", error

### Private member declarations

Maintain a private list of all registered handlers and middlewares. `withMiddlewares(fn)` is a helper function for
composing all the registered middlewares.

    handlers     = {} # table mapping eventType -> handlerFunction
    middlewares     = [] # list of middleware functions
    withMiddlewares = (fn) -> (fn = m(fn) for m in middlewares) and fn # middleware composer