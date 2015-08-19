## app/events

A singleton event emitter that wires everything together.

In simplest form, an event emitter is just a kind of dispatch table, where
you add handlers to the table and then the `emit()` call looks up the handler
for the specified event and calls it.

This implementation also adds *services*, which are middleware functions
that are composed with all event handlers. Using services was chosen over
allowing global handlers because services can do work both before and after
the event handler executes.

### Public Functions

*addHandler(eventType, handlerFunc)*: adds a handler for a new event type.
Only one handler is permitted per event type.

>     Events.addHandler "app:sampleevent", (eventData) -> ...

    Events.addHandler = (type, handler) ->
      if type of handlers then Log.error "overwriting existing handler for type '#{type}'"
      handlers[type] = handler


*addService(middlewareFunc)*: adds a middleware handler, called a
"service". All services are triggered for every event.
They let you add logic that runs before or after the event handler.
Services are expected to use the following middleware pattern:

>     Events.addService (next) ->
>       (data) ->
>         # pre-execute stuff
>         next(data)
>         # post-execute stuff

    Events.addService = (svc) ->
      if svc in services then Log.warn "duplicate service added"
      services.push(svc)

*emit(eventData)*: emits an event. The "type" property of the eventData object
must indicate the event type. Attempts to emit an event with no handler will
fail. Handlers are passed the whole object passed into emit, so use it to
send context or data.

>     Events.emit type: "app:sampleevent", value: "a value"

    Events.emit = (data) ->
      if not data.type then Log.error "no type property in event data", data
      if not data.type of handlers
        Log.error "no handlers for event type", data
        return
      Log.debug "emitted #{data.type}"
      try
        withServices(handlers[data.type])(data)
      catch error
        Log.error "exception while handling event. Event data:", data, " Ex:", error

### Private member declarations

Maintain a private list of all registered handlers and services. `withServices(fn)` is
a helper function for composing all the registered middlewares.

    Log          = require './log.coffee'
    Events       = module.exports = {}

    handlers     = {} # table mapping eventType -> handlerFunction
    services     = [] # list of middleware functions
    withServices = (fn) -> (fn = svc(fn) for svc in services) and fn # middleware composer