## home/view

View for sample Home component. We only need to do two things.

First, define any needed event handlers using [`app/events`](../app/events.litcoffee):

    State = require '../app/state.litcoffee'
    Events = require '../app/events.litcoffee'

    Events.addHandler 'home:clicked', (ev) ->
      State.message = ev.message

Since we update [`app/state`](../app/state.litcoffee) in our event handler, the
[`app/renderer`](../app/renderer.litcoffee) middleware will trigger a re-render.

Second, we need to export a function which is called to render the view. In other words, the module itself is a
function. It returns a `VTree`, which is the signature for a view function expected by the
[`app/renderer`](../app/renderer.litcoffee).

    h = require 'virtual-dom/h'

    module.exports = ->
      h 'div', [
        h 'h3', 'Home'
        h 'p', State.message

Add `onclick` event that emits an event using [`app/events`](../app/events.litcoffee). This is the standard pattern of
immediately delegating control of the event to the event emitter. The `home:clicked` event type has a handler defined
earlier in the file. This ensures that your event handler benefits from all the event middleware defined in
[`app/events`](../app/events.litcoffee).

        h 'button', { onclick: -> Events.emit type: "home:clicked", message: "Hello World" }, 'Click me']