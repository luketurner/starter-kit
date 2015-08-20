## app/state

Provides a globally accessible clearinghouse for all application data.
In other words, it's a global object that you put stuff in!

Let's define it right now:

    module.exports = {}

That's it! We could replace `app/state` with a global variable,
but using a module is more idiomatic for `webpack`-based projects.

`app/state` could also be created as an Immstruct, in-memory DB, Backbone model, etc.
However, those incur additional dependencies, and it's in the nature of `starter-kit`
to try to reduce each component to its simplest form, including minimizing third-party
dependencies. It is left to the framework's user to decide whether to incur the cost of
integrating a separate library.
